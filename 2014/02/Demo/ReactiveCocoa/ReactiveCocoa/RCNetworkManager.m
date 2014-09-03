//
//  RCNetworkManager.m
//  ReactiveCocoa
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import "RCNetworkManager.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <ReactiveCocoa.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


@implementation RCNetworkManager

static void RCNetworkManagerReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *context)
{
	BOOL isReachable = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
	NSLog(@"Reachability: %i", isReachable);
	
	// Send reachability state to subscriber
	id<RACSubscriber> subscriber = (__bridge id)context;
	[subscriber sendNext: @(isReachable)];
}

+ (RACSignal *)networkAvailabilitySignal
{
	static RACSignal *availabilityCheck;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		availabilityCheck = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			// Create handle for 0.0.0.0
			struct sockaddr_in zeroAddress;
			bzero(&zeroAddress, sizeof(zeroAddress));
			zeroAddress.sin_len = sizeof(zeroAddress);
			zeroAddress.sin_family = AF_INET;
			
			// Query reachability and setup callback
			SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&zeroAddress);
			SCNetworkReachabilityContext context = { 0, NULL, NULL, NULL, NULL };
			
			context.info = (__bridge void*)subscriber;
			SCNetworkReachabilitySetCallback(reachability, RCNetworkManagerReachabilityCallback, &context);
			
			SCNetworkReachabilitySetDispatchQueue(reachability, dispatch_get_main_queue());
			
			// Send an initial signal by querying manually
			SCNetworkReachabilityFlags flags;
			SCNetworkReachabilityGetFlags(reachability, &flags);
			RCNetworkManagerReachabilityCallback(reachability, flags, context.info);
			
			NSLog(@"SCNetwork callback installed.");
			
			// Create a disposable, releasing the reachability
			return [RACDisposable disposableWithBlock:^{
				CFRelease(reachability);
			}];
		}];
		
		// Ensure that we only connect once. However, every further subscriber to this signal should receive the last value when connecting.
		availabilityCheck = availabilityCheck.replayLast;
	});
	
	return availabilityCheck;
}

@end

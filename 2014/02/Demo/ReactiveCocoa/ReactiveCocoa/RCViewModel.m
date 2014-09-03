//
//  RCViewModel.m
//  ReactiveCocoa
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import "RCViewModel.h"
#import "RCNetworkManager.h"

#import <ReactiveCocoa.h>

@implementation RCViewModel

- (RACSignal *)formValiditySignal
{
	return
	[RACSignal
	 combineLatest:@[RACObserve(self, username), RACObserve(self, password), RACObserve(self, passwordConfirmation)]
	 reduce:^(NSString *username, NSString *password, NSString *confirmation) {
		 return @(
		 (username.length > 0)
		 && (password.length >= 8)
		 && [password isEqualToString: confirmation]
		 );
	 }];
}

- (RACSignal *)networkAvailabilitySignal
{
	return RCNetworkManager.networkAvailabilitySignal;
}

- (RACSignal *)signupAllowedSignal
{
	return
	[RACSignal
     combineLatest:@[self.formValiditySignal, RCNetworkManager.networkAvailabilitySignal] reduce:^(NSNumber *isFormValid, NSNumber *isNetworkAvailable) {
		 return @(isFormValid.boolValue && isNetworkAvailable.boolValue);
	 }];
}

@end

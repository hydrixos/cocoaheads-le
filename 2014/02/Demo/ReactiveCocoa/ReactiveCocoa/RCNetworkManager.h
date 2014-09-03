//
//  RCNetworkManager.h
//  ReactiveCocoa
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface RCNetworkManager : NSObject

+ (RACSignal *)networkAvailabilitySignal;

@end

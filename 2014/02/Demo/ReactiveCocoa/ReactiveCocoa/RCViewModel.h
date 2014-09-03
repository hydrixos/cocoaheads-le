//
//  RCViewModel.h
//  ReactiveCocoa
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface RCViewModel : NSObject

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *passwordConfirmation;

@property(nonatomic, strong) RACSignal *signupAllowedSignal;
@property(nonatomic, strong) RACSignal *networkAvailabilitySignal;

@end

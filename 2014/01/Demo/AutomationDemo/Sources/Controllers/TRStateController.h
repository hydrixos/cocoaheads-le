//
//  TRStateController.h
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRStateController : NSObject

+ (instancetype)sharedStateController;

@property (nonatomic, getter = isLoggedIn) BOOL loggedIn;

- (NSArray *)mails;

@end

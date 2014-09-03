//
//  TRMailModel.h
//  AutomationDemo
//
//  Created by trispo on 07/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMailModel : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSDate *sentDate;

@end

//
//  TRMailModel+Fake.m
//  AutomationDemo
//
//  Created by trispo on 07/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TRMailModel+Fake.h"
#import <MBFaker/MBFaker.h>

@implementation TRMailModel (Fake)

+ (instancetype)fakeModel
{
    TRMailModel *mailModel = [TRMailModel new];
    mailModel.displayName = [MBFakerName name];
    mailModel.subject = [MBFakerLorem sentence];
    mailModel.body = [MBFakerLorem paragraphs:4];

    NSTimeInterval start = 1388534400;
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];

    mailModel.sentDate = [NSDate dateWithTimeIntervalSince1970:start + arc4random_uniform(end-start)];
    
    return mailModel;
}

@end

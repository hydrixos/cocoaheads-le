//
//  TRStateController.m
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TRStateController.h"
#import "TRMailModel+Fake.h"

@implementation TRStateController

+ (instancetype)sharedStateController
{
    static TRStateController *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    if (_sharedInstance)
    {
        return _sharedInstance;
    }

    dispatch_once(&onceToken, ^
    {
        _sharedInstance = [TRStateController alloc];
        _sharedInstance = [_sharedInstance init];
    });

    return _sharedInstance;
}


- (NSArray *)mails
{
    static NSArray *models = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        NSMutableArray *mailModels = [NSMutableArray array];
        for (NSUInteger i = 0; i < 100; i++)
        {
            [mailModels addObject:[TRMailModel fakeModel]];
        }
        models = [mailModels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sentDate" ascending:NO]]];
    });

    return models;
}

@end

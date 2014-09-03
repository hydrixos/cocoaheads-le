//
//  NSDate+Format.m
//  AutomationDemo
//
//  Created by trispo on 07/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

- (NSString *)formattedString
{
    static NSDateFormatter *formatter = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        formatter = [NSDateFormatter new];
        formatter.doesRelativeDateFormatting = YES;
    });

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];

    if ([today isEqualToDate:otherDate])
    {
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
    }
    else
    {
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    }

    return [formatter stringFromDate:self];
}


- (NSString *)longFormattedString
{
    static NSDateFormatter *formatter = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        formatter = [NSDateFormatter new];
        formatter.doesRelativeDateFormatting = NO;
        formatter.dateStyle = NSDateFormatterLongStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
    });
    
    return [formatter stringFromDate:self];
}

@end

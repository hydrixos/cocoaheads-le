//
//  DayRowController.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 03/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "DayRowController.h"

@interface DayRowController ()

@property(nonatomic) IBOutlet WKInterfaceLabel *dayLabel;

@end

@implementation DayRowController

- (void)setDay:(NSUInteger)day
{
	_day = day;
	
	self.dayLabel.text = [NSString stringWithFormat: @"%lu", day];
}

@end

//
//  DoorRowController.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 03/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "DoorRowController.h"

#import "AdventCalendarEntry.h"

@interface DoorRowController ()

@property(nonatomic) IBOutlet WKInterfaceLabel *dayLabel;
@property(nonatomic) IBOutlet WKInterfaceLabel *doorLabel;

@end

@implementation DoorRowController

- (void)setDay:(NSUInteger)day
{
	_day = day;
	
	self.dayLabel.text = [NSString stringWithFormat: @"%lu.12.", day];
}

- (void)setCalendarEntry:(AdventCalendarEntry *)calendarEntry
{
	_calendarEntry = calendarEntry;
	
	self.doorLabel.text = [NSString stringWithFormat: @"%lu", calendarEntry.doorIndex];
	self.doorLabel.textColor = calendarEntry.calendarColor;
}

@end

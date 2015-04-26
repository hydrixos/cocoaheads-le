//
//  EntryRowController.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 02/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "EntryRowController.h"

#import "AdventCalendarEntry.h"

@interface EntryRowController ()

@property(nonatomic) IBOutlet WKInterfaceLabel *personLabel;
@property(nonatomic) IBOutlet WKInterfaceLabel *doorLabel;

@end

@implementation EntryRowController

- (void)setCalendarEntry:(AdventCalendarEntry *)entry
{
	_calendarEntry = entry;
	
	self.personLabel.text = entry.person;
	self.doorLabel.text = [NSString stringWithFormat: @"%lu", entry.doorIndex];
	self.doorLabel.textColor = entry.calendarColor;
}

@end

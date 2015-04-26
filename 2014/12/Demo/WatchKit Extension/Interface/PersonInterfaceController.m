//
//  PersonInterfaceController.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 03/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "PersonInterfaceController.h"

#import "AdventCalendar.h"
#import "DoorRowController.h"

@interface PersonInterfaceController ()

@property(nonatomic, readonly) NSString *person;

@property(nonatomic) IBOutlet WKInterfaceLabel *personLabel;
@property(nonatomic) IBOutlet WKInterfaceTable *dayTable;

@end


@implementation PersonInterfaceController

- (instancetype)initWithContext:(id)context
{
	self = [super initWithContext: context];
	
	if (self) {
		_person = context;
		
		[self setUpInterface];
	}
	
	return self;
}

- (void)setUpInterface
{
	// Setup header
	self.personLabel.text = _person;
	
	
	// Setup table
	NSDictionary *entriesForDay = [AdventCalendar.soulmenCalendar entriesForPerson: self.person];
	NSUInteger days = AdventCalendar.soulmenCalendar.numberOfDays;
	
	[self.dayTable setNumberOfRows:entriesForDay.count withRowType:@"personByDay"];
	
	NSUInteger rowIndex = 0;
	
	for (NSUInteger day = 1; day <= days; day ++) {
		AdventCalendarEntry *entry = entriesForDay[@(day)];
		if (!entry)
			continue;
		
		DoorRowController *doorRow = [self.dayTable rowControllerAtIndex: rowIndex];
		doorRow.day = day;
		doorRow.calendarEntry = entry;
		
		rowIndex ++;
	}
}

@end

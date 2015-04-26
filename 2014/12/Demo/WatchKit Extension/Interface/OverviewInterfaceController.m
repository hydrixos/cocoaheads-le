//
//  OverviewInterfaceController.m
//  WatchKit Sample WatchKit Extension
//
//  Created by Friedrich Gräter on 02/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "OverviewInterfaceController.h"

#import "AdventCalendar.h"
#import "AdventCalendarEntry.h"
#import "DayRowController.h"
#import "EntryRowController.h"

@interface OverviewInterfaceController ()

@property(nonatomic) IBOutlet WKInterfaceTable *calendarTable;

@end

@implementation OverviewInterfaceController

- (instancetype)initWithContext:(id)context
{
    self = [super initWithContext: context];
	
	if (self) {
		[self setUpTable];
	}
	
    return self;
}

- (void)setUpTable
{
	AdventCalendar *calendar = AdventCalendar.soulmenCalendar;
	
	NSUInteger rowIndex = 0;
	
	for (NSUInteger day = 1; day < calendar.numberOfDays; day ++) {
		NSArray *entriesForDay = [calendar entriesForDay: day];
		
		// Insert day label row
		[self.calendarTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex: rowIndex] withRowType:@"dayRow"];
		DayRowController *dayRow = [self.calendarTable rowControllerAtIndex: rowIndex ];
		dayRow.day = day;
		
		
		// Insert calendar entries for day
		rowIndex ++;
		[self.calendarTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange(rowIndex, entriesForDay.count)] withRowType:@"personByDay"];
		
		for (AdventCalendarEntry *entry in entriesForDay) {
			EntryRowController *rowController = [self.calendarTable rowControllerAtIndex: rowIndex ++];
			rowController.calendarEntry = entry;
		}
	}
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
	EntryRowController *rowController = [self.calendarTable rowControllerAtIndex: rowIndex];
	[self pushControllerWithName:@"Person Interface" context:rowController.calendarEntry.person];
}

@end




//
//  AdventCalendarEntry.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 03/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "AdventCalendarEntry.h"

@implementation AdventCalendarEntry

+ (instancetype)entryWithPerson:(NSString *)person doorIndex:(NSUInteger)doorIndex kind:(AdventCalendarKind)calendar
{
	return [[self alloc] initWithPerson:person doorIndex:doorIndex kind:calendar];
}

- (instancetype)initWithPerson:(NSString *)person doorIndex:(NSUInteger)doorIndex kind:(AdventCalendarKind)calendar
{
	NSParameterAssert(person);
	NSParameterAssert(doorIndex >= 1);
	NSParameterAssert(doorIndex <= 24);
	
	self = [super init];
	
	if (self) {
		_person = person;
		_doorIndex = doorIndex;
		_calendarKind = calendar;
	}
	
	return self;
}

- (UIColor *)calendarColor
{
	switch (self.calendarKind) {
		case AdventCalendarBlue:
			return [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
		case AdventCalendarRed:
			return [UIColor redColor];
	}
}

@end

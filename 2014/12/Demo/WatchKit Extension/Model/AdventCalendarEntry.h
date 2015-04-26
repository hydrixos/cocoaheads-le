//
//  AdventCalendarEntry.h
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 03/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

/*!
 @abstract The advent calendar that has been assigned to a person.
 */
typedef enum : NSUInteger {
	AdventCalendarBlue,
	AdventCalendarRed
} AdventCalendarKind;

/*!
 @abstract A single entry inside an advent calendar
 */
@interface AdventCalendarEntry : NSObject

/*!
 @abstract Initializes a new entry for the given person, door index and calendar kind.
 */
+ (instancetype)entryWithPerson:(NSString *)person doorIndex:(NSUInteger)doorIndex kind:(AdventCalendarKind)calendar;

/*!
 @abstract The name of the person assigned to this entry.
 */
@property(nonatomic, readonly) NSString *person;

/*!
 @abstract The door to be opened by the entry's person.
 */
@property(nonatomic, readonly) NSUInteger doorIndex;

/*!
 @abstract The calendar the assigned door belongs to.
 */
@property(nonatomic, readonly) AdventCalendarKind calendarKind;

/*!
 @abstract The UIColor used for the calendar kind.
 */
@property(nonatomic, readonly) UIColor *calendarColor;

@end


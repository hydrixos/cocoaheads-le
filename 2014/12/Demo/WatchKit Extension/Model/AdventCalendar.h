//
//  AdventCalendar.h
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 02/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

@class AdventCalendarEntry;

/*!
 @abstract The global advent calendar
 */
@interface AdventCalendar : NSObject

/*!
 @abstract Soulmen's universal truth for 2014.
 */
+ (AdventCalendar *)soulmenCalendar;

/*!
 @abstract The highest day available in the calendar.
 */
@property(nonatomic, readonly) NSUInteger numberOfDays;

/*!
 @abstract The total count of entries available in the calendar.
 */
@property(nonatomic, readonly) NSUInteger numberOfEntries;

/*!
 @abstract Returns an array of all entries on a particular day.
 */
- (NSArray *)entriesForDay:(NSUInteger)day;

/*!
 @abstract Returns a dictionary mapping from days to entries of a person.
 */
- (NSDictionary *)entriesForPerson:(NSString *)person;

/*!
 @abstract Provides a days's entry for a particular person.
 */
- (AdventCalendarEntry *)entryForPerson:(NSString *)person day:(NSUInteger)day;

@end

//
//  AdventCalendar.m
//  WatchKit Sample
//
//  Created by Friedrich Gräter on 02/12/14.
//  Copyright (c) 2014 The Soulmen GbR. All rights reserved.
//

#import "AdventCalendar.h"

#import "AdventCalendarEntry.h"

@interface AdventCalendar ()

@property(nonatomic, readonly) NSDictionary *entriesForPerson;

@end

@implementation AdventCalendar

+ (AdventCalendar *)soulmenCalendar
{
	static AdventCalendar *soulmenCalendar;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		// Load calendar
		NSDictionary *serializedEntriesForPerson = [NSDictionary dictionaryWithContentsOfURL: [NSBundle.mainBundle URLForResource:@"Soulmen" withExtension:@"plist"]];
		NSMutableDictionary *entriesForPerson = [NSMutableDictionary new];
		__block NSUInteger numberOfDays = 0;
		
		// Deserialize
		[serializedEntriesForPerson enumerateKeysAndObjectsUsingBlock:^(NSString *person, NSString *unparsed, BOOL *stop) {
			NSMutableDictionary *entryByDay = [NSMutableDictionary new];
			NSArray *unparsedEntries = [unparsed componentsSeparatedByString: @","];
			
			[unparsedEntries enumerateObjectsUsingBlock:^(NSString *unparsedEntry, NSUInteger day, BOOL *stop) {
				if ([unparsedEntry hasPrefix: @"-"] || unparsedEntry.length == 0)
					return;
				
				AdventCalendarKind kind = [[unparsedEntry substringToIndex: 1] isEqual: @"r"] ? AdventCalendarRed : AdventCalendarBlue;
				NSUInteger doorIndex = [[unparsedEntry substringFromIndex: 1] integerValue];
				
				entryByDay[@(day+1)] = [AdventCalendarEntry entryWithPerson:person doorIndex:doorIndex kind:kind];
			}];
			
			entriesForPerson[person] = entryByDay;
			numberOfDays = MAX(unparsedEntries.count, numberOfDays);
		}];
		
		soulmenCalendar = [[AdventCalendar alloc] initWithEntriesForPersons:entriesForPerson numberOfDays:numberOfDays];
	});
	
	return soulmenCalendar;
}

- (instancetype)initWithEntriesForPersons:(NSDictionary *)entriesForPerson numberOfDays:(NSUInteger)numberOfDays
{
	self = [super init];
	
	if (self) {
		_entriesForPerson = entriesForPerson;
		_numberOfDays = numberOfDays;
		_numberOfEntries = 0;
		
		[entriesForPerson enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *entriesByDay, BOOL *stop) {
			_numberOfEntries += entriesByDay.count;
		}];
	}
	
	return self;
}

- (NSArray *)entriesForDay:(NSUInteger)day
{
	NSMutableArray *entries = [NSMutableArray new];
	
	[self.entriesForPerson enumerateKeysAndObjectsUsingBlock:^(NSString *person, NSDictionary *entryByDay, BOOL *stop) {
		AdventCalendarEntry *entry = entryByDay[@(day)];
		if (entry)
			[entries addObject: entry];
	}];
	
	return entries;
}

- (NSDictionary *)entriesForPerson:(NSString *)person
{
	return self.entriesForPerson[person];
}

- (AdventCalendarEntry *)entryForPerson:(NSString *)person day:(NSUInteger)day
{
	return self.entriesForPerson[person][@(day)];
}

@end

//
//  SlidingWindowArray.m
//  Squats
//
//  Created by Götz Fabian on 14/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "SlidingWindowArray.h"

@interface SlidingWindowArray ()

@property(nonatomic, readonly) NSUInteger size;

@property(nonatomic) CGFloat *values;
@property(nonatomic) NSUInteger valueIndex;
@property(nonatomic) BOOL isFillingUp;

@end

@implementation SlidingWindowArray

- (instancetype)initWithSize:(NSUInteger)size
{
	NSParameterAssert(size > 0);
	
	self = [super init];
	
	if (self) {
		_size = size;
		
		_values = malloc(sizeof(CGFloat) * self.size);
		[self resetValues];
	}
	
	return self;
}

- (void)dealloc
{
	free(_values);
}


#pragma mark -

- (void)addValue:(CGFloat)value
{
	self.values[self.valueIndex] = value;
	
	if (self.valueIndex == self.size-1)
		self.isFillingUp = NO;
	
	self.valueIndex = ++self.valueIndex % self.size;
}

- (void)resetValues
{
	for (NSUInteger idx = 0; idx < self.size; idx++)
		_values[idx] = 0.0;
	
	_valueIndex = 0;
	_isFillingUp = YES;
}

- (void)printValues
{
	NSMutableString *str = [NSMutableString new];
	for (NSUInteger idx = 0; idx < self.size; idx++)
		[str appendFormat: @"%f ", self.values[idx]];
	
	NSLog(@"min: %f max: %f median: %f", self.minValue, self.maxValue, self.medianValue);
}


#pragma mark - Accessors

- (NSUInteger)maxIndex
{
	return self.isFillingUp ? self.valueIndex : self.size;
}

- (CGFloat)averageValue
{
	if (self.maxIndex == 0)
		return 0.0;
	
	CGFloat sum = 0.0;
	for (NSUInteger idx = 0; idx < self.maxIndex; idx++)
		sum += self.values[idx];
	
	return (sum / self.maxIndex);
}

- (CGFloat)medianValue
{
	if (self.maxIndex == 0)
		return 0.0;
	
	return self.values[self.maxIndex/2];
}

- (CGFloat)minValue
{
	CGFloat minValue = CGFLOAT_MAX;
	NSUInteger maxIndex = self.maxIndex;
	if (maxIndex == 0)
		return minValue;
	
	for (NSUInteger idx = 0; idx < maxIndex; idx++)
		minValue = fmin(minValue, self.values[idx]);
	
	return minValue;
}

- (CGFloat)maxValue
{
	CGFloat maxValue = CGFLOAT_MIN;
	NSUInteger maxIndex = self.maxIndex;
	if (maxIndex == 0)
		return maxValue;
	
	for (NSUInteger idx = 0; idx < maxIndex; idx++)
		maxValue = fmax(maxValue, self.values[idx]);
	
	return maxValue;
}

@end

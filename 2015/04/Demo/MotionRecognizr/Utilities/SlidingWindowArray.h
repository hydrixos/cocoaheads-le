//
//  SlidingWindowArray.h
//  Squats
//
//  Created by Götz Fabian on 14/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//


@interface SlidingWindowArray : NSObject

- (instancetype)initWithSize:(NSUInteger)size;

- (void)addValue:(CGFloat)value;
- (void)resetValues;

- (void)printValues;

@property(nonatomic, readonly) CGFloat averageValue;
@property(nonatomic, readonly) CGFloat medianValue;
@property(nonatomic, readonly) CGFloat minValue;
@property(nonatomic, readonly) CGFloat maxValue;

@end

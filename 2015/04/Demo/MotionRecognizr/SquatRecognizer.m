//
//  SquatRecognizer.m
//  Squats
//
//  Created by Götz Fabian on 14/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "SquatRecognizer.h"
#import "MotionRecognizer_Subclassing.h"

#import "SlidingWindowArray.h"


static NSUInteger SquatRecognizerSlidingWindowSize	= 10;


typedef enum : NSUInteger {
	SquatStateIdle,
	SquatStateDownwards,
	SquatStateUpwards,
	SquatStateUp
} SquatRecognizerState;


@interface SquatRecognizer ()

@property(nonatomic, readonly) NSOperationQueue *motionQueue;

@property(nonatomic) SlidingWindowArray *values;

@property(nonatomic) SquatRecognizerState state;

@end

@implementation SquatRecognizer

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		_motionQueue = [NSOperationQueue new];
		_values = [[SlidingWindowArray alloc] initWithSize: SquatRecognizerSlidingWindowSize];
	}
	
	return self;
}

- (void)dealloc
{
	if (self.motionManager.isDeviceMotionActive)
		[self.motionManager stopDeviceMotionUpdates];
}


#pragma mark - Accessors

- (void)setState:(SquatRecognizerState)state
{
	if (_state == state)
		return;
	
	_state = state;
	
	if (state == SquatStateUpwards)
		self.count++;
}

+ (NSString *)displayName
{
	return @"Squats";
}


#pragma mark - Motion Change Handling

- (void)orientationDidChange
{
	// Only recognize squats when held in landscape
	BOOL isRecognizingSquats = (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight);
	
	if (isRecognizingSquats)
		[self beginFetchingDeviceMotionUpdates];
	
	else if (self.motionManager.isDeviceMotionActive)
		[self.motionManager stopDeviceMotionUpdates];
	
	self.isRecognizingMotion = isRecognizingSquats;
}

- (void)beginFetchingDeviceMotionUpdates
{
	// Reset state
	self.state = SquatStateIdle;
	[self.values resetValues];
	
	// Set up device motion updates
	NSAssert(self.motionManager.deviceMotionAvailable, @"There are no device motion data available. Are you using the iOS simulator, dumbass?");
	self.motionManager.deviceMotionUpdateInterval = 0.01;
	
	// Pull updates
	[self.motionManager startDeviceMotionUpdatesToQueue:self.motionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
		if (motion)
			[self handleDeviceMotionUpdate: motion];
	}];
}

- (void)handleDeviceMotionUpdate:(CMDeviceMotion *)motion
{
	// We only care about x acceleration
	[self.values addValue: motion.userAcceleration.x];
	
	CGFloat median = self.values.medianValue;
	CGFloat minValue = self.values.minValue;
	CGFloat maxValue = self.values.maxValue;
	
	switch (self.state) {
		// Downwards motion
		case SquatStateIdle:
			if (median < -0.4)
				self.state = SquatStateDownwards;
			break;
		case SquatStateDownwards:
			if (median > 0.3)
				self.state = SquatStateUpwards;
			break;
			
		// Upwards motion
		case SquatStateUpwards:
			if (median < -0.3)
				self.state = SquatStateUp;
			break;
		case SquatStateUp:
			if (maxValue < 0.2 && minValue > -0.2)
				self.state = SquatStateIdle;
			break;
	}
}


#pragma mark - Debugging

- (NSString *)stateDescription
{
	switch (self.state) {
		case SquatStateIdle:
			return @"Idle";
		case SquatStateDownwards:
			return @"Downwards";
		case SquatStateUpwards:
			return @"Upwards";
		case SquatStateUp:
			return @"Up";
	}
}

+ (NSSet *)keyPathsForValuesAffectingStateDescription
{
	return [NSSet setWithObject: @"state"];
}

@end

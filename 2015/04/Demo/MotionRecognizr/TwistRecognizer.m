//
//  TwistRecognizer.m
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "TwistRecognizer.h"
#import "MotionRecognizer_Subclassing.h"

#import "SlidingWindowArray.h"

#define RAD_TO_DEG(rad) (rad*180/M_PI)


static NSUInteger TwistRecognizerSlidingWindowSize	= 10;


typedef enum : NSUInteger {
	TwistStateMiddle,
	TwistStateLeft,
	TwistStateRight
} TwistRecognizerState;

@interface TwistRecognizer ()

@property(nonatomic, readonly) NSOperationQueue *motionQueue;

@property(nonatomic) SlidingWindowArray *values;
@property(nonatomic) TwistRecognizerState state;

@end

@implementation TwistRecognizer

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		_motionQueue = [NSOperationQueue new];
		_values = [[SlidingWindowArray alloc] initWithSize: TwistRecognizerSlidingWindowSize];
	}
	
	return self;
}

- (void)dealloc
{
	if (self.motionManager.isDeviceMotionActive)
		[self.motionManager stopDeviceMotionUpdates];
}


#pragma mark - Accessors

- (void)setState:(TwistRecognizerState)state
{
	if (_state == state)
		return;

	TwistRecognizerState oldState = _state;
	_state = state;
	
	if (oldState == TwistStateRight && state == TwistStateMiddle)
		self.count++;
}

+ (NSString *)displayName
{
	return @"Russian Twists";
}


#pragma mark - Motion Change Handling

- (void)orientationDidChange
{
	// Only recognize twists when held in landscape
	BOOL isRecognizingTwists = (UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight);
	
	if (isRecognizingTwists)
		[self beginFetchingDeviceMotionUpdates];
	
	else if (self.motionManager.isDeviceMotionActive)
		[self.motionManager stopDeviceMotionUpdates];
	
	self.isRecognizingMotion = isRecognizingTwists;
}

- (void)beginFetchingDeviceMotionUpdates
{
	// Reset state
	self.state = TwistStateMiddle;
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
	// We only care about yaw
	[self.values addValue: RAD_TO_DEG(motion.attitude.yaw)];
	
	CGFloat medianValue = self.values.medianValue;
	
	switch (self.state) {
		case TwistStateMiddle:
			if (medianValue > 60)
				self.state = TwistStateLeft;
			else if (medianValue < -60)
				self.state = TwistStateRight;
			break;
			
		case TwistStateLeft:
			if (medianValue < 10)
				self.state = TwistStateMiddle;
			break;
			
		case TwistStateRight:
			if (medianValue > -10)
				self.state = TwistStateMiddle;
			break;
	}
}


#pragma mark - Debugging

- (NSString *)stateDescription
{
	switch (self.state) {
		case TwistStateMiddle:
			return @"Middle";
		case TwistStateLeft:
			return @"Left";
		case TwistStateRight:
			return @"Right";
	}
}

+ (NSSet *)keyPathsForValuesAffectingStateDescription
{
	return [NSSet setWithObject: @"state"];
}

@end

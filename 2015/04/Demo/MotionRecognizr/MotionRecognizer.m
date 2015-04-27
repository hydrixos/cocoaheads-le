//
//  MotionRecognizer.m
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "MotionRecognizer_Subclassing.h"

@implementation MotionRecognizer

- (instancetype)init
{
	self = [super init];

	if (self) {
		[self beginOrientationChangeObservation];
	}

	return self;
}

- (void)dealloc
{
	[NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - Accessors

- (CMMotionManager *)motionManager
{
	static CMMotionManager *motionManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		motionManager = [CMMotionManager new];
	});
	
	return motionManager;
}

+ (NSString *)displayName
{
	NSAssert(NO, @"Must be overwritten by concrete subclasses!");
	return nil;
}


#pragma mark - Orientation Change Observation

- (void)beginOrientationChangeObservation
{
	if (!UIDevice.currentDevice.isGeneratingDeviceOrientationNotifications)
		[UIDevice.currentDevice beginGeneratingDeviceOrientationNotifications];
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	[self orientationDidChange];
}

- (void)_orientationDidChange:(NSNotification *)notification
{
	[self orientationDidChange];
}

- (void)orientationDidChange
{
	// Default implementaiton is empty
}

@end

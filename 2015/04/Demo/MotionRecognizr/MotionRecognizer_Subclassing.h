//
//  MotionRecognizer_Subclassing.h
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "MotionRecognizer.h"

#import <CoreMotion/CoreMotion.h>


@interface MotionRecognizer (Subclassing)

- (void)orientationDidChange;

@end

@interface MotionRecognizer ()

@property(nonatomic, readonly) CMMotionManager *motionManager;

@property(nonatomic, readwrite) BOOL isRecognizingMotion;
@property(nonatomic, readwrite) NSUInteger count;

@end

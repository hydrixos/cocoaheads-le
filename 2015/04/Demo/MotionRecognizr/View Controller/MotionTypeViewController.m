//
//  MotionTypeViewController.m
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "MotionTypeViewController.h"

#import "MotionCounterViewController.h"
#import "SquatRecognizer.h"
#import "TwistRecognizer.h"


@implementation MotionTypeViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	MotionRecognizer *recognizer;
	if ([segue.identifier isEqual: @"squatSegue"])
		recognizer = [SquatRecognizer new];
	else if ([segue.identifier isEqual: @"russianTwistSegue"])
		recognizer = [TwistRecognizer new];
	else
		NSAssert(NO, @"Invalid segue with identifier '%@'.", segue.identifier);
	
	[segue.destinationViewController setTitle: [recognizer.class displayName]];
	
	[segue.destinationViewController setMotionRecognizer: recognizer];
}

@end

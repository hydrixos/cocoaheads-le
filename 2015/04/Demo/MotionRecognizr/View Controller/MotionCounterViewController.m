//
//  MotionCounterViewController.m
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "MotionCounterViewController.h"

#import "MotionRecognizer.h"


// KVO Contexts
void *MotionCounterViewControllerIsRecognizingMotionContext = @"isRecognizingMotion";
void *MotionCounterViewControllerCountContext = @"count";
void *MotionCounterViewControllerStateDescriptionContext = @"stateDescription";


@interface MotionCounterViewController ()

@property(nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic) IBOutlet UILabel *placeholderLabel;

@property(nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation MotionCounterViewController

- (void)dealloc
{
	self.motionRecognizer = nil;
}


#pragma mark - Accessors

- (void)setMotionRecognizer:(MotionRecognizer *)motionRecognizer
{
	[_motionRecognizer removeObserver:self forKeyPath:@"isRecognizingMotion" context:MotionCounterViewControllerIsRecognizingMotionContext];
	[_motionRecognizer removeObserver:self forKeyPath:@"count" context:MotionCounterViewControllerCountContext];
	[_motionRecognizer removeObserver:self forKeyPath:@"stateDescription" context:MotionCounterViewControllerStateDescriptionContext];
	
	_motionRecognizer = motionRecognizer;
	
	[_motionRecognizer addObserver:self forKeyPath:@"isRecognizingMotion" options:NSKeyValueObservingOptionInitial context:MotionCounterViewControllerIsRecognizingMotionContext];
	[_motionRecognizer addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionInitial context:MotionCounterViewControllerCountContext];
	[_motionRecognizer addObserver:self forKeyPath:@"stateDescription" options:NSKeyValueObservingOptionInitial context:MotionCounterViewControllerStateDescriptionContext];
}


#pragma mark - Observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// Recognizer started/stopped recognizing
	if (context == MotionCounterViewControllerIsRecognizingMotionContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self updateLabels];
		});
	}
	
	// Motion count changed
	else if (context == MotionCounterViewControllerCountContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self updateLabels];
		});
	}
	
	// State description changed
	else if (context == MotionCounterViewControllerStateDescriptionContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.stateLabel.text = self.motionRecognizer.stateDescription;
		});
	}
	
	// Default handling
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)updateLabels
{
	BOOL isRecognizingMotion = self.motionRecognizer.isRecognizingMotion;
	
	self.placeholderLabel.hidden = isRecognizingMotion;
	self.countLabel.hidden = !isRecognizingMotion;
	
	if (isRecognizingMotion)
		self.countLabel.text = [NSString stringWithFormat: @"%ld", (unsigned long)self.motionRecognizer.count];
}

@end

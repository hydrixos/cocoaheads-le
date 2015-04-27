//
//  MotionRecognizer.h
//  Squats
//
//  Created by Götz Fabian on 15/04/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//


@interface MotionRecognizer : NSObject

+ (NSString *)displayName;

@property(nonatomic, readonly) BOOL isRecognizingMotion;
@property(nonatomic, readonly) NSUInteger count;

@end

@interface MotionRecognizer (Debugging)

@property(nonatomic, readonly) NSString *stateDescription;

@end
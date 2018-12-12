//
//  NonVibrantLabel.m
//  Dark Mode Sample
//
//  Created by Florian Lücke on 06.11.18.
//  Copyright © 2018 Florian Lücke. All rights reserved.
//

#import "NonVibrantLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NonVibrantLabel ()

@end


@implementation NonVibrantLabel

- (BOOL)allowsVibrancy
{
	return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect: dirtyRect];
}

@end

NS_ASSUME_NONNULL_END

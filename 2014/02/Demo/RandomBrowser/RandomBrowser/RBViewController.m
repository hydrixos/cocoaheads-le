//
//  RBViewController.m
//  RandomBrowser
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import "RBViewController.h"
#import <ReactiveCocoa.h>

@interface RBViewController ()
{
	RACSignal *_URLSignal;
	RACSignal *_HTMLSignal;
}

@end

@implementation RBViewController

- (RACSignal *)URLSignal
{
	_URLSignal = _URLSignal ?: [[[[self.randomPageButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
		NSArray *URLs = @[@"http://www.ulyssesapp.com", @"http://wikipedia.org", @"http://apple.com", @"http://www.daedalusapp.com/", @"http://www.cocoaheads.org/"];
		NSString *string = URLs[arc4random() % URLs.count];
		return [NSURL URLWithString: string];
	}] publish] autoconnect];
	
	return _URLSignal;
}

- (RACSignal *)htmlSignal
{
	_HTMLSignal = _HTMLSignal ?: [[[self.URLSignal flattenMap:^RACStream *(NSURL *url) {
		NSStringEncoding encoding = NSUTF8StringEncoding;
		NSLog(@"Query: %@", url.absoluteString);
		
		return [NSString rac_readContentsOfURL:url usedEncoding:&encoding scheduler:[RACScheduler scheduler]];
	}] publish] autoconnect];
	
	return _HTMLSignal;
}

- (void)viewDidLoad
{
	// Show URL
	RAC(self.currentURLLabel, text) = [self.URLSignal map:^id(NSURL *url) { return url.absoluteString; }];

	// Connect source view
	RAC(self.sourceView, text) = [self.htmlSignal deliverOn: RACScheduler.mainThreadScheduler];

	// Connect web view
	[self.webView rac_liftSelector:@selector(loadHTMLString:baseURL:) withSignals:[self.htmlSignal deliverOn: RACScheduler.mainThreadScheduler], self.URLSignal, nil];
}

@end

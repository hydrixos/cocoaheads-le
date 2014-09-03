//
//  RBViewController.h
//  RandomBrowser
//
//  Created by Friedrich Gräter on 02.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *randomPageButton;
@property (nonatomic, strong) IBOutlet UILabel *currentURLLabel;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UITextView *sourceView;

@end

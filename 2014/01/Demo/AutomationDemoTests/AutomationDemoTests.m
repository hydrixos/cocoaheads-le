//
//  AutomationDemoTests.m
//  AutomationDemoTests
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import <KIF/KIF.h>
#import "TRStateController.h"
#import "TRHomeViewController.h"

@interface AutomationDemoTests : KIFTestCase

@end

@implementation AutomationDemoTests

- (void)afterEach
{
    [super afterEach];
    [self navigateToHomeScreenAndLogout];
}


- (void)navigateToHomeScreenAndLogout
{
    UINavigationController *navigationController = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [navigationController popToRootViewControllerAnimated:NO];

    if (navigationController.presentedViewController)
    {
        [navigationController dismissViewControllerAnimated:NO completion:nil];
    }

    [((TRHomeViewController *)[navigationController.viewControllers firstObject]) logout];
}


- (void)loginWithUsername:(NSString *)userName andPassword:(NSString *)password
{
    [tester waitForViewWithAccessibilityLabel:@"Home"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Sign in"];
    [tester tapViewWithAccessibilityLabel:@"Sign in"];
    [tester waitForTappableViewWithAccessibilityLabel:@"User name"];
    [tester tapViewWithAccessibilityLabel:@"User name"];
    [tester enterText:userName intoViewWithAccessibilityLabel:@"User name"];
    [tester clearTextFromAndThenEnterText:password intoViewWithAccessibilityLabel:@"Password"];
    [tester tapViewWithAccessibilityLabel:@"Sign in"];
}


- (void)test_login_with_right_credentials_opens_inbox
{
    [self loginWithUsername:@"admin" andPassword:@"secure"];
    [tester waitForViewWithAccessibilityLabel:@"Inbox"];
}


- (void)test_login_with_wrong_credentials_shows_alert
{
    [self loginWithUsername:@"wrongUserName" andPassword:@"password"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Try again" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Try again" traits:UIAccessibilityTraitButton];
}


- (void)test_showing_first_mail_opens_mail_details
{
    [self loginWithUsername:@"admin" andPassword:@"secure"];
    [tester tapRowInTableViewWithAccessibilityLabel:@"All Mails" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [tester waitForViewWithAccessibilityLabel:@"Details"];
    [tester waitForTimeInterval:1];
}

@end

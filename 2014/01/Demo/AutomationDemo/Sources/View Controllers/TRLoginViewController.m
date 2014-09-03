//
//  TRLoginViewController.m
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TRLoginViewController.h"

NSString * const GRANTED_USER_NAME = @"admin";

NSString * const GRANTED_PASSWORD = @"secure";

@interface TRLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TRLoginViewController

- (void)showLoginFailedAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login failed", nil) message:NSLocalizedString(@"The credentials you provided are not correct.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Try again", nil) otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - Actions

- (IBAction)usernameChanged:(id)sender
{
    self.loginButton.enabled = [self.usernameTextField.text length] > 0 && [self.passwordTextField.text length] > 0;
}


- (IBAction)passwordChangedAction:(id)sender
{
    self.loginButton.enabled = [self.usernameTextField.text length] > 0 && [self.passwordTextField.text length] > 0;
}


- (IBAction)loginButtonAction:(id)sender
{
    [self.view endEditing:YES];

    NSString *userName = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.loginButton.enabled = NO;

    [self.activityIndicator startAnimating];

    __weak typeof(self)weakSelf = self;

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        weakSelf.usernameTextField.enabled = YES;
        weakSelf.passwordTextField.enabled = YES;
        weakSelf.loginButton.enabled = YES;

        [weakSelf.activityIndicator stopAnimating];

        if ([userName isEqualToString:GRANTED_USER_NAME] && [password isEqualToString:GRANTED_PASSWORD])
        {
            [weakSelf performSegueWithIdentifier:@"UserLoggedIn" sender:weakSelf];
        }
        else
        {
            [weakSelf showLoginFailedAlert];
        }
    });
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField && [textField.text length] > 0)
    {
        [self loginButtonAction:textField];
    }
    else
    {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}


@end

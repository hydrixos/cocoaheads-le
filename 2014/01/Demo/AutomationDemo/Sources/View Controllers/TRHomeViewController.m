//
//  TRViewController.m
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TRHomeViewController.h"
#import "TREmailTableViewController.h"
#import "TRStateController.h"


@interface TRHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end



@implementation TRHomeViewController


- (void)showTable
{
    [self performSegueWithIdentifier:@"ShowTable" sender:self];
}


- (void)showLogin
{
    [self performSegueWithIdentifier:@"ShowLogin" sender:self];
}


- (void)logout
{
    [TRStateController sharedStateController].loggedIn = NO;
    [self updateSignInButtonLabel];
}


- (void)updateSignInButtonLabel
{
    if ([TRStateController sharedStateController].isLoggedIn)
    {
        [self.signInButton setTitle:@"Log out admin" forState:UIControlStateNormal];
        self.signInButton.accessibilityLabel = @"Log out admin";
    }
    else
    {
        [self.signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
        self.signInButton.accessibilityLabel = @"Sign in";
    }
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateSignInButtonLabel];
}


#pragma mark - Actions

- (IBAction)startButtonAction:(UIButton *)sender
{
    if ([TRStateController sharedStateController].isLoggedIn)
    {
        [self logout];
    }
    else
    {
        [self showLogin];
    }
}


#pragma mark - Segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTable"])
    {
        TREmailTableViewController *emailViewController = segue.destinationViewController;
        emailViewController.mails = [TRStateController sharedStateController].mails;
    }
}


- (IBAction)cancelLogin:(UIStoryboardSegue *)segue
{
}


- (IBAction)userLoggedIn:(UIStoryboardSegue *)segue
{
    [TRStateController sharedStateController].loggedIn = YES;

    [self performSelector:@selector(showTable) withObject:nil afterDelay:0.25];
}

@end

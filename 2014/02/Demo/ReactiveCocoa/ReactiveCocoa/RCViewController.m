//
//  RCViewController.m
//  ReactiveCocoa
//
//  Created by Friedrich Gräter on 01.02.14.
//  Copyright (c) 2014 Friedrich Gräter. All rights reserved.
//

#import "RCViewController.h"
#import "RCNetworkManager.h"
#import "RCViewModel.h"

#import <ReactiveCocoa.h>

@interface RCViewController ()

@property(nonatomic) IBOutlet UITextField	*usernameField;
@property(nonatomic) IBOutlet UITextField	*passwordField;
@property(nonatomic) IBOutlet UITextField	*confirmationField;
@property(nonatomic) IBOutlet UILabel		*connectivityLabel;

@property(nonatomic) IBOutlet UIButton		*signUpButton;

@property(nonatomic) RCViewModel *viewModel;

@end

@implementation RCViewController

#pragma mark - Form validation

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.viewModel = [RCViewModel new];

	// Bind with view model
	RAC(self.viewModel, username) = self.usernameField.rac_textSignal;
	RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
	RAC(self.viewModel, passwordConfirmation) = self.confirmationField.rac_textSignal;
	
	RAC(self.signUpButton, enabled) = self.viewModel.signupAllowedSignal;
	RAC(self.connectivityLabel, hidden) = RCNetworkManager.networkAvailabilitySignal;
}

@end

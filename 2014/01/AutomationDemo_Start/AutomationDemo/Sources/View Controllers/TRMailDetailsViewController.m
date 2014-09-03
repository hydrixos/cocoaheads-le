//
//  TRMailDetailsViewController.m
//  AutomationDemo
//
//  Created by trispo on 07/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TRMailDetailsViewController.h"
#import "TRMailModel.h"
#import "NSDate+Format.h"

@interface TRMailDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorHeightConstraint;

@end

@implementation TRMailDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.accessibilityLabel = @"Details";

    self.topSeparatorHeightConstraint.constant = 0.5;
    self.bottomSeparatorHeightConstraint.constant = 0.5;

    self.senderLabel.text = self.mail.displayName;
    self.subjectLabel.text = self.mail.subject;
    self.dateLabel.text = [self.mail.sentDate longFormattedString];
    self.bodyLabel.text = self.mail.body;
}


@end

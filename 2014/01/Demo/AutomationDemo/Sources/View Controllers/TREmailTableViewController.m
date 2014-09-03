//
//  TREmailTableViewController.m
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import "TREmailTableViewController.h"
#import "TREmailCell.h"
#import "TRMailModel.h"
#import "NSDate+Format.h"
#import "TRMailDetailsViewController.h"


@implementation TREmailTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.accessibilityLabel = @"All Mails";
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mails count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TREmailCell *cell = (TREmailCell *)[tableView dequeueReusableCellWithIdentifier:@"TREmailCell" forIndexPath:indexPath];

    TRMailModel *mail = self.mails[indexPath.row];

    cell.senderLabel.text = mail.displayName;
    cell.subjectLabel.text = mail.subject;
    cell.bodyLabel.text = mail.body;
    cell.dateLabel.text = [mail.sentDate formattedString];
    
    return cell;
}


#pragma mark - Segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

    if ([segue.identifier isEqualToString:@"ShowMail"])
    {
        ((TRMailDetailsViewController *)segue.destinationViewController).mail = self.mails[indexPath.row];
    }
}

@end

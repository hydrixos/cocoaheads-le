//
//  TREmailCellTableViewCell.h
//  AutomationDemo
//
//  Created by trispo on 04/01/14.
//  Copyright (c) 2014 trispo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TREmailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

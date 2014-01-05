//
//  NEPHistoryViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 22/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPEditWorkDayProtocol.h"

@interface NEPHistoryViewController : UITableViewController <NEPEditWorkDayProtocol>

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

- (IBAction)filterPriorMonthButtonAction:(id)sender;
- (IBAction)filterNextMonthButtonAction:(id)sender;


- (IBAction)backButtonAction:(id)sender;

@end

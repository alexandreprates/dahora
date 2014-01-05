//
//  NEPHistoryCell.h
//  Da Hora
//
//  Created by Alexandre Prates on 25/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEPHistoryCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginningLabel;
@property (weak, nonatomic) IBOutlet UILabel *endingLabel;
@property (weak, nonatomic) IBOutlet UILabel *worktimeLabel;

- (void)workDay:(NSDate *)beginning to:(NSDate *)ending;

@end

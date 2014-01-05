//
//  NEPWorkingViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 19/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPTimeIntervalPickerProtocol.h"
#import "NEPWorkDay.h"


@interface NEPWorkingViewController : UIViewController <NEPTimeIntervalPickerProtocol>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)finishWorkButtonAction:(id)sender;
- (IBAction)pageChanged:(id)sender;

- (void)checkNotifications;

@end

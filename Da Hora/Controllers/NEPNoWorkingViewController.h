//
//  NEPNoWorkingViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 19/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEPNoWorkingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *beginningDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *beginningButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)startWorkingButtonAction:(id)sender;

@end

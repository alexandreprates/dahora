//
//  NEPNoWorkingViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 19/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPNoWorkingViewController.h"
#import "NEPWorkDay.h"
#import "NEPWorkingViewController.h"

@interface NEPNoWorkingViewController ()

@end

@implementation NEPNoWorkingViewController

- (void)viewDidLoad {
    self.view.hidden = true;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 200);
}

- (void)viewDidAppear:(BOOL)animated {
    if (NEPWorkDay.current.started) {
        [self performSegueWithIdentifier:@"WorkInProgress" sender:self];
    } else {
        _beginningDatePicker.date = [NSDate date];
        self.view.hidden = false;
    }
}

- (IBAction)startWorkingButtonAction:(id)sender {
    NEPWorkDay.current.beginning = _beginningDatePicker.date;
    [NEPWorkDay saveCurrent];
    [self performSegueWithIdentifier:@"WorkInProgress" sender:self];
}

@end

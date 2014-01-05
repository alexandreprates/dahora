//
//  NEPHourInfo.m
//  Da Hora
//
//  Created by Alexandre Prates on 04/01/14.
//  Copyright (c) 2014 MyAppLab. All rights reserved.
//

#import "NEPHourInfo.h"

@implementation NEPHourInfo


- (NEPHourInfo *)viewFromStoryboard {
    return [NEPHourInfo viewFromStoryboard:NSStringFromClass([self class])];
}

+ (id)viewFromStoryboard:(NSString *)storyboardID {
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:storyboardID];
	
	NEPHourInfo * myView = (NEPHourInfo *)(controller.view);
	return myView;
}

- (void)display:(NSDate *)date andInfo:(NSString *)message {
    _infoLabel.text = message;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH mm"];
    _hourLabel.text = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"EEEE, dd 'de' MMMM"];
    _dateLabel.text = [dateFormatter stringFromDate:date];
}

@end

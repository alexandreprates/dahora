//
//  NEPHourInfo.h
//  Da Hora
//
//  Created by Alexandre Prates on 04/01/14.
//  Copyright (c) 2014 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEPHourInfo : UIView
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

+ (id)viewFromStoryboard:(NSString *)storyboardId;
- (NEPHourInfo *)viewFromStoryboard;

- (void)display:(NSDate *)date andInfo:(NSString *)message;

@end

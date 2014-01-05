//
//  NEPToolBarView.m
//  Da Hora
//
//  Created by Alexandre Prates on 04/01/14.
//  Copyright (c) 2014 MyAppLab. All rights reserved.
//

#import "NEPToolBarView.h"

@implementation NEPToolBarView

- (void)didMoveToSuperview {
    [_infoBarButton setTitle:@" "];
    [_infoBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"dripicons" size:22]} forState:UIControlStateNormal];
    
    [_historyBarButton setTitle:@""];
    [_historyBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"dripicons" size:22]} forState:UIControlStateNormal];
    
    [_settingsBarButton setTitle:@" "];
    [_settingsBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"dripicons" size:22]} forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

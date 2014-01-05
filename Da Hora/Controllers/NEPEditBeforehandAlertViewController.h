//
//  NEPEditBeforehandAlertViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 02/01/14.
//  Copyright (c) 2014 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPEditBeforehandProtocol.h"

@interface NEPEditBeforehandAlertViewController : UITableViewController <NEPEditBeforehandProtocol>

@property (strong, nonatomic) id <NEPEditBeforehandProtocol> delegate;
@property int currentSeconds;

@end

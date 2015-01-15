//
//  StatusViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-13.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *myStatus;
@property (strong, nonatomic) IBOutlet UITextField *statusMessage;
@property (strong, nonatomic) IBOutlet UISwitch *redNotifEn;
@property (strong, nonatomic) IBOutlet UISwitch *orangeNotifEn;
@property (strong, nonatomic) IBOutlet UISwitch *greenNotifEn;

@end

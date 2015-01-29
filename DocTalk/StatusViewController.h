//
//  StatusViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-13.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *myStatus;
@property (strong, nonatomic) IBOutlet UISwitch *redNotifEn;
@property (strong, nonatomic) IBOutlet UISwitch *orangeNotifEn;
@property (strong, nonatomic) IBOutlet UISwitch *greenNotifEn;
@property (weak, nonatomic) IBOutlet UIPickerView *availability;

@end

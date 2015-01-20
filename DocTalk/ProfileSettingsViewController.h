//
//  ProfileSettingsViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-18.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *profileSettings;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePic;
@property (strong, nonatomic) IBOutlet UIButton *browse;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *hospital;

@end

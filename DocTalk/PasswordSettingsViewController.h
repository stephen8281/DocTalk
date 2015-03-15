//
//  PasswordSettingsViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordSettingsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *passwordSettings;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *updatedPassword;
@property (weak, nonatomic) IBOutlet UITextField *repeatedPassword;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
- (IBAction)backgroundTap:(id)sender;

@property (strong, nonatomic) NSString *userid;
- (IBAction)updateClicked:(id)sender;

@end

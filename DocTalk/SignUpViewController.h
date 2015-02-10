//
//  SignUpViewController.h
//  DocTalk
//
//  Created by Randy Or on 2015-01-23.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;

@property (weak, nonatomic) IBOutlet UITextField *txtNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

- (IBAction)signupClicked:(id)sender;

@end

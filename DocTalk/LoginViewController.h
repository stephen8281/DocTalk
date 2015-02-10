//
//  LoginViewController.h
//  DocTalk
//
//  Created by Randy Or on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)signinClicked:(id)sender;

- (IBAction)backgroundTap:(id)sender;
@end

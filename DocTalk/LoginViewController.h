//
//  LoginViewController.h
//  DocTalk
//
//  Created by Randy Or on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)signinClicked:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *username;

@end

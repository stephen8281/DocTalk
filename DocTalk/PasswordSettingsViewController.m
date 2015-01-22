//
//  PasswordSettingsViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "PasswordSettingsViewController.h"

@interface PasswordSettingsViewController ()

@end

@implementation PasswordSettingsViewController

@synthesize passwordSettings;
@synthesize oldPassword;
@synthesize updatedPassword;
@synthesize repeatedPassword;
@synthesize updateButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    oldPassword.delegate = self;
    oldPassword.returnKeyType = UIReturnKeyDone;
    
    updatedPassword.delegate = self;
    updatedPassword.returnKeyType = UIReturnKeyDone;
    
    repeatedPassword.delegate = self;
    repeatedPassword.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)updateButtonPressed:(id)sender {
    if ([updatedPassword.text isEqualToString:repeatedPassword.text]) {
        NSLog(@"new password is %@", repeatedPassword.text);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please be sure the new password matches the password"
                                                        delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

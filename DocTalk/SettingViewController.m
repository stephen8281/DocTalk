//
//  TableViewController.m
//  DocTalk
//
//  Created by Randy Or on 2015-03-12.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "SettingViewController.h"
#import "PasswordSettingsViewController.h"
#import "ProfileSettingsViewController.h"

@interface SettingViewController ()


@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.phoneLabel.text = _phone;
    self.usernameLabel.text = _username;
    self.useridLabel.text = _userid;
    
    NSLog(@"phone:%@, userid:%@, username:%@",_phone,_userid,_username);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"profileSettings"] || [[segue identifier] isEqualToString:@"changePassword"]) {
        [[segue destinationViewController] setUserid:_userid];
    }
}


@end

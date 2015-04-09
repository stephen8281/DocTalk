//
//  TableViewController.h
//  DocTalk
//
//  Created by Randy Or on 2015-03-12.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) IBOutlet UILabel *useridLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;


@end

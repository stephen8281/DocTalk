//
//  sortSettingsViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-29.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sortSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *sortSettings;
@property (weak, nonatomic) IBOutlet UITableView *messageSort;

@end

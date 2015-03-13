//
//  MessagesViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-29.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myMessages;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *userid;

@end

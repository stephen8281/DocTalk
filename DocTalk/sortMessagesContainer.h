//
//  sortMessagesContainerTableViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-29.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sortMessagesContainer : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *sortMsgsTable;

+(NSMutableArray *)sortOrder;

@end

//
//  TableViewController.h
//  DocTalk
//
//  Created by Randy Or on 2015-03-12.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *userid;

@end

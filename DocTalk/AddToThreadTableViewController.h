//
//  AddToThreadTableViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-03.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToThreadTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) IBOutlet UITableView *myContacts;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;

@end

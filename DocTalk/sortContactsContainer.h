//
//  sortContactsContainer.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-02-04.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sortContactsContainer : UITableViewController  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *sortContactsTable;

+(NSMutableArray *)sortOrder;

@end

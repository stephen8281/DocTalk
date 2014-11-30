//
//  ReadMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadMessageController : UITableViewController


@property (nonatomic,strong)IBOutlet UITableView *mainTableView;

@property (nonatomic,strong)NSArray *json; //news
@property (nonatomic,strong)NSMutableData *data;

@end

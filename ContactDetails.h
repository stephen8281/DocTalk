//
//  ContactDetails.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-03-03.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetails : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailsTable;
@property (weak, nonatomic) IBOutlet UIImageView *ProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Status;

@property (strong, nonatomic) NSString *phone;
@property (nonatomic, strong) NSDictionary *dictContactDetails;

@end
//
//  ViewController.h
//  DocTalk
//
//  Created by Stephen on 2014-11-28.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myContactList;

- (IBAction)showAddressBook:(id)sender;

//@property (strong, nonatomic) NSString *phone;

@end


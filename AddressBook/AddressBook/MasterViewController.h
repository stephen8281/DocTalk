//
//  MasterViewController.h
//  AddressBook
//
//  Created by Gabriel Theodoropoulos on 9/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myContactList;
- (IBAction)showAddressBook:(id)sender;
@end

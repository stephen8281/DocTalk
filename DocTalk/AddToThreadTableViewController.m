//
//  AddToThreadTableViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-03.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "AddToThreadTableViewController.h"

@interface AddToThreadTableViewController ()

@end

@implementation AddToThreadTableViewController

@synthesize myContacts;
@synthesize mySearchBar;
NSArray *Contacts;
NSArray *filteredContacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myContacts.delegate = self;
    self.myContacts.dataSource = self;
    
    Contacts = [NSArray arrayWithObjects: @"Test1", @"Test2", @"Test3", @"Test4", @"Test5", @"Test6", @"Test7", @"Test8", @"Test9", nil];
    
    // Reload the table view data.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Contacts count];
//    if (tableView == self.UISearchController.searchResultsTableView) {
//        return [filteredContacts count];
//        
//    } else {
//        return [Contacts count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    //    Set the image
    UIImage *image = [UIImage imageNamed:@"ProfilePic.png"];
    cell.imageView.image = image;
    
    //    Set the message title
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [Contacts objectAtIndex:indexPath.row]];
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", [filteredContacts objectAtIndex:indexPath.row]];
//    } else {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Contacts objectAtIndex:indexPath.row]];
//    }
    
    //    Set the message preview
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hey this is a really cool preview message which you can use to get an idea of what the message might be about"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    filteredContacts = [Contacts filteredArrayUsingPredicate:resultPredicate];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    
//    return YES;
//}

@end

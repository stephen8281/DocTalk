//
//  sortContactsContainer.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-02-04.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "sortContactsContainer.h"

@interface sortContactsContainer ()

@end

@implementation sortContactsContainer

static NSMutableArray *sort = nil;

+ (NSMutableArray *)sortOrder {
    return sort;
}

+ (void)initialize {
    sort = [NSMutableArray arrayWithObjects: @"First Name", @"Last Name", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sortContactsTable.delegate = self;
    _sortContactsTable.dataSource = self;
    
    [_sortContactsTable setEditing:YES animated:YES];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Reload the table view data.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortContactCell"];
    
    //    Set the message title
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[sortContactsContainer sortOrder] objectAtIndex:indexPath.row]];
    cell.showsReorderControl = YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //    Rearrange the options list to reflect changes
    NSMutableArray * options = [sortContactsContainer sortOrder];
    id temp = [options objectAtIndex:sourceIndexPath.row];
    [options removeObjectAtIndex:sourceIndexPath.row];
    [options insertObject:temp atIndex:destinationIndexPath.row];
    sort = options;
}

// This function pretty much just gets rid of the delete control
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

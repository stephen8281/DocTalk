//
//  sortMessagesContainerTableViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-29.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "sortMessagesContainer.h"

@interface sortMessagesContainer ()

@end

@implementation sortMessagesContainer

static NSMutableArray *sort = nil;

+ (void)initialize {
    sort = [NSMutableArray arrayWithObjects: @"Sender", @"Time", @"Urgency", nil];
}
+ (NSMutableArray *)sortOrder {
    return sort;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sortMsgsTable.delegate = self;
    _sortMsgsTable.dataSource = self;
    
    [_sortMsgsTable setEditing:YES animated:YES];
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortMsgCell"];
    
    //    Set the message title
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[sortMessagesContainer sortOrder] objectAtIndex:indexPath.row]];
    cell.showsReorderControl = YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray * options = [sortMessagesContainer sortOrder];
    NSLog(@"%@ moved higher than %@", [options objectAtIndex:sourceIndexPath.row], [options objectAtIndex:destinationIndexPath.row]);
    
//    Rearrange the options list to reflect changes
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

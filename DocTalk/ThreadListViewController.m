//
//  MessagesViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-29.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "ThreadListViewController.h"
#import "ThreadViewController.h"
#import "sortMessagesContainer.h"

@interface ThreadListViewController ()

@end

@implementation ThreadListViewController{
    NSArray *Threads;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myMessages.delegate = self;
    _myMessages.dataSource = self;
    
    Threads = [NSArray arrayWithObjects: @"Test1", @"Test2", @"Test3", @"Test4", @"Test5", @"Test6", @"Test7", @"Test8", @"Test9", nil];
    
    // Reload the table view data.
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
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
    return Threads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Sort Messages based on %@", [sortMessagesContainer sortOrder]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    Set the image
    UIImage *image = [UIImage imageNamed:@"ProfilePic.png"];
    cell.imageView.image = image;

//    Set the message title
    UILabel *Sender = (UILabel *)[cell viewWithTag:1];
    Sender.text = [NSString stringWithFormat:@"%@", [Threads objectAtIndex:indexPath.row]];
    
//    Set the message preview
    UILabel *Preview = (UILabel *)[cell viewWithTag:2];
    Preview.text = [NSString stringWithFormat:@"%@", @"Hey this is a really cool preview message which you can use to get an idea of what the message might be about"];
    
//    Set the message time
    UILabel *Time = (UILabel *)[cell viewWithTag:3];
    Time.text = [NSString stringWithFormat:@"%@", @"Time stamp"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ListToThread"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ThreadViewController *controller = (ThreadViewController *)segue.destinationViewController;
        controller.messageID = [Threads objectAtIndex:indexPath.row];
    }
}

- (IBAction)createMessage:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

@end

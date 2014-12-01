//
//  MessagesViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-29.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "MessagesViewController.h"
#import "ThreadViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

@synthesize myMessages;
NSArray *Messages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myMessages.delegate = self;
    self.myMessages.dataSource = self;
    
    Messages = [NSArray arrayWithObjects: @"Test1", @"Test2", @"Test3", @"Test4", @"Test5", @"Test6", @"Test7", @"Test8", @"Test9", nil];
    
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
    return Messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    Set the image
    UIImage *image = [UIImage imageNamed:@"ProfilePic.png"];
    cell.imageView.image = image;

//    Set the message title
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [Messages objectAtIndex:indexPath.row]];
    
//    Set the message preview
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hey this is a really cool preview message which you can use to get an idea of what the message might be about"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ListToThread"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ThreadViewController *controller = (ThreadViewController *)segue.destinationViewController;
        controller.messageID = [Messages objectAtIndex:indexPath.row];
    }
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

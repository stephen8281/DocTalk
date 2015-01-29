//
//  sortSettingsViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-29.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "sortSettingsViewController.h"

@interface sortSettingsViewController ()

@end

@implementation sortSettingsViewController


@synthesize sortSettings;
@synthesize messageSort;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    sortSettings.delegate = self;
//    sortSettings.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return Threads.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    
//    //    Set the image
//    UIImage *image = [UIImage imageNamed:@"ProfilePic.png"];
//    cell.imageView.image = image;
//    
//    //    Set the message title
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", [Threads objectAtIndex:indexPath.row]];
//    
//    //    Set the message preview
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hey this is a really cool preview message which you can use to get an idea of what the message might be about"];
//    
//    return cell;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

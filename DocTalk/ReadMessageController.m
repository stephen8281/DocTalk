//
//  ReadMessageController.m
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "ReadMessageController.h"

@interface ReadMessageController ()
-(void)start;
@end

@implementation ReadMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Messages";
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(start) forControlEvents:UIControlEventValueChanged];
    
    [self start];
    
    
}

-(void)start
{
    NSURL *url = [NSURL URLWithString:@"http:localhost/getjson.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _json = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    [_mainTableView reloadData];
    [self.refreshControl endRefreshing];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Message read/send error - please make sure you are connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_json count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
    }
    
    //    cell.textLabel.text = [[json objectAtIndex:indexPath.row] objectForKey:@"name"];
    //    cell.detailTextLabel.text = [[json objectAtIndex:indexPath.row] objectForKey:@"date_string"];
    
    cell.textLabel.text = [[_json objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.detailTextLabel.text = [[_json objectAtIndex:indexPath.row] objectForKey:@"message"];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController"  bundle:nil];
//    
//    detailViewController.title = [[json objectAtIndex:indexPath.row] objectForKey:@"name"];
//    detailViewController.jsonMessage = [json objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

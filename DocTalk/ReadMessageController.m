//
//  ReadMessageController.m
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "ReadMessageController.h"
#import "DBManager.h"

@interface ReadMessageController ()
-(void) start;
-(void) deleteMessage:(NSString*)messageID;
-(void) loadData;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *arrMessage;

@end


@implementation ReadMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialize database to store messages locally
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"chat.sql"];
    
    self.title = @"Messages";
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(start) forControlEvents:UIControlEventValueChanged];
    
    //[self start];
    
    [self loadData];
    
    
}

#pragma mark - Private method implementation

-(void)loadData{
    
    // Form the query.
    NSString *query = @"select * from messageTable";
    
    // Get the results.
    if (self.arrMessage != nil) {
        self.arrMessage = nil;
    }
    self.arrMessage = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view data.
    [_mainTableView reloadData];
}



// method for deleting message after an user has read it from the database
-(void) deleteMessage:(NSString*)messageID
{
    NSMutableString *postString = [NSMutableString stringWithString:@"http://192.168.1.66/deletemessage.php"];
    
    [postString appendString:[NSString stringWithFormat:@"?%@=%@", @"messageID", (NSString*)messageID]];
    
    
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    
    _deleteConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}





// Method to establish connection to the online database
//TODO: receiver is hardcoded for now, will change after login is done
-(void)start
{

    NSMutableString *postString = [NSMutableString stringWithString:@"http://192.168.1.66/getjson.php"];
    [postString appendString:[NSString stringWithFormat:@"?%@=%@", @"receiver", @"Stephen"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
     
    _readConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}


#pragma mark - Connection handling

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    NSLog(@"response received");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _json = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    
    
    //store the json data into local database
    for(int i = 0; i<[_json count];i++)
    {
        NSString *messageID = [[_json objectAtIndex:i] objectForKey:@"messageID"];
        NSString *sender = [[_json objectAtIndex:i] objectForKey:@"sender"];
        NSString *receiver = [[_json objectAtIndex:i] objectForKey:@"receiver"];
        NSString *message = [[_json objectAtIndex:i] objectForKey:@"message"];
        
        NSString *query;
        query = [NSString stringWithFormat:@"insert into messageTable values('%@', '%@', '%@', '%@')", messageID,sender,receiver,message];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            [self deleteMessage:messageID];
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }

    [self loadData];
    [self.refreshControl endRefreshing];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Message read/send error - please make sure you are connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainCell"];
    }
    
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSInteger indexOfMessage = [self.dbManager.arrColumnNames indexOfObject:@"message"];
    
  
    cell.textLabel.text = [[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender];
    cell.detailTextLabel.text = [[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfMessage];
    
    
    //cell.textLabel.text = [[_json objectAtIndex:indexPath.row] objectForKey:@"sender"];
    
    //cell.detailTextLabel.text = [[_json objectAtIndex:indexPath.row] objectForKey:@"message"];
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

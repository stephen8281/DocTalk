//
//  MessagesViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-29.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "ThreadListViewController.h"
#import "ThreadViewController.h"
#import "DBManager.h"

@interface ThreadListViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *arrContact; // 2 dimensional array for result from querying local database
@property (nonatomic, strong) NSMutableArray *arrMessage; // 2 dimensional array for result from querying local database
-(void) loadData;
@end

@implementation ThreadListViewController{
    NSArray *Threads;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myMessages.delegate = self;
    _myMessages.dataSource = self;
    
    //Threads = [NSArray arrayWithObjects: @"Test1", @"Test2", @"Test3", @"Test4", @"Test5", @"Test6", @"Test7", @"Test8", @"Test9", nil];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"chat.sql"];

    [self loadData];
    
    // Reload the table view data.
    //[self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - loading the table view
-(void)loadData
{
    //Form the query

    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT receiver FROM messageTable WHERE sender LIKE '%@' UNION SELECT DISTINCT sender FROM messageTable WHERE receiver LIKE '%@' ",_phone,_phone];
    if (self.arrContact != nil) {
        self.arrContact = nil;
    }
    self.arrContact = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    
    //reload the contentview
    [self.tableView reloadData];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrContact.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    Set the image
    UIImage *image = [UIImage imageNamed:@"ProfilePic.png"];
    cell.imageView.image = image;

//    Set the message title
    NSString *incomingPerson = [NSString stringWithString:[[self.arrContact objectAtIndex:indexPath.row] objectAtIndex:0]];
    UILabel *Sender = (UILabel *)[cell viewWithTag:1];
    Sender.text = incomingPerson;
    
//    Set the message preview
    //query to get the latest message sent between phoneOwner and a given incoming person
    NSString *query1 = [NSString stringWithFormat:@"SELECT * From messageTable WHERE ((sender = '%@' and receiver = '%@') OR (sender = '%@' and receiver = '%@')) AND messageID = (SELECT MAX(messageID) FROM messageTable WHERE ((sender = '%@' and receiver = '%@') OR (sender = '%@' and receiver = '%@')))", incomingPerson,_phone,_phone,incomingPerson, incomingPerson,_phone,_phone,incomingPerson];
    
    if (self.arrMessage != nil) {
        self.arrMessage = nil;
    }
    self.arrMessage = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
    NSInteger indexOfMessage = [self.dbManager.arrColumnNames indexOfObject:@"message"];
    
    UILabel *Preview = (UILabel *)[cell viewWithTag:2];
    if(self.arrMessage != nil)
    {
        Preview.text = [NSString stringWithString:[[self.arrMessage objectAtIndex:0] objectAtIndex:indexOfMessage]];
    }
    
    
//    Set the message time
    UILabel *Time = (UILabel *)[cell viewWithTag:3];
    Time.text = [NSString stringWithFormat:@"%@", @"Time stamp"];
    
//    Make a little circle to display the urgency
    UIImageView *Urgency = (UIImageView *)[cell viewWithTag:4];
    if (indexPath.row % 3 == 0) {
        Urgency.image = [UIImage imageNamed: @"normalBubble.png"];
    } else if (indexPath.row % 3 == 1) {
        Urgency.image = [UIImage imageNamed: @"semiurgentBubble.png"];
    } else {
        Urgency.image = [UIImage imageNamed: @"urgentBubble.png"];
    }
    
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

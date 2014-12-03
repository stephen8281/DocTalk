//
//  ThreadViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-30.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

@synthesize Thread;
@synthesize messageID;
@synthesize MsgList;
NSMutableArray *Messages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MsgList.delegate = self;
    self.MsgList.dataSource = self;
    
    self.title = messageID;
    
//    This is the list of messages that will be displayed
//    For now it is hard coded with one message
    Messages = [NSMutableArray arrayWithObjects:nil];
    
    NSArray *obj = [NSArray arrayWithObjects:@"ProfilePic", @"Hi this is some message I would like to send", @"0", nil];
    NSArray *key = [NSArray arrayWithObjects:@"Picture", @"Message", @"Priority", nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:obj forKeys:key];
    [Messages addObject:dict];
    
    // Reload the table view data.
    [MsgList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    Make the image
    cell.imageView.image = [UIImage imageNamed:[[Messages objectAtIndex:indexPath.row] objectForKey:@"Picture"]];
    
//    Find the desired width of textfield
    int width = (int)[[[Messages objectAtIndex:indexPath.row] objectForKey:@"Message"] length]*2;
    if (width > cell.frame.size.width - cell.imageView.frame.size.width - 50) {
        width = cell.frame.size.width - cell.imageView.frame.size.width - 50;
    }else if (width < 100){
        width = 100;
    }
    
//    Make the text field
    UITextView *msg = [[UITextView alloc] initWithFrame:CGRectMake(80, 8, width, 30)];
    [msg setTranslatesAutoresizingMaskIntoConstraints:NO];
    [msg.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [msg.layer setCornerRadius:10];
    [msg.layer setBorderWidth:1];
    msg.editable = false;
    msg.font = [UIFont systemFontOfSize:15];
    msg.keyboardType = UIKeyboardTypeDefault;
    msg.text = [[Messages objectAtIndex:indexPath.row] objectForKey:@"Message"];
    [msg sizeToFit];

//    Apply priority shadow
    [msg.layer setMasksToBounds:NO];
    msg.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    msg.layer.shadowOpacity = 1.0f;
    msg.layer.shadowRadius = 1.0f;
    if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"0"]) {
        msg.layer.shadowColor = [[UIColor colorWithRed:0 green:0.7 blue:0 alpha:1] CGColor];
    }else if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"0"]){
        msg.layer.shadowColor = [[UIColor colorWithRed:1 green:0.5 blue:0 alpha:1] CGColor];
    }else if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"0"]){
        msg.layer.shadowColor = [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    }
    
// Add the textfield to the cell
    [cell addSubview:msg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

@end

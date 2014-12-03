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
    
    NSArray *obj1 = [NSArray arrayWithObjects:@"ProfilePic", @"This message isnt really important", @"0", @"0", @"ToMe", nil];
    NSArray *key = [NSArray arrayWithObjects:@"Picture", @"Message", @"Priority", @"Height", @"MsgDirection", nil];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithObjects:obj1 forKeys:key];
    [Messages addObject:dict1];
    NSArray *obj2 = [NSArray arrayWithObjects:@"ProfilePic", @"This message is really important and it is also quite a bit longer then the previous message that is why it takes up more room....", @"2", @"0", @"FromMe", nil];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithObjects:obj2 forKeys:key];
    [Messages addObject:dict2];
    
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
    
//    Find the desired width of textfield
    int width = (int)[[[Messages objectAtIndex:indexPath.row] objectForKey:@"Message"] length]*2;
    if (width > self.MsgList.frame.size.width - cell.imageView.frame.size.width - 70) {
        width = self.MsgList.frame.size.width - cell.imageView.frame.size.width - 70;
    }else if (width < 100){
        width = 100;
    }
    
//    Find the position and size of the image view and text field view
    CGRect imageRect;
    CGRect textRect;
    if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"MsgDirection"] isEqualToString:@"ToMe"]) {
        imageRect = CGRectMake(10, 10, 40, 40);
        textRect = CGRectMake(60, 8, width, 30);
    } else {
        imageRect = CGRectMake(self.MsgList.frame.size.width - 50, 10, 40, 40);
        textRect = CGRectMake(self.MsgList.frame.size.width - width - 60, 8, width, 30);
    }
    
//    Make the image
    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:imageRect];
    profilePic.image = [UIImage imageNamed:[[Messages objectAtIndex:indexPath.row] objectForKey:@"Picture"]];
    
//    Make the text field
    UITextView *msg = [[UITextView alloc] initWithFrame:textRect];
    [msg setTranslatesAutoresizingMaskIntoConstraints:NO];
    [msg.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [msg.layer setCornerRadius:10];
    [msg.layer setBorderWidth:1];
    msg.editable = false;
    msg.font = [UIFont systemFontOfSize:15];
    msg.keyboardType = UIKeyboardTypeDefault;
    msg.text = [[Messages objectAtIndex:indexPath.row] objectForKey:@"Message"];
    [msg sizeToFit];
    [[Messages objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%f", msg.frame.size.height] forKey:@"Height"];

//    Apply priority shadow
    [msg.layer setMasksToBounds:NO];
    msg.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    msg.layer.shadowOpacity = 1.0f;
    msg.layer.shadowRadius = 1.0f;
    if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"0"]) {
        msg.layer.shadowColor = [[UIColor colorWithRed:0 green:0.7 blue:0 alpha:1] CGColor];
    }else if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"1"]){
        msg.layer.shadowColor = [[UIColor colorWithRed:1 green:0.5 blue:0 alpha:1] CGColor];
    }else if ([[[Messages objectAtIndex:indexPath.row] objectForKey:@"Priority"] isEqual: @"2"]){
        msg.layer.shadowColor = [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    }
    
// Add the views to the cell
    [cell addSubview:profilePic];
    [cell addSubview:msg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[[Messages objectAtIndex:indexPath.row] objectForKey:@"Height"] floatValue] + 20;
}

@end

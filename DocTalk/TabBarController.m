//
//  TabBarController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-02-17.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

static NSMutableArray *Messages = nil;

// This function returns the latest list of messages
+ (NSMutableArray *)getMessages {
    return Messages;
}

// For the time being the list of messages is hard coded to this two dimensional array
+ (void)initialize {
    Messages = [NSMutableArray arrayWithObjects: [NSMutableArray arrayWithObjects: @"MessageID 1", @"Sender 1", @"Receiver 1", @"Text 1", nil], [NSMutableArray arrayWithObjects: @"MessageID 2", @"Sender 2", @"Receiver 2", @"Text 2", nil], [NSMutableArray arrayWithObjects: @"MessageID 3", @"Sender 3", @"Receiver 3", @"Text 3", nil], [NSMutableArray arrayWithObjects: @"MessageID 4", @"Sender 4", @"Receiver 4", @"Text 4", nil], [NSMutableArray arrayWithObjects: @"MessageID 5", @"Sender 5", @"Receiver 5", @"Text 5", nil], nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  SendingViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "SendingViewController.h"

@interface SendingViewController ()

@end

@implementation SendingViewController

@synthesize priorityControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self priorityChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)priorityChanged:(id)sender {
    switch (priorityControl.selectedSegmentIndex) {
        case 0:
            priorityControl.tintColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
            break;
        case 1:
            priorityControl.tintColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1];
            break;
        case 2:
            priorityControl.tintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
            break;
        default:
            break;
    }
}

@end

//
//  SendingViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "SendMsgViewController.h"

@interface SendMsgViewController ()

@end

@implementation SendMsgViewController

@synthesize priorityControl;
@synthesize textEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self priorityChanged:nil];
    
    textEntry.delegate = self;
    textEntry.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
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

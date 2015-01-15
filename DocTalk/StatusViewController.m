//
//  StatusViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-13.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

@synthesize statusMessage;
@synthesize redNotifEn;
@synthesize orangeNotifEn;
@synthesize greenNotifEn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    statusMessage.delegate = self;
    statusMessage.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
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

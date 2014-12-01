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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = messageID;
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

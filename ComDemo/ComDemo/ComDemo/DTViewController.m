//
//  DTViewController.m
//  ComDemo
//
//  Created by Kevin Wagner on 2014-10-28.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "DTViewController.h"

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Event handler for sending SMS messages
- (IBAction)sendSMSText:(id)sender {
    self.SMSInText.text = self.SMSOutText.text;
}

// Event handler for sending server messages
- (IBAction)sendServerText:(id)sender {
    self.ServerInText.text = self.ServerOutText.text;
}

@end

//
//  FirstViewController.m
//  SQL
//
//  Created by Randy Or on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) postMessage:(NSString*) message withName:(NSString *) name{
    if (name != nil && message != nil){
        NSMutableString *postString = [NSMutableString stringWithString:kPostURL];
        
        [postString appendString:[NSString stringWithFormat:@"?%@=%@", kName, name]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kMessage, message]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        
        postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
}

-(IBAction)post:(id)sender{
    [self postMessage:messageText.text withName:nameText.text];
    [messageText resignFirstResponder];
    messageText.text = nil;
    nameText.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

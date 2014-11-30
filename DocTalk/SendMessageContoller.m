//
//  SendMessageController.m
//  SQL
//
//  Created by Randy Or on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "SendMessageController.h"

@interface SendMessageController ()

@end

@implementation SendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _messageText.delegate = self;

    self.title = _name;
}

-(void) postMessage:(NSString*) message withName:(NSString *) name{
    if (![message isEqual:@""]){
        NSMutableString *postString = [NSMutableString stringWithString:kPostURL];
        
        [postString appendString:[NSString stringWithFormat:@"?%@=%@", kName, name]];

        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kMessage, message]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        
        _postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
}

-(IBAction)post:(id)sender{
    [self postMessage:_messageText.text withName:_name];
    [_messageText resignFirstResponder];
    _messageText.text = nil;

}

#pragma dismisskeyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_messageText resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField)
    {
        [textField resignFirstResponder];
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end

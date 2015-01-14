//
//  SendMessageController.m
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "SendMessageController.h"

@interface SendMessageController ()
-(void) post:(id)sender;
-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver;

@end

@implementation SendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageText.delegate = self;

    self.title = _name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Moving the textfield when keyboard pops up

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -180; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Methods for posting message onto the server

-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver {
    
    if (![message isEqual:@""]){
        NSMutableString *postString = [NSMutableString stringWithString:kPostURL];
        
        [postString appendString:[NSString stringWithFormat:@"?%@=%@", kSender, sender]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kReceiver, receiver]];

        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kMessage, message]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        
        _postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
}

#pragma mark - IBaction method implementation
//TODO: sender hardcoded for now, will change it after login is implemented
-(IBAction)post:(id)sender{
    
    [self postMessage:_messageText.text withSender:@"Stephen" withReceiver:_name];
    [_messageText resignFirstResponder];
    _messageText.text = nil;

}


#pragma mark - Methods to dismiss Keyboard
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


@end

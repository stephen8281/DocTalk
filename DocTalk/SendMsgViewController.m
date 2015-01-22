//
//  SendingViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "SendMsgViewController.h"

@interface SendMsgViewController ()
//send message methods
-(void) send:(id)sender;
-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver;
//@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation SendMsgViewController



@synthesize priorityControl;
@synthesize scrollView;
//@synthesize textEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self priorityChanged:nil];
    
    _textEntry.delegate = self;


    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL) textFieldShouldReturn:(UITextField*) textField {
//    [textField resignFirstResponder];
//    return YES;
//}

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




#pragma mark - Moving the textfield when keyboard pops up

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:YES];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:NO];
//}
//
//-(void)animateTextField:(UITextField*)textField up:(BOOL)up
//{
//
//    const int movementDistance = -175; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//    
//}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGSize tabBarSize = [[[self tabBarController]tabBar]bounds].size;

    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - kbSize.height +tabBarSize.height, self.view.frame.size.width, self.view.frame.size.height);
    

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
     CGSize tabBarSize = [[[self tabBarController]tabBar]bounds].size;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + kbSize.height - tabBarSize.height, self.view.frame.size.width, self.view.frame.size.height);
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    activeField = textField;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    activeField = nil;
//}

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

#pragma mark - send button implementation
//TODO: sender hardcoded for now, will change it after login is implemented
-(IBAction)send:(id)sender{
    
    //_sendButton = (UIButton *)sender;
    
    [self postMessage:_textEntry.text withSender:@"Stephen" withReceiver:_name];
    [_textEntry resignFirstResponder];
    _textEntry.text = nil;
    
}


#pragma mark - Methods to dismiss Keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textEntry resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField)
    {
        [textField resignFirstResponder];
    }
    return NO;
}
//-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSUInteger length = _textEntry.text.length - range.length + string.length;
//    if(length > 0){
//        _sendButton.enabled = YES;
//    }else{
//        _sendButton.enabled= NO;
//    }
//    return YES;
//}




@end

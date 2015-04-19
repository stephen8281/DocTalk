//
//  PasswordSettingsViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "PasswordSettingsViewController.h"

@interface PasswordSettingsViewController ()

@property (nonatomic, strong) NSString *phoneUID;

@end

@implementation PasswordSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.phoneUID = _userid;
    NSLog(@"%@",self.phoneUID);
    
    _oldPassword.delegate = self;
    _oldPassword.returnKeyType = UIReturnKeyDone;
    
    _updatedPassword.delegate = self;
    _updatedPassword.returnKeyType = UIReturnKeyDone;
    
    _repeatedPassword.delegate = self;
    _repeatedPassword.returnKeyType = UIReturnKeyDone;
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
 - (IBAction)updateButtonPressed:(id)sender {
    if ([_updatedPassword.text isEqualToString:_repeatedPassword.text]) {
        NSLog(@"new password is %@", _repeatedPassword.text);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please be sure the new password matches the password"
                                                        delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)updateClicked:(id)sender {
    
    NSInteger success = 0;
    @try {
        
        if([[self.oldPassword text] isEqualToString:@""] || [[self.updatedPassword text] isEqualToString:@""] || [[self.repeatedPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter all fields!" :@"Sign up Failed!" :0];
            
        } else if (![self.updatedPassword.text isEqualToString:self.repeatedPassword.text]) {
            
            [self alertStatus:@"Paswords do no match!" :@"Sign up Failed!" :0];
            
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"id=%@&oldpassword=%@&updatedpassword=%@&repeatedpassword=%@",self.phoneUID,[self.oldPassword text], [self.updatedPassword text],[self.repeatedPassword text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://192.168.1.74/jsonpwchange.php"];
            //NSURL *url=[NSURL URLWithString:@"http://128.189.245.75:1200/jsonpwchange.php"];
            //NSURL *url=[NSURL URLWithString:@"http://localhost/jsonpwchange.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                success = [jsonData[@"success"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Sign up SUCCESS");
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Password change failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Password change failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Password change failed." :@"Error!" :0];
    }
    if (success) {
        //[self performSegueWithIdentifier:@"login_success" sender:self];
        NSLog(@"Password change SUCCESS");
        [self alertStatus:@"Password change is successful." :@"Success!" :0];
    }
    
    

}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}


@end

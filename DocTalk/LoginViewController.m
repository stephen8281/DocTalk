//
//  LoginViewController.m
//  DocTalk
//
//  Created by Randy Or on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "LoginViewController.h"
#import "ThreadListViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (IBAction)signinClicked:(id)sender {
    //    Added this line of code for testing purposes

//    [self performSegueWithIdentifier:@"login_success" sender:self];
//    return;

    
    NSInteger success = 0;
    @try {
        
        if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
            
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.txtUsername text],[self.txtPassword text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://128.189.245.211/jsonlogin2.php"];

            // NSURL *url=[NSURL URLWithString:@"http://128.189.245.75:1200"];
            //NSURL *url=[NSURL URLWithString:@"http://localhost/jsonlogin2.php"];

            
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
                //NSString *phoneNumber = [jsonData objectForKey:@"phonenumber"];
                _phone = [jsonData objectForKey:@"phonenumber"];
                _userid = [jsonData objectForKey:@"getuserid"];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                    NSLog(@"%@",_phone);
                    NSLog(@"%@",_userid);
                    
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"login_success"]) {
        /* errors when trying to integrate both cvc and tlvcs for phone and userid. hence, testing userid indepenedantly for now
         
        UITabBarController *tabBar = segue.destinationViewController;
        
        UINavigationController *navController = [tabBar.viewControllers objectAtIndex:0];
        ViewController *cvc = [navController.viewControllers objectAtIndex:0];
        cvc.phone = _phone;
        
        UINavigationController *navController1 = [tabBar.viewControllers objectAtIndex:1];
        ThreadListViewController *tlvc = [navController1.viewControllers objectAtIndex:0];
        tlvc.phone = _phone;
        
        */
        
        // ----------------------------------------------------------------------------------
        
        UITabBarController *tabBar = segue.destinationViewController;
        
        UINavigationController *navController = [tabBar.viewControllers objectAtIndex:3];
        ViewController *cvc = [navController.viewControllers objectAtIndex:0];
        cvc.userid = _userid;
        
        UINavigationController *navController1 = [tabBar.viewControllers objectAtIndex:0];
        ThreadListViewController *tlvc = [navController1.viewControllers objectAtIndex:0];
        tlvc.userid = _userid;

        

        
        
        

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

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end

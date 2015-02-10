//
//  ProfileSettingsViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-18.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "ProfileSettingsViewController.h"

@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController

@synthesize profileSettings;
@synthesize ProfilePic;
@synthesize browse;
@synthesize name;
@synthesize email;
@synthesize phoneNumber;
@synthesize hospital;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    name.delegate = self;
    name.returnKeyType = UIReturnKeyDone;
    
    email.delegate = self;
    email.returnKeyType = UIReturnKeyDone;
    
    phoneNumber.delegate = self;
    phoneNumber.returnKeyType = UIReturnKeyDone;
    
    hospital.delegate = self;
    hospital.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    if (textField == email) {
//        Make sure it contains an @ sign
        if ([textField.text containsString:@"@"]) {
            [textField resignFirstResponder];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                            message:@"Email adress entered is not a valid email address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else if (textField == phoneNumber){
//        Make sure it contains exactly 10 digitits and no other characters
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]{10,10}$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRange textRange = NSMakeRange(0, textField.text.length);
        NSRange matchRange = [regex rangeOfFirstMatchInString:textField.text options:NSMatchingReportProgress range:textRange];
        if (matchRange.location == NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Phone Number"
                                                            message:@"Please be sure to enter a 10 digit phone number and remove any non numeric characters"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            [textField resignFirstResponder];
        }
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)browseProfilePic:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    ipc.delegate = self;
    ipc.editing = NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:
(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ProfilePic.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
@end

//
//  SendingViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostURL @"http://192.168.1.66/test.php"
#define kSender @"sender"
#define kReceiver @"receiver"
#define kMessage @"message"

@interface SendMsgViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *priorityControl;
//@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *attachButton;
@property (strong, nonatomic) IBOutlet UITextField *textEntry;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)    NSURLConnection *postConnection;
@property(nonatomic,strong) NSString *name;

- (IBAction)priorityChanged:(id)sender;
-(IBAction)send:(id)sender;


@end

//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostURL @"http://192.168.1.66/test.php"
#define kSender @"sender"
#define kReceiver @"receiver"
#define kMessage @"message"

@interface SendMessageController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
    
//@property(nonatomic,strong)    IBOutlet UITextField *nameText;
@property(nonatomic,strong)    IBOutlet UITextField *messageText;
@property(nonatomic,strong)    NSURLConnection *postConnection;

@property(nonatomic,strong) NSString *name;


-(IBAction)post:(id)sender;
@end


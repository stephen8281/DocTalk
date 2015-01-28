//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"

#define kPostURL @"http://192.168.1.66/test.php"
#define kSender @"sender"
#define kReceiver @"receiver"
#define kMessage @"message"

@interface SendMessageController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,MessageComposerViewDelegate>


//send message methods
@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property(nonatomic,strong)    NSURLConnection *postConnection;

//recipient name
@property(nonatomic,strong) NSString *name;


//read message methods
@property (nonatomic,strong)IBOutlet UITableView *mainTableView;

@property (nonatomic,strong)NSArray *json; //news
@property (nonatomic,strong)NSMutableData *data;

@property(nonatomic,strong)    NSURLConnection *deleteConnection;
@property(nonatomic,strong)    NSURLConnection *readConnection;

@end


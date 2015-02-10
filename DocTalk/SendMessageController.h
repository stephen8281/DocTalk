//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//
#import "JSQMessages.h"
#import <UIKit/UIKit.h>


#define sendURL @"http://192.168.1.73/test.php"
#define readURL @"http://192.168.1.73/getjson.php"
#define deleteURL @"http://192.168.1.73/deletemessage.php"



@interface SendMessageController : JSQMessagesViewController<UIActionSheetDelegate>

//UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,MessageComposerViewDelegate>


//Chat bubbles objects
@property(nonatomic,strong)JSQMessagesBubbleImage *outgoingBubbleImageData;
@property(nonatomic,strong)JSQMessagesBubbleImage *incomingBubbleImageData;

//connection objects
@property(nonatomic,strong)  NSURLConnection *postConnection;
@property(nonatomic,strong)  NSURLConnection *deleteConnection;
@property(nonatomic,strong)  NSURLConnection *readConnection;

//name of the person chatting with
@property(nonatomic,strong) NSString *name;

//objects for receiving json data from server
@property (nonatomic,strong)NSArray *json;
@property (nonatomic,strong)NSMutableData *data;



@end


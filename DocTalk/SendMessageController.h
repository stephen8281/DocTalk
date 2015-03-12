//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//
#import "JSQMessages.h"
#import <UIKit/UIKit.h>



//#define sendURL @"http://128.189.72.103:12000/postmessage"
//#define readURL @"http://128.189.72.103:12000/readmessage"
//#define deleteURL @"http://128.189.72.103:12000/deletemessage"
#define sendURL @"http://128.189.244.100/postmessage.php"
#define readURL @"http://128.189.244.100/readmessage.php"
#define deleteURL @"http://128.189.244.100/deletemessage.php"




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
@property(nonatomic,strong) NSString *receiverName;
@property(nonatomic,strong) NSString *receiverLastName;
@property(nonatomic,strong) NSString *receiverNumber;

//objects for receiving json data from server
@property (nonatomic,strong)NSArray *json;
@property (nonatomic,strong)NSMutableData *data;

@property (strong, nonatomic) NSString *phone;



@end


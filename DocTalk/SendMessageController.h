//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//
#import "JSQMessages.h"
#import <UIKit/UIKit.h>

//#define sendURL @"http://192.168.43.249:12000"
//#define readURL @"http://192.168.43.249:12000"
//#define deleteURL @"http://192.168.43.249:12000"
#define sendURL @"http://192.168.1.71/postmessage.php"
#define readURL @"http://192.168.1.71/readmessage.php"
#define deleteURL @"http://192.168.1.71/deletemessage.php"

@interface SendMessageController : JSQMessagesViewController<UIActionSheetDelegate, JSQMessagesLoadEarlierHeaderViewDelegate>


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


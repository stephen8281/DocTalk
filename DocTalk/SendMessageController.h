//
//  SendMessageController.h
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//
#import "JSQMessages.h"
#import <UIKit/UIKit.h>
#import "MessageComposerView.h"


#define sendURL @"http://192.168.1.73/test.php"
#define readURL @"http://192.168.1.73/getjson.php"
#define deleteURL @"http://192.168.1.73/deletemessage.php"



@interface SendMessageController : JSQMessagesViewController<UIActionSheetDelegate>

//UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,MessageComposerViewDelegate>


@property(nonatomic,strong)NSMutableArray *messages;
@property(nonatomic,strong)JSQMessagesBubbleImage *outgoingBubbleImageData;
@property(nonatomic,strong)JSQMessagesBubbleImage *incomingBubbleImageData;


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


//
//  SendMessageController.m
//  DocTalk
//
//  Created by Randy Or and Stephen Tai on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import "SendMessageController.h"
#import "LoginViewController.h"
#import "DBManager.h"

@interface SendMessageController ()

//send message methods
//-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver;
-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver withTime:(NSString *) time withUrgency:(NSString *)urgency;

//read message methods
-(void) LaunchTimer; // a timer that calls readMessage every 8 sec
-(void) readMessage;
-(void) deleteMessage:(NSString*)messageID;
-(void) loadData;

//database objects for chat.sql
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *arrMessage;

//database objects for contact.sql
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) DBManager *dbManagerForContact;

//private properties
@property (nonatomic, strong) NSString *phoneOwner;
@property (nonatomic, strong) NSString *incomingNumber;
@property (nonatomic, strong) NSMutableString *incomingPersonInitial;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSString *urgency;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) JSQMessagesAvatarImage *outgoingProfileImage;
@property (nonatomic, strong) JSQMessagesAvatarImage *incomingProfileImage;

@end

@implementation SendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _receiverName;
    
    //set the phoneOwner to be the phone number retrieved from online database
    //self.phoneOwner = _phone;
    self.phoneOwner = @"Stephen";
        
    //Initialize database to store messages locally
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"chat.sql"];

    //reformat the phone number of the person chatting with to get rid of brackets and dash
    //self.incomingNumber = [[_receiverNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    self.incomingNumber = _receiverNumber;
    self.incomingPersonInitial = [NSMutableString stringWithFormat:@"%c%c",[_receiverName characterAtIndex:0],[_receiverLastName characterAtIndex:0]];
    


    
    //set the senderID and senderDisplayName that will be used by JSQMessage
    self.senderId = _phoneOwner;
    self.senderDisplayName = _phoneOwner;
    self.showLoadEarlierMessagesHeader = YES;

    
    self.urgency = @"Green";
    
    
    self.outgoingProfileImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"ST"
                                                                            backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0]
                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                            font:[UIFont systemFontOfSize:14.0f]
                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    self.incomingProfileImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:self.incomingPersonInitial
                                                                    backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0]
                                                                          textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                               font:[UIFont systemFontOfSize:14.0f]
                                                                           diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    //initialize the refresh control will replace with a timer later
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(readMessage)  forControlEvents:UIControlEventValueChanged];
//    [_mainTableView addSubview:self.refreshControl];

    
    //Initialize the chat bubbles
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc]init];
    _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    //populate the tables from local database
    [self loadData];
    
    //Check in with the server every 8 second
    [self performSelectorOnMainThread:@selector(LaunchTimer) withObject:nil waitUntilDone:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JSQmessage Datasource Delegate
//- (NSString *)senderDisplayName
//{
//    return @"Stephen";
//}
//- (NSString *)senderId
//{
//    return @"Stephentai";
//}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSInteger indexOfMessage = [self.dbManager.arrColumnNames indexOfObject:@"message"];
    
    NSString *sender = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender]];
    NSString *text = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfMessage]];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:sender senderDisplayName:sender date:[NSDate date] text:text];
    
    return message;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //get the sender of the current text
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSString *sender = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender]];
    
    if ([sender isEqualToString:self.senderId]) {
        return _outgoingBubbleImageData;
    }
    return _incomingBubbleImageData;
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //get the sender of the current text
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSString *sender = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender]];
    
    if ([sender isEqualToString:self.senderId]) {
        return self.outgoingProfileImage;
    }
    
    return self.incomingProfileImage;
}


-(NSAttributedString*)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //get the sender of the current text
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSString *sender = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender]];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([sender isEqualToString:self.senderId]) {
        return nil;
    }
    
    //display the sender only if it is a different person
    if (indexPath.item - 1 > 0) {
        NSString *previousMessageSender = [[self.arrMessage objectAtIndex:indexPath.item - 1] objectAtIndex:indexOfSender];
        if ([previousMessageSender isEqualToString:sender]) {
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:sender];
}


-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        NSInteger indexOfTime = [self.dbManager.arrColumnNames indexOfObject:@"time"];
        NSString *time = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfTime]];
        return [[NSAttributedString alloc] initWithString:time];
    }
    return nil;
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.arrMessage count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.textView.textColor = [UIColor blackColor];
    
//    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : [UIColor redColor],
//                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };

    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate
-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //get the sender of the text at current index
    NSInteger indexOfSender = [self.dbManager.arrColumnNames indexOfObject:@"sender"];
    NSString *sender = [NSString stringWithString:[[self.arrMessage objectAtIndex:indexPath.row] objectAtIndex:indexOfSender]];
    
    /**
     *  iOS7-style sender name labels
     */
    
    if ([sender isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    //check if previous sender is the same and adjust height accordingly
    if (indexPath.item - 1 > 0) {
        NSString *previousMessageSender = [[self.arrMessage objectAtIndex:indexPath.item - 1] objectAtIndex:indexOfSender];
        if ([previousMessageSender isEqualToString:sender]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

#pragma mark - JSQMessagesViewController Methods
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *time = [format stringFromDate:date];
    
    [self postMessage:text withSender:self.phoneOwner withReceiver:self.incomingNumber withTime:time withUrgency:self.urgency];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
//    switch (buttonIndex) {
//        case 0:
//            [self.demoData addPhotoMediaMessage];
//            break;
//            
//        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
//            
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
//            break;
//            
//        case 2:
//            [self.demoData addVideoMediaMessage];
//            break;
//    }
//    
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    
//    [self finishSendingMessageAnimated:YES];
}



#pragma mark - send message methods

-(void) postMessage:(NSString*) message withSender:(NSString*)sender withReceiver:(NSString *)receiver withTime:(NSString *) time withUrgency:(NSString *)urgency
{
    
    if (![message isEqual:@""]){
        NSMutableString *postString = [NSMutableString stringWithString:sendURL];
        
        [postString appendString:[NSString stringWithFormat:@"?%@=%@", @"sender", sender]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", @"receiver", receiver]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", @"message", message]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", @"time", time]];
        
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", @"urgency", urgency]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        
        NSLog(@"%@",postString);
        _postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    
}


#pragma mark - read message methods

-(void)loadData
{
    //Form the query
    NSString *query = [NSString stringWithFormat:@"select * from messageTable where (sender = '%@' and receiver = '%@') or (sender = '%@' and receiver = '%@') order by messageID", self.incomingNumber,_phoneOwner,_phoneOwner,self.incomingNumber];
    
    // Get the results.
    if (self.arrMessage != nil) {
        self.arrMessage = nil;
    }
    self.arrMessage = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //reload the contentview
    [self.collectionView reloadData];

    
}


// method for deleting message after an user has read it from the database
-(void) deleteMessage:(NSString*)messageID
{
    NSMutableString *postString = [NSMutableString stringWithString:deleteURL];
    
    [postString appendString:[NSString stringWithFormat:@"?%@=%@", @"messageID", (NSString*)messageID]];
    
    
    [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    
    _deleteConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


//Timer to periodically check in with server for new messages
-(void)LaunchTimer
{
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(readMessage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

// Method to establish connection to the online database
-(void) readMessage
{
    
    NSMutableString *postString = [NSMutableString stringWithString:readURL];
    [postString appendString:[NSString stringWithFormat:@"?%@=%@", @"receiver", self.phoneOwner]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    //[request setHTTPMethod:@"POST"];
    NSLog(@"HERE");
    _readConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

}


#pragma mark - Connection handling for reading messages

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
        NSLog(@"didReceiveData");
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        NSLog(@"connectionDidFinishLoading");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(connection == _deleteConnection)
    {
        return;
    }
    
    BOOL didUpdateDatabase = NO;
    
    _json = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];

    //store the json data into local database
    for(int i = 0; i<[_json count];i++)
    {
        NSString *messageID = [[_json objectAtIndex:i] objectForKey:@"messageID"];
        NSString *sender = [[_json objectAtIndex:i] objectForKey:@"sender"];
        NSString *receiver = [[_json objectAtIndex:i] objectForKey:@"receiver"];
        NSString *message = [[_json objectAtIndex:i] objectForKey:@"message"];
        NSString *time = [[_json objectAtIndex:i] objectForKey:@"time"];
        NSString *urgency = [[_json objectAtIndex:i] objectForKey:@"urgency"];
        
//        NSString *messageID = [json objectForKey:@"messageID"];
//        NSString *sender = [json objectForKey:@"sender"];
//        NSString *receiver = [json objectForKey:@"receiver"];
//        NSString *message = [json objectForKey:@"message"];
//        NSString *time = [json objectForKey:@"time"];
//        NSString *urgency = [json objectForKey:@"urgency"];
        
        NSLog(@"%@, %@, %@,%@, %@, %@",messageID,sender,receiver,message,time,urgency);
        
        
        NSString *query;
        query = [NSString stringWithFormat:@"insert into messageTable values('%@', '%@', '%@', '%@', '%@', '%@')", messageID,sender,receiver,message,time,urgency];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            didUpdateDatabase = YES;
            
            if(connection == _readConnection)
            {
                [self deleteMessage:messageID];
            }

        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }
    
    [self loadData];
    if(didUpdateDatabase)
    {
        [self scrollToBottomAnimated:YES];
    }
    //[self.refreshControl endRefreshing];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Message read/send error - please make sure you are connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    //[errorView show];
        NSLog(@"didFailWithError");
    NSLog(@"%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}




@end

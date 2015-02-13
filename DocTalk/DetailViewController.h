//
//  DetailViewController.h
//  DocTalk
//
//  Created by Stephen Tai on 2014-11-28.
//  Copyright (c) 2013 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
//@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;

-(IBAction)makeCall:(id)sender;
-(IBAction)sendSMS:(id)sender;

@property (strong, nonatomic) NSString *phone;

@end

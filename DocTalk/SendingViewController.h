//
//  SendingViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendingViewController : UIViewController

@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIButton *attachButton;
@property (strong, nonatomic) UITextField *textEntry;
@property (strong, nonatomic) UIButton *sendButton;

@end

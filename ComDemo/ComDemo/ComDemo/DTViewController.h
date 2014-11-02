//
//  DTViewController.h
//  ComDemo
//
//  Created by Kevin Wagner on 2014-10-28.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *SMSOutText;
@property (weak, nonatomic) IBOutlet UILabel *SMSInText;
@property (weak, nonatomic) IBOutlet UIButton *SMSSendButton;

@property (weak, nonatomic) IBOutlet UITextField *ServerOutText;
@property (weak, nonatomic) IBOutlet UILabel *ServerInText;
@property (weak, nonatomic) IBOutlet UIButton *ServerSendButton;

@end

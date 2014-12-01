//
//  ThreadViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2014-11-30.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *Thread;
@property (strong, nonatomic) NSString *messageID;

@end

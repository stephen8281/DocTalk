//
//  AutoMsgDelViewController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoMsgDelViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *autoMsgDelSettings;
@property (strong, nonatomic) IBOutlet UIPickerView *autoMsgDelTime;

@end

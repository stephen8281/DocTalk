//
//  SendingViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2014-12-01.
//  Copyright (c) 2014 DocTalk. All rights reserved.
//

#import "SendingViewController.h"

@interface SendingViewController ()

@end

@implementation SendingViewController

@synthesize segmentedControl;
@synthesize attachButton;
@synthesize textEntry;
@synthesize sendButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self makePriorityControl];
//    [self makeAttachButton];
//    [self makeTextEntry];
//    [self makeSendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makePriorityControl {
    NSArray *itemArray = [NSArray arrayWithObjects: @"Normal", @"Semi-Urgent", @"Urgent", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:segmentedControl];
    
    NSMutableArray *Constraints = [NSMutableArray array];
    [Constraints addObject:[NSLayoutConstraint
                            constraintWithItem:segmentedControl
                            attribute:NSLayoutAttributeLeadingMargin
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.view
                            attribute:NSLayoutAttributeLeadingMargin
                            multiplier:1.0
                            constant:0]];
    [Constraints addObject:[NSLayoutConstraint
                            constraintWithItem:segmentedControl
                            attribute:NSLayoutAttributeTrailingMargin
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.view
                            attribute:NSLayoutAttributeTrailingMargin
                            multiplier:1.0
                            constant:0]];
    [Constraints addObject:[NSLayoutConstraint
                            constraintWithItem:segmentedControl
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.view
                            attribute:NSLayoutAttributeTop
                            multiplier:1.0
                            constant:8]];
    [self.view addConstraints:Constraints];
}

- (void)makeAttachButton {
    attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Attach"];
    [attachButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [attachButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    attachButton.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:attachButton];
//
//    NSMutableArray *Constraints = [NSMutableArray array];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:attachButton
//                            attribute:NSLayoutAttributeLeadingMargin
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeLeadingMargin
//                            multiplier:1.0
//                            constant:0]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:attachButton
//                            attribute:NSLayoutAttributeWidth
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeWidth
//                            multiplier:1.0
//                            constant:10]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:attachButton
//                            attribute:NSLayoutAttributeHeight
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:segmentedControl
//                            attribute:NSLayoutAttributeHeight
//                            multiplier:1.0
//                            constant:10]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:attachButton
//                            attribute:NSLayoutAttributeBottom
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeBottom
//                            multiplier:1.0
//                            constant:8]];
//    [self.view addConstraints:Constraints];
}

- (void)makeTextEntry {
//    textEntry = [[UITextField  alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
//    textEntry.placeholder = @"Writer";
//    textEntry.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
//    [textEntry setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:textEntry];
//    NSMutableArray *Constraints = [NSMutableArray array];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:textEntry
//                            attribute:NSLayoutAttributeLeadingMargin
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeLeadingMargin
//                            multiplier:1.0
//                            constant:0]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:textEntry
//                            attribute:NSLayoutAttributeTrailingMargin
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeTrailingMargin
//                            multiplier:1.0
//                            constant:0]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:textEntry
//                            attribute:NSLayoutAttributeBottom
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeBottom
//                            multiplier:1.0
//                            constant:0]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:textEntry
//                            attribute:NSLayoutAttributeHeight
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:segmentedControl
//                            attribute:NSLayoutAttributeHeight
//                            multiplier:1.0
//                            constant:10]];
//    [Constraints addObject:[NSLayoutConstraint
//                            constraintWithItem:textEntry
//                            attribute:NSLayoutAttributeBottom
//                            relatedBy:NSLayoutRelationEqual
//                            toItem:self.view
//                            attribute:NSLayoutAttributeBottom
//                            multiplier:1.0
//                            constant:8]];
//    [self.view addConstraints:Constraints];
}

- (void)makeSendButton {
    sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:sendButton];
    
    NSMutableArray *Constraints = [NSMutableArray array];
    [Constraints addObject:[NSLayoutConstraint
                            constraintWithItem:sendButton
                            attribute:NSLayoutAttributeTrailingMargin
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.view
                            attribute:NSLayoutAttributeTrailingMargin
                            multiplier:1.0
                            constant:0]];
    [Constraints addObject:[NSLayoutConstraint
                            constraintWithItem:sendButton
                            attribute:NSLayoutAttributeBottom
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.view
                            attribute:NSLayoutAttributeBottom
                            multiplier:1.0
                            constant:0]];
    [self.view addConstraints:Constraints];
}

@end

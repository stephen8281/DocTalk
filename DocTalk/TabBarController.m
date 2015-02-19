//
//  TabBarController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-02-17.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "TabBarController.h"
#import "sortMessagesContainer.h"

@interface TabBarController ()

@end

@implementation TabBarController

// A list of messages
static NSMutableArray *Messages = nil;

// A lookup table that converts a value to sort by into an index of a message that needs to be checked when sorting by that value
static NSArray *SortingMap = nil;

// This function returns the latest list of messages
+ (NSMutableArray *)getMessages {
    [self sortMessages];
    return Messages;
}

+ (void)sortMessages {
    NSArray *order = [sortMessagesContainer sortOrder];
    NSArray *tempArray = [Messages sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger compareVal = 0;
        for (NSInteger index = 0; index < [order count]; index++) {
            NSInteger messageIndex = [SortingMap indexOfObjectIdenticalTo:[order objectAtIndex:index]];
            compareVal = (NSInteger)[[a objectAtIndex:messageIndex] compare:[b objectAtIndex:messageIndex]];
            if (compareVal != 0) {
                break;
            }
        }
        return compareVal;
    }];
    Messages = [NSMutableArray arrayWithObjects:tempArray, nil];
}

// For the time being the list of messages is hard coded to this two dimensional array
+ (void)initialize {
    SortingMap = [NSArray arrayWithObjects:@"ID", @"Sender", @"Receiver", @"Text", @"Urgency", @"Time", nil];
    Messages = [NSMutableArray arrayWithObjects: [NSMutableArray arrayWithObjects: @"MessageID 1", @"Kevin", @"Receiver 1", @"Text 1", @0, @5000, nil], [NSMutableArray arrayWithObjects: @"MessageID 2", @"Andrew", @"Receiver 2", @"Text 2", @1, @300, nil], [NSMutableArray arrayWithObjects: @"MessageID 3", @"Stephen", @"Receiver 3", @"Text 3", @2, @4000, nil], [NSMutableArray arrayWithObjects: @"MessageID 4", @"Roger", @"Receiver 4", @"Text 4", @0, @1000, nil], [NSMutableArray arrayWithObjects: @"MessageID 5", @"Randy", @"Receiver 5", @"Text 5", @1, @2000, nil], nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

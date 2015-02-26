//
//  TabBarController.h
//  DocTalk
//
//  Created by Kevin Wagner on 2015-02-17.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

+(NSMutableArray *)getMessages;
+(NSMutableArray *)getPeople;
+(void)sortMessages;
+(void)sortPeople;

@end

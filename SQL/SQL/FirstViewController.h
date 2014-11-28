//
//  FirstViewController.h
//  SQL
//
//  Created by Randy Or on 2014-11-27.
//  Copyright (c) 2014 Randy Or. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostURL @"http://localhost/test.php"
#define kName @"name"
#define kMessage @"message"

@interface FirstViewController : UIViewController{
    
    IBOutlet UITextField *nameText;
    IBOutlet UITextView *messageText;
    NSURLConnection *postConnection;
}


-(IBAction)post:(id)sender;
@end


//
//  AutoMsgDelViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-20.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "AutoMsgDelViewController.h"

@interface AutoMsgDelViewController ()

@end

@implementation AutoMsgDelViewController{
    NSArray *_pickerData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerData = @[@"never", @"after 1 hour", @"after 2 hours", @"after 12 hours", @"after 1 day", @"after 1 week", @"after 1 month"];
    
    _autoMsgDelTime.dataSource = self;
    _autoMsgDelTime.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
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

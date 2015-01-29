//
//  StatusViewController.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-01-13.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

@synthesize redNotifEn;
@synthesize orangeNotifEn;
@synthesize greenNotifEn;
@synthesize availability;
NSArray *_mainOptions;
NSArray *_availableOptions;
NSArray *_busyOptions;
NSArray *_awayOptions;
NSString *_sellected;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainOptions = @[@"Available", @"Busy", @"Away"];
    _availableOptions = @[@"indefinitely"];
    _busyOptions = @[@"indefinitely", @"for < 1 hour", @"for 1 - 2 hours", @"for 2 - 4 hours", @"for 4 - 8 hours", @"for > 8 hours"];
    _awayOptions = @[@"indefinitely", @"for < 1 day", @"for 1 - 2 days", @"for 2 - 4 days", @"for 4 - 7 days", @"for 2 weeks", @"for > 1 month"];
    _sellected = [_mainOptions objectAtIndex:0];
    
    availability.dataSource = self;
    availability.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_mainOptions count];
    } else if ([_sellected isEqual: @"Available"]) {
        return [_availableOptions count];
    } else if ([_sellected isEqual: @"Busy"]) {
        return [_busyOptions count];
    } else if ([_sellected isEqual: @"Away"]) {
        return [_awayOptions count];
    } else {
        return 1;
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_mainOptions objectAtIndex:row];
    } else if ([_sellected isEqual: @"Available"]) {
        return [_availableOptions objectAtIndex:row];
    } else if ([_sellected isEqual: @"Busy"]) {
        return [_busyOptions objectAtIndex:row];
    } else if ([_sellected isEqual: @"Away"]) {
        return [_awayOptions objectAtIndex:row];
    } else {
        return @"Error";
    }
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _sellected = [_mainOptions objectAtIndex:row];
        [availability reloadAllComponents];
    }
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

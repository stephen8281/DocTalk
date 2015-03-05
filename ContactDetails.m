//
//  ContactDetails.m
//  DocTalk
//
//  Created by Kevin Wagner on 2015-03-03.
//  Copyright (c) 2015 DocTalk. All rights reserved.
//

#import "ContactDetails.h"
#import "SendMessageController.h"

@interface ContactDetails (){
    NSArray *Header;
}

@end

@implementation ContactDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    The following 3 lines will not be needed once Picture Status and Hospital have been added to the dictContactDetails
    NSArray *keys = [NSArray arrayWithObjects:@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"workEmail", @"Picture", @"Status", @"Hospital", nil];
    NSArray *values = [NSArray arrayWithObjects:@"firstNameTest", @"lastNameTest", @"mobileNumberTest", @"homeNumberTest", @"workEmailTest", @"PictureTest", @"StatusTest", @"HospitalTest", nil];
    _dictContactDetails = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    //    Assign table delegate and datasource
    [_detailsTable setDelegate:self];
    [_detailsTable setDataSource:self];
    
    //    Set the section header names
    Header = [NSArray arrayWithObjects:@"Phone Numbers", @"Email Address", @"Hospital", nil];
    
    //    Update the profile picture
    _ProfilePic.image = [UIImage imageNamed:[_dictContactDetails objectForKey:@"Picture"]];
    
    //    Update the name
    NSString *firstName = [_dictContactDetails objectForKey:@"firstName"];
    NSString *lastName = [_dictContactDetails objectForKey:@"lastName"];
    _Name.text = [[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];
    
    //    Update the name
    _Status.text = [_dictContactDetails objectForKey:@"Status"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Header.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numRows = 0;
    switch (section) {
        case 0:
            numRows = 2;
            break;
        case 1:
            numRows = 1;
            break;
        case 2:
            numRows = 1;
            break;
        default:
            break;
    }
    return numRows;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [Header objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = [_dictContactDetails objectForKey:@"mobileNumber"];
            } else {
                cell.textLabel.text = [_dictContactDetails objectForKey:@"homeNumber"];
            }
            break;
        case 1:
            cell.textLabel.text = [_dictContactDetails objectForKey:@"workEmail"];
            break;
        case 2:
            cell.textLabel.text = [_dictContactDetails objectForKey:@"Hospital"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showContactThread"]) {
        NSString *name = [NSString stringWithString:[_dictContactDetails objectForKey:@"Name"]];
        NSString *phoneNumber = [NSString stringWithString:[_dictContactDetails objectForKey:@"mobileNumber"]];
        
        SendMessageController *destination = [segue destinationViewController];
        [destination setReceiverName: name];
        [destination setReceiverNumber: phoneNumber];
        [destination setPhone: _phone];
    }
}

@end
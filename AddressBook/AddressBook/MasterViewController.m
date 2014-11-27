//
//  MasterViewController.m
//  AddressBook
//
//  Created by Gabriel Theodoropoulos on 9/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "DBManager.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) DBManager *dbManager;
-(void)loadData;
//-(void)showAddressBook;

@end

@implementation MasterViewController

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddressBook)];
//    
//    self.navigationItem.rightBarButtonItem = addButton;
    self.myContactList.delegate = self;
    self.myContactList.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"contact.sql"];
    
    // Load the data from database
    [self loadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private method implementation

-(void)loadData{

    // Form the query.
    NSString *query = @"select * from peopleInfo";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    // Reload the table view data.
    [self.tableView reloadData];
}


#pragma mark - IBAction method implementation

-(IBAction)showAddressBook:(id)sender {
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_arrContactsData) {
//        return _arrContactsData.count;
//    }
//    else{
//        return 0;
//    }
    
    return self.arrPeopleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    NSDictionary *contactInfoDict = [_arrContactsData objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];

    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from peopleInfo where peopleInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSMutableDictionary *contactDetailsDictionary = [[NSMutableDictionary alloc]
                                                  initWithObjects:@[@"", @"", @"", @"",@""]
                                                  forKeys:@[@"firstName", @"lastName", @"mobileNumber",@"homeNumber",@"workEmail"]];
        
        //get the index of element corresponding to each field in our arrPeopleInfo
        NSInteger indexOfFirstName = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
        NSInteger indexOfLastName = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
        NSInteger indexOfMobileNumber = [self.dbManager.arrColumnNames indexOfObject:@"mobilenumber"];
        NSInteger indexOfHomeNumber = [self.dbManager.arrColumnNames indexOfObject:@"homenumber"];
        NSInteger indexOfWorkEmail = [self.dbManager.arrColumnNames indexOfObject:@"workemail"];
        
        //get the contact detail of person at selected row
        NSString *firstName = [[self.arrPeopleInfo objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectAtIndex:indexOfFirstName];
        NSString *lastName = [[self.arrPeopleInfo objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectAtIndex:indexOfLastName];
        NSString *mobileNumber = [[self.arrPeopleInfo objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectAtIndex:indexOfMobileNumber];
        NSString *homeNumber = [[self.arrPeopleInfo objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectAtIndex:indexOfHomeNumber];
        NSString *workEmail = [[self.arrPeopleInfo objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectAtIndex:indexOfWorkEmail];
        
        //populate the dictionary
        [contactDetailsDictionary setObject:firstName forKey:@"firstName"];
        [contactDetailsDictionary setObject:lastName forKey:@"lastName"];
        [contactDetailsDictionary setObject:mobileNumber forKey:@"mobileNumber"];
        [contactDetailsDictionary setObject:homeNumber forKey:@"homeNumber"];
        [contactDetailsDictionary setObject:workEmail forKey:@"workEmail"];
        
        [[segue destinationViewController] setDictContactDetails:contactDetailsDictionary];
    }
}


#pragma mark - ABPeoplePickerNavigationController Delegate method implementation

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    // Initialize a mutable dictionary and give it initial values.
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"",@""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber",@"homeNumber",@"workEmail"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    if (phonesRef !=nil)
    {
        CFRelease(phonesRef);
    }

    
    
    // Get the e-mail addresses as a multi-value property.
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    if(emailsRef != nil)
    {
        CFRelease(emailsRef);
    }
    
    
    // If the contact has an image then get it too.
//    if (ABPersonHasImageData(person)) {
//        NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
//        
//        [contactInfoDict setObject:contactImageData forKey:@"image"];
//    }
    
//    // Initialize the array if it's not yet initialized.
//    if (_arrContactsData == nil) {
//        _arrContactsData = [[NSMutableArray alloc] init];
//    }
//    // Add the dictionary to the array.
//    [_arrContactsData addObject:contactInfoDict];
    
    NSString *firstName = [contactInfoDict objectForKey:@"firstName"];
    NSString *lastName = [contactInfoDict objectForKey:@"lastName"];
    NSString *workEmail = [contactInfoDict objectForKey:@"workEmail"];
    NSString *mobileNumber = [contactInfoDict objectForKey:@"mobileNumber"];
    NSString *homeNumber = [contactInfoDict objectForKey:@"homeNumber"];
    
    NSString *query;
    query = [NSString stringWithFormat:@"insert into peopleInfo values(null, '%@', '%@', '%@', '%@','%@')", firstName,lastName,mobileNumber,homeNumber,workEmail];
   
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

    // Load the data from database
    [self loadData];
    
    // Dismiss the address book view controller.
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
}




-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

@end

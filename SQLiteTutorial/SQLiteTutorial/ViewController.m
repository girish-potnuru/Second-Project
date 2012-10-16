//
//  ViewController.m
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import"DataController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DataController *dataController = [[DataController alloc]init];
    [dataController initDatabase];
   
    
    
    // Create address and person objects
   
    // Create address and person objects
    Address *address = [[Address alloc]initWithStreetName:@"Infinite Loop" andStreetNumber:[NSNumber numberWithInt:1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthday = [dateFormatter dateFromString: @"1955-02-24"];
    Person *person  = [[Person alloc]initWithFirstName:@"Steve" andLastName:@"Jobs" andBirthday:birthday andAddress:address];
    
    // Insert the person
    [dataController insertPerson:person];
    
    // Cleanup
    [dateFormatter release];
    [address release];
    [person release];
    
    // Get the persons
    NSArray* persons = [dataController getPersons];
    NSLog(@"Persons count: %@",persons);
    
    // Update the address
    Address *updateAddress = [[Address alloc]initWithStreetName:@"Microsoft Way" andStreetNumber:[NSNumber numberWithInt:666]];
    [dataController updateAddress:updateAddress];
    [updateAddress release];
   
     [dataController release];
    
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

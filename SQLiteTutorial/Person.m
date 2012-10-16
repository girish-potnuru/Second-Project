//
//  Person.m
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "Address.h"

@implementation Person

@synthesize firstName;
@synthesize lastName;
@synthesize birthday;
@synthesize address;

// Custom initializer
-(id)initWithFirstName:(NSString*)aFirstName
           andLastName:(NSString*)aLastName
           andBirthday:(NSDate*)aBirthday
            andAddress:(Address*)anAddress
{
    self = [super init];
    if(self) {
        self.firstName = aFirstName;
        self.lastName = aLastName;
        self.birthday = aBirthday;
        self.address = anAddress;
    }
    return self;
}

// Cleanup all contained objects
- (void)dealloc {
    [self.firstName release];
    [self.lastName release];
    [self.birthday release];
    [self.address release];
    [super dealloc];
}
@end

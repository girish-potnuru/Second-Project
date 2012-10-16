//
//  Address.m
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Address.h"

@implementation Address

@synthesize streetName;
@synthesize streetNumber;

// Custom initializer
-(id)initWithStreetName:(NSString*)aStreetName
        andStreetNumber:(NSNumber*)aStreetNumber
{
    self = [super init];
    if(self) {
        self.streetName = aStreetName;
        self.streetNumber = aStreetNumber;
    }
    return self;
}

// Cleanup all contained properties
- (void)dealloc {
    [self.streetName release];
    [self.streetNumber release];
    [super dealloc];
}

@end

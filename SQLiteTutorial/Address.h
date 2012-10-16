//
//  Address.h
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
{
    NSString *streetName;
    NSNumber *streetNumber;
}

@property (nonatomic, retain) NSString* streetName;
@property (nonatomic, retain) NSNumber* streetNumber;

-(id)initWithStreetName:(NSString*)aStreetName
        andStreetNumber:(NSNumber*)streetNumber;
@end

//
//  DataController.h
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<sqlite3.h>
#import"Person.h"
#import"Address.h"

@interface DataController : NSObject
{
    sqlite3 *databaseHandle;
    
}
-(void)initDatabase;
-(void)insertPerson:(Person*)person;
-(NSArray*)getPersons;
-(Address*)getAddressByPersonID:(int)personID;
-(void)updateAddress:(Address*)address;
@end

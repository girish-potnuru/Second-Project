//
//  DataController.m
//  SQLiteTutorial
//
//  Created by Prasad on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import<sqlite3.h>

@implementation DataController



// Method to open a database, the database will be created if it doesn't exist
-(void)initDatabase
{
    // Create a string containing the full path to the sqlite.db inside the documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Paths is %@",paths);
   ///Users/prasadb/Library/Application Support/iPhone Simulator/5.0/Applications/5B1C2F62-FF5D-4D67-94CA-D816E50CAFB5/Documents
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath= [documentsDirectory stringByAppendingPathComponent:@"psqlite.db"];
    NSLog(@"databasePath is %@",databasePath);
    // Check to see if the database file already exists
    bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([databasePath UTF8String], &databaseHandle) == SQLITE_OK)
    {
        // Create the database if it doesn't yet exists in the file system
        if (!databaseAlreadyExists)
        {
            // Create the PERSON table
            const char *sqlStatement = "CREATE TABLE IF NOT EXISTS PERSON (ID INTEGER PRIMARY KEY AUTOINCREMENT, FIRSTNAME TEXT, LASTNAME TEXT, BIRTHDAY DATE)";
            char *error;
            if (sqlite3_exec(databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
            {
            
                // Create the ADDRESS table with foreign key to the PERSON table
                sqlStatement = "CREATE TABLE IF NOT EXISTS ADDRESS (ID INTEGER PRIMARY KEY AUTOINCREMENT, STREETNAME TEXT, STREETNUMBER INT, PERSONID INT, FOREIGN KEY(PERSONID) REFERENCES PERSON(ID))";
                if (sqlite3_exec(databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
                {
                    NSLog(@"Database and tables created.");
                }
                else
                {
                    NSLog(@"Error: %s", error);
                }
            }
            else
            {
                NSLog(@"Error: %s", error);
            }
        }
    }
}


// Method to store a person and his associated address
-(void)insertPerson:(Person*)person
{
    // Create insert statement for the person
    NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO PERSON (FIRSTNAME, LASTNAME, BIRTHDAY) VALUES (\"%@\", \"%@\", \"%@\")", person.firstName, person.lastName, person.birthday];
    
    char *error;
    if ( sqlite3_exec(databaseHandle, [insertStatement UTF8String], NULL, NULL, &error) == SQLITE_OK)
    {
        int personID = sqlite3_last_insert_rowid(databaseHandle);
        
        // Create insert statement for the address
        insertStatement = [NSString stringWithFormat:@"INSERT INTO ADDRESS (STREETNAME, STREETNUMBER, PERSONID) VALUES (\"%@\", \"%@\", \"%d\")", person.address.streetName, person.address.streetNumber, personID];
        if ( sqlite3_exec(databaseHandle, [insertStatement UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"Person inserted.");
        }
        else
        {
            NSLog(@"Error: %s", error);
        }
    }
    else
    {
        NSLog(@"Error: %s", error);
    }
}

// Get an array of all persons stored inside the database
-(NSArray*)getPersons
{
    // Allocate a persons array
    NSMutableArray *persons = [[NSMutableArray alloc]init];
    
    // Create the query statement to get all persons
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT ID, FIRSTNAME, LASTNAME, BIRTHDAY FROM PERSON"];
    
    // Prepare the query for execution
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        // Iterate over all returned rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            // Get associated address of the current person row
            int personID = sqlite3_column_int(statement, 0);
            Address *address = [self getAddressByPersonID:personID];
            
            // Convert the birthday column to an NSDate
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
            NSString *birthdayAsString = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSDate *birthday = [dateFormatter dateFromString: birthdayAsString];
            [dateFormatter release];
            
            // Create a new person and add it to the array
            Person *person = [[Person alloc]initWithFirstName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]
                                                  andLastName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]
                                                  andBirthday:birthday
                                                   andAddress:address];
            [persons addObject:person];
            
            // Release the person because the array takes ownership
            [person release];
        }
        sqlite3_finalize(statement);
    }
    // Return the persons array an mark for autorelease
    return [persons autorelease];
}


// Get an address by means of the associated person ID
-(Address*)getAddressByPersonID:(int)personID
{
    Address *address = nil;
    // Create the query statement to find the correct address based on person ID
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT ID, STREETNAME, STREETNUMBER, PERSONID FROM ADDRESS WHERE PERSONID = %d", personID];
    
    // Prepare the query for execution
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        // Create a new address from the found row
        while (sqlite3_step(statement) == SQLITE_ROW) {
            address = [[Address alloc]initWithStreetName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]
                                         andStreetNumber:[NSNumber numberWithInt:sqlite3_column_int(statement, 2)]];
        }
        sqlite3_finalize(statement);
    }
    // Return the found address and mark for autorelease
    return [address autorelease];
}

// Update and address
-(void)updateAddress:(Address*)address
{
    // This is left as an exercise to extend both the Address and Person class with an ID and use this ID for the update
    int addressID = 1;
    
    // Create the replace statement for the address
    NSString *replaceStatement = [NSString stringWithFormat:@"REPLACE INTO ADDRESS (ID, STREETNAME, STREETNUMBER) VALUES (%d, \"%@\", %@);", addressID, address.streetName, address.streetNumber];
    
    // Execute the replace
    char *error;        
    if (sqlite3_exec(databaseHandle, [replaceStatement UTF8String], NULL, NULL, &error) == SQLITE_OK)
    {
        NSLog(@"Address updated");
    }
    else
    {
        NSLog(@"Error: %s", error);
    }
}


// Close the database connection when the DataController is disposed
- (void)dealloc {
    sqlite3_close(databaseHandle);
    [super dealloc];
}
@end

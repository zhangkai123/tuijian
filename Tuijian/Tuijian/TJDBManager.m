//
//  TJDBManager.m
//  Tuijian
//
//  Created by zhang kai on 3/24/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJDBManager.h"
#import "TJMessage.h"

@implementation TJDBManager

+(id)sharedDBManager
{
    static TJDBManager *databaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        databaseManager = [[TJDBManager alloc]initDatabase:TJ_DATABASE_NAME];
    });
    return databaseManager;
}

- (id)initDatabase:(NSString *)databaseName {
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// check if the db is already installed
	NSFileManager *manager = [NSFileManager defaultManager];
	
	if(![manager fileExistsAtPath:databasePath]) {
		printf("No database\n");
		NSString *appPath = [[NSBundle mainBundle] pathForResource:databaseName ofType:nil];
		[manager copyItemAtPath:appPath toPath:databasePath error:NULL];
	}
	
//	// setup our compiled sql statements
//	sqlite3 *database;
//	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
//		printf("SQLite is ok\n");
//		sqlite3_stmt *compiledStatement;
//        
//		const char *insertMessageSQL = "" ;
//		sqlite3_prepare_v2(database, insertMessageSQL, -1, &compiledStatement, NULL);
//		insertMessageStatement = compiledStatement;
//		
//		const char *getMessagesSQL = "" ;
//		sqlite3_prepare_v2(database, getMessagesSQL, -1, &compiledStatement, NULL);
//		getMessagesStatement = compiledStatement;
//	}
//	
//	sqlite3_close(database);
	return self;
	
}
-(void)insertMessageList:(NSString *)messageId type:(NSString *)mType url:(NSString *)iUrl title:(NSString *)mTitle name:(NSString *)mName message:(NSString *)mes
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = [NSString stringWithFormat:@"select * from mesList where messageId='%@' and messageType='%@'" , messageId , mType];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
        //		sqlite3_reset(compiledStatement);
        NSString *theId = nil;
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			theId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
		}
        if (theId != nil) {
            NSString *deleteCommand = [NSString stringWithFormat:@"delete from mesList where id='%@'" , theId];
            const char *deleteSqlCommand = [deleteCommand UTF8String];
            if (sqlite3_prepare_v2(database, deleteSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    compiledStatement = nil;
                }
            }
        }
        NSString *insertCommand = [NSString stringWithFormat:
                                   @"insert into mesList (messageId,messageType,imageUrl,messageTitle,messageName,message) VALUES('%@','%@','%@','%@','%@','%@')"
                                   , messageId,mType,iUrl,mTitle,mName,mes];
		const char *insertSqlCommand = [insertCommand UTF8String];
		if (sqlite3_prepare_v2(database, insertSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
			if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
				compiledStatement = nil;
			}
		}
	}
	sqlite3_close(database);
}
-(NSArray *)getMessageList
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
    NSMutableArray *messageListArray = [[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *getCommand = [NSString stringWithFormat:@"select * from mesList"];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
        //		sqlite3_reset(compiledStatement);
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSString *messageId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *messageType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            NSString *imageUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            NSString *messageTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            NSString *messageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
            NSString *message = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
            TJMessage *theMessage = [[TJMessage alloc]init];
            theMessage.messageId = messageId;
            theMessage.messageType = messageType;
            theMessage.imageUrl = imageUrl;
            theMessage.messageType = messageTitle;
            theMessage.messageName = messageName;
            theMessage.message = message;
            [messageListArray addObject:theMessage];
		}
	}
	sqlite3_close(database);
	return messageListArray;
}

-(void)insertMessage:(NSString *)theMessage
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *insertCommand = [NSString stringWithFormat:@"insert into mes (message) VALUES('%@')" , theMessage];
		const char *insertSqlCommand = [insertCommand UTF8String];
		if (sqlite3_prepare_v2(database, insertSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
			if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
				compiledStatement = nil;
			}
			printf("ok\n");
		}
        
	}
	sqlite3_close(database);
}
-(NSArray *)getAllMessages
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
    NSMutableArray *messageArray = [[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *getCommand = [NSString stringWithFormat:@"select * from mes"];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
//		sqlite3_reset(compiledStatement);
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSString *xmlStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            [messageArray addObject:xmlStr];
		}
	}
	sqlite3_close(database);
	return messageArray;
}
@end

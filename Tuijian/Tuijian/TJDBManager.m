

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
	return self;
	
}
#pragma mesList table
-(void)insertMessageList:(NSString *)messageId type:(NSString *)mType url:(NSString *)iUrl title:(NSString *)mTitle name:(NSString *)mName message:(NSString *)mes messageContentType:(NSString *)messageContentType
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = [NSString stringWithFormat:@"select * from mesList where messageId='%@' and messageType='%@'" , messageId , mType];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
        NSString *theId = nil;
        int messageNum = 0;
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			theId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            messageNum = sqlite3_column_int(compiledStatement, 7);
		}
        if (theId != nil) {
            NSString *updateCommand = [NSString stringWithFormat:@"delete from mesList where id='%@'" , theId];
            const char *updateSqlCommand = [updateCommand UTF8String];
            if (sqlite3_prepare_v2(database, updateSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    compiledStatement = nil;
                }
            }
            NSString *insertCommand = [NSString stringWithFormat:
                                       @"insert into mesList (messageId,messageType,imageUrl,messageTitle,messageName,message,messageContentType,messageNum) VALUES('%@','%@','%@','%@','%@','%@','%@','%d')"
                                       , messageId,mType,iUrl,mTitle,mName,mes,messageContentType,messageNum + 1];
            const char *insertSqlCommand = [insertCommand UTF8String];
            if (sqlite3_prepare_v2(database, insertSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    compiledStatement = nil;
                }
            }
            sqlite3_close(database);
            return;
        }
        NSString *insertCommand = [NSString stringWithFormat:
                                   @"insert into mesList (messageId,messageType,imageUrl,messageTitle,messageName,message,messageContentType,messageNum) VALUES('%@','%@','%@','%@','%@','%@','%@',1)"
                                   , messageId,mType,iUrl,mTitle,mName,mes,messageContentType];
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
		NSString *getCommand = [NSString stringWithFormat:@"select * from mesList order by id DESC"];
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
            NSString *messageContentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
            int messageNum = sqlite3_column_int(compiledStatement, 8);
            TJMessage *theMessage = [[TJMessage alloc]init];
            theMessage.messageId = messageId;
            theMessage.messageType = messageType;
            theMessage.imageUrl = imageUrl;
            theMessage.messageTitle = messageTitle;
            theMessage.messageName = messageName;
            theMessage.message = message;
            theMessage.messageContentType = messageContentType;
            theMessage.messageNum = messageNum;
            [messageListArray addObject:theMessage];
		}
	}
	sqlite3_close(database);
	return messageListArray;
}
-(int)getInfoMessageNum
{
    sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
    int totalMessageNum = 0;
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *getCommand = [NSString stringWithFormat:@"select * from mesList order by id DESC"];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            int messageNum = sqlite3_column_int(compiledStatement, 8);
            if (messageNum > 0) {
                totalMessageNum++;
            }
		}
	}
	sqlite3_close(database);
	return totalMessageNum;
}
-(void)clearInfoMessageNum:(int)messageId messageType:(NSString *)mType
{
    sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *updateCommand = [NSString stringWithFormat:@"update mesList set messageNum = 0 where messageId = '%d' and messageType='%@'",messageId,mType];
		const char *updateSqlCommand = [updateCommand UTF8String];
		sqlite3_prepare_v2(database, updateSqlCommand, -1, &compiledStatement, NULL);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
		}
	}
	sqlite3_close(database);
}
-(void)deleteFromMeslist:(NSString *)messageType messageId:(NSString *)messageId
{
    sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        //delete from meslist
		NSString *deleteMeslistCommand = [NSString stringWithFormat:@"delete from mesList where messageId='%@' and messageType='%@'" , messageId,messageType];
		const char *deleteMeslistSqlCommand = [deleteMeslistCommand UTF8String];
		sqlite3_prepare_v2(database, deleteMeslistSqlCommand, -1, &compiledStatement, NULL);
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
		}
        
        //delete all the messages from mes
        NSString *deleteMesCommand = [NSString stringWithFormat:@"delete from mes where messageId='%@' and messageType='%@'" , messageId,messageType];
		const char *deleteMesSqlCommand = [deleteMesCommand UTF8String];
		sqlite3_prepare_v2(database, deleteMesSqlCommand, -1, &compiledStatement, NULL);
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
		}
	}
	sqlite3_close(database);
}
#pragma mes table
-(void)insertMessage:(NSString *)theMessage messageType:(NSString *)messageT messageId:(NSString *)mId messageContentType:(NSString *)messageContentType
{
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *insertCommand = [NSString stringWithFormat:@"insert into mes (messageId,messageType,message,messageContentType) VALUES('%@','%@','%@','%@')" ,mId ,messageT ,theMessage,messageContentType];
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
-(NSArray *)getMessagesByOrder:(NSString *)messageType messageId:(NSString *)mId idOrder:(NSString *)idOrder
{
    [self clearInfoMessageNum:[mId intValue] messageType:messageType];//clear unread message number in message list table when featch message
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
    
    NSMutableArray *messageArray = [[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		NSString *getCommand = [NSString stringWithFormat:@"select * from mes where messageId='%@' and messageType='%@' order by id %@",mId,messageType,idOrder];
		const char *getSqlCommand = [getCommand UTF8String];
		sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSString *xmlStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            [messageArray addObject:xmlStr];
		}
	}
	sqlite3_close(database);
	return messageArray;
}
@end

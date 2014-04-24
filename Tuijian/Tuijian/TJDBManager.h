//
//  TJDBManager.h
//  Tuijian
//
//  Created by zhang kai on 3/24/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TJDBManager : NSObject
{
    NSString		*databasePath;    
}
+(id)sharedDBManager;

-(NSArray *)getMessageList;
-(void)insertMessageList:(NSString *)messageId type:(NSString *)mType url:(NSString *)iUrl title:(NSString *)mTitle name:(NSString *)mName message:(NSString *)mes messageContentType:(NSString *)messageContentType;
-(void)deleteFromMeslist:(NSString *)messageType messageId:(NSString *)messageId;

-(void)insertMessage:(NSString *)theMessage messageType:(NSString *)messageT messageId:(NSString *)mId messageContentType:(NSString *)messageContentType;
-(NSArray *)getMessagesByOrder:(NSString *)messageType messageId:(NSString *)mId idOrder:(NSString *)idOrder;
-(int)getInfoMessageNum;
-(void)clearInfoMessageNum:(int)messageId messageType:(NSString *)mType;
@end

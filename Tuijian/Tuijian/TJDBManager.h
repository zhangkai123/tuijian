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
-(void)insertMessage:(NSString *)theMessage;
-(NSArray *)getAllMessages;

-(NSArray *)getMessageList;
-(void)insertMessageList:(NSString *)messageId type:(NSString *)mType url:(NSString *)iUrl title:(NSString *)mTitle name:(NSString *)mName message:(NSString *)mes;
@end

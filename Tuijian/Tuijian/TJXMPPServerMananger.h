//
//  TJXMPPServerMananger.h
//  Tuijian
//
//  Created by zhang kai on 3/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface TJXMPPServerMananger : NSObject
{
    XMPPStream *xmppStream;
    NSString *password;
    BOOL isOpen;
}

+(id)sharedXMPPServerMananger;
-(void)userConnectToXMPPServer:(NSString *)userId password:(NSString *)pword success:(void (^)(BOOL hasOnline))success;
- (void)disconnect;
-(void)sendMessage:(NSString *)userId messageId:(NSString *)mId messageType:(NSString *)mType imageUrl:(NSString *)iUrl title:(NSString *)title messageName:(NSString *)mName message:(NSString *)mes;
-(void)sendItemMessage:(NSString *)userId messageId:(NSString *)mId messageType:(NSString *)mType imageUrl:(NSString *)iUrl title:(NSString *)title messageName:(NSString *)mName message:(NSString *)mes userProfileImage:(NSString *)pImage;
//- (void)sendMessage:(NSString *)msgContent toUser:(NSString *)userId;
@end

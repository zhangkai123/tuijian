//
//  TJXMPPServerMananger.h
//  Tuijian
//
//  Created by zhang kai on 3/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "TJMessage.h"

@interface TJXMPPServerMananger : NSObject
{
    XMPPStream *xmppStream;
    NSString *password;
    BOOL isOpen;
}

+(id)sharedXMPPServerMananger;
-(void)userConnectToXMPPServer:(NSString *)userId password:(NSString *)pword success:(void (^)(BOOL hasOnline))success;
- (void)disconnect;
//item message
-(void)sendItemMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userProfileImage:(NSString *)pImage userGender:(NSString *)userG theItemId:(NSString *)theItemId;
//chat message
-(void)sendChatMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userGender:(NSString *)userG;
//hi message
-(void)sendHiMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userGender:(NSString *)userG;
@end

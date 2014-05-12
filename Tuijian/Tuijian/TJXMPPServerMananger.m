//
//  TJXMPPServerMananger.m
//  Tuijian
//
//  Created by zhang kai on 3/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJXMPPServerMananger.h"

typedef void (^TJXMLLServerConnectedStatus)(BOOL hasOnline);

@interface TJXMPPServerMananger()

@property (readwrite, nonatomic, copy) TJXMLLServerConnectedStatus xmllServerConnectedStatus;
@end

@implementation TJXMPPServerMananger
@synthesize xmllServerConnectedStatus;

+(id)sharedXMPPServerMananger
{
    static TJXMPPServerMananger *xmppServerMananger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        xmppServerMananger = [[TJXMPPServerMananger alloc]init];
    });
    return xmppServerMananger;
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)userConnectToXMPPServer:(NSString *)userId password:(NSString *)pword success:(void (^)(BOOL hasOnline))success
{
    [self connect:userId password:pword];
    self.xmllServerConnectedStatus = success;
}
- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (BOOL)connect:(NSString *)userId password:(NSString *)pword {
    
    [self setupStream];
    
    NSString *jabberID = [NSString stringWithFormat:@"%@@115.28.6.27",userId];
    NSString *myPassword = pword;
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    //    [xmppStream setHostName:@"localhost"];
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}
- (void)disconnect {
    
    [self goOffline];
    [xmppStream disconnect];
    
}
- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

#pragma mark send item message
-(void)sendItemMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userProfileImage:(NSString *)pImage userGender:(NSString *)userG theItemId:(NSString *)theItemId
{
    NSXMLElement *message = [self constructBasicMessage:userId basicMessage:basicM];
    NSXMLElement *userProfileImage = [NSXMLElement elementWithName:@"userProfileImage"];
    [userProfileImage setStringValue:pImage];
    [message addChild:userProfileImage];
    NSXMLElement *userGender = [NSXMLElement elementWithName:@"userGender"];
    [userGender setStringValue:userG];
    [message addChild:userGender];
    NSXMLElement *itemId = [NSXMLElement elementWithName:@"itemId"];
    [itemId setStringValue:theItemId];
    [message addChild:itemId];

    [xmppStream sendElement:message];
}
#pragma mark send chat message
-(void)sendChatMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userGender:(NSString *)userG
{
    NSXMLElement *message = [self constructBasicMessage:userId basicMessage:basicM];
    NSXMLElement *userGender = [NSXMLElement elementWithName:@"userGender"];
    [userGender setStringValue:userG];
    [message addChild:userGender];
    
    [xmppStream sendElement:message];
}
#pragma mark send hi message
-(void)sendHiMessage:(NSString *)userId basicMessage:(TJMessage *)basicM userGender:(NSString *)userG
{
    NSXMLElement *message = [self constructBasicMessage:userId basicMessage:basicM];
    NSXMLElement *userGender = [NSXMLElement elementWithName:@"userGender"];
    [userGender setStringValue:userG];
    [message addChild:userGender];

    [xmppStream sendElement:message];
}

-(NSXMLElement *)constructBasicMessage:(NSString *)userId basicMessage:(TJMessage *)basicM
{
    NSString *jabberID = [NSString stringWithFormat:@"%@@115.28.6.27",userId];
    XMPPJID *jid = [XMPPJID jidWithString:jabberID];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"to" stringValue:[jid full]];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    
    
    NSXMLElement *messageId = [NSXMLElement elementWithName:@"messageId"];
    [messageId setStringValue:basicM.messageId];
    [message addChild:messageId];
    
    NSXMLElement *messageType = [NSXMLElement elementWithName:@"messageType"];
    [messageType setStringValue:basicM.messageType];
    [message addChild:messageType];
    
    NSXMLElement *imageUrl = [NSXMLElement elementWithName:@"imageUrl"];
    [imageUrl setStringValue:basicM.imageUrl];
    [message addChild:imageUrl];
    
    NSXMLElement *messageTitle = [NSXMLElement elementWithName:@"title"];
    [messageTitle setStringValue:basicM.messageTitle];
    [message addChild:messageTitle];
    
    NSXMLElement *messageName = [NSXMLElement elementWithName:@"messageName"];
    [messageName setStringValue:basicM.messageName];
    [message addChild:messageName];
    
    NSXMLElement *messageContentType = [NSXMLElement elementWithName:@"messageContentType"];
    [messageContentType setStringValue:basicM.messageContentType];
    [message addChild:messageContentType];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:basicM.message];
    [message addChild:body];
    
    return message;
}

#pragma mark XMPP delegates
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
	
	isOpen = YES;
	NSError *error = nil;
    //	[xmppStream authenticateWithPassword:password error:&error];
    if (![xmppStream authenticateWithPassword:password error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
        self.xmllServerConnectedStatus(NO);
	}
    
}
/**
 * This method is called after the stream is closed.
 *
 * The given error parameter will be non-nil if the error was due to something outside the general xmpp realm.
 * Some examples:
 * - The TCP socket was unexpectedly disconnected.
 * - The SRV resolution of the domain failed.
 * - Error parsing xml sent from server.
 **/
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	
	[self goOnline];
    self.xmllServerConnectedStatus(YES);
	
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    self.xmllServerConnectedStatus(NO);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	
	return NO;
	
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	
	[[NSNotificationCenter defaultCenter]postNotificationName:TJ_RECIEVE_MESSAGE_NOTIFICATION object:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	
	NSString *presenceType = [presence type]; // online/offline
	NSString *myUsername = [[sender myJID] user];
	NSString *presenceFromUser = [[presence from] user];
	
	if (![presenceFromUser isEqualToString:myUsername]) {
		
		if ([presenceType isEqualToString:@"available"]) {
			
            //			[_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"YOURSERVER"]];
			
		} else if ([presenceType isEqualToString:@"unavailable"]) {
			
            //			[_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"YOURSERVER"]];
			
		}
		
	}
	
}
@end

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
    
    NSString *jabberID = userId;
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

#pragma mark -
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
///**
// * This method is called after the stream is closed.
// *
// * The given error parameter will be non-nil if the error was due to something outside the general xmpp realm.
// * Some examples:
// * - The TCP socket was unexpectedly disconnected.
// * - The SRV resolution of the domain failed.
// * - Error parsing xml sent from server.
// **/
//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
//{
//    
//}
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
	
	
	NSString *msg = [[message elementForName:@"body"] stringValue];
	NSString *from = [[message attributeForName:@"from"] stringValue];
    
	NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
	[m setObject:msg forKey:@"msg"];
	[m setObject:from forKey:@"sender"];
	
    //	[_messageDelegate newMessageReceived:m];
    //	[m release];
	
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

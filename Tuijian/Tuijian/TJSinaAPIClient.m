//
//  TJSinaAPIClient.m
//  Tuijian
//
//  Created by zhang kai on 4/2/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJSinaAPIClient.h"

@implementation TJSinaAPIClient

+(TJSinaAPIClient *)sharedClient {
    static TJSinaAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:TJ_SINA_BASE_URL]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
    
}

@end

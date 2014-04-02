//
//  TJSinaAPIClient.h
//  Tuijian
//
//  Created by zhang kai on 4/2/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "AFHTTPClient.h"

@interface TJSinaAPIClient : AFHTTPClient

+(TJSinaAPIClient *)sharedClient;
@end

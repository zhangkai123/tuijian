//
//  ADSinaAPIClient.h
//  AiDaBan
//
//  Created by zhang kai on 8/27/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//
#import "AFNetworking.h"

@interface TJTencentAPIClient : AFHTTPClient

+(TJTencentAPIClient *)sharedClient;
@end

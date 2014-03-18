//
//  ADUser.m
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJUser.h"

@implementation TJUser
@synthesize accessToken;
@synthesize name = _name ,gender = _gender, profile_image_url = _profile_image_url;

-(id)initWithJsonData:(id)json
{
    if (self = [super init]) {
        
        self.name = [json objectForKey:@"nickname"];
        self.gender = [json objectForKey:@"gender"];
        self.profile_image_url = [json objectForKey:@"figureurl_qq_2"];
    }
    return self;
}
-(id)initWithDictionaryData:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        self.name = [dic objectForKey:TJ_USER_NAME];
        self.gender = [dic objectForKey:TJ_USER_GENDER];
        self.profile_image_url = [dic objectForKey:TJ_USER_IMAGE_URL];
    }
    return self;
}
@end

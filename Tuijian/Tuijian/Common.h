//
//  Common.h
//  Tuijian
//
//  Created by zhang kai on 3/11/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#ifndef Tuijian_Common_h
#define Tuijian_Common_h

//#define TJ_MY_SERVER_BASE_URL @"http://192.168.199.109/TJServer/webServices/"
#define TJ_MY_SERVER_BASE_URL @"http://115.28.6.27/TJServer/webServices/"
#define TJ_TENCENT_BASE_URL @"https://graph.qq.com/"

#define TJ_USER_HAVE_LOGIN @"user_have_login"

#define TJ_TENCENT_USER_LOGIN_INFO @"tencent_user_login_info"
#define TJ_TENCENT_USER_ID @"tencent_user_id"
#define TJ_TENCENT_ACCESS_TOKEN @"tencent_access_token"
#define TJ_TENCENT_TOKEN_EXPIRATION_DATE @"tencent_token_expiration_date"

#define TJ_MY_ACCESS_TOKEN @"my_access_token"
#define TJ_MY_USER_ID @"my_user_id"
#define TJ_MY_USER_PASSWORD @"my_user_password"//password for openfire 

#define TJ_USER_INFO @"user_info"
#define TJ_USER_NAME @"user_name"
#define TJ_USER_GENDER @"user_gender"
#define TJ_USER_IMAGE_URL @"user_image_url"

#define TJ_RECIEVE_MESSAGE_NOTIFICATION @"recieve_message_notification"
#define TJ_INFO_VIEWCONTROLLER_NOTIFICATION @"info_viewcontroller_notification"

#define TJ_DATABASE_NAME @"message.sqlite"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

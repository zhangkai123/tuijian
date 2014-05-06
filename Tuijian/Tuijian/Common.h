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
#define TJ_TENCENT_APP_ID @"101035345"

//sina weibo
#define TJ_SINA_BASE_URL @"https://api.weibo.com/2/"
#define TJ_SINA_kAppKey         @"2773657914"
#define TJ_SINA_kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define TJ_USER_HAVE_LOGIN @"user_have_login"

//tencent user info
#define TJ_TENCENT_USER_LOGIN_INFO @"tencent_user_login_info"
#define TJ_TENCENT_USER_ID @"tencent_user_id"
#define TJ_TENCENT_ACCESS_TOKEN @"tencent_access_token"
#define TJ_TENCENT_TOKEN_EXPIRATION_DATE @"tencent_token_expiration_date"

//sina user info
#define TJ_SINA_USER_LOGIN_INFO @"sina_user_login_info"
#define TJ_SINA_USER_ID @"sina_user_id"
#define TJ_SINA_ACCESS_TOKEN @"sina_access_token"
#define TJ_SINA_TOKEN_EXPIRATION_DATE @"sina_token_expiration_date"

//my user info
#define TJ_MY_ACCESS_TOKEN @"my_access_token"
#define TJ_MY_USER_ID @"my_user_id"
#define TJ_MY_USER_PASSWORD @"my_user_password"//password for openfire 

#define TJ_USER_INFO @"user_info"
#define TJ_USER_NAME @"user_name"
#define TJ_USER_GENDER @"user_gender"
#define TJ_USER_IMAGE_URL @"user_image_url"

//notifications
#define TJ_UPLOADING_ITEM_NOTIFICATION @"uploading_item_notification"
#define TJ_UPLOADING_ITEM_SUCCESS @"uploading_item_success"
#define TJ_UPLOADING_ITEM_FAIL @"uploading_item_fail"

#define TJ_CONNECT_XMPP_NOTIFICATION @"connect_xmpp_notification"
#define TJ_APP_ACTIVE_UPDATE_ALL_DATA @"app_active_update_all_data"
#define TJ_UPDATE_RECOMMEND_LIST_NOTIFICATION @"update_recommend_list_notification"
#define TJ_RECIEVE_MESSAGE_NOTIFICATION @"recieve_message_notification"
#define TJ_INFO_VIEWCONTROLLER_NOTIFICATION @"info_viewcontroller_notification"
#define TJ_CHAT_VIEWCONTROLLER_NOTIFICATION @"chat_viewcontroller_notification"
#define TJ_ITEM_MESSAGE_VIEWCONTROLLER_NOTIFICATION @"item_message_viewcontroller_notification"

#define TJ_DATABASE_NAME @"message.sqlite"

//text size
#define TJ_RECOMMEND_SIZE 15
#define TJ_RECOMMEND_WIDTH 300
#define TJ_COMMENT_SIZE 15
#define TJ_COMMENT_LABEL_WIDTH 220
#define TJ_ITEM_MESSAGE_SIZE 15
#define TJ_ITEM_MESSAGE_WIDTH 200

//item message id
#define TJ_ITEM_MESSAGE_ID @"1"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#endif

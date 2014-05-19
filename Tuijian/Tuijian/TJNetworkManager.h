//
//  ADNetworkManager.h
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNetworkManager : NSObject

+(id)sharedNetworkManager;
-(void)sendTencentUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendSinaUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendUserTokenToServerForLogin:(NSString *)access_token userCate:(NSString *)uCate userInfo:(NSDictionary *)userInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)uploadItem:(NSString *)accessT uid:(NSString *)uid title:(NSString *)title category:(NSString *)category recMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)uploadUserPhoto:(UIImage *)userPhoto userId:(NSString *)uid progress:(void (^)(float uploadProgess))uploadPro success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)reportUser:(UIImage *)reportPhoto userId:(NSString *)uid reportedId:(NSString *)reportedId reportText:(NSString *)reportText success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendFeatchItemsRequest:(NSString *)accessT uid:(NSString *)uid category:(NSString *)category success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendLikeRequest:(NSString *)accessT uid:(NSString *)uid itemId:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendComment:(NSString *)accessT uid:(NSString *)uid itemId:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getLikesAndComments:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getItemWholeInfo:(NSString *)itemId myUserId:(NSString *)myUserId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getWholeUserInfo:(NSString *)myUserId theUserId:(NSString *)theUserId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)updateMoodInformation:(NSString *)myUserId moodInfo:(NSString *)moodInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)removePhotoWithId:(NSString *)myUserId photoId:(NSString *)photoId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendFeatchUserItemsRequest:(NSString *)ownUid uid:(NSString *)uid success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getUserStatus:(NSString *)ownUid usercpFlag:(NSString *)usercpFlag success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
@end

//
//  SessionManager.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMDbCompletionHandler)(NSDictionary * _Nullable responseDict, NSError * _Nullable error);

@interface SessionManager : AFHTTPSessionManager

#pragma mark - API Key Property
@property (nonatomic, copy) NSString *APIKey;

#pragma mark - Singleton
+ (instancetype)sharedManager;

#pragma mark - GET Method
- (nullable NSURLSessionDataTask *)getInformationWithService:(NSString *)service requestModel:(nullable id<MTLJSONSerializing>)model completionHandler:(nullable TMDbCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END

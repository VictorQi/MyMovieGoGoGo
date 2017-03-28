//
//  SessionManager.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "SessionManager.h"
#import "ProjectConstants.h"
#import "MovieResultsModel.h"

static NSString *const kAPIKeyParameter = @"api_key";
static NSString *const kIDParameter = @"id";
static NSString *const kIDPlaceholder = @"{id}";

@implementation SessionManager

#pragma mark - Singleton
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kAPIBaseUrl]];
    if (!self) { return nil; }
    
    self.APIKey = kAPIKey;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

+ (instancetype)sharedManager {
    static SessionManager *_sessionManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sessionManager = [[SessionManager alloc] init];
    });
    
    return _sessionManager;
}

#pragma mark - Public Method
- (NSURLSessionDataTask *)getInformationWithService:(NSString *)service requestModel:(id<MTLJSONSerializing>)model completionHandler:(TMDbCompletionHandler)handler {
    NSAssert(self.APIKey != nil, @"SessionManager's APIKey cannot be nil. Please add your TMDb API key first!");
    
    NSError *modelToDictionaryError = nil;
    NSDictionary *params =
    model ? [MTLJSONAdapter JSONDictionaryFromModel:model error:&modelToDictionaryError] : @{};
    if (modelToDictionaryError != nil) {
        handler(nil, modelToDictionaryError);
        return nil;
    }
    
    NSMutableDictionary *parameters = [params mutableCopy];
    parameters[kAPIKeyParameter] = self.APIKey;
    
    if ([service rangeOfString:kIDPlaceholder].location != NSNotFound) {
        NSAssert(parameters[kIDParameter] != nil, @"Request parameter \'id\' cannot be nil. Please add the id");
        if (![parameters[kIDParameter] isKindOfClass:[NSString class]]) {
            parameters[kIDParameter] = [NSString stringWithFormat:@"%@", parameters[kIDParameter]];
            
            service = [service stringByReplacingOccurrencesOfString:kIDPlaceholder withString:(NSString *)parameters[kIDParameter]];
        }
    }
    
    return [self
            GET:service
            parameters:parameters
            progress:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *jsonError = nil;
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
                    if (jsonError) {
                        handler(nil, jsonError);
                    } else {
                        handler(jsonDict, nil);
                    }
                } else {
                    NSDictionary *jsonDict = (NSDictionary *)responseObject;
                    handler(jsonDict, nil);
                }
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
}

@end

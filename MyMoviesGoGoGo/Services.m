//
//  Services.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "Services.h"
#import "ProjectConstants.h"
#import "SessionManager.h"
#import "MovieSearchRequest.h"
#import "MovieResultsModel.h"
#import "MovieConfigurationModel.h"

@interface Services ()

@end

@implementation Services

- (RACSignal<MovieResultsModel *> *)signalForQuery:(NSString *)query {
    MovieSearchRequest *model = [MovieSearchRequest requestWithQuery:query];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =
        [[SessionManager sharedManager]
         getInformationWithService:kAPIMoviesSearch
         requestModel:model
         completionHandler:^(NSDictionary * _Nullable responseDict, NSError * _Nullable error) {
             if (error) {
                 [subscriber sendError:error];
             } else {
                 NSError *jsonToModelError = nil;
                 MovieResultsModel *results = [MTLJSONAdapter modelOfClass:[MovieResultsModel class] fromJSONDictionary:responseDict error:&jsonToModelError];
                 if (jsonToModelError) {
                     [subscriber sendError:jsonToModelError];
                 } else {
                     [subscriber sendNext:results];
                 }
             }
             
             [subscriber sendCompleted];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal<MovieConfigurationModel *> *)getPosterSignal {
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =
        [[SessionManager sharedManager]
         getInformationWithService:kAPIConfiguration
         requestModel:nil
         completionHandler:^(NSDictionary * _Nullable responseDict, NSError * _Nullable error) {
             if (error) {
                 [subscriber sendError:error];
             } else {
                 NSError *jsonToModelError = nil;
                 MovieConfigurationModel *results = [MTLJSONAdapter modelOfClass:[MovieConfigurationModel class] fromJSONDictionary:responseDict error:&jsonToModelError];
                 if (jsonToModelError) {
                     [subscriber sendError:jsonToModelError];
                 } else {
                     [subscriber sendNext:results];
                 }
             }
             
             [subscriber sendCompleted];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] retry:5];
}


@end

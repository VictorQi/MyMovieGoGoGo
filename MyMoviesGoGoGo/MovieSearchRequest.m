//
//  MovieSearchRequest.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MovieSearchRequest.h"

@implementation MovieSearchRequest

+ (MovieSearchRequest *)requestWithQuery:(NSString *)query page:(NSUInteger)page {
    NSAssert(query != nil, @"Query cannot be nil!!");
    MovieSearchRequest *request = [[MovieSearchRequest alloc]init];
    request.query = query;
    request.page = page;
    
    return request;
}

+ (MovieSearchRequest *)requestWithQuery:(NSString *)query {
    return [self requestWithQuery:query page:1];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // Property: JSON KEY
    return [NSDictionary mtl_identityPropertyMapWithModel:[MovieSearchRequest class]];
}

@end


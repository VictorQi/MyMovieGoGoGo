//
//  MovieSearchRequest.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MovieSearchRequest : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, nonnull) NSString *query;
@property (nonatomic, assign) NSUInteger page;

+ (nonnull MovieSearchRequest *)requestWithQuery:(nonnull NSString *)query page:(NSUInteger)page;
+ (nonnull MovieSearchRequest *)requestWithQuery:(nonnull NSString *)query;

@end

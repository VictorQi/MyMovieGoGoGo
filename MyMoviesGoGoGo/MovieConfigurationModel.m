//
//  MovieConfigurationModel.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/27.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MovieConfigurationModel.h"

@implementation MovieConfigurationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"secureBaseUrl": @"images.secure_base_url",
             @"posterSizes": @"images.poster_sizes",
             @"profileSizes": @"images.profile_sizes"
             };
}

@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@implementation MovieGenresMovieListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[MovieGenresMovieListModel class]];
}

+ (NSValueTransformer *)genresJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MovieGenreModel class]];
}

@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@implementation MovieGenreModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"genreID": @"id",
             @"genreName": @"name"
             };
}

@end

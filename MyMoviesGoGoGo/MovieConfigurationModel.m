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

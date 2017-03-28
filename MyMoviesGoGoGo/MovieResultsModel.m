//
//  MovieResultsModel.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MovieResultsModel.h"

static NSString *const kDateFormat = @"yyyy-MM-dd";

@implementation MovieModel

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = kDateFormat;
    });
    
    return dateFormatter;
}

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"posterPath": @"poster_path",
             @"overview": @"overview",
             @"originalTitle": @"original_title",
             @"title": @"title",
             @"genres": @"genre_ids",
             @"originalLanguage": @"original_language",
             @"releaseDate": @"release_date",
             @"voteCount": @"vote_count",
             @"voteAverage": @"vote_average"
             };
}

#pragma mark - JSON Transformer
+ (NSValueTransformer *)releaseDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@implementation MovieResultsModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"page": @"page",
             @"movieResults": @"results",
             @"totalResults": @"total_results",
             @"totalPages": @"total_pages"
             };
}

#pragma mark - JSON Transformer
+ (NSValueTransformer *)movieResultsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MovieModel class]];
}

@end

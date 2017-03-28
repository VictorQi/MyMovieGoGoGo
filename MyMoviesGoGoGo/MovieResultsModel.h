//
//  MovieResultsModel.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/23.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy, nullable) NSString *posterPath;
@property (nonatomic, copy, nullable) NSString *overview;
@property (nonatomic, copy, nullable) NSString *originalTitle;
@property (nonatomic, copy, nullable) NSString *originalLanguage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *genres;
@property (nonatomic, strong, nullable) NSDate *releaseDate;
@property (nonatomic, assign) NSUInteger voteCount;
@property (nonatomic, assign) CGFloat voteAverage;
@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@interface MovieResultsModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSArray<MovieModel *> *movieResults;
@property (nonatomic, assign) NSUInteger totalResults;
@property (nonatomic, assign) NSUInteger totalPages;
@end

NS_ASSUME_NONNULL_END

//
//  MovieConfigurationModel.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/27.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MovieConfigurationModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *secureBaseUrl;
@property (nonatomic, copy) NSArray<NSString *> *posterSizes;
@property (nonatomic, copy) NSArray<NSString *> *profileSizes;

@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@interface MovieGenreModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSNumber *genreID;
@property (nonatomic, copy) NSString *genreName;

@end

/* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

@interface MovieGenresMovieListModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray<MovieGenreModel *> *genres;

@end


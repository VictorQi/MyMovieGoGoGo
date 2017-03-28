//
//  Services.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MovieResultsModel, MovieConfigurationModel, MovieGenresMovieListModel;

NS_ASSUME_NONNULL_BEGIN

@interface Services : NSObject

- (RACSignal<MovieResultsModel *> *)signalForQuery:(NSString *)query;

- (RACSignal<MovieConfigurationModel *> *)getPosterSignal;

- (RACSignal<MovieGenresMovieListModel *> *)getGenreSignal;

@end

NS_ASSUME_NONNULL_END

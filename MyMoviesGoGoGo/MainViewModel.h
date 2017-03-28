//
//  MainViewModel.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MovieModel, MovieResultsModel;

@interface MainViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *searchText;
@property (nonatomic, copy, readonly) NSArray<MovieModel *> *movieResults;
@property (nonatomic, copy, readonly) NSString *posterBaseUrl;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, assign, readonly) NSUInteger totalPages;
@property (nonatomic, strong, readonly) MovieModel *cellDetailModel;

@end

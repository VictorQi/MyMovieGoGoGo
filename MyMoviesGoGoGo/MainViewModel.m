//
//  MainViewModel.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MainViewModel.h"
#import "MovieResultsModel.h"
#import "Services.h"
#import "MovieConfigurationModel.h"
#import "ProjectConstants.h"

@interface MainViewModel ()

@end

@implementation MainViewModel
#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    [self initializeBinding];
    
    return self;
}

#pragma mark - Private Binding Method
- (void)initializeBinding {
    Services *service = [[Services alloc] init];
    
    [[service getGenreSignal]
     subscribeNext:^(MovieGenresMovieListModel * _Nullable x) {
         NSData *genresData = [NSKeyedArchiver archivedDataWithRootObject:x];
         [[NSUserDefaults standardUserDefaults] setObject:genresData forKey:kGenresModelListKey];
     }];
    
    RAC(self, posterBaseUrl) =
    [[service getPosterSignal]
     map:^NSString * _Nullable(MovieConfigurationModel * _Nullable value) {
        return [value.secureBaseUrl stringByAppendingString:value.posterSizes[1]];
    }];
    
    RACSignal<MovieResultsModel *> *resultModelSignal =
    [[[[RACObserve(self, searchText)
        ignore:nil]
       filter:^BOOL(NSString * _Nullable text) {
           return text.length >= 2;
       }]
      throttle:0.6]
     flattenMap:^RACSignal<MovieResultsModel *> * _Nullable(NSString * _Nullable query) {
         return [service signalForQuery:query];
     }];
    
    RAC(self, movieResults) =
    [resultModelSignal
     map:^NSArray<MovieModel *> * _Nullable(MovieResultsModel * _Nullable resultModel) {
         return resultModel.movieResults;
     }];
    
    RAC(self, page) =
    [resultModelSignal
     map:^NSNumber * _Nullable(MovieResultsModel * _Nullable resultModel) {
         return @(resultModel.page);
     }];
    
    RAC(self, totalPages) =
    [resultModelSignal
     map:^NSNumber * _Nullable(MovieResultsModel * _Nullable resultModel) {
         return @(resultModel.totalPages);
     }];
}


@end

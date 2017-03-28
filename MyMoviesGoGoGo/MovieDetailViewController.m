//
//  MovieDetailViewController.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/24.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieResultsModel.h"
#import "MovieConfigurationModel.h"
#import "ProjectConstants.h"
#import <UIImageView+WebCache.h>

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (nonatomic, copy) NSArray<MovieGenreModel *> *genresList;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *genresListData = [[NSUserDefaults standardUserDefaults] dataForKey:kGenresModelListKey];
    self.genresList = ((MovieGenresMovieListModel *)[NSKeyedUnarchiver unarchiveObjectWithData:genresListData]).genres;
    
    [self bindToViewModel];
}

- (void)bindToViewModel {
    @weakify(self);
    
    [RACObserve(self.viewModel, originalTitle)
     subscribeNext:^(NSString *  _Nullable title) {
         @strongify(self);
         self.titleLabel.text = title;
     }];
    
    [[RACObserve(self.viewModel, posterPath)
      ignore:nil]
     subscribeNext:^(NSString *posterPath) {
         @strongify(self);
         [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:posterPath]];
     }];
    
    [RACObserve(self.viewModel, genres)
     subscribeNext:^(NSArray<NSNumber *> * _Nullable genres) {
         @strongify(self);
         NSArray *genresStringArray =
         [[self.genresList.rac_sequence
           filter:^BOOL(MovieGenreModel * _Nullable genreModel) {
               return [genres containsObject:genreModel.genreID];
           }] map:^NSString * _Nullable(MovieGenreModel * _Nullable genreModel) {
               return genreModel.genreName;
           }].array;
         self.genresLabel.text = [genresStringArray componentsJoinedByString:@",\n"];
     }];
    
    [RACObserve(self.viewModel, overview)
     subscribeNext:^(NSString * _Nullable overview) {
         @strongify(self);
         self.overviewTextView.text = overview;
     }];
}

@end

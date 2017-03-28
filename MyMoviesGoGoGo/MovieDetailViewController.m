//
//  MovieDetailViewController.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/24.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieResultsModel.h"
#import <UIImageView+WebCache.h>

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
         self.genresLabel.text = [genres componentsJoinedByString:@","];
     }];
    
    [RACObserve(self.viewModel, overview)
     subscribeNext:^(NSString * _Nullable overview) {
         @strongify(self);
         self.overviewTextView.text = overview;
     }];
}

@end

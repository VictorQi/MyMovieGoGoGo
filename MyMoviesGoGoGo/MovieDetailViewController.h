//
//  MovieDetailViewController.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/24.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieModel;

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailViewController : UIViewController

#pragma mark - View Model Property
@property (nonatomic, strong) MovieModel *viewModel;

@end

NS_ASSUME_NONNULL_END

//
//  LocationSignalController.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/29.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationSignalController : NSObject

#pragma mark - Singleton
+ (instancetype)sharedController;

#pragma mark - Public Method
- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

- (RACSignal<CLLocation *> *)locationChangedSignal;

- (RACSignal<NSNumber *> *)authorizationChangedSignal;

@end

NS_ASSUME_NONNULL_END

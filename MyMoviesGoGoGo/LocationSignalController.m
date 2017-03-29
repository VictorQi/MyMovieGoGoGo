//
//  LocationSignalController.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/29.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "LocationSignalController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSignalController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) RACReplaySubject *locationSubject;
@property (nonatomic, strong) RACReplaySubject *authorizationSubject;
@end

@implementation LocationSignalController

+ (instancetype)sharedController {
    static LocationSignalController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[LocationSignalController alloc] init];
    });
    
    return sharedController;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationSubject = [RACReplaySubject replaySubjectWithCapacity:1];
    [self.locationSubject sendNext:nil];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    self.authorizationSubject = [RACReplaySubject replaySubjectWithCapacity:1];
    [self.authorizationSubject sendNext:@(status)];
    
    return self;
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

- (RACSignal *)locationChangedSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.locationSubject subscribe:subscriber];
        return nil;
    }];
}

- (RACSignal *)authorizationChangedSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.authorizationSubject subscribe:subscriber];
        return nil;
    }];
}

#pragma mark - Core Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationSubject sendNext:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.authorizationSubject sendNext:@(status)];
}

@end

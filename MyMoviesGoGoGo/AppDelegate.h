//
//  AppDelegate.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


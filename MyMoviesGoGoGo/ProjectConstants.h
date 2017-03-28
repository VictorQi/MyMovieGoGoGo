//
//  ProjectConstants.h
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#ifndef ProjectConstants_h
#define ProjectConstants_h

#ifdef __OBJC__

#pragma mark - Base URL & API Key
// The Movie Database API Base Url & API Key
static NSString *const kAPIKey = @"f14a34a55c74aa4551cb26a652403179";
static NSString *const kAPIBaseUrl = @"https://api.themoviedb.org/3/";

#pragma mark - Search
// TMDb Search Operation
static NSString *const kAPIMoviesSearch = @"search/movie";
static NSString *const kAPIConfiguration = @"configuration";

#endif

#endif /* ProjectConstants_h */

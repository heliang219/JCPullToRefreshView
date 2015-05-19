//
//  UIViewController+JC.h
//  JCPullToRefreshView
//
//  Created by 李京城 on 15/5/18.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface UIViewController (JC)

- (void)requestWithURI:(NSString *)uri completion:(CompletionBlock)completionBlock;

- (void)requestWithURI:(NSString *)uri params:(NSDictionary *)params completion:(CompletionBlock)completionBlock;

@end

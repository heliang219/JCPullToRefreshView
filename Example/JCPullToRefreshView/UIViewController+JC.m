//
//  UIViewController+JC.m
//  JCPullToRefreshView
//
//  Created by 李京城 on 15/5/18.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import "UIViewController+JC.h"
#import "NSDictionary+JC.h"

#define kBaseServiceURL @"http://image.haosou.com/"

@implementation UIViewController (JC)

- (void)requestWithURI:(NSString *)uri completion:(CompletionBlock)completionBlock
{
    [self requestWithURI:uri params:@{} completion:completionBlock];
}

- (void)requestWithURI:(NSString *)uri params:(NSDictionary *)params completion:(CompletionBlock)completionBlock
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (!self.loadMoreView.isRefreshing) {
        self.currentPage = 1;
    }
    
    [dict setObject:@(self.currentPage) forKey:@"sn"];
    
    uri = [uri stringByAppendingString:[dict toURLParams]];

    NSString *url = [[kBaseServiceURL stringByAppendingString:uri] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/javascript"];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        
        completionBlock(operation, nil);
        
        self.currentPage++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        
        completionBlock(operation, error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

#pragma mark -

- (void)endRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pullToRefreshView.isRefreshing) {
            [self.pullToRefreshView endRefresh];
        }
        
        if (self.loadMoreView.isRefreshing) {
            [self.loadMoreView endRefresh];
        }
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    });
}

@end

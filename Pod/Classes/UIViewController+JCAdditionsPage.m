//
//  UIViewController+JCAdditionsPage.m
//  JCPullToRefreshView
//
//  Created by 李京城 on 15/5/18.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "UIViewController+JCAdditionsPage.h"
#import <objc/runtime.h>

static const void *pullToRefreshViewKey;
static const void *loadMoreViewKey;
static const void *currentPageKey;
static const void *hasNextPageKey;

@implementation UIViewController (JCAdditionsPage)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jc_swizzledMethod:@selector(viewDidLoad) and:@selector(swizzle_viewDidLoad)];
    });
}

- (void)swizzle_viewDidLoad
{
    [self swizzle_viewDidLoad];
    
    self.currentPage = 1;
    self.hasNextPage = YES;
}

- (void)enabledPullToRefreshAndLoadMore:(UIScrollView *)scrollView
{
    [self enabledPullToRefresh:scrollView];
    [self enabledLoadMore:scrollView];
}

- (void)enabledPullToRefresh:(UIScrollView *)scrollView
{
    if (!self.pullToRefreshView) {
        __weak __typeof(self) weakSelf = self;
        
        self.pullToRefreshView = [[JCPullToRefreshView alloc] initWithScrollView:scrollView];
        [self.pullToRefreshView setPullToRefreshCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDatas];
        }];
        
        [scrollView addSubview:self.pullToRefreshView];
    }
}

- (void)enabledLoadMore:(UIScrollView *)scrollView
{
    if (!self.loadMoreView) {
        __weak __typeof(self) weakSelf = self;
        
        self.loadMoreView = [[JCLoadMoreView alloc] initWithScrollView:scrollView];
        [self.loadMoreView setLoadMoreCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDatas];
        }];
        
        [scrollView addSubview:self.loadMoreView];
    }
}

- (void)loadDatas
{
    NSAssert(NO, @"subclass must be overwrite this method!");
}

#pragma mark -

- (JCPullToRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &pullToRefreshViewKey);
}

- (void)setPullToRefreshView:(JCPullToRefreshView *)pullToRefreshView
{
    objc_setAssociatedObject(self, &pullToRefreshViewKey, pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCLoadMoreView *)loadMoreView
{
    return objc_getAssociatedObject(self, &loadMoreViewKey);
}

- (void)setLoadMoreView:(JCLoadMoreView *)loadMoreView
{
    objc_setAssociatedObject(self, &loadMoreViewKey, loadMoreView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)currentPage
{
    return [objc_getAssociatedObject(self, &currentPageKey) intValue];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    objc_setAssociatedObject(self, &currentPageKey, [NSNumber numberWithInteger:currentPage], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hasNextPage
{
    return [objc_getAssociatedObject(self, &hasNextPageKey) boolValue];
}

- (void)setHasNextPage:(BOOL)hasNextPage
{
    objc_setAssociatedObject(self, &hasNextPageKey, [NSNumber numberWithBool:hasNextPage], OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - private method

+ (void)jc_swizzledMethod:(SEL)originalSelector and:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
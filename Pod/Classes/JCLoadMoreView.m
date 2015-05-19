//
//  JCLoadMoreView.m
//  JCPullToRefreshView
//
//  Created by 李京城 on 15/5/13.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCLoadMoreView.h"
#import <KVOController/FBKVOController.h>
#import "UIViewController+JCAdditionsPage.h"

#define kDefaultHeight 50.0f

@interface JCLoadMoreView()

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, copy) LoadMoreCallback callback;

@end

@implementation JCLoadMoreView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        
        self.scrollView = scrollView;
        self.contentInset = self.scrollView.contentInset;
        self.viewController = [self jc_getViewController];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = CGPointMake(screenWidth/2, kDefaultHeight/2);
        [self addSubview:self.activityView];
        
        self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kDefaultHeight-20)/2, screenWidth, 20)];
        self.bottomLabel.text = @"没有更多内容了";
        self.bottomLabel.hidden = YES;
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.bottomLabel];
        
        [self.KVOController observe:self.scrollView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld action:@selector(observeContentOffset:)];
    }
    
    return self;
}

- (void)startRefresh
{
    [self.activityView startAnimating];
    
    _isRefreshing = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        UIEdgeInsets inset = self.contentInset;
        inset.bottom += kDefaultHeight;
        self.scrollView.contentInset = inset;
        
        [self.scrollView setContentOffset:CGPointMake(0.f, self.scrollView.contentOffset.y + kDefaultHeight) animated:NO];
    } completion:^(BOOL finished) {
        if (self.callback) {
            self.callback();
        }
    }];
}

- (void)endRefresh
{
    [self.activityView stopAnimating];
    
    self.frame = CGRectZero;
   
    [UIView animateWithDuration:0.3f animations:NULL completion:^(BOOL finished) {
        self.scrollView.contentInset = self.contentInset;

        _isRefreshing = NO;
    }];
}

- (void)setLoadMoreCallback:(LoadMoreCallback)callback
{
    self.callback = callback;
}

#pragma mark - private method

- (void)observeContentOffset:(NSDictionary *)change
{
    if (!self.isRefreshing) {
        //The contentSize is big enough, and the rolling direction is downward
        if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height && [change[NSKeyValueChangeNewKey] CGPointValue].y > [change[NSKeyValueChangeOldKey] CGPointValue].y) {
            if ((self.scrollView.contentOffset.y + self.scrollView.bounds.size.height) > self.scrollView.contentSize.height) {
                self.frame = CGRectMake(0.f, self.scrollView.contentSize.height, self.scrollView.frame.size.width, kDefaultHeight);
                
                self.bottomLabel.hidden = self.viewController.hasNextPage;
                
                if ([self.viewController hasNextPage]) {
                    [self startRefresh];
                }
            }
        }
    }
}

- (UIViewController *)jc_getViewController
{
    UIResponder *responder = [self.scrollView nextResponder];
    
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}

@end
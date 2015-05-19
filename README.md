# JCPullToRefreshView

[![CI Status](http://img.shields.io/travis/lijingcheng/JCPullToRefreshView.svg?style=flat)](https://travis-ci.org/lijingcheng/JCPullToRefreshView)
[![Version](https://img.shields.io/cocoapods/v/JCPullToRefreshView.svg?style=flat)](http://cocoapods.org/pods/JCPullToRefreshView)
[![License](https://img.shields.io/cocoapods/l/JCPullToRefreshView.svg?style=flat)](http://cocoapods.org/pods/JCPullToRefreshView)
[![Platform](https://img.shields.io/cocoapods/p/JCPullToRefreshView.svg?style=flat)](http://cocoapods.org/pods/JCPullToRefreshView)

Supports pull-to-refresh and pull-to-loadmore.

<img width="320" src="./ScreenShot.gif"> 

## Installation

pod "JCPullToRefreshView"

## Usage

``` objc
#import "UIViewController+JCAdditionsPage.h"
```

Only need to add a line of code in your UIViewController.

``` objc
[self enabledPullToRefreshAndLoadMore:self.collectionView];
```

Refer to demo

## Author

[李京城](http://lijingcheng.github.io)

## License

MIT

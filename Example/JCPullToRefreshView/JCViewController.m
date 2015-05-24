//
//  JCViewController.m
//  JCPullToRefreshView
//
//  Created by lijingcheng on 05/18/2015.
//  Copyright (c) 2014 lijingcheng. All rights reserved.
//

#import "JCViewController.h"
#import "UIViewController+JC.h"

@interface JCViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation JCViewController

static NSString * const reuseIdentifier = @"cellId";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.rowHeight = 50.0f;
    self.tableView.tableFooterView = [UIView new];
    
    [self enabledPullToRefreshAndLoadMore:self.tableView];

    self.datas = [[NSMutableArray alloc] initWithCapacity:10];
    
    [SVProgressHUD show];
    [self loadDatas];
}

- (void)loadDatas
{
    [self requestWithURI:@"j" params:@{@"q":@"iPhone", @"pn": @20} completion:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(self.currentPage == 1) {
            [self.datas removeAllObjects];
        }
        
        NSArray *list = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil][@"list"];
        
        [self.datas addObjectsFromArray:list];
        
        self.hasNextPage = list.count ? YES : NO;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.datas[indexPath.row][@"title"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return cell;
}

@end

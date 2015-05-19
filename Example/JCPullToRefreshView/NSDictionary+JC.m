//
//  NSDictionary+JC.m
//  JCPullToRefreshView
//
//  Created by 李京城 on 15/5/18.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import "NSDictionary+JC.h"

@implementation NSDictionary (JC)

- (NSString *)toURLParams
{
    __block NSMutableArray *params = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [params addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    return [NSString stringWithFormat:@"?%@", [params componentsJoinedByString:@"&"]];
}

@end

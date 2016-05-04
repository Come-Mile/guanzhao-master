//
//  WorkListModel.m
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WorkListModel.h"

@implementation WorkListModel

-(NSMutableArray *)child
{
    if (_child ==nil) {
        _child = [NSMutableArray array];
    }
    
    return _child;
}

- (NSString *)money
{
    if (![_money isKindOfClass:[NSString class]]||_money ==NULL || _money ==nil || [_money isEqualToString:@"null"]) {
        _money = @"0";
    }
    return _money;
    
}
@end

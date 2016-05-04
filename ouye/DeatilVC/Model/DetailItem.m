//
//  DetailItem.m
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DetailItem.h"

@implementation DetailItem

- (NSString *)money
{
    if (![_money isKindOfClass:[NSString class]]||_money ==NULL || _money ==nil || [_money isEqualToString:@"null"]) {
        _money = @"0";
    }
    return _money;
    
}
@end

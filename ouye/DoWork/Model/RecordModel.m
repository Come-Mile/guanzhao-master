//
//  RecordModel.m
//  ouye
//
//  Created by Sino on 16/4/13.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "RecordModel.h"


@implementation RecordModel

- (NSMutableArray *)questionArray
{
    if (_questionArray ==nil) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}

@end

//
//  VideoModel.m
//  ouye
//
//  Created by Sino on 16/4/15.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel


- (NSMutableArray *)videoArray
{
    if (_videoArray ==nil) {
        _videoArray = [NSMutableArray array];
    }
    
    return _videoArray;
}
@end

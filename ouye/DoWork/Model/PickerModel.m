//
//  PickerModel.m
//  ouye
//
//  Created by Sino on 16/4/13.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "PickerModel.h"

@implementation PickerModel



- (NSMutableArray *)questionArray
{
    if (_questionArray ==nil) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}

- (NSMutableArray *)imageArray
{
    if (_imageArray ==nil) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (NSMutableArray *)textArray
{
    if (_textArray ==nil) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

@end

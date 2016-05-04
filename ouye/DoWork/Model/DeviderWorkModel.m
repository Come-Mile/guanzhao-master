//
//  DeviderWorkModel.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DeviderWorkModel.h"
#import "IWPhoto.h"

@implementation DeviderWorkModel

- (NSDictionary *)objectClassInArray
{
    return @{@"pics" : [IWPhoto class]};
}

- (NSArray *)pics
{
    if (_pics ==nil) {
        _pics = [NSArray array];
    }
    return _pics;
}

- (NSMutableArray *)pictures
{
    if (_pictures == nil) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
}
@end

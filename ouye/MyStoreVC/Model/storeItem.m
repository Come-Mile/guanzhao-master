//
//  storeItem.m
//  ouye
//
//  Created by Sino on 16/3/30.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "storeItem.h"
#import "UIImage+ImagURL.h"

@implementation storeItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setPicurls:(NSMutableArray *)picurls
{
    if ([picurls isKindOfClass:[NSMutableArray class]]) {
        _picurls = [NSMutableArray array];
        for (NSString *str in picurls) {
            [_picurls addObject:MWImageHeadFormat(str)];
        }
    }
}

@end

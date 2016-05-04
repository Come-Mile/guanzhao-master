//
//  AnnomentModel.m
//  ouye
//
//  Created by Sino on 16/4/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "AnnomentModel.h"

@implementation AnnomentModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.myId = value;
    }
}


@end

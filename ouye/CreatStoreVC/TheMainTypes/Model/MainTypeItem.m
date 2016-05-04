//
//  MainTypeItem.m
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MainTypeItem.h"

@implementation MainTypeItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title select:(BOOL)select multiselect:(BOOL)multiselect
{
    MainTypeItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.select = select;
    item.multiSelect = multiselect;
    return item;
}


+ (instancetype)itemWithTitle:(NSString *)title select:(BOOL)select multiselect:(BOOL)multiselect
{
    return [self itemWithIcon:nil title:title select:select multiselect:(BOOL)multiselect];
}
@end

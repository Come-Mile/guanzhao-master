//
//  MainTypeItem.h
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTypeItem : NSObject
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标记item
 */
@property (nonatomic ,assign)NSInteger cellId;
/**
 *  标记是否选中
 */
@property (nonatomic ,assign)BOOL select;

//标记是否可以多选
@property (nonatomic , assign)BOOL multiSelect;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title select:(BOOL)select multiselect:(BOOL)multiselect;
+ (instancetype)itemWithTitle:(NSString *)title select:(BOOL)select multiselect:(BOOL)multiselect;
@end

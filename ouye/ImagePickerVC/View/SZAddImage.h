//
//  SZAddImage.h
//  ouye
//
//  Created by Sino on 16/3/25.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

/**
 * 使用说明:直接创建此view添加到你需要放置的位置即可.
 * 属性images可以获取到当前选中的所有图片对象.
 */

#import <UIKit/UIKit.h>

@interface SZAddImage : UIView

/**
 *  存储所有的照片(UIImage)
 */
@property (nonatomic, strong) NSMutableArray *images;

@end
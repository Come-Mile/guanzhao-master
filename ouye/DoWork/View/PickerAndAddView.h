//
//  PickerAndAddView.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickerAndAddViewDelegate <NSObject>

- (void)ScrollSHouldChangeCountSize:(int)count;

@end

@interface PickerAndAddView : UIView
/**
 *  存储所有的照片或视频的地址
 */
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic ,weak)id<PickerAndAddViewDelegate>delegate;


- (CGFloat )getHeight;
@end

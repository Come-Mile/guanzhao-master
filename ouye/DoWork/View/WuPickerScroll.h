//
//  WuPickerScroll.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviderWorkModel;
@class PickerModel;

@protocol WuPickerScrollDelegate <NSObject>

- (void)pickerSummitBtnHaveClick:(UIButton *)sender;

@end

@interface WuPickerScroll : UIScrollView

@property (nonatomic,weak)id<WuPickerScrollDelegate>baseDelegate;


@property (nonatomic ,strong)PickerModel *pickerModel;
@property (nonatomic, strong)DeviderWorkModel *DeviderItem;
@end

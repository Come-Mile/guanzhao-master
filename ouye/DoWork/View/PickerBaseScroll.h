//
//  PickerBaseScroll.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviderWorkModel;
@class PickerModel;

@protocol PickerBaseScrollDelegate <NSObject>

- (void)pickerSummitBtnHaveClick:(UIButton *)sender;

@end

@interface PickerBaseScroll : UIScrollView
@property (nonatomic,weak)id<PickerBaseScrollDelegate>baseDelegate;
@property (nonatomic ,strong)PickerModel *pickerModel;
@property (nonatomic, strong)DeviderWorkModel *DeviderItem;
@end

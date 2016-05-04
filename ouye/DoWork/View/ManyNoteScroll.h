//
//  ManyNoteScroll.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviderWorkModel;
@class PickerModel;


@protocol ManyNoteScrollDelegate <NSObject>

- (void)manyPickerSummitBtnHaveClick:(UIButton *)sender;

@end
@interface ManyNoteScroll : UIScrollView
@property (nonatomic,weak)id<ManyNoteScrollDelegate>baseDelegate;
@property (nonatomic, strong)DeviderWorkModel *DeviderItem;
@property (nonatomic ,strong)PickerModel *pickerModel;
@end

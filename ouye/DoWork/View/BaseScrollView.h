//
//  BaseScrollView.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviderWorkModel;

@protocol BaseScrollViewDelegate <NSObject>

- (void)summitBtnHaveClick:(UIButton *)sender;

@end

@interface BaseScrollView : UIScrollView
@property (nonatomic ,strong)DeviderWorkModel *item;

@property (nonatomic,weak)id<BaseScrollViewDelegate>baseDelegate;

@end

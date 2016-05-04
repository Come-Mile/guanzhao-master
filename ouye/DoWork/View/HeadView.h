//
//  HeadView.h
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkListModel;

@protocol HeadBtnHaveClickDelegate <NSObject>

- (void)HeadBtnHaveClickWith:(UIButton *)senderBtn;

- (void)switchBtnHaveClickWith:(UISwitch *)switchBtn;

@end

@interface HeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *downImag;
@property (nonatomic , strong)WorkListModel *item;
@property (nonatomic , weak)id<HeadBtnHaveClickDelegate>delegate;

@end

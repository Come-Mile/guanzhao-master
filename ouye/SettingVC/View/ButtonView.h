//
//  ButtonView.h
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewDelegate <NSObject>

@optional
- (void)logoutBtnClick;


@end

@interface ButtonView : UIView

@property (nonatomic , weak)id<ButtonViewDelegate>delegate;

@end

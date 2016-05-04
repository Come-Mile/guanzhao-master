//
//  PresentView.h
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentViewDelegate <NSObject>

- (void)presentViewCloseBtnClick;
- (void)sureBtnHaveClick;

@end


typedef void(^ClosBlock)(BOOL isClose);

@interface PresentView : UIView
@property (nonatomic ,weak)id<PresentViewDelegate>delegate;

@property (nonatomic , strong)ClosBlock closeBlock;

- (void)show;
@end

//
//  VideoTaskStroll.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@protocol VideoTaskStrollDelegate <NSObject>

- (void)pickerSummitBtnHaveClick:(UIButton *)sender;

@end
@interface VideoTaskStroll : UIScrollView

@property (nonatomic ,weak)id<VideoTaskStrollDelegate>baseDelegate;
@property (nonatomic ,strong)VideoModel *videoItem;

//@property (nonatomic ,copy)NSString *detailText;
@end

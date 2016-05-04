//
//  MWCustomLoadingView.h
//  
//
//  Created by Sino on 16/3/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWCustomLoadingView : UIView

+ (MWCustomLoadingView *)shareCustomLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title InView:(UIView *)view;
- (void)stopShow;
@end

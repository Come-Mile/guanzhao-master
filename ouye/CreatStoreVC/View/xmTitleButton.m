//
//  xmTitleButton.m
//  Research
//
//  Created by Sino on 15/12/29.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "xmTitleButton.h"

@implementation xmTitleButton

/**
 自定义图片在上文字在下的按钮
 */
//从文件解析一个对象时先调用这个方法
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super initWithCoder:decoder])
    {
        [self setUp];
    }
    return self;
}
//通过代码创建一个对象时调用这个方法
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}
#pragma mark 下面两个方法是自定义按钮中图片和标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height *0.3;
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height -titleH;
    CGFloat titleW = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *0.7;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end

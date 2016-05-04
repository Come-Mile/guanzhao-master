//
//  SingleNoteView.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "SingleNoteView.h"

#import "PickerAndAddView.h"

@interface SingleNoteView()<UITextViewDelegate>

@property (nonatomic ,weak)UILabel *titleLabel;


//@property (nonatomic ,weak)PickerAndAddView *pickerView;



@end

@implementation SingleNoteView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    UILabel *label01 = [[UILabel alloc]init];
    label01.text = @"拍照备注:";
    [self addSubview:label01];
    self.titleLabel = label01;
    
    IWTextView *text = [[IWTextView alloc]init];
    // 1.添加textView
    text.font = [UIFont systemFontOfSize:15];
//    text.frame = self.bounds;
    // 垂直方向上永远可以拖拽
    text.alwaysBounceVertical = YES;
    text.delegate = self;
    text.placeholder = @"请输入备注信息...";
    text.backgroundColor = [UIColor colorWithWhite:0.600 alpha:0.4];
    self.textView = text;
    [self addSubview:text];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 0, ScreenW - 2*maginX, 21);
    self.textView.frame = CGRectMake(maginX, CGRectGetMaxY(self.titleLabel.frame) +8.0f, ScreenW -2*maginX, 120);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}

- (CGFloat )getHeight
{
    return CGRectGetMaxY(self.textView.frame);
}

@end

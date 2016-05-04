//
//  BaseScrollView.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "BaseScrollView.h"
#import "IWPhotosView.h"
#import "IWPhoto.h"
#import "ZJSwitch.h"
#import "DeviderWorkModel.h"

@interface BaseScrollView()
@property (weak, nonatomic)UILabel *titleLabel;
@property (weak, nonatomic)UIView *devideView;
@property (weak, nonatomic)UILabel *taskNameLabel;
@property (weak, nonatomic)UILabel *detailLabel;
@property (weak, nonatomic)UILabel *imageTitleLabel;
@property (weak, nonatomic)IWPhotosView *imageView;
@property (weak, nonatomic)UIView *switchBgView;
@property (weak, nonatomic)UILabel *rightLabel;
@property (weak, nonatomic)ZJSwitch *switchView;
@property (weak, nonatomic)UILabel *leftLabel;
@property (weak, nonatomic)UIButton *summitBtn;


@end

@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[UIColor colorWithRed:0.800 green:1.000 blue:1.000 alpha:1.000]];
        
        [self setUpSubViews];
    }
    return self;
}


- (void)setUpSubViews
{
    UILabel *labe = [[UILabel alloc]init];
    labe.text = @"北京赛诺营销";
    self.titleLabel = labe;
    
    UIView *lin = [[UIView alloc]init];
    lin.backgroundColor = [UIColor lightGrayColor];
    self.devideView = lin;
    
    UILabel *labe02 = [[UILabel alloc]init];
    labe02.text = @"任务说明：";
    self.taskNameLabel = labe02;
    
    UILabel *labe03 = [[UILabel alloc]init];
    labe03.numberOfLines = 0;
//    labe03.text = @"安安静过；案发就啊；国剧盛典个；爱打架；啊时光机；四大金刚设计稿；四大金刚；空间公积金感觉怪怪发按快捷键及钢结构件加工费大家快来加";
    self.detailLabel = labe03;
    
    
    UILabel *labe04 = [[UILabel alloc]init];
    labe04.text = @"示例图片：";
    self.imageTitleLabel = labe04;
    
    [self addSubview:labe];
    [self addSubview:labe02];
    [self addSubview:labe03];
    [self addSubview:labe04];
    [self addSubview:lin];

    
    IWPhotosView *photosView = [[IWPhotosView alloc]init];
    self.imageView = photosView;
    [self addSubview: photosView];
    
    UILabel *labe05 = [[UILabel alloc]init];
    self.rightLabel = labe05;
    
    ZJSwitch *swit = [[ZJSwitch alloc]init];
    swit.onText = @"有";
    swit.offText = @"无";
    swit.on = YES;
    swit.onTintColor = [UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000];
    self.switchView = swit;
    
    UILabel *labe06 = [[UILabel alloc]init];
    labe06.text = @"现场";
    labe06.textAlignment = NSTextAlignmentRight;
    self.leftLabel = labe06;
    
    [self addSubview:labe05];
    [self addSubview:labe06];
    [self addSubview:swit];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    self.summitBtn = button;
    button.tag = 101;
    [button addTarget:self action:@selector(summitBtnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self addSubview:button];
    
  
}
- (void)setItem:(DeviderWorkModel *)item
{
    _item = item;
    
    [self setUpDatas];
    
}
- (void)setUpDatas
{
    self.titleLabel.text = self.item.name;
    self.detailLabel.text = self.item.desc;
    self.imageView.photos = self.item.pictures;
    self.rightLabel.text = self.item.name;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat marGinX = 20;
    
    self.titleLabel.frame = CGRectMake(marGinX,10, ScreenW -marGinX, 21);
    self.devideView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW - 10, 1);
    self.taskNameLabel.frame = CGRectMake(marGinX, CGRectGetMaxY(self.devideView.frame)+8, ScreenW-2*marGinX, 21);
    self.detailLabel.frame = CGRectMake(marGinX, CGRectGetMaxY(self.taskNameLabel.frame)+8, ScreenW-30, 30);
    self.detailLabel.size = [self.detailLabel boundingRectWithSize:CGSizeMake(ScreenW -30, MAXFLOAT)];
    self.imageTitleLabel.frame = CGRectMake(marGinX, CGRectGetMaxY(self.detailLabel.frame)+8, ScreenW-2*marGinX, 30);
#warning 根据图片个数计算整个相册的尺寸
    CGSize retweetPhotosViewSize = [IWPhotosView photosViewSizeWithPhotosCount:(int)self.item.pictures.count];

    self.imageView.frame = CGRectMake(marGinX, CGRectGetMaxY(self.imageTitleLabel.frame)+8, ScreenW -30, 100);
    self.imageView.size = retweetPhotosViewSize;
    
    self.rightLabel.frame = CGRectMake(ScreenW-marGinX-120, CGRectGetMaxY(self.imageView.frame)+marGinX, 120, 21);
    
    self.switchView.frame = CGRectMake(ScreenW-CGRectGetWidth(self.rightLabel.frame)-marGinX-5 - 60, CGRectGetMaxY(self.imageView.frame)+marGinX- 5, 60, 30);
    
    self.leftLabel.frame = CGRectMake(ScreenW -CGRectGetWidth(self.switchView.frame)-5-CGRectGetWidth(self.rightLabel.frame)-marGinX-5 -100, CGRectGetMaxY(self.imageView.frame) +marGinX, 100, 21);
    
    self.summitBtn.frame = CGRectMake(marGinX, CGRectGetMaxY(self.leftLabel.frame) +80, ScreenW -2*marGinX, 25*floatScreenH);
    
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.summitBtn.frame)+10)];
}

- (void)summitBtnHaveClick:(UIButton *)sender
{
    if ([self.baseDelegate respondsToSelector:@selector(summitBtnHaveClick:)]) {
         self.item.haveOn = self.switchView.on;
        [self.baseDelegate performSelector:@selector(summitBtnHaveClick:) withObject:sender];
    }
}


@end

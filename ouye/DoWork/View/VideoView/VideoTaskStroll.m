//
//  VideoTaskStroll.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "VideoTaskStroll.h"
#import "SingleNoteView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoAddView.h"
#import "VideoModel.h"

@interface VideoTaskStroll()<VideoAddImageDelegate>
@property (weak, nonatomic)UILabel *titleLabel;
@property (weak, nonatomic)UIView *devideView;

@property (nonatomic ,weak)SingleNoteView *singleView;

@property (nonatomic ,weak)VideoAddView *videoAddView;

@property (nonatomic ,weak)UILabel *desLabel;

@property (nonatomic ,weak)UIButton *sureBtn;

@property (weak, nonatomic)UILabel *taskNameLabel;
@property (weak, nonatomic)UILabel *detailLabel;

@property (nonatomic ,strong)NSMutableArray *videoData;
@end

@implementation VideoTaskStroll

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[UIColor colorWithRed:0.800 green:1.000 blue:1.000 alpha:1.000]];
        
        [self setUpSubViews];
    }
    return self;
}

- (NSMutableArray *)videoData
{
    if (_videoData ==nil) {
        _videoData = [NSMutableArray array];
    }
    return _videoData;
}
- (void)setUpSubViews
{
    UILabel *labe = [[UILabel alloc]init];
//    labe.text = @"北京赛诺营销";
    self.titleLabel = labe;
    [self addSubview:labe];
    
    UIView *lin = [[UIView alloc]init];
    lin.backgroundColor = [UIColor lightGrayColor];
    self.devideView = lin;
    [self addSubview:lin];
    
    UILabel *labe02 = [[UILabel alloc]init];
    labe02.text = @"任务说明：";
    self.taskNameLabel = labe02;
    [self addSubview:labe02];
    
    UILabel *labe03 = [[UILabel alloc]init];
    labe03.numberOfLines = 0;

    self.detailLabel = labe03;
    [self addSubview:labe03];
    
    SingleNoteView *singleView = [[SingleNoteView alloc]init];
    self.singleView = singleView;
    [self addSubview:singleView];
    
    
    VideoAddView *addV = [[VideoAddView alloc]init];
    addV.canPickerCount = 1;
    addV.delegate = self;
    self.videoAddView = addV;
    [self addSubview:addV];
    
    UILabel *label04 = [[UILabel alloc]init];
    label04.text = @"提示：视频最大支持3分钟(长按可删除)";
    label04.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:label04];
    self.desLabel = label04;
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setBackgroundColor:[UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000] ];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sure addTarget:self action:@selector(summitBtnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sure;
    [self addSubview:sure];
   
}

//- (void)setDetailText:(NSString *)detailText
//{
//    _detailText = [detailText copy];
//    self.detailLabel.text = detailText;
//}
- (void)setVideoItem:(VideoModel *)videoItem
{
    _videoItem = videoItem;
    self.titleLabel.text = videoItem.taskname;
    self.detailLabel.text = videoItem.note;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 10, ScreenW-2*maginX, 21);
    self.devideView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW-10, 1);
    self.taskNameLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.devideView.frame)+8, ScreenW-2*maginX, 21);
    self.detailLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.taskNameLabel.frame)+8, ScreenW-30, 30);
    self.detailLabel.size = [self.detailLabel boundingRectWithSize:CGSizeMake(ScreenW -30, MAXFLOAT)];
    
    self.singleView.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame)+8, ScreenW,149);
    self.videoAddView.frame = CGRectMake(0, CGRectGetMaxY(self.singleView.frame)+8, ScreenW, 90*floatScreenH);
    self.desLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.videoAddView.frame)+8, ScreenW - maginX, 21);
    self.sureBtn.frame = CGRectMake(20, CGRectGetMaxY(self.desLabel.frame)+20, ScreenW - 40, 25*floatScreenH);
    
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.sureBtn.frame)+10)];
}
- (void)VCshouldAddVideoArr:(NSMutableArray *)VideoArray
{
    [self.videoData removeAllObjects];
    self.videoData = [NSMutableArray arrayWithArray:VideoArray];
}
- (void)summitBtnHaveClick:(UIButton *)sender
{
    /**
     视频
     */
    self.videoItem.videoArray = self.videoData;
    self.videoItem.textStr = self.singleView.textView.text;
    
    MWLog(@"备注：%@ 视频数组：%@",self.videoItem.textStr,self.videoData);
    
    if ([self.baseDelegate respondsToSelector:@selector(pickerSummitBtnHaveClick:)]) {
        [self.baseDelegate performSelector:@selector(pickerSummitBtnHaveClick:) withObject:sender];
        
    }
}

@end
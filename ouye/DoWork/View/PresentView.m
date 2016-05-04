//
//  PresentView.m
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "PresentView.h"
#import "AppDelegate.h"
#import "IWTextView.h"
#import "VideoAddView.h"

@interface PresentView()<UITextViewDelegate ,VideoAddImageDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewBOottom;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet IWTextView *mesTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *video1Btn;

@property (weak, nonatomic) IBOutlet VideoAddView *videoAddView;

@property (nonatomic , strong)NSMutableArray *videoDatas;
@end

@implementation PresentView

- (NSMutableArray *)videoDatas
{
    if (_videoDatas ==nil) {
        _videoDatas = [NSMutableArray array];
    }
    return _videoDatas;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpSubViews];
}

- (void)setUpSubViews
{
    self.frame = CGRectMake(0,ScreenH, ScreenW, ScreenH);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    
    // 1.添加textView
    self.mesTextView.font = [UIFont systemFontOfSize:15];
    // 垂直方向上永远可以拖拽
    self.mesTextView.alwaysBounceVertical = YES;
    self.mesTextView.delegate = self;
    self.mesTextView.placeholder = @"请输入备注说明（500字以内）";
    self.videoAddView.delegate = self;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self.mesTextView endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.mesTextView endEditing:YES];
}
- (void)show{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController.view addSubview:self];
    
    // 通过动画移动视图
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -ScreenH);
    } completion:^(BOOL finished) { // 向上移动的动画执行完毕后
        [UIView animateWithDuration:0.3 animations:^{
          self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        } completion:^(BOOL finished) {
        }];
        
    }];
}

- (void)viewShouldHidden
{
    // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将view从内存中移除
            [self removeFromSuperview];
        }];
    }];
}


- (IBAction)closeBtnClick:(id)sender {
    [self viewShouldHidden];
    if ([self.delegate respondsToSelector:@selector(presentViewCloseBtnClick)]) {
        [self.delegate performSelector:@selector(presentViewCloseBtnClick)];
    }
    
}
- (IBAction)cancleBtnClick:(id)sender {

    [self viewShouldHidden];
    if ([self.delegate respondsToSelector:@selector(presentViewCloseBtnClick)]) {
        [self.delegate performSelector:@selector(presentViewCloseBtnClick)];
    }
}

- (IBAction)sureBtnClick:(UIButton *)sender {
     [self viewShouldHidden];
    if ([self.delegate respondsToSelector:@selector(sureBtnHaveClick)]) {
        [self.delegate performSelector:@selector(sureBtnHaveClick)];
    }
}

- (void)VCshouldAddVideoArr:(NSMutableArray *)VideoArray
{
    [self.videoDatas removeAllObjects];
    self.videoDatas = [NSMutableArray arrayWithArray:VideoArray];
    
    MWLog(@"上传的视频地址：%@",self.videoDatas);

    
}
@end

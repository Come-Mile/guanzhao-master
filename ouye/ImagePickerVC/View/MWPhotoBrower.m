//
//  MWPhotoBrower.m
//  ouye
//
//  Created by Sino on 16/3/28.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MWPhotoBrower.h"
#import "XHZoomingImageView.h"
#import "NavigationBarView.h"
#import <MBProgressHUD.h>

@interface MWPhotoBrower()<UIScrollViewDelegate>

@property (nonatomic ,weak)UILabel *countLabel;

@property (nonatomic , weak)UIScrollView *baseScroView;

@property (nonatomic , weak)UIButton *backBtn;

@property (nonatomic ,weak)UIButton *nextBtn;

@end

@implementation MWPhotoBrower

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpContentViews];
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didPan:(UITapGestureRecognizer *)pan{
    MWLog(@"点击");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpContentViews
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
   
    if(self.baseScroView == nil) {
         UIScrollView *scrow  = [[UIScrollView alloc]initWithFrame:self.view.bounds];

        scrow.pagingEnabled = YES;
        scrow.showsHorizontalScrollIndicator = NO;
        scrow.showsVerticalScrollIndicator   = NO;
        scrow.delegate = self;
        scrow.alwaysBounceHorizontal = NO;
        scrow.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        [self.view addSubview:scrow];
        self.baseScroView = scrow;
    }

     [self setUpScrollDatas];
    
    self.backBtn = [self setUpButtonWIthTitlt:nil image:@"back-0"];

    self.nextBtn = [self setUpButtonWIthTitlt:nil image:@"next"];
    [self layoutBtnView];

    CGFloat fullW = self.view.bounds.size.width;
    //    CGFloat fullH = self.bounds.size.height;
    
    UILabel *count = [[UILabel alloc]initWithFrame:CGRectMake(fullW/2.0 - 50, 30, 100, 21)];
    count.font = [UIFont boldSystemFontOfSize:25.0f];
    count.textColor = [UIColor whiteColor];
    count.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:count];
    
    self.countLabel  = count;
    
    self.countLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.pageIndex +1,self.images.count];
}

- (void)layoutBtnView
{
    self.backBtn.frame = CGRectMake(5, ScreenH/2.0, 20, 34);
    self.backBtn.tag  = 100;
    self.nextBtn.frame = CGRectMake(ScreenW -20-5, ScreenH/2.0, 20, 34);
    self.nextBtn.tag = 101;
}

- (UIButton *)setUpButtonWIthTitlt:(NSString *)title image:(NSString *)imagStr
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, ScreenH -30, 30, 30);
    [btn setImage:[UIImage imageNamed:imagStr] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (void)btnHaveClick:(UIButton *)sender
{
    MWLog(@"%ld ,%ld",sender.tag,self.pageIndex);

    if (sender.tag ==100 && self.pageIndex >=1.0) {
        [self.baseScroView setContentOffset:CGPointMake(self.baseScroView.contentOffset.x  -ScreenW, 0.f) animated:YES];
    }else if(sender.tag ==101 && self.pageIndex +1< self.images.count){
        [self.baseScroView setContentOffset:CGPointMake(self.baseScroView.contentOffset.x  +ScreenW, 0.f) animated:YES];
    }
    [self scrollViewDidScroll:self.baseScroView];
    
}
- (void)setUpScrollDatas
{
    const NSInteger currentPage = 0;
    
    const CGFloat fullW = self.view.frame.size.width;
    const CGFloat fullH = self.view.frame.size.height;
    self.baseScroView.contentSize = CGSizeMake(self.images.count * fullW, 0);
    self.baseScroView.contentOffset = CGPointMake(currentPage * fullW, 0);
    
    for(id obj in self.images){
        XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake([self.images indexOfObject:obj] * (fullW), 0, fullW, fullH)];
        tmp.image = obj;
        [self.baseScroView addSubview:tmp];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.countLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.pageIndex +1,self.images.count];
}
- (NSInteger)pageIndex {
    return (self.baseScroView.contentOffset.x / self.baseScroView.frame.size.width + 0.5);
}
@end

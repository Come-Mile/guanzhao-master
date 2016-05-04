//
//  DetailViewController.m
//  ouye
//
//  Created by Sino on 16/4/5.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DetailViewController.h"

#import "NavigationBarView.h"

#import "LWHttpTool.h"
#import "CurrrentAppTool.h"

#import "StoreListItem.h"
#import "DetailItem.h"

#import "MWCustomLoadingView.h"
#import <MBProgressHUD.h>

#import "WorkListTwoViewController.h"

@interface DetailViewController ()<NavigationBarViewDelegate , UIWebViewDelegate>

@property (nonatomic ,strong)DetailItem *DetailItem;

@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@end

@implementation DetailViewController
{
    MBProgressHUD *HUD;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getDetailData];
    
}
#pragma mark 加载数据
- (void)getDetailData
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"pid"] = self.item.p_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TASKDetailURL params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"%@",json);
        self.DetailItem = [[DetailItem alloc]init];
        self.DetailItem.p_id = json[@"p_id"];
        self.DetailItem.end_time = json[@"end_time"];
        self.DetailItem.money = json[@"money"];
        self.DetailItem.p_name = json[@"p_name"];
        self.DetailItem.task_type = json[@"task_type"];
        self.DetailItem.cycle = json[@"cycle"];
        self.DetailItem.publish_id = json[@"publish_id"];
        self.DetailItem.desc = json[@"desc"];
        [self setUpWebViewData:self.DetailItem.desc];
        [self setUpViewData];
        
        MWLog(@"%@",self.DetailItem.task_type);
       
//      [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
       
        
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}


- (void)setUpWebViewData:(NSString *)htmlStr
{
    [self.myWebView loadHTMLString:htmlStr baseURL:nil];
    
}
- (void)setUpViewData
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.DetailItem.p_name];
    self.typeLabel.text = [NSString stringWithFormat:@"任务类型：%@",self.DetailItem.task_type];
    self.codeLabel.text = MWSTRFormat(@"任务编号：",self.DetailItem.publish_id);
    self.timeLabel.text = MWSTRFormat(@"任务结束时间：",self.DetailItem.end_time);
    self.moneyLabel.text = MWSTRFormat(@"￥", self.DetailItem.money);
}

#pragma mark loading
//开始加载数据
- (void)ViewDidStartLoadW:(UIView *)view {
    
    [[MWCustomLoadingView shareCustomLoadingView]showLoadingViewWithTitle:@"正在加载..." InView:view];
}

//数据加载完
- (void)ViewDidFinishLoadW:(UIView *)view {
    [[MWCustomLoadingView shareCustomLoadingView]stopShow];
}

#pragma webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
     [self ViewDidStartLoadW:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self ViewDidFinishLoadW:nil];
}

- (void)dealloc{

    [self ViewDidFinishLoadW:nil];
}
- (IBAction)startBtnClicl:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WorkListTwoViewController * controller= [board instantiateViewControllerWithIdentifier:@"WorkListTwoViewController"];
    controller.title = @"任务列表";
    controller.DetailItem = self.DetailItem;
    [self.navigationController pushViewController:controller animated:YES];
    
}


@end

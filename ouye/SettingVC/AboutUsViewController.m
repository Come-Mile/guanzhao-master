//
//  AboutUsViewController.m
//  ouye
//
//  Created by Sino on 16/3/24.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "AboutUsViewController.h"
#import "NavigationBarView.h"
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "MWCustomLoadingView.h"

@interface AboutUsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWeb;
@end

@implementation AboutUsViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setController:self];
    
    [self setUpWebView];
}


//开始加载数据
- (void)ViewDidStartLoadW:(UIView *)view {
    [[MWCustomLoadingView shareCustomLoadingView]showLoadingViewWithTitle:@"正在加载..." InView:view];
    
}

//数据加载完
- (void)ViewDidFinishLoadW:(UIView *)view {
    [[MWCustomLoadingView shareCustomLoadingView]stopShow];
}
- (void)setUpWebView
{
    [self ViewDidStartLoadW:self.myWeb];
    NSString *subStr = [NSString stringWithFormat:@"?token=%@&id=%@",[NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]],@"0"];
    NSString *url = MWSTRFormat(ABOUT, subStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.myWeb loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self ViewDidStartLoadW:webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self ViewDidFinishLoadW:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad:webView];
    [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    
}
@end

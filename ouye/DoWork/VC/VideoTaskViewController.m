//
//  VideoTaskViewController.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "VideoTaskViewController.h"
#import "VideoTaskStroll.h"
#import "NavigationBarView.h"

#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "WorkListModel.h"
#import "LWHttpTool.h"
#import "VideoModel.h"

@interface VideoTaskViewController ()<VideoTaskStrollDelegate>

@property (nonatomic ,weak)VideoTaskStroll *myScroll;

@property (nonatomic ,strong)VideoModel *videoModel;

@end

@implementation VideoTaskViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
    [self getDatas];
    
}

-  (void)getDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"task_pack_id"] = self.workItem.p_id;
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:VIDEOINDEX params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"视频任务：%@",json);
        
        if ([json[@"code"]isEqualToNumber:@200]) {
            NSArray *datasArray = [NSArray arrayWithObjects:json, nil];
            self.videoModel = [[VideoModel alloc]init];
            if ([datasArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *questinDic in datasArray) {
                    [self.videoModel setValuesForKeysWithDictionary:questinDic];
                }
            }
            [self setUpSubViews];
        }
        
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)setUpSubViews
{
    VideoTaskStroll *scr = [[VideoTaskStroll alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    scr.baseDelegate = self;
    scr.videoItem = self.videoModel;
    self.myScroll = scr;
    
    [self.view addSubview:scr];
}
- (void)pickerSummitBtnHaveClick:(UIButton *)sender
{
    if (self.videoModel.videoArray.count ==0) {
        [self showAlert:@"请至少上传一段视频"];
        return;
    }
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i=0 ;i<self.videoModel.videoArray.count ;i++) {
        
        IWFormData *formData = [[IWFormData alloc] init];
        formData.name = [NSString stringWithFormat:@"video%d",i+1];
        formData.mimeType = @"mp4";
        formData.filename = [NSString stringWithFormat:@"video%d.mp4",i+1];
        formData.dataStr = [NSString stringWithFormat:@"file://localhost/private%@",self.videoModel.videoArray[i]];
        [formDataArray addObject:formData];
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"pid"] = self.workItem.p_id;
    parameter[@"usermobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"note"] = self.videoModel.textStr;
    
    [ LWHttpTool postWithURL:VIDEOUP params:parameter formDataArray2:formDataArray success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            [MWNotificationCenter postNotificationName:@"dowrkSucess" object:nil];
        }else{
            [CurrrentAppTool showMessage:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        MWLog(@"%@",error.localizedDescription);
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:error.localizedDescription];
    }];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
@end

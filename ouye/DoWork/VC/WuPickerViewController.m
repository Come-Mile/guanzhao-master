//
//  WuPickerViewController.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WuPickerViewController.h"
#import "WuPickerScroll.h"
#import "NavigationBarView.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "LWHttpTool.h"
#import "QuenstionModel.h"


#import "DeviderWorkModel.h"
#import "WorkListModel.h"
#import "PickerModel.h"

@interface WuPickerViewController ()<WuPickerScrollDelegate>

@property (nonatomic ,weak)WuPickerScroll *myScroll;

@property (nonatomic ,strong)PickerModel *pickerModel;
@end

@implementation WuPickerViewController
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
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"taskid"] = self.workItem.task_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TAKEPHOTO params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
//        MWLog(@"拍照任务：%@",json);
        
        if ([json[@"code"]isEqualToNumber:@200]) {
            self.pickerModel = [[PickerModel alloc]init];
            self.pickerModel.title = self.title;
            NSArray *questionArray = [NSArray arrayWithObjects:json, nil];
            if ([questionArray isKindOfClass:[NSArray class]]) {
                //问题
                for (NSDictionary *questinDic in questionArray) {
                    QuenstionModel *model = [[QuenstionModel alloc]init];
                    [model setValuesForKeysWithDictionary:questinDic];
                    //选项
                    NSArray *optionsArray =  questinDic[@"options"];
                    if ([optionsArray isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *optionDic in optionsArray) {
                            OptionalAnswerModel *optionModel = [[OptionalAnswerModel alloc]init];
                            [optionModel setValuesForKeysWithDictionary:optionDic];
                            [model.optionalAnswers addObject:optionModel];
                        }
                    }
                     if (model.questionSummary.length !=0) {
                         [self.pickerModel.questionArray addObject:model];
                     }
                    MWLog(@"%@",model.type);
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
    WuPickerScroll *scr = [[WuPickerScroll alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    self.myScroll = scr;
    scr.baseDelegate =self;
    scr.pickerModel = self.pickerModel;
    scr.DeviderItem = self.DeviderItem;
    [self.view addSubview:scr];
    
}

#pragma mark 协议方法
- (void)pickerSummitBtnHaveClick:(UIButton *)sender
{
    if (self.pickerModel.imageArray.count ==0) {
        [self showAlert:@"请至少上传一段视频"];
        return;
    }
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i=0 ;i<self.pickerModel.imageArray.count ;i++) {
        
        IWFormData *formData = [[IWFormData alloc] init];
        formData.name = [NSString stringWithFormat:@"video%d",i+1];
        formData.mimeType = @"mp4";
        formData.filename = [NSString stringWithFormat:@"video%d.mp4",i+1];
        formData.dataStr = [NSString stringWithFormat:@"file://localhost/private%@",self.pickerModel.imageArray[i]];
        [formDataArray addObject:formData];
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"taskid"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"pid"] = self.workItem.p_id;
    parameter[@"question_id"] = self.pickerModel.questionId;
    parameter[@"usermobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"note"] = self.pickerModel.textStr;
    parameter[@"answers"] = self.pickerModel.selectStr;
    
    [ LWHttpTool postWithURL:CLOSETASK params:parameter formDataArray2:formDataArray success:^(id json) {
//        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            [MWNotificationCenter postNotificationName:@"dowrkSucess" object:@"note"];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
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

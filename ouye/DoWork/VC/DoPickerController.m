//
//  DoPickerController.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DoPickerController.h"
#import "PickerBaseScroll.h"
#import "NavigationBarView.h"
#import "ManyNoteScroll.h"
#import <IQKeyboardManager.h>

#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>

#import "DeviderWorkModel.h"
#import "WorkListModel.h"

#import "QuenstionModel.h"

#import "PickerModel.h"
@interface DoPickerController ()<PickerBaseScrollDelegate , ManyNoteScrollDelegate>

@property (nonatomic ,weak)PickerBaseScroll *myScroll;

@property (nonatomic ,weak)ManyNoteScroll *manyScroll;

@property (nonatomic ,strong)PickerModel *pickerModel;

@end

@implementation DoPickerController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getDatas];
}

- (void)getDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"taskid"] = self.workItem.task_id;
    
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TAKEPHOTO params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"拍照任务：%@",json);
      
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

            if ([self.DeviderItem.photo_type isEqualToString:@"1"]) {//单备注
                [self setUpSubViews];
            }else if ([self.DeviderItem.photo_type isEqualToString:@"2"]){
                [self setUpManyNoteViews];
            }
        }else{
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        }
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)setUpSubViews
{
    PickerBaseScroll *scr = [[PickerBaseScroll alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    scr.baseDelegate = self;
    scr.pickerModel = self.pickerModel;
    scr.DeviderItem = self.DeviderItem;
    self.myScroll = scr;
    [self.view addSubview:scr];
}

- (void)setUpManyNoteViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    ManyNoteScroll *scr = [[ManyNoteScroll alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    scr.baseDelegate =self;
    scr.pickerModel = self.pickerModel;
    scr.DeviderItem = self.DeviderItem;
    self.manyScroll = scr;
    
    [self.view addSubview:scr];
}

#pragma mark 协议方法
- (void)pickerSummitBtnHaveClick:(UIButton *)sender
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    for (int index =0; index < self.myScroll.pickerModel.imageArray.count; index ++) {
        NSString *strDic = [NSString stringWithFormat:@"img%d",index+1];
        [parameter setObject:self.myScroll.pickerModel.imageArray[index] forKey:strDic];
    }
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
     parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"status"] = @"0";
    parameter[@"task_pack_id"] = self.workItem.p_id;
    parameter[@"question_id"] = self.pickerModel.questionId;
    parameter[@"user_mobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"txt1"] = self.pickerModel.textStr;
    
//    MWLog(@"上传照片：%@",parameter);
   [ LWHttpTool postWithURL:PHOTOUP params:parameter formDataArray:nil success:^(id json) {
        MWLog(@"%@",json);
       if ([json[@"code"] isEqualToNumber:@200]) {
           [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
           [MWNotificationCenter postNotificationName:@"dowrkSucess" object:nil];
       }
       [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
       [CurrrentAppTool showMessage:json[@"msg"]];
   } failure:^(NSError *error) {
       MWLog(@"%@",error.localizedDescription);
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
       [CurrrentAppTool showMessage:error.localizedDescription];
   }];
}

- (void)manyPickerSummitBtnHaveClick:(UIButton *)sender
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    for (int index =0; index < self.manyScroll.pickerModel.imageArray.count; index ++) {
        NSString *strDic = [NSString stringWithFormat:@"img%d",index+1];
        [parameter setObject:self.manyScroll.pickerModel.imageArray[index] forKey:strDic];
    }
    for (int index = 0; index <self.manyScroll.pickerModel.textArray.count; index ++) {
        NSString *strDic = [NSString stringWithFormat:@"txt%d",index+1];
        [parameter setObject:self.manyScroll.pickerModel.textArray[index] forKey:strDic];
    }
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"status"] = @"0";
    parameter[@"task_pack_id"] = self.workItem.p_id;
    parameter[@"question_id"] = self.pickerModel.questionId;
    parameter[@"user_mobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    
    MWLog(@"上传照片：%@",parameter);
    [ LWHttpTool postWithURL:PHOTOUP params:parameter formDataArray:nil success:^(id json) {
        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            [MWNotificationCenter postNotificationName:@"dowrkSucess" object:nil];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
    } failure:^(NSError *error) {
        MWLog(@"%@",error.localizedDescription);
         [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:error.localizedDescription];
    }];
}

@end

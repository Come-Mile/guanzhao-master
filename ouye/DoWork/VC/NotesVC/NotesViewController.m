//
//  NotesViewController.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "NotesViewController.h"
#import "NavigationBarView.h"
#import "NotesScroll.h"
#import <IQKeyboardManager.h>
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "WorkListModel.h"

#import "QuenstionModel.h"
#import "RecordModel.h"

@interface NotesViewController ()<UIScrollViewDelegate ,NotesScrollDelegate>
@property (nonatomic ,weak)NotesScroll *myScroll;

@property (nonatomic ,strong)NSMutableArray *datas;

@property (nonatomic , strong)RecordModel *recordItem;

@end

@implementation NotesViewController
{
    MBProgressHUD *HUD;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager sharedManager].enable = NO;
   
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
//    [IQKeyboardManager sharedManager].enable = YES;
    self.myScroll.baseDelegate = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
   
    [self getNotesDatas];
}
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)getNotesDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"tasktype"] = self.workItem.task_type;
    parameter[@"taskid"] = self.workItem.task_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    
     __weak NotesViewController *controller = self;
    [LWHttpTool postWithURL:RECORD params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"记录任务：%@",json);
        if ([json[@"code"]isEqualToNumber:@200]) {
            controller.recordItem = [[RecordModel alloc]init];
            controller.recordItem.task_name = json[@"task_name"];
            controller.recordItem.questionnaire_type = json[@"questionnaire_type"];
            controller.recordItem.note = json[@"note"];
            NSArray *questionArray = json[@"datas"];
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
                    [controller.recordItem.questionArray addObject:model];
                    MWLog(@"%@",model.type);
                }
            }
             [controller setUpSubViews];
        }
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)setUpSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    NotesScroll *scr = [[NotesScroll alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    scr.baseDelegate =self;
    scr.RecoItem = self.recordItem;
    self.myScroll = scr;
    [self.view addSubview:scr];
}

- (void)summitBtnHaveClick:(UIButton *)sender
{
    [HUD removeFromSuperview];
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    parameter[@"taskid"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"pid"] = self.workItem.p_id;
    parameter[@"usermobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"answers"] = self.recordItem.selectStr;

    MWLog(@"记录上传：%@ ",parameter);
    
    __weak NotesViewController *controller = self;
    [LWHttpTool postWithURL:RECORDUP params:parameter success:^(id json) {
        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            [controller.navigationController popToViewController:controller.navigationController.viewControllers[2] animated:YES];
            [MWNotificationCenter postNotificationName:@"dowrkSucess" object:nil];
        }else{
           
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

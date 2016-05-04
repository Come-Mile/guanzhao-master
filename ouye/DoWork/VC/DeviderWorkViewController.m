//
//  DeviderWorkViewController.m
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DeviderWorkViewController.h"
#import "BaseScrollView.h"
#import "NavigationBarView.h"
#import "DoPickerController.h"
#import "WuPickerViewController.h"

#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "WorkListModel.h"
#import "DeviderWorkModel.h"
#import "IWPhoto.h"
@interface DeviderWorkViewController ()<BaseScrollViewDelegate>

@property (nonatomic ,weak) BaseScrollView *myScroll;
@property (nonatomic ,strong)DeviderWorkModel *deviderItem;

@end

@implementation DeviderWorkViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;

    [self getPickerDatas];
}

- (void)getPickerDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"taskid"] = self.workItem.task_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:PHOTO params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"拍照任务：%@",json);
        if ([json[@"code"]isEqualToNumber:@200]) {
            self.deviderItem = [[DeviderWorkModel alloc]init];
            self.deviderItem.desc = json[@"desc"];
            self.deviderItem.isphoto = json[@"isphoto"];
            self.deviderItem.name = json[@"name"];
            self.deviderItem.num = json[@"num"];
            self.deviderItem.photo_type = json[@"photo_type"];
            self.deviderItem.pics = json[@"pics"];
            self.deviderItem.haveOn = YES;
            for (NSString *imagURl in self.deviderItem.pics) {
                IWPhoto *photo = [[IWPhoto alloc]init];
                photo.thumbnail_pic = MWImageHeadFormat(imagURl);
                [self.deviderItem.pictures addObject:photo];
            }
            self.deviderItem.sta_location = json[@"sta_location"];
            self.deviderItem.wuxiao = json[@"wuxiao"];
            
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
  
    BaseScrollView *scr = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH -64)];
    scr.item = self.deviderItem;
    self.myScroll = scr;
    scr.baseDelegate = self;
    [self.view addSubview:self.myScroll];
}

- (void)summitBtnHaveClick:(UIButton *)sender
{
    if (self.myScroll.item.haveOn) {
        DoPickerController *picker = [[DoPickerController alloc]init];
        picker.title = self.title;
        picker.workItem = self.workItem;
        picker.DeviderItem = self.deviderItem;
        [self.navigationController pushViewController:picker animated:YES];
    }else{
        WuPickerViewController *picker = [[WuPickerViewController alloc]init];
        picker.title = self.title;
        picker.workItem = self.workItem;
        picker.DeviderItem = self.deviderItem;
        [self.navigationController pushViewController:picker animated:YES];
    }
}

@end

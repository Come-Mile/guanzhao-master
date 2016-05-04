//
//  DetailMessageViewController.m
//  ouye
//
//  Created by Sino on 16/4/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "DetailMessageViewController.h"
#import "NavigationBarView.h"
#import <MBProgressHUD.h>
#import "AnnomentModel.h"
#import "CurrrentAppTool.h"
#import "LWHttpTool.h"

@interface DetailMessageViewController()

@property (nonatomic ,weak)UILabel *titleLabel;
@property (nonatomic ,weak)UILabel *contentLabel;

@property (nonatomic ,strong)AnnomentModel *model;

@end

@implementation DetailMessageViewController
{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setController:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getDatas];
}

- (void)getDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"id"] = self.item.myId;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    MWLog(@"公告：%@",parameter);
    [LWHttpTool postWithURL:ANNOUNCEMENT params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"公告详情：%@",json);
      
        if ([json[@"code"]isEqualToNumber:@200]) {
            NSArray *datas = [NSArray arrayWithObject:json];
            if ([datas isKindOfClass:[NSArray class]] &&datas.count !=0) {
                 self.model = [[AnnomentModel alloc]init];
                for (NSDictionary *dic in datas) {
                    [self.model setValuesForKeysWithDictionary:dic];
                }
            }
            [self setUpSubViews];
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
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 64 +8, ScreenW - 40, 21)];
    
    [self.view addSubview:lab];
    self.titleLabel = lab;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW -15, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame)+8, ScreenW - 40, 21)];
    content.numberOfLines = 0;
    [self.view addSubview:content];
    self.contentLabel = content;
    self.titleLabel.text = self.model.title;
    self.contentLabel.text = self.model.content;
    
    CGRect tempR = self.contentLabel.frame;
    tempR.size = [self.contentLabel boundingRectWithSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)];
    self.contentLabel.frame = tempR;
}

@end

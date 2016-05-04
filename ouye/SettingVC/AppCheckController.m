//
//  AppCheckController.m
//  ouye
//
//  Created by Sino on 16/3/24.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "AppCheckController.h"
#import "NavigationBarView.h"
#import "CurrrentAppTool.h"
#import "LWHttpTool.h"
#import <MBProgressHUD.h>
#import "loadingView.h"
#import "VersionModel.h"

@interface AppCheckController ()

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (nonatomic ,weak)loadingView *loadingView;
@property (nonatomic ,strong)VersionModel *verModel;
@end

@implementation AppCheckController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setController:self];
    /**
     *  检测版本号
     */
    NSString *strVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = MWSTRFormat(@"版本号：", strVersion);
}

- (void)setUpLoading
{
    /**
     加载loading
     */
    loadingView *load = [[loadingView alloc]init];
    [self.view addSubview:load];
    load.alertTitle = @"正在检测新版本，请稍等...";
    self.loadingView = load;
}
- (IBAction)checkBtnClick:(id)sender {
    
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
//    NSString *strVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [self setUpLoading];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:UPDATEVER params:parameter success:^(id json) {
        MWLog(@"%@",json);
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        NSDictionary *datas = json[@"datas"];
        if ([datas isKindOfClass:[NSDictionary class]]) {
             self.verModel = [[VersionModel alloc]init];
            [self.verModel setValuesForKeysWithDictionary:datas];
        }
        NSString *currentV = MWSTRFormat(@"v", @"1.0.4.9");
        if ([currentV isEqualToString:self.verModel.version_num]) {
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"暂无新版本"]];
        }else{
            [self showAlert:[NSString stringWithFormat:@"版本号：%@\n%@",self.verModel.version_num,self.verModel.version_desc]];
        }
        MWLog(@"%@",MWImageHeadFormat(self.verModel.img_url));
    } failure:^(NSError *error) {
//         [self.loadingView removeFromSuperview];
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}
- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"有新版本" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


@end

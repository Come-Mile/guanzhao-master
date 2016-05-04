//
//  WarningSendMessageVC.m
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WarningSendMessageVC.h"
#import "NavigationBarView.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "LWHttpTool.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "MyStoreViewController.h"

@interface WarningSendMessageVC ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *summitBtn;
@end

@implementation WarningSendMessageVC
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad
{
    
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"观照";
    [nav setController:self];
    self.summitBtn.layer.cornerRadius = 3.0f;
    NSString *str1=[self.phoneStr substringToIndex:3];
    NSString *str2=[self.phoneStr substringFromIndex:8];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@*****%@",str1,str2];
    
    [self addTap];
}
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

//mobile	手机号  字符型
//vcode	短信验证码 字符型
//token	字符型
//name	应用名称字符型
//versionnum	版本号字符型
//logintime	登录时间字符型格式为2015-12-11 12:43:00
//comname	设备名称 字符型
//phonemodle	手机型号 字符型
//sysversion	系统版本 字符型
//operator	运营商 字符型
//resolution	分辨率 字符型
//mac	mac 字符型
//imei	imei字符型
//idfa	idfa 字符型
//idfv	idfv 字符型
- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

- (void)setUpProgress
{
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [self.view addSubview:HUD];
    [HUD show:YES];
}

- (void)setHUDHidden:(NSString *)text
{
    [HUD hide:YES afterDelay:2];
    
    if (text !=nil) {
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabelFont = [UIFont systemFontOfSize:15.0];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@",text];
    }
    [HUD removeFromSuperViewOnHide];
}

- (IBAction)summiteBtnClick:(id)sender {
    
    
    if (self.codeTF.text.length ==0) {
        [self showAlert:@"请输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSDictionary *appDic = [CurrrentAppTool getCurrentDeviceInfo];
    parameter[@"versionnum"] = appDic[@"appversion"];
    parameter[@"phonemodle"] = appDic[@"comname"];
    parameter[@"name"] = appDic[@"name"];
    parameter[@"logintime"] = appDic[@"regtime"];
    parameter[@"sysversion"] = appDic[@"sysversion"];
    parameter[@"idfa"] = [MWUserDefaul objectForKey:@"idfa"];
    parameter[@"idfv"] = [MWUserDefaul objectForKey:@"idfv"];;
    parameter[@"imei"] = [CurrrentAppTool uniqueAppInstanceIdentifier];;
    parameter[@"mac"] = [MWUserDefaul objectForKey:@"mac"];;
    parameter[@"resolution"] = [MWUserDefaul objectForKey:@"screensize"];;
    parameter[@"operator"] = [MWUserDefaul objectForKey:@"operator"];
    parameter[@"comname"] = @"ios";
    parameter[@"token"] = [MWUserDefaul objectForKey:Apptoken];
    parameter[@"mobile"] = [NSString stringWithFormat:@"%@",self.phoneStr];
    parameter[@"vcode"] = self.codeTF.text;
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    [LWHttpTool postWithURL:CheckCode params:parameter success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@200]) {
            
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_mobile"]] forKey:user_mobile];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"key"]] forKey:Apptoken];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"true_name"]] forKey:tureName];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_mobile"]] forKey:user_mobile];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_name"]] forKey:UserName];
            
//             [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",pwd] forKey:PassWord];
            if (![json[@"datas"][@"shop_id"] isKindOfClass:[NSNull class]]) {
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"shop_id"]] forKey:SHOPID];
            }
            
            [MWUserDefaul synchronize];

            /**
             *  登陆成功之后给推送设置别名
             */
//            [JPUSHService setTags:nil alias:json[@"datas"][@"user_mobile"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [JPUSHService setTags:nil alias:json[@"datas"][@"user_mobile"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                MWLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
            
//            AppDelegate *currentApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [currentApp showMyStoreVC];
            
            [self showRootVc];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
        
    } failure:^(NSError *error) {
        
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        
    }];
}

- (void)showRootVc
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyStoreViewController * myStoreVC = [board instantiateViewControllerWithIdentifier:@"MyStoreViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myStoreVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    MWLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end

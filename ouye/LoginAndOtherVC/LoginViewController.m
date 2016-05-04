//
//  LoginViewController.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FindPassViewController.h"
#import "RegistViewController.h"
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import <SFHFKeychainUtils.h>
#import "WarningViewController.h"
#import "NSString+MW.h"
#import "JPUSHService.h"
#import "MyStoreViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *useNameTF;

@property (weak, nonatomic) IBOutlet UIImageView *bgImagView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
@end

@implementation LoginViewController
{
    MBProgressHUD *HUD;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [MWNotificationCenter addObserver:self selector:@selector(registSucess) name:@"logoutSucess" object:nil];
    // 注册成功 ，刷新数据获取token
    [MWNotificationCenter addObserver:self selector:@selector(haveRegistSucessWith) name:@"registSucess" object:nil];
    //修改密码成功
    [MWNotificationCenter addObserver:self selector:@selector(reviseSucess) name:@"reviseSucess" object:nil];
    
    [self addTap];
    
    [self addKeyBoardNot];
    [self reviseSucess];
    

}
- (void)addKeyBoardNot
{
    // 3.监听键盘的通知
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ((ScreenH-keyboardF.size.height)-CGRectGetMaxY(self.pwdBgView.frame) >0) {
        return;
    }
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, (ScreenH-keyboardF.size.height)-CGRectGetMaxY(self.pwdBgView.frame));
    }];
}
/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
       
    }];
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
//用来注册成功 获取token
- (void)haveRegistSucessWith
{
    [self loginWithname:[MWUserDefaul objectForKey:user_mobile] pwd:[MWUserDefaul objectForKey:PassWord]];  
}
//修改密码成功，需要先登录
- (void)reviseSucess
{
    self.useNameTF.text = [MWUserDefaul objectForKey:user_mobile];
    self.pwdTF.text = [MWUserDefaul objectForKey:PassWord];
    MWLog(@"%@",[MWUserDefaul objectForKey:user_mobile]);
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

- (IBAction)loginBtnClick:(id)sender {
    if (![self checkPhoneTF]) return;
    if (![self checkPWDTF])return;
    [self.view endEditing:YES];
    [self loginWithname:self.useNameTF.text pwd:self.pwdTF.text];
   
}

- (void)loginWithname:(NSString *)name pwd:(NSString *)pwd
{
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
    parameter[@"token"] = @"";
    parameter[@"mobile"] = [NSString stringWithFormat:@"%@",name];
    parameter[@"pwd"] = [NSString stringWithFormat:@"%@",pwd];
    parameter[@"client"] = @"ios";
    MWLog(@"%@",parameter);
    
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    [LWHttpTool postWithURL:LIndex params:parameter success:^(id json) {

        if([json[@"code"] isEqualToNumber:@200]){
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"key"]] forKey:Apptoken];
            
//            NSLog(@"打印token:%@",[MWUserDefaul objectForKey:Apptoken]);
            /**
             *  登陆成功之后给推送设置别名
             */
            
//            [JPUSHService setTags:nil alias:name callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            
            [JPUSHService setTags:nil alias:json[@"datas"][@"user_mobile"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                MWLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"true_name"]] forKey:tureName];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_mobile"]] forKey:user_mobile];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_name"]] forKey:UserName];
            [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",pwd] forKey:PassWord];
            if (![json[@"datas"][@"shop_id"] isKindOfClass:[NSNull class]]) {
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"shop_id"]] forKey:SHOPID];
            }
            [MWUserDefaul synchronize];
//            [self dismissViewControllerAnimated:YES completion:nil];
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyStoreViewController * myStoreVC = [board instantiateViewControllerWithIdentifier:@"MyStoreViewController"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myStoreVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }else if([json[@"code"]isEqualToNumber:@2]){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WarningViewController* warning = [board instantiateViewControllerWithIdentifier:@"WarningViewController"];
            warning.phoneStr = self.useNameTF.text;
            [self.navigationController pushViewController:warning animated:YES];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
        MWLog(@"%@",json);
    } failure:^(NSError *error) {
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        MWLog(@"%@",error.localizedDescription);
    }];
}

//- (NSString *)getIMeiInKeyCHain
//{
//    NSString *imei =  [SFHFKeychainUtils getPasswordForUsername:self.useNameTF.text andServiceName:ServiceName error:nil];
//    return imei;
//}

- (IBAction)registBtnCLick:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistViewController * controller= [board instantiateViewControllerWithIdentifier:@"RegistViewController"];

    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)finPassWordBtnClick:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindPassViewController * controller= [board instantiateViewControllerWithIdentifier:@"FindPassViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)checkPhoneTF
{
    if ([self tfHaveString:self.useNameTF] ==NO) {
        [self showAlert:@"请输入正确的手机号"];
        return NO;
        
    }else{
        if (self.useNameTF.text.length !=11 || [self checkPhone] == NO || [NSString checkSpace:self.useNameTF.text]) {
            [self showAlert:@"您输入的手机号码不正确,请确认后输入"];
            MWLog(@"%d",[self checkPhone]);
            return NO;
        }else{
            return YES;
        }
    }
}

- (BOOL)tfHaveString:(UITextField *)tf
{
    if(tf.text.length !=0 ){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)checkPhone
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone=[pred evaluateWithObject:self.useNameTF.text];
    MWLog(@"%@",self.useNameTF.text);
    
    return isPhone;
}
- (BOOL)checkPWDTF
{
    if (![self tfHaveString:self.pwdTF]) {
        [self showAlert:@"请输入密码"];
        return NO;
    }else if(self.pwdTF.text.length>16 ||self.pwdTF.text.length <6) {
        [self showAlert:@"密码长度有误！请注意密码由6-16位的字符组成"];
        return NO;
    }else if(![NSString checkPWDWithString:self.pwdTF.text]|| [NSString checkSpace:self.pwdTF.text]){
        [self showAlert:@"密码只能由字母+数字组成，不允许输入特殊字符！"];
        return NO;
        
    }else{
        return YES;
    }
    
}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}


-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)dealloc
{
    [MWNotificationCenter removeObserver:self];
    
}
@end

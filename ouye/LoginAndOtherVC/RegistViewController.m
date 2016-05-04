//
//  RegistViewController.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "RegistViewController.h"
#import "NavigationBarView.h"
#import "JKCountDownButton.h"
#import <MBProgressHUD.h>
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <SFHFKeychainUtils.h>
#import "AppDelegate.h"
#import "NSString+MW.h"
#import "JPUSHService.h"
#import "MyStoreViewController.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *visitTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *pdfBtn;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIView *tfBgView;
@end

@implementation RegistViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"注册";
    [nav setController:self];
    
    [self addTap];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.getCodeBtn stop];
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    MWLog(@"TapClick");
    [self.view endEditing:YES];
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
- (IBAction)sendMesBtnCLick:(JKCountDownButton*)sender {
   if (![self checkPhoneTF]) return;
    [self.view endEditing:YES];
    sender.enabled = NO;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mobile"] = self.phoneTF.text;
    parameter[@"ident"] = @1;
    parameter[@"token"] = @"";
    [self setUpProgress];
    [LWHttpTool postWithURL:SendMes params:parameter success:^(id json) {
        [self setHUDHidden:json[@"msg"]];
        MWLog(@"%@ ,%@",json,SendMes);
        if ([json[@"code"] isEqualToNumber:@200]) {
            //button type要 设置成custom 否则会闪动
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second){
                NSString *title = [NSString stringWithFormat:@"%ds后重新获取",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }else{
            sender.enabled = YES;
        }
        
    } failure:^(NSError *error) {
        sender.enabled = YES;
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        
    }];
  
}
- (IBAction)RegistBtnClick:(id)sender {
     NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    NSDictionary *appDic = [CurrrentAppTool getCurrentDeviceInfo];
    parameter[@"versionnum"] = appDic[@"appversion"];
    parameter[@"phonemodle"] = appDic[@"comname"];
    parameter[@"name"] = appDic[@"name"];

    parameter[@"regtime"] = appDic[@"regtime"];
    parameter[@"sysversion"] = appDic[@"sysversion"];
    parameter[@"idfa"] = [MWUserDefaul objectForKey:@"idfa"];
    parameter[@"idfv"] = [MWUserDefaul objectForKey:@"idfv"];
    
    parameter[@"imei"] = [CurrrentAppTool uniqueAppInstanceIdentifier];
    parameter[@"mac"] = [MWUserDefaul objectForKey:@"mac"];;
     parameter[@"resolution"] = [MWUserDefaul objectForKey:@"screensize"];;
    parameter[@"operator"] = [MWUserDefaul objectForKey:@"operator"];
    parameter[@"comname"] = appDic[@"ios"];
//    parameter[@"token"] = @"";
    
    MWLog(@"%@ ***%@",[CurrrentAppTool getCurrentDeviceInfo],parameter);
    if (![self checkPhoneTF]) return;
    if (![self checkNameTF]) return;
    if (![self checkPWDTF]) return;
    if (![self checkVisitTF]) {
        return;
    }
    if (![self checkCodeTF]) return;
    if(!self.agreeBtn.selected){
        [self showAlert:@"使用注册前请先同意用户协议！"];
        return;
    }
    parameter[@"mobile"] = [NSString stringWithFormat:@"%@",self.phoneTF.text];
    parameter[@"truename"] = [NSString stringWithFormat:@"%@",self.nameTF.text];
    parameter[@"pwd"] = [NSString stringWithFormat:@"%@",self.pwdTF.text];
    parameter[@"vcode"] = [NSString stringWithFormat:@"%@",self.codeTF.text];
    parameter[@"ident"] = [NSString stringWithFormat:@"%@",self.visitTF.text];
    parameter[@"client"] = @"ios";
    
    [self registHttp:parameter];
    
}

//- (void)saveToKeyChain
//{
//    [SFHFKeychainUtils storeUsername:self.phoneTF.text andPassword:[CurrrentAppTool uniqueAppInstanceIdentifier] forServiceName:ServiceName updateExisting:1 error:nil];
//    MWLog(@"保存到keyChain成功%@",[SFHFKeychainUtils getPasswordForUsername:self.phoneTF.text andServiceName:ServiceName error:nil]);
//}

- (void)registHttp:(NSMutableDictionary *)parmer
{
     [self.view endEditing:YES];
    [self setUpProgress];
    MWLog(@"注册参数：%@",parmer);
    [LWHttpTool postWithURL:Regist params:parmer success:^(id json) {
        [self setHUDHidden:json[@"msg"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            MWLog(@"%@",json);
            if([json[@"code"] isEqualToNumber:@200]){
    
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_mobile"]] forKey:user_mobile];
    
//                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",self.phoneTF.text] forKey:user_mobile];
                /**
                 *  登陆成功之后给推送设置别名
                 */
                [JPUSHService setTags:nil alias:json[@"datas"][@"user_mobile"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    MWLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
                }];
    
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",json[@"datas"][@"user_name"]] forKey:UserName];
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",self.pwdTF.text] forKey:PassWord];
                
                [MWUserDefaul synchronize];
                
                /**
                 *  保存手机唯一标识符
                 */
//                [self saveToKeyChain];
//                [MWNotificationCenter postNotificationName:@"registSucess" object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
                
               [MWNotificationCenter postNotificationName:@"registSucess" object:nil];
//                AppDelegate *currentApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [currentApp showMyStoreVC];
                [self showRootVc];
            }
            
        }];
    
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

- (IBAction)agreeBtnClick:(id)sender {
    UIButton *agreeBtn = (UIButton *)sender;
    agreeBtn.selected = !agreeBtn.selected;
    
}

- (BOOL)checkPhoneTF
{
    if (![self tfHaveString:self.phoneTF]) {
        [self showAlert:@"请输入正确的手机号"];
        return NO;
        
    }else{
        if (self.phoneTF.text.length !=11 || ![self checkPhone]) {
            [self showAlert:@"您输入的手机号码不正确,请确认后输入"];
            return NO;
        }else if([NSString checkSpace:self.phoneTF.text]){
            return NO;
        }
        return YES;
    }
}
- (BOOL)checkNameTF
{
    if (![self tfHaveString:self.nameTF]) {
        [self showAlert:@"请输入用户姓名"];
        return NO;
    }else{
        if (![NSString checkNameWith:self.nameTF.text] ||[NSString checkSpace:self.nameTF.text]) {
            [self showAlert:@"请输入正确的用户名，用户名只支持输入中文！"];
            return NO;
        }else if(self.nameTF.text.length>10 ){
            [self showAlert:@"用户姓名最多只能输入10个汉字"];
            return NO;
        }
        return YES;
    }
}



- (BOOL)checkPWDTF
{
    if (![self tfHaveString:self.pwdTF]) {
        [self showAlert:@"请输入密码"];
        return NO;
    }else if(self.pwdTF.text.length>16 ||self.pwdTF.text.length <6 ) {
        [self showAlert:@"密码长度有误！请注意密码由6-16位的字符组成"];
        return NO;
    }else if(![NSString checkPWDWithString:self.pwdTF.text]||[NSString checkSpace:self.pwdTF.text]){
        [self showAlert:@"密码只能由字母+数字组成，不允许输入特殊字符！"];
        return NO;
        
    }else{
        return YES;
    }
    
}

- (BOOL)checkVisitTF
{
    
    if (![self tfHaveString:self.visitTF]) {
    
        return YES;
    }else if(self.visitTF.text.length!=12 ||self.visitTF.text.length <6) {
        [self showAlert:@"邀请码长度有误！请注意邀请码由12位的字符组成"];
        return NO;
    }else if(![self checkYaoQing]||[NSString checkSpace:self.visitTF.text]){
        [self showAlert:@"邀请码只能由字母+数字组成"];
        return NO;
        
    }else{
        return YES;
    }
}

- (BOOL)checkCodeTF
{
    if (![self tfHaveString:self.codeTF]) {
        [self showAlert:@"请输入验证码"];
        return NO;
    }else if([NSString checkSpace:self.visitTF.text]){
        [self showAlert:@"请输入正确的验证码"];
        return NO;
    }else{
        return YES;
    }
}
//iOS 验证字母加数字的组合
- (BOOL)checkCode:(NSString *)code
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
    s = [s invertedSet];
    NSRange r = [code rangeOfCharacterFromSet:s];
    if (r.location !=NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return YES;
    }else{
        return NO;
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
- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}


- (BOOL)checkYaoQing
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    BOOL isPwd=[passWordPredicate evaluateWithObject:self.visitTF.text];
    return isPwd;
}

- (BOOL)checkPhone
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone=[pred evaluateWithObject:self.phoneTF.text];
    
    return isPhone;
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

@end

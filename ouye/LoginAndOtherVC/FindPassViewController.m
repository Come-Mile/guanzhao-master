//
//  FindPassViewController.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "FindPassViewController.h"
#import "NavigationBarView.h"
#import "JKCountDownButton.h"
#import <MBProgressHUD.h>
#import "LWHttpTool.h"
#import "NSString+MW.h"

@interface FindPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviseBtn;

@end

@implementation FindPassViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"忘记密码";
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
- (IBAction)senMesBtnClick:(JKCountDownButton *)sender {
    
    if (![self checkPhoneTF]) return;
    [self.view endEditing:YES];
    sender.enabled = NO;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mobile"] = self.phoneTF.text;
    parameter[@"ident"] = @0;
    parameter[@"token"] = @"";
    [self setUpProgress];
    [LWHttpTool postWithURL:SendMes params:parameter success:^(id json) {
        [self setHUDHidden:json[@"msg"]];
        MWLog(@"%@ ,%@",json,SendMes);
        if ([json[@"code"] isEqualToNumber:@200]) {
            //button type要 设置成custom 否则会闪动
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second){
                NSString *title = [NSString stringWithFormat:@"%d后重新获取",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }
        
    } failure:^(NSError *error) {
        sender.enabled = YES;
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        
    }];
}

- (BOOL)checkPhoneTF
{
    if (![self tfHaveString:self.phoneTF]) {
        [self showAlert:@"请输入正确的手机号"];
        return NO;
        
    }else{
        if (self.phoneTF.text.length !=11 || ![self checkPhone]||[NSString checkSpace:self.phoneTF.text]) {
            [self showAlert:@"您输入的手机号码不正确,请确认后输入"];
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
    }else if(self.pwdTF.text.length>16 ||self.pwdTF.text.length <6) {
        [self showAlert:@"密码长度有误！请注意密码由6-16位的字符组成"];
        return NO;
    }else if(![NSString checkPWDWithString:self.pwdTF.text] ||[NSString checkSpace:self.pwdTF.text]){
        [self showAlert:@"密码只能由字母+数字组成，不允许输入特殊字符！"];
        return NO;
        
    }else{
        return YES;
    }
    
}

- (BOOL)checkCodeTF
{
    if (![self tfHaveString:self.codeTF] ||[NSString checkSpace:self.codeTF.text]) {
        [self showAlert:@"请输入正确的验证码"];
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)checkPhone
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone=[pred evaluateWithObject:self.phoneTF.text];
    
    return isPhone;
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

//mobile	手机号  字符型
//vcode	短信验证码 字符型
//pwd	新密码 字符型
//token	字符型
- (IBAction)reviseBtnClick:(id)sender {
    
    if (![self checkPhoneTF]) return;
    if (![self checkPWDTF]) return;
    if (![self checkCodeTF]) return;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mobile"] = self.phoneTF.text;
    parameter[@"vcode"] = self.codeTF.text;
    parameter[@"pwd"] = self.pwdTF.text;
    parameter[@"token"] = [MWUserDefaul objectForKey:Apptoken];
    [LWHttpTool postWithURL:findPass params:parameter success:^(id json) {
        [self setHUDHidden:json[@"msg"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            MWLog(@"%@",json);
            if([json[@"code"] isEqualToNumber:@200]){
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",self.phoneTF.text] forKey:user_mobile];
                [MWUserDefaul setObject:[NSString stringWithFormat:@"%@",self.pwdTF.text] forKey:PassWord];
                
                //修改密码成功
                [MWNotificationCenter postNotificationName:@"reviseSucess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } failure:^(NSError *error) {
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
    
}

@end

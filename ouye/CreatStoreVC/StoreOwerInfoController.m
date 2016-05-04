//
//  StoreOwerInfoController.m
//  ouye
//
//  Created by Sino on 16/3/24.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "StoreOwerInfoController.h"
#import "NavigationBarView.h"
#import "NSString+MW.h"
#import "MJSettingItem.h"

@interface StoreOwerInfoController ()<NavigationBarViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *famelBtn;
@property (weak, nonatomic) IBOutlet UIButton *manSBtn;
@property (weak, nonatomic) IBOutlet UIButton *famelSBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation StoreOwerInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setSummitBtnShow];
    [nav setController:self];
    nav.delegate = self;
    
    [self addTap];
    
    [self setUpData];
    
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

- (void)setUpData
{
    if (self.item.dic) {
        self.nameTF.text = self.item.dic[@"createusername"];
        if ([self.item.dic[@"usersex"] isKindOfClass:[NSString class]]) {
            if ([self.item.dic[@"usersex"] isEqualToString:@"0"]) {
                self.manSBtn.selected = YES;
                self.manBtn.selected = YES;
            }else if([self.item.dic[@"usersex"] isEqualToString:@"1"]){
                self.famelSBtn.selected = YES;
                self.famelBtn.selected = YES;
            }
        }
        self.phoneTF.text = self.item.dic[@"userphone"];
    }
}

- (IBAction)manBtnClick:(id)sender {
    self.manSBtn.selected = YES;
    self.famelSBtn.selected = NO;
 
   
}
- (IBAction)famelBtnClick:(id)sender {
    self.famelSBtn.selected = YES;
    self.manSBtn.selected = NO;
}

- (BOOL)checkNameTF
{
//    if (![self tfHaveString:self.nameTF]) {
////        [self showAlert:@"请输入用户姓名"];
//        return YES;
//    }else{
//        if (![NSString checkNameWith:self.nameTF.text] ||[NSString checkSpace:self.nameTF.text]) {
//            [self showAlert:@"请输入正确的用户名，用户名只支持输入中文！"];
//            return NO;
//        }else
    
            if(self.nameTF.text.length>10 ){
            [self showAlert:@"用户姓名最多只能输入10个汉字"];
            return NO;
        }
        return YES;
//    }
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

- (BOOL)checkPhoneTF
{
    if (![self tfHaveString:self.phoneTF]) {
//        [self showAlert:@"请输入正确的手机号"];
        return YES;
        
    }else{
        if (self.phoneTF.text.length >15 ) {
            [self showAlert:@"您输入的联系方式不正确,请确认后输入"];
            return NO;
        }else if([NSString checkSpace:self.phoneTF.text]){
            return NO;
        }
        return YES;
    }
}

// 手机号不做限制
- (BOOL)checkPhone
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone=[pred evaluateWithObject:self.phoneTF.text];
    
    return isPhone;
}

- (void)summitBtnHaveClick
{
    [self.view endEditing:YES];
    if(![self checkNameTF])return;
    if (![self checkPhoneTF]) return;
    
    NSString *sex = @"";
    NSString *name = @"";
    NSString *phone =@"";
    if (self.manSBtn.selected) {
        sex = @"0";
    }else if(self.famelSBtn.selected){
        sex = @"1";
    }
    
    if (self.nameTF.text.length >0) {
        name = self.nameTF.text;
    }
    
    if (self.phoneTF.text >0) {
        phone = self.phoneTF.text;
    }
    
    self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"createusername",sex,@"usersex",phone,@"userphone", nil];
    if ([sex isEqualToString:@"0"]) {
        self.item.subtitle = [NSString stringWithFormat:@"%@ %@ %@",name,@"男",phone];
    }else if ([sex isEqualToString:@"1"]){
        self.item.subtitle = [NSString stringWithFormat:@"%@ %@ %@",name,@"女",phone];
    }else{
        self.item.subtitle = [NSString stringWithFormat:@"%@ %@ %@",name,sex,phone];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

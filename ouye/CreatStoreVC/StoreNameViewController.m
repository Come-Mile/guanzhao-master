//
//  StoreNameViewController.m
//  ouye
//
//  Created by Sino on 16/3/24.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "StoreNameViewController.h"
#import "NavigationBarView.h"
#import "MJSettingItem.h"
#import "CurrrentAppTool.h"
#import "LWHttpTool.h"
#import <MBProgressHUD.h>

@interface StoreNameViewController ()<NavigationBarViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *storeName;
@property (weak, nonatomic)UIButton *sumBtn;
@end

@implementation StoreNameViewController
{
    MBProgressHUD *HUD;
    NavigationBarView *nav;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
     nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setSummitBtnShow];
    [nav setController:self];
    nav.delegate = self;
    self.sumBtn = nav.summitBtn;
//    nav.summitBtn.enabled = NO;
//    [MWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.storeName];
    [self addTap];
    
    self.storeName.text = self.item.subtitle;
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

- (void)summitBtnHaveClick
{
    [self.view endEditing:YES];
    self.item.subtitle = self.storeName.text;
    if (self.storeName.text.length >50) {
        [self showAlert:@"商铺名称不允许超过50个字符"];
        return;
    }
    
    self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:self.storeName.text,@"shopname", nil];
//    没有同名的商铺时：
//    {"code":0,"msg":"没有该店铺名称","id":null,"shop_num":null,"shop_name":null,"product_type":null,"address":null,"province":null,"city":null,"shop_area":null,"picurl":null}
//    存在同名的商铺时：
//    {"code":200,"msg":null,"id":"1","shop_num":"J7Ug1K","shop_name":"测试店铺1","product_type":"食品","address":"北京市海淀区","province":"北京市","city":"北京市","shop_area":"10-20平米","picurl":null}
    
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shopname"] = self.storeName.text;
    [LWHttpTool postWithURL:CHECKStroeNameURL params:parameter success:^(id json) {
        MWLog(@"主营类型：%@%@",json,parameter);
        if ([json[@"code"]isEqualToNumber:@200]) {
            [self showAlert:[NSString stringWithFormat:@"已存在同名商铺：\n商铺名称：%@\n建议您修改商铺名称！",json[@"shop_name"]]];
        }else if([json[@"code"] isEqualToNumber:@0])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
       
    }failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] HUD:HUD];
        MWLog(@"%@",error.localizedDescription);
    }]; 
}

//-(void)textDidChange
//{
//    nav.summitBtn.enabled= (self.storeName.text.length != 0);
//}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
@end

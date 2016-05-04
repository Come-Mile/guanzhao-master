//
//  WarningViewController.m
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WarningViewController.h"
#import "NavigationBarView.h"
#import "LWHttpTool.h"
#import <MBProgressHUD.h>
#import "WarningSendMessageVC.h"

@interface WarningViewController()

@property (weak, nonatomic) IBOutlet UILabel *mesLabel;
@property (weak, nonatomic) IBOutlet UIButton *senButton;

@end

@implementation WarningViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad
{
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"观照";
    [nav setController:self];
    self.senButton.layer.cornerRadius = 3.0f;
    NSString *str1=[self.phoneStr substringToIndex:3];
    NSString *str2=[self.phoneStr substringFromIndex:8];
    
    self.mesLabel.text = [NSString stringWithFormat:@"由于你在新的设备上登录，需要验证你的手机号(%@*****%@)",str1,str2];
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

- (IBAction)sendButtonClick:(id)sender {
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
  
    parameter[@"ident"] = @3;
    parameter[@"mobile"] = self.phoneStr;
    parameter[@"token"] = @"";
    [self setUpProgress];
    [LWHttpTool postWithURL:SendMes params:parameter success:^(id json) {
        [self setHUDHidden:json[@"msg"]];
      
        if ([json[@"code"] isEqualToNumber:@200]) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WarningSendMessageVC* warning = [board instantiateViewControllerWithIdentifier:@"WarningSendMessageVC"];
            warning.phoneStr = self.phoneStr;
            [self.navigationController pushViewController:warning animated:YES];
        }
        
    } failure:^(NSError *error) {
      
        [self setHUDHidden:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        
    }];
}
@end

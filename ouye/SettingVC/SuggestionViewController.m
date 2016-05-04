//
//  SuggestionViewController.m
//  ouye
//
//  Created by Sino on 16/3/29.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "SuggestionViewController.h"
#import "IWTextView.h"
#import "NavigationBarView.h"
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#define MAX_INPUT_LENGTH 500

@interface SuggestionViewController()<UITextViewDelegate,NavigationBarViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *faceBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *sugesstBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@property (weak, nonatomic) IBOutlet IWTextView *messageText;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SuggestionViewController
{
    MBProgressHUD *HUD;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    [nav setSummitBtnShow];
    nav.delegate = self;
    [nav.summitBtn setImage:[UIImage imageNamed:@"_dui"] forState:UIControlStateNormal];
    [nav.summitBtn setTitle:@"" forState:UIControlStateNormal];
    [nav setController:self];
    
    self.titleLabel.text = @"我们期待听到您的声音，把最好的体验带给您！\n\n欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的软件。";
    
    [self setUpSubViews];
}

- (void)setUpSubViews
{
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    // 1.添加textView
    self.messageText.font = [UIFont systemFontOfSize:15];
    self.messageText.frame = self.view.bounds;
    // 垂直方向上永远可以拖拽
    self.messageText.alwaysBounceVertical = YES;
    self.messageText.delegate = self;
    self.messageText.placeholder = @"请输入您的反馈意见（500字以内）";
    // 3.监听键盘的通知
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat tem = ScreenH -keyboardF.size.height - CGRectGetMinY(self.messageText.frame);
    
    if (tem>0.0) {
        return;
    }
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, tem);
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
        self.bgView.transform = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }else {
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }else {
            return YES;
        }
    }
}

- (IBAction)haveClockBtn:(UIButton *)sender {
    MWLog(@"%ld",sender.tag);
    sender.selected = YES;
    for (UIButton *btn in self.bgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]&& btn !=sender && btn.selected ) {
            btn.selected = NO;
        }
    }
    
    
}

- (void)summitBtnHaveClick
{
    [self.view endEditing:YES];
    
    
    MWLog(@"提交:%@",self.messageText.text);
    
    NSString *typeStr;
    
    for (UIButton *btn in self.bgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.selected ) {
            typeStr = btn.titleLabel.text;
        }
    }

    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSDictionary *appDic = [CurrrentAppTool getCurrentDeviceInfo];
    parameter[@"appversion"] = appDic[@"appversion"];
    parameter[@"phonemodle"] = appDic[@"comname"];
   
    parameter[@"sysversion"] = appDic[@"sysversion"];
    parameter[@"idfa"] = [MWUserDefaul objectForKey:@"idfa"];
    parameter[@"idfv"] = [MWUserDefaul objectForKey:@"idfv"];;
    parameter[@"imei"] = [CurrrentAppTool uniqueAppInstanceIdentifier];;
    parameter[@"mac"] = [MWUserDefaul objectForKey:@"mac"];;
    parameter[@"screensize"] = [MWUserDefaul objectForKey:@"screensize"];;
    parameter[@"operator"] = [MWUserDefaul objectForKey:@"operator"];
    parameter[@"comname"] = @"ios";
    parameter[@"usermobile"]= [MWUserDefaul objectForKey:user_mobile];
    parameter[@"type"] = typeStr;//问题类型
    parameter[@"createtime"] = [CurrrentAppTool getCurrentDate];
    
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"question"]= self.messageText.text;
    
    MWLog(@"%@",parameter);
    
    [self UpDetailDatawith:parameter];
}

- (void)dealloc
{
    [MWNotificationCenter removeObserver:self];
}
#pragma mark 加载数据
- (void)UpDetailDatawith:(NSDictionary *)parameter
{
     HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传.."];
    [LWHttpTool postWithURL:ADDQUESTION params:parameter success:^(id json) {
        
        MWLog(@"%@",json);
       
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        if ([json[@"code"]isEqualToNumber:@200]) {
          [self.navigationController popViewControllerAnimated:YES];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        
        
        
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}


@end

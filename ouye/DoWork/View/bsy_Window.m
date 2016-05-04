//
//  bsy_Window.m
//  Sainuo_Project
//
//  Created by 薛俊强 on 16/1/6.
//  Copyright © 2016年 薛俊强. All rights reserved.
//

#import "bsy_Window.h"

@implementation bsy_Window


#define bsy_width [UIScreen mainScreen].bounds.size.width
#define bsy_height [UIScreen mainScreen].bounds.size.height
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.windowLevel = UIWindowLevelAlert;
        
        self.bsy_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bsy_width-60, 200)];
        self.bsy_superView.backgroundColor = [UIColor whiteColor];
        self.bsy_superView.center = CGPointMake(bsy_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.bsy_superView.center = CGPointMake(bsy_width/2.0,bsy_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.bsy_superView.layer.borderWidth = 1;
        self.bsy_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bsy_superView.layer.cornerRadius = 10;
        self.bsy_superView.clipsToBounds = YES;
        [self addSubview:self.bsy_superView];
        
        [self makeKeyAndVisible];
    }
    
    return self;
}


-(void)addBsy_quitBtnMessage:(NSString *)quitmessage sureMessage:(NSString *)sureMessage shopNum:(NSString *)shopNum shopName:(NSString *)shopName shopAddress:(NSString *)shopAddress jingdu:(NSString *)jingdu weidu:(NSString *)weidu{
    self.bsy_quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bsy_quitBtn setTitle:quitmessage forState:UIControlStateNormal];
    [self.bsy_quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.bsy_quitBtn.frame = CGRectMake(0, self.bsy_superView.frame.size.height-50, self.bsy_superView.frame.size.width/2, 40);
    self.bsy_quitBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.bsy_quitBtn.layer.borderWidth = 1;
    self.bsy_quitBtn.layer.cornerRadius = 5;
    self.bsy_quitBtn.clipsToBounds = YES;
    [self.bsy_superView addSubview:self.bsy_quitBtn];
    [self.bsy_quitBtn addTarget:self action:@selector(bsy_Windowclose) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.bsy_sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bsy_sureBtn setTitle:sureMessage forState:UIControlStateNormal];
    [self.bsy_sureBtn setTitleColor:[UIColor colorWithRed:100.0/255.0 green:159.0/255.0 blue:4.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.bsy_sureBtn.frame = CGRectMake(self.bsy_superView.frame.size.width/2, self.bsy_superView.frame.size.height-50, self.bsy_superView.frame.size.width/2, 40);
    self.bsy_sureBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.bsy_sureBtn.layer.borderWidth = 1;
    self.bsy_sureBtn.layer.cornerRadius = 5;
    self.bsy_sureBtn.clipsToBounds = YES;
    [self.bsy_superView addSubview:self.bsy_sureBtn];
    
    
    self.labelShopNum=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 56, 20)];
    self.labelShopNumContent=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 20)];
    self.labelShopName=[[UILabel alloc]initWithFrame:CGRectMake(20, 34, 56, 20)];
    self.labelShopNameContent=[[UILabel alloc]initWithFrame:CGRectMake(80, 34, 200, 20)];
    self.labelShopAddress=[[UILabel alloc]initWithFrame:CGRectMake(20, 58, 56, 20)];
    self.labelShopAddressContent=[[UILabel alloc]initWithFrame:CGRectMake(80,60, 200, 44)];
    self.labelGps=[[UILabel alloc]initWithFrame:CGRectMake(20, 106, 56, 20)];
    self.labelJingdu=[[UILabel alloc]initWithFrame:CGRectMake(80, 106, 30, 20)];
    
    
    self.labelJingduContent=[[UILabel alloc]initWithFrame:CGRectMake(115, 106, 150, 20)];
    
    
    self.labelWeidu=[[UILabel alloc]initWithFrame:CGRectMake(80, 130, 30, 20)];
    self.labelweiduContent=[[UILabel alloc]initWithFrame:CGRectMake(115, 130, 150, 20)];
    
    self.labelShopNumContent.text = shopNum;
    self.labelShopNameContent.text=shopName;
    self.labelShopAddressContent.text=shopAddress;
    self.labelweiduContent.text=weidu;
    self.labelJingduContent.text=jingdu;
    
    
    self.labelShopNum.text=@"店铺编号:";
    self.labelShopName.text=@"店铺名称:";
    self.labelShopAddress.text=@"店铺地址:";
    self.labelGps.text=@"GPS坐标:";
    self.labelJingdu.text=@"经度:";
    self.labelWeidu.text=@"纬度:";
    
    self.labelShopNum.textColor = [UIColor blackColor];
    self.labelShopNumContent.textColor = [UIColor blackColor];
    self.labelShopName.textColor = [UIColor blackColor];
    self.labelShopNameContent.textColor = [UIColor blackColor];
    self.labelShopAddress.textColor = [UIColor blackColor];
    self.labelShopAddressContent.textColor = [UIColor blackColor];
    self.labelGps.textColor = [UIColor blackColor];
    self.labelJingdu.textColor = [UIColor blackColor];
    self.labelJingduContent.textColor = [UIColor blackColor];
    
    self.labelShopNum.font = [UIFont systemFontOfSize:13];
    self.labelShopNumContent.font = [UIFont systemFontOfSize:13];
    self.labelShopNameContent.font = [UIFont systemFontOfSize:13];
    self.labelShopName.font = [UIFont systemFontOfSize:13];
    self.labelShopAddressContent.font = [UIFont systemFontOfSize:13];
    self.labelShopAddress.font = [UIFont systemFontOfSize:13];
    self.labelGps.font = [UIFont systemFontOfSize:13];
    self.labelJingdu.font = [UIFont systemFontOfSize:13];
    self.labelJingduContent.font = [UIFont systemFontOfSize:13];
    self.labelWeidu.font = [UIFont systemFontOfSize:13];
    self.labelweiduContent.font = [UIFont systemFontOfSize:13];
    
    self.labelShopAddressContent.numberOfLines = 0;
    self.labelShopAddressContent.adjustsFontSizeToFitWidth=NO;
    
    self.labelShopAddressContent.textAlignment  =NSTextAlignmentLeft;
    self.labelShopAddressContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect tempR = self.labelShopAddressContent.frame;
    tempR.size = [self.labelShopAddressContent boundingRectWithSize:CGSizeMake(self.labelShopAddressContent.frame.size.width, MAXFLOAT)];
    self.labelShopAddressContent.frame = tempR;
    
    self.labelGps.frame = CGRectMake(20, CGRectGetMaxY(self.labelShopAddressContent.frame)+8, 56, 20);
    self.labelJingdu.frame =CGRectMake(80, CGRectGetMaxY(self.labelShopAddressContent.frame)+8, 30, 20);
    self.labelJingduContent.frame= CGRectMake(115, CGRectGetMaxY(self.labelShopAddressContent.frame)+8, 150, 20);
    
    
    self.labelWeidu.frame =CGRectMake(80, CGRectGetMaxY(self.labelJingdu.frame)+8, 30, 20);
    self.labelweiduContent.frame=CGRectMake(115,CGRectGetMaxY(self.labelJingdu.frame)+8, 150, 20);
    
    [self.bsy_superView addSubview:self.labelGps];
    [self.bsy_superView addSubview:self.labelJingdu];
    [self.bsy_superView addSubview:self.labelJingduContent];
    [self.bsy_superView addSubview:self.labelShopAddress];
    [self.bsy_superView addSubview:self.labelShopAddressContent];
    [self.bsy_superView addSubview:self.labelShopName];
    [self.bsy_superView addSubview:self.labelShopNameContent];
    [self.bsy_superView addSubview:self.labelShopNum];
    [self.bsy_superView addSubview:self.labelShopNumContent];
    [self.bsy_superView addSubview:self.labelWeidu];
    [self.bsy_superView addSubview:self.labelweiduContent];
  
}

- (void)bsy_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.bsy_superView.center = CGPointMake(bsy_width/2.0,bsy_height+300);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 点击消失
    [self bsy_Windowclose];
}
@end

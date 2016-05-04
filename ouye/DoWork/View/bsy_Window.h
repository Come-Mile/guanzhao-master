//
//  bsy_Window.h
//  Sainuo_Project
//
//  Created by 薛俊强 on 16/1/6.
//  Copyright © 2016年 薛俊强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bsy_Window : UIWindow
-(void)bsy_Windowclose;
@property (nonatomic ,strong)UIView *bsy_superView;
/**
 *  取消按钮
 */
@property (nonatomic ,strong)UIButton *bsy_quitBtn;
/**
 *  确定按钮
 */
@property (nonatomic ,strong)UIButton *bsy_sureBtn;
/**
 *  内容label
 */
@property (nonatomic ,strong)UILabel *bsy_messageLab;

/**
 *  提示label
 */
@property (nonatomic ,strong)UILabel *bsy_cueLab;

@property(strong,nonatomic)UILabel *labelShopNum;
@property(strong,nonatomic)UILabel *labelShopNumContent;
@property(strong,nonatomic)UILabel *labelShopName;
@property(strong,nonatomic)UILabel *labelShopNameContent;
@property(strong,nonatomic)UILabel *labelShopAddress;
@property(strong,nonatomic)UILabel *labelShopAddressContent;
@property(strong,nonatomic)UILabel *labelGps;
@property(strong,nonatomic)UILabel *labelJingdu;
@property(strong,nonatomic)UILabel *labelJingduContent;
@property(strong,nonatomic)UILabel *labelWeidu;
@property(strong,nonatomic)UILabel *labelweiduContent;

-(void)addBsy_quitBtnMessage:(NSString *)quitmessage sureMessage:(NSString *)sureMessage shopNum:(NSString *)shopNum shopName:(NSString *)shopName shopAddress:(NSString *)shopAddress jingdu:(NSString *)jingdu weidu:(NSString *)weidu;

@end

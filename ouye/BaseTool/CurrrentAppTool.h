//
//  CurrrentAppTool.h
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface CurrrentAppTool : NSObject
+ (NSDictionary *)getCurrentDeviceInfo;
+ (NSString *)getMacAddress;
+(NSString*)getUuid;
+ (NSString*)uniqueAppInstanceIdentifier;

+ (NSString *)getCurrentDate;

+(void)showMessage:(NSString *)message;
+ (MBProgressHUD *)showHUDMessageInView:(UIView *)view ;
+ (void)HUDShouldHIddenWithMessage:(NSString *)message HUD:(MBProgressHUD *)HUD;

+ (MBProgressHUD *)showHUDMessageInView:(UIView *)view withTitle:(NSString *)title;

@end

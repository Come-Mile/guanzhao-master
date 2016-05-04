//
//  CurrrentAppTool.m
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CurrrentAppTool.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import "sys/utsname.h"
#import <SFHFKeychainUtils.h>
#import "UILabel+StringFrame.h"


@implementation CurrrentAppTool


+ (NSDictionary *)getCurrentDeviceInfo
{
    //app版本号
    NSString *strVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //运营商名称
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    
    //手机型号
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    //手机系统版本
    NSString *phoneVersio=  [[UIDevice currentDevice] systemVersion];
    
    
    //手机分辨率
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    NSString *str1=[NSString stringWithFormat:@"%.2f",width];
    NSString *str2=[NSString stringWithFormat:@"%.2f",height];
    NSString *str3=[NSString stringWithFormat:@"%@*%@",str1,str2];
    NSLog(@"分辨率为%@",str3);
    //手机mac地址
    NSString *strMac=[self getMacAddress];
    
    //手机idfa
    NSString *stridfa= [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //手机idfv
    NSString *stridfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //手机udid
    NSString *strudid=[self uniqueAppInstanceIdentifier];

    [MWUserDefaul setObject:strMac forKey:@"mac"];
    [MWUserDefaul setObject:stridfa forKey:@"idfa"];
    [MWUserDefaul setObject:stridfv forKey:@"idfv"];
    [MWUserDefaul setObject:strudid forKey:@"udid"];
    [MWUserDefaul setObject:str3 forKey:@"screensize"];
    [MWUserDefaul setObject:currentCountry forKey:@"operator"];
    [MWUserDefaul synchronize];
    
    
    //注册时间
    NSDate *date=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strCurrentDate=[dateformatter stringFromDate:date];
    
    //应用名称
    NSBundle*bundle =[NSBundle mainBundle];
    NSDictionary*info =[bundle infoDictionary];
    NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
    
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:prodName,@"name",strCurrentDate,@"regtime",strVersion,@"appversion",[self deviceVersion],@"comname",platform,@"phonemodle",phoneVersio,@"sysversion",nil];
    return dic;
}

#pragma mark  获取手机MAC地址
+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+(NSString*)getUuid{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    static NSString* UUID_KEY = @"MPUUID";
    
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    
    if (app_uuid == nil) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        
        [userDefaults synchronize];
        
        CFRelease(uuidString);
        
        CFRelease(uuidRef);
        
    }
    NSLog(@"app_uuid====%@",app_uuid);
    return app_uuid;
    
    
}

+ (NSString*)uniqueAppInstanceIdentifier
{
    NSString *struuid=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"手机唯一标识符---%@",struuid);
    
    return struuid;
    
}

+ (NSString *)getCurrentDate
{
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *localtimezone = [NSTimeZone localTimeZone];
    [dateformatter setTimeZone:localtimezone];
    NSString * locationString=[dateformatter stringFromDate:nowDate];
    return locationString;

}
+(NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    //    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}

+(void)showMessage:(NSString *)message{
    
    if ([message isKindOfClass:[NSNull class]]) {
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    //    CGSize LabelSize = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:15.0]}];
    
//    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
  
  
    
    label.numberOfLines = 0;
    
    label.text = message;
      CGSize labelSize = [label boundingRectWithSize:CGSizeMake(290, MAXFLOAT)];
    label.frame = CGRectMake(10, 10, labelSize.width, ceilf(labelSize.height/25.0)*25.0);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    //    label.font = [UIFont boldSystemFontOfSize:13];
    [showview addSubview:label];
    showview.frame = CGRectMake((ScreenW - CGRectGetWidth(label.frame) - 20)/2,  ScreenH*0.7, CGRectGetWidth(label.frame)+20+6, ceilf(labelSize.height/25.0)*25.0+20);
    [UIView animateWithDuration:3 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
}

+ (MBProgressHUD *)showHUDMessageInView:(UIView *)view
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [view addSubview:HUD];
    [HUD show:YES];
    return HUD;
}

+ (MBProgressHUD *)showHUDMessageInView:(UIView *)view withTitle:(NSString *)title
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    HUD.labelText = title;
    [view addSubview:HUD];
    [HUD show:YES];
    return HUD;
}

+(void)HUDShouldHIddenWithMessage:(NSString *)message HUD:(MBProgressHUD *)HUD
{
    if (message !=nil) {
        [HUD hide:YES afterDelay:2];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabelFont = [UIFont systemFontOfSize:15.0];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@",message];
    }else{
        [HUD hide:YES];
    }
    [HUD removeFromSuperview];
}
@end

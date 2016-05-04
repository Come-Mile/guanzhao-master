//
//  AppDelegate.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "AppDelegate.h"
#import "MyStoreVC/MyStoreViewController.h"
#import "LoginAndOtherVC/LoginViewController.h"
#import "CreatViewController.h"
#import "JPUSHService.h"
#import "LWHttpTool.h"
#import <AFNetworking.h>
#import <IQKeyboardManager.h>
#import "SuggestionViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "DBManager2.h"
#import "CurrrentAppTool.h"

#import "MessageVC/MessageViewController.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <Crashlytics/Crashlytics.h>

#import "BBLaunchAdMonitor.h"

@interface AppDelegate ()

//@property (nonatomic ,weak)UIAlertView *alertMes;
@end

@implementation AppDelegate
{
    NSString *updataURL;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:mapAppKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // 激光推送设置iOS8.0 需要使用新的API接口
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:PushAppKey channel:@"Publish channel" apsForProduction:YES];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    /**
     *  检测更新
     */
    [self check];
    
    NSString * string = [[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    if(string.length !=0){
        [self showMyStoreVC];
    }else{
        [self showLoginVC];
    }
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:[SuggestionViewController class]];
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:[LoginViewController class]];
 
    [Fabric with:@[[Crashlytics class], [Digits class]]];
    [[Fabric sharedSDK] setDebug: YES];
    [Fabric with:@[CrashlyticsKit]];
    /**
     *  加载动态启动图（广告）
     *  @param showAdDetail: 广告详情，（字典）
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
    // http://mg.soupingguo.com/bizhi/big/10/258/043/10258043.jpg
    NSString *path = @"http://taylor.fausak.me/static/images/apple-touch-startup-image-320x460.png";
//    [BBLaunchAdMonitor showAdAtPath:path
//                             onView:self.window.rootViewController.view
//                       timeInterval:5.0f
//                   detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"}];
    
    [BBLaunchAdMonitor showAdAtPath2:path
                              onView:self.window.rootViewController.view
                        timeInterval:5.0f
                    detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"} placeHoderImage:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
}
- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
}
/**
 *  收到自定义消息
 *
 *  @param notification 消息内容详情
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *dicParmeter = [self parseJSONStringToNSDictionary:content];
//    NSLog(@"推送收的信息--- %@",dicParmeter);
    
    MWLog(@"消息：%@ ,%@",userInfo,dicParmeter);
    if (dicParmeter !=nil && [dicParmeter isKindOfClass:[NSDictionary class]]) {
        NSString *code = [dicParmeter valueForKey:@"code"];
       NSString *state = dicParmeter[@"msg"][@"state"];
        //声音
        SystemSoundID soundID = 1012;
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        NSString *mes;
        if([state isEqualToString:@"1"]){
            mes = @"任务执行完成";
        }else{
            mes = @"资料回收完成";
        }
//        if (self.alertMes !=nil) {
//            [self.alertMes removeFromSuperview];
//        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您有新消息" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看",nil];
        alert.tag = 11;
//        self.alertMes = alert;
        [alert show];
        
        NSString *userId = [MWUserDefaul objectForKey:user_mobile];
        if (userId !=nil) {
            [[DBManager2 shared]inserDataWIthUid:userId msg:dicParmeter[@"msg"] state:state code:code dateTime:[CurrrentAppTool getCurrentDate] check:@"0"];
        }
        MWLog(@"查询数据库：%@",[[DBManager2 shared]selectAllDataWithUid:userId]);
    }
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    
    NSString *jsonStr = [JSONString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err.localizedDescription);
        return nil;
    }
    return dic;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
//     [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}
- (void)applicationWillTerminate:(UIApplication *)application {
}

//通知相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    if (application.applicationState == UIApplicationStateBackground)
    {
    }
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [[aps valueForKey:@"alert"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 应用正处在前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive)
    {
        //声音
        SystemSoundID soundID = 1012;
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"registNot" object:self];
        [self showNewStatusCount:content];
    }
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    MWLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,(int)badge,sound,customizeField1);

     [JPUSHService handleRemoteNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
   
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 *  显示APNS 通知（自定义）
 *
 *  @param mess 内容
 */
- (void)showNewStatusCount:(NSString *)mess
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
//    [self.window insertSubview:btn belowSubview:self.window.rootViewController.navigationController.navigationBar];
    [self.window addSubview:btn];
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
//    [btn setBackgroundImage:[UIImage resizedImageWithName:@"_juxing"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[[UIColor blackColor]  colorWithAlphaComponent:0.6]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    if (mess.length !=0) {
        NSString *title = [NSString stringWithFormat:@"有新通知：%@", mess];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"有新通知:" forState:UIControlStateNormal];
    }
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 45;
    CGFloat btnY = 20 - btnH;
    CGFloat btnX = 10;
    CGFloat btnW = ScreenW - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0f;
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:0.7 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, btnH + 2);
        
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)showLoginVC
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * VC = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
    self.window.rootViewController = nav;
}

- (void)showMyStoreVC
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyStoreViewController * myStoreVC = [board instantiateViewControllerWithIdentifier:@"MyStoreViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myStoreVC];
    self.window.rootViewController = nav;
}

- (void)ShowCreatStoreVC
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreatViewController * VC = [board instantiateViewControllerWithIdentifier:@"CreatViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
    self.window.rootViewController = nav;
}

- (void)check
{
    //检测版本号是否相同
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 发送登录请求
    [manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"resObjc:%@",responseObject);
        if (responseObject[@"ver"]){
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            NSString * newViersion = responseObject[@"ver"];
            if (![appVersion isEqual:newViersion]&&newViersion.length!=0) {
                updataURL = responseObject[@"app_path"];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"检测到新版本%@，请更新后使用",responseObject[@"ver"]] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure:%@",error.localizedDescription);
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==100)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updataURL]];
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
        
    }else if(alertView.tag ==11){
        if (buttonIndex ==1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"registMessage" object:self];
        }
        
    }
}
@end

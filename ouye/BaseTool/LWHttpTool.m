//
//  LWHttpTool.m
//  lianhelihua
//
//  Created by Sino on 16/1/13.
//  Copyright (c) 2016年 Sino. All rights reserved.
//

#import "LWHttpTool.h"
#import "AFNetworking.h"
#import <MBProgressHUD.h>

@implementation LWHttpTool

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        NSLog(@"%ld", status);
        if (status == 2) {
            
//             [self promptMessageview:@"连接WIFI"];
        }
        else if (status == 1) {
//             [self promptMessageview:@"连接3G"];
            
        }
        else if (status == 0){
            
            [self promptMessageview:@"无网络连接"];
        }
    }];
}




+(BOOL)promptMessageview:(NSString *)text{
    UIWindow *window=[[UIApplication sharedApplication].delegate window] ;
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    [window addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    return YES;
}



+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in formDataArray) {
        
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//上传文件
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray2:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileURL:[NSURL URLWithString:formData.dataStr] name:formData.name fileName:formData.filename mimeType:formData.mimeType error:nil];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}
+ (void)getTextUpWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation IWFormData


+ (instancetype)itemWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)filename   mimeType:(NSString *)mimeType

{
    IWFormData *item = [[self alloc] init];
    item.data = data;
    item.name = name;
    item.filename = filename;
    item.mimeType = mimeType;
    return item;
}

+ (instancetype)itemWithDataStr:(NSString *)data name:(NSString *)name fileName:(NSString *)filename   mimeType:(NSString *)mimeType
{
    IWFormData *item = [[self alloc] init];
    item.dataStr = data;
    item.name = name;
   
    item.mimeType = mimeType;
    return item;
}
@end
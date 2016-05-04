//
//  HttpHeader.h
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#ifndef HttpHeader_h
#define HttpHeader_h


#endif /* HttpHeader_h */

#define mapAppKey @"5ink8fQO6dzkWoKAE3EizX5brCmyp3gH"

#define PushAppKey @"96c612b351037e792fd4b64b"

#define user_mobile @"user_mobile"
#define PassWord @"password"
#define UserName @"user_name"
#define Apptoken @"key"
#define tureName @"true_name"
#define SHOPID @"shop_id"

#define ServiceName @"ouyeAPPKeyChain"


//照片域名(需要用来拼接照片地址)
#define MWImageHeadFormat(str) ([NSString stringWithFormat:@"http://182.92.73.31:8061/shop/%@",str])
//服务器域名
#define MWStringFormat(str) ([NSString stringWithFormat:@"http://182.92.73.31:8061/shop/mobile/%@",str])
#pragma mark 各接口地址
//一、注册接口
#define Regist MWStringFormat(@"login/reg")

//二、登录接口
#define LIndex  MWStringFormat(@"login")

//三、四、六、发送短信验证码接口
#define SendMes MWStringFormat(@"login/sendsms")
//五、找回密码接口
#define findPass MWStringFormat(@"login/findpwd")

//七、短信验证码验证登录接口 login/check
#define CheckCode MWStringFormat(@"login/check")

//八、【商铺】主营类型接口 shop/producttype
#define PTypeURL MWStringFormat(@"shop/producttype")

//九、【商铺】商铺面积接口
#define SHOPAREAURL MWStringFormat(@"shop/shoparea")
//十、【商铺】检查商铺名称是否相同接口
#define CHECKStroeNameURL MWStringFormat(@"shop/checkshopname")
//十一、【商铺】创建商铺接口
#define CREATShopURL MWStringFormat(@"shop/createshop")

//【商铺】根据id查询商铺接口
#define chechaveStoreURL MWStringFormat(@"shop/selectshop")

//十三、【商铺】修改商铺信息
#define UPDateShopURL MWStringFormat(@"shop/updateshop")

//十四、【任务】任务包列表 接口地址
#define TASKINDEX MWStringFormat(@"taskindex")

//十五、【任务】任务包详情接口
#define TASKDetailURL MWStringFormat(@"taskpackage")

//二十八、【设置】关于我们接口
#define ABOUT MWStringFormat(@"about")

//二十九、【设置】版本更新接口
#define UPDATEVER MWStringFormat(@"version")

//三十、【设置】问题反馈接口
#define ADDQUESTION MWStringFormat(@"addquestion")

//十六、【任务】任务列表接口
#define TASKLIST MWStringFormat(@"tasklist")
//十七、【任务】进入拍照任务页面接口
#define PHOTO MWStringFormat(@"photo")

//十八、【任务】拍照任务有拍照点接口
#define TAKEPHOTO MWStringFormat(@"takephoto")

//十九、【任务】拍照任务没有拍照点接口
#define CLOSETASK MWStringFormat(@"closetask")

//二十、【任务】记录任务接口
#define RECORD MWStringFormat(@"record")
//二十一、【任务】视频任务接口 //二十二、【任务】定位任务接口 接口地址 selectprojectrw
#define VIDEOINDEX MWStringFormat(@"selectprojectrw")



//二十三、【任务】上传照片接口
#define PHOTOUP MWStringFormat(@"taskphotoup")

//二十五、【任务】视频任务上传接口
#define VIDEOUP MWStringFormat(@"video/videoup")

//二十六、【任务】记录任务上传接口
#define RECORDUP MWStringFormat(@"recordup")

//二十四、【任务】上传定位截图接口
#define LOCATIONTASKUP MWStringFormat(@"addlocationtask")

//二十七、【任务】查看详情接口
#define TASKDETAIL MWStringFormat(@"taskdetail")

//二十八、【设置】关于我们接口



//三十一、【消息中心】公告列表接口接口
#define MESSAGELIST MWStringFormat(@"message/announcementlist")

//三十二【消息中心】公告详情接口
#define ANNOUNCEMENT MWStringFormat(@"message/announcement")




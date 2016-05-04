//
//  MapWorkModel.h
//  ouye
//
//  Created by Sino on 16/4/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface MapWorkModel : CommentModel
//{"code":200,"msg":"查询成功","taskid":"1","taskname":"经销商商场负责人","note":"定位任务","taskpackid":"1","storenum":"SJ9998","storename":"四海通达","province":"河北","city":"保定","address":"河北安国","storeid":6}

@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,copy)NSString *city;
@property (nonatomic ,copy)NSString *province;
@property (nonatomic ,copy)NSString *storeid;
@property (nonatomic ,copy)NSString *storenum;
@property (nonatomic ,copy)NSString *taskname;

@property (nonatomic ,copy)NSString *storename;
@property (nonatomic ,copy)NSString *taskid;
@property (nonatomic ,copy)NSString *taskpackid;
@property (nonatomic ,copy)NSString *url;
@property (nonatomic ,copy)NSString *note;


/**
 *  保存数据
 */
/**
 *  纬度
 */
@property (nonatomic ,copy)NSString *strLat;
/**
 *  经度
 */
@property (nonatomic ,copy)NSString *strLng;
@property (nonatomic ,copy)NSString *strAdress;
@property (nonatomic ,copy)NSString *strProvince;
@end

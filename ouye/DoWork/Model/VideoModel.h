//
//  VideoModel.h
//  ouye
//
//  Created by Sino on 16/4/15.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface VideoModel : CommentModel

//正确结果	{"code":200,"msg":"查询成功","datas":{"taskName":"经销商商场负责人","taskid":"1","taskpackid":"1","url":"122qq.mp","note":"视频任务说明"}}


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


@property (nonatomic ,copy)NSString *textStr;// 备注 单备注的时候用到

@property (nonatomic ,strong)NSMutableArray *videoArray;// 视频数组


@end

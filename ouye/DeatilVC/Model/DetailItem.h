//
//  DetailItem.h
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface DetailItem : CommentModel


//{"code":0,"msg":null,"p_id":"92","p_name":"328测试任务包","money":"20.0","end_time":"2016-04-08","desc":"<img src=\"http://182.92.73.31:8899/images/20160328152314_385.png\" alt=\"\" />1111111111111","task_type":"拍照任务"}
//任务包详情接口返回的参数增加了cycle，当cycle为1时为任务包循环周期为每天的
@property (nonatomic ,copy)NSString *p_id;
@property (nonatomic ,copy)NSString *cycle;
@property (nonatomic ,copy)NSString *p_name;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *end_time;
@property (nonatomic ,copy)NSString *desc;
@property (nonatomic , copy)NSString *task_type;
@property (nonatomic , copy)NSString *publish_id;

@end

//
//  StoreListItem.h
//  ouye
//
//  Created by Sino on 16/4/5.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
#import "CommentModel.h"

@interface StoreListItem :CommentModel

//{"code":200,"msg":"查询成功","datas":[{"p_id":"92","p_name":"328测试任务包","task_id":null,"task_name":null,"task_type":null,"is_package":"1","is_close":null,"money":"20.0","child":null},{"p_id":"91","p_name":"328测试任务包","task_id":null,"task_name":null,"task_type":null,"is_package":"1","is_close":null,"money":"20.0","child":null}]}


@property (nonatomic , copy)NSString *p_id;
@property (nonatomic , copy)NSString *p_name;
@property (nonatomic , copy)NSString *task_id;
@property (nonatomic , copy)NSString *task_name;
//1拍照2视频3记录4定位
@property (nonatomic , copy)NSString *task_type;
@property (nonatomic , copy)NSString *is_package;
@property (nonatomic , copy)NSString *is_close;
@property (nonatomic , copy)NSString *money;
@property (nonatomic , strong)NSMutableArray *child;



@end

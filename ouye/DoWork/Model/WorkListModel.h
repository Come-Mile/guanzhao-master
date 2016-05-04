//
//  WorkListModel.h
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface WorkListModel : CommentModel

//{"code":200,"msg":"查询成功","datas":[{"p_id":"92","p_name":null,"task_id":"391","task_name":"售后区域","task_type":"1","is_package":"0","is_close":null,"money":null,"child":null},{"p_id":"92","p_name":null,"task_id":"390","task_name":"08沃蓝达展车资料","task_type":"1","is_package":"0","is_close":null,"money":null,"child":null},{"p_id":"92","p_name":null,"task_id":"389","task_name":"07沃蓝达参数牌","task_type":"1","is_package":"0","is_close":null,"money":null,"child":null}]}


@property (nonatomic ,copy)NSString *p_id;
@property (nonatomic ,copy)NSString *p_name;
@property (nonatomic ,copy)NSString *task_name;
@property(nonatomic ,copy)NSString *task_id;

//1拍照2视频3记录4定位
@property (nonatomic ,copy)NSString *task_type;

@property (nonatomic ,copy)NSString *is_package;
@property (nonatomic ,copy)NSString *is_close;
@property (nonatomic ,copy)NSString *money;

@property (nonatomic ,strong)NSMutableArray *child;

//标记任务包列表是否被打开
@property (nonatomic ,assign)BOOL isOpen;

//标记任务夹得switch按钮的状态
@property (nonatomic ,assign)int isClose;

//被选中的 section
@property (nonatomic ,strong)NSIndexPath* indexPath;

/**
 *  任务详情返回的 任务包发布id
 */
@property (nonatomic , copy)NSString *publish_id;

@end

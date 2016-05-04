//
//  PickerModel.h
//  ouye
//
//  Created by Sino on 16/4/13.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface PickerModel : CommentModel

@property (nonatomic ,copy)NSString *title;//任务标题

@property (nonatomic ,copy)NSString *questionId;
@property (nonatomic ,copy)NSString *selectStr;//问题答案
@property (nonatomic ,copy)NSString *textStr;// 备注 //单备注的时候用到

@property (nonatomic ,strong)NSMutableArray *imageArray;// 图片数组/ 视频数组
@property (nonatomic ,strong)NSMutableArray *textArray;//备注数组 //多备注的时候用到

@property (nonatomic ,strong)NSMutableArray *questionArray;


@end

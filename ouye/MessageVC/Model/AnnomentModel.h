//
//  AnnomentModel.h
//  ouye
//
//  Created by Sino on 16/4/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface AnnomentModel : CommentModel

//brief = "<null>";
//code = 0;
//content = "<null>";
//date = "2016-04-11";
//filelist = "<null>";
//id = 32;
//img = "<null>";
//msg = "<null>";
//title = "\U89c9\U5f97\U4f60\U731c\U4f60\U731c";
//type = "<null>";

@property (nonatomic ,copy)NSString *brief;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *date;
@property (nonatomic ,strong)NSArray *filelist;
@property (nonatomic ,copy)NSString *myId;
@property (nonatomic ,copy)NSString *img;
@property (nonatomic ,copy)NSString *msg;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *type;
/**
 *  辅助字段标记是否显示小红点
 */
@property (nonatomic ,copy)NSString *check;
@property (nonatomic ,copy)NSString *tagStr;

@end

//
//  VersionModel.h
//  ouye
//
//  Created by Sino on 16/4/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"

@interface VersionModel : CommentModel

//code = 200;
//datas =     {
//    "img_url" = "/ouye/file/task/2D8CD55676EC385EFE6B4E94BF9F8C88.jpg";
//    "verison_url" = "http://app.pgyer.com/10ad6334e229bca83a05e543b449a9b7.apk?v=1.1&sign=4e1de8ade71fccf471a797a6feb0554e&t=56aaccb9&attname=app-release%281%29.apk";
//    "version_desc" = "\U7248\U672c\U66f4\U65b0\U8bf4\U660e\Uff1a123";
//    "version_num" = "v1.0.4.9";
//};
//msg = "<null>";

@property (nonatomic ,copy)NSString *img_url;
@property (nonatomic ,copy)NSString *verison_url;
@property (nonatomic ,copy)NSString *version_desc;
@property (nonatomic ,copy)NSString *version_num;

@end

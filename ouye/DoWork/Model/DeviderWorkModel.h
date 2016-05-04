//
//  DeviderWorkModel.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviderWorkModel : NSObject

//code = 200;
//desc = "\U62cd\U7167\U8bf4\U660e";
//isphoto = 1;
//msg = "\U67e5\U8be2\U6210\U529f";
//name = "\U4efb\U52a1\U540d\U79f0\U62cd\U7167";
//num = 3;
//"photo_type" = 2;
//pics =     (
//            "/file/task/107E0B93484F3BF6D900223E5714122E.jpg"
//            );
//"sta_location" = 1;
//wuxiao = 1;

/**
 *  图片
 */
@property (nonatomic, strong) NSArray *pics;

@property (nonatomic ,strong)NSMutableArray *pictures;

@property (nonatomic ,copy)NSString *desc;
@property (nonatomic ,copy)NSString *isphoto;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *num;
@property (nonatomic ,copy)NSString *photo_type;
@property (nonatomic ,copy)NSString *sta_location;
@property (nonatomic ,copy)NSString *wuxiao;

/**
 *  标记是否有现场
 */
@property (nonatomic ,assign)BOOL haveOn;

@end

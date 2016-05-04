//
//  Comment.h
//
//  Created by Sino on 16/3/9.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

//自定义Log
#ifdef DEBUG
//#define IWLog(...) NSLog(__VA_ARGS__)
#define MWLog(fmt, ...) NSLog((@"%s [Line %d]\n\n-----------Log-------------\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MWLog(fmt, ...)
#endif


// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 3.当前屏幕size
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 4.5inch 比例适配
#define floatScreenW ([UIScreen mainScreen].bounds.size.width/320.0)
#define floatScreenH ([UIScreen mainScreen].bounds.size.height/480.0)

// 5.获得RGB颜色
#define MWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MWColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/** 时间的字体 */
#define MWStatusTimeFont [UIFont systemFontOfSize:12]
/** 来源的字体 */
#define MWStatusSourceFont MWStatusTimeFont


// 6.常用的对象
#define MWNotificationCenter [NSNotificationCenter defaultCenter]

#define MWUserDefaul [NSUserDefaults standardUserDefaults]

#define MWSTRFormat(des,str) ([NSString stringWithFormat:@"%@%@",des,str])

// 6.图片内部相册
#define IWPhotoW 80*floatScreenW
#define IWPhotoH 80*floatScreenW
#define IWPhotoMargin 20

// 填空题的textView的高度
#define textViewH 100





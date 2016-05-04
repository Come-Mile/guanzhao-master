//
//  UIImage+ImagURL.h
//  ouye
//
//  Created by Sino on 16/3/30.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImagURL)

/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

+ (UIImage *)imageWithImagURL:(NSString *)url;
/**
 *  截屏
 */
+(UIImage *)screenShot:(UIView *)view;
+(instancetype)captureWithView:(UIView *)view;
@end

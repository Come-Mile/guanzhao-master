//
//  UIImage+ImagURL.m
//  ouye
//
//  Created by Sino on 16/3/30.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "UIImage+ImagURL.h"
#import <UIImageView+WebCache.h>

@implementation UIImage (ImagURL)

+ (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
+ (UIImage *)imageWithImagURL:(NSString *)url
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage *imag = [UIImage imageWithData:imageData];
    
    return imag;
}

#pragma mark---  截屏代码
+ (UIImage *)screenShot:(UIView *)view{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0);
    //设置截屏大小
    
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    
    CGRect rect = CGRectMake(0, 0, width,height);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    //以下为图片保存代码
    
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pictureName= @"screenShow.png";
    
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    
    CGImageRelease(imageRefRect);
    
    
    
    //从手机本地加载图片
    UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
    
    return bgImage2;
}

+(instancetype)captureWithView:(UIView *)view
{
    /**
     *  开启上下文
     */
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    /**
     *  将控制器的view的layer渲染到上下文
     */
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    /**
     *  取出图片
     */
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
     *  结束上下文
     */
    UIGraphicsEndImageContext();
    
    
    return newImage;
    
}

@end

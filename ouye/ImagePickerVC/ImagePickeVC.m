//
//  ImagePickeVC.m
//  ouye
//
//  Created by Sino on 16/3/25.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "ImagePickeVC.h"
#import "NavigationBarView.h"
#import "SZAddImage.h"
#import "MWPhotoBrower.h"
#import "UIImage+ImagURL.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ImagePickeVC()<NavigationBarViewDelegate>

@property (weak, nonatomic)SZAddImage *addView;
@end

@implementation ImagePickeVC

- (NSMutableArray *)images
{
    if (_images ==nil) {
        _images = [NSMutableArray array];
        
    }
    return _images;
}

- (void)viewDidLoad
{
    NavigationBarView *nav = [[NavigationBarView alloc]init];
   
    [nav setController:self];
    [nav setSummitBtnChange:@"预览"];
    [nav setSummitBtnShow];
    nav.delegate = self;
    
    nav.titleLabel.text  = self.title;
    [self setUpADDImagView];
}

- (void)setUpADDImagView
{
    SZAddImage *adImagV = [[SZAddImage alloc]initWithFrame:CGRectMake(10, 64, ScreenW -20,100*3 +20)];
    self.addView = adImagV;
    self.addView.userInteractionEnabled = YES;
    [self.view addSubview:self.addView];
    
//    for (id obj in self.images) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            UIImage *image = [UIImage imageWithImagURL:obj];
//            [self.images replaceObjectAtIndex:[self.images indexOfObject:obj] withObject:image];
//        }
//    }
    
    self.addView.images = self.images;

}

- (void)summitBtnHaveClick
{
    if(self.images.count ==0)return;
    
    MWLog(@"********");
    MWPhotoBrower *borwer = [[MWPhotoBrower alloc]init];
    borwer.images = self.images;
    [self.navigationController presentViewController:borwer animated:YES completion:nil];
    
 
//    [self setUpPhotoBro];
}

- (void)setUpPhotoBro
{
    int count = (int)self.images.count;
    
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        NSString *photoUrl = self.images[i];
        mjphoto.url = [NSURL URLWithString:photoUrl]; // 图片路径
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    browser.showSaveBtn = 0;
    [browser show];
}

- (void)backBtnHaveCLick
{
    if ([self.delegate respondsToSelector:@selector(popVCWithImages:)]) {
        [self.delegate performSelector:@selector(popVCWithImages:) withObject:self.addView.images];
    }
    
    MWLog(@"%@",self.addView.images);
}

@end

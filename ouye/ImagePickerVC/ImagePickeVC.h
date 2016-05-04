//
//  ImagePickeVC.h
//  ouye
//
//  Created by Sino on 16/3/25.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImagePickeVCDelegate <NSObject>

- (void)popVCWithImages:(NSMutableArray *)images;

@end

@interface ImagePickeVC : UIViewController

@property (nonatomic,weak)id<ImagePickeVCDelegate>delegate;



@property (nonatomic , strong)NSMutableArray *images;
@end



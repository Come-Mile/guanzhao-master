//
//  MapViewController.h
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MJSettingItem;

typedef void(^retutnTextBlock)(NSString *text);
@interface MapViewController : UIViewController

@property (nonatomic , strong)MJSettingItem *item;

@property (nonatomic , copy)retutnTextBlock  returnTextBlock;

@end

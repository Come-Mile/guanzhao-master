//
//  storeItem.h
//  ouye
//
//  Created by Sino on 16/3/30.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface storeItem : NSObject

@property (nonatomic ,copy)NSString *shop_num;

@property (nonatomic ,copy)NSString *shop_name;

@property (nonatomic ,copy)NSString *product_type;
@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,copy)NSString *province;
@property (nonatomic ,copy)NSString *city;
@property (nonatomic ,copy)NSString *shop_area;
@property (nonatomic ,strong)NSMutableArray *picurls;

@property (nonatomic , copy)NSString *shopowner;
@property (nonatomic , copy)NSString *usersex;
@property (nonatomic , copy)NSString *userphone;
@end

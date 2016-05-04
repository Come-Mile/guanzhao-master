//
//  AppDelegate.h
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

- (void)showLoginVC;
- (void)showMyStoreVC;
- (void)ShowCreatStoreVC;
@end


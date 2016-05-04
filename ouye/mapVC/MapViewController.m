//
//  MapViewController.m
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "NavigationBarView.h"
#import "MJSettingItem.h"
#import "loadingView.h"

@interface MapViewController ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate ,UITextFieldDelegate,NavigationBarViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *CityBtn;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak ,nonatomic)UIView *bgView;

/**
 *  定位等待
 */
@property (nonatomic , weak)loadingView *loadingView;

@end

@implementation MapViewController
{
    BMKGeoCodeSearch *_search;
    BMKLocationService *_locService;
    NSString *cityStr;
    
    BMKReverseGeoCodeResult *resultData;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.zoomLevel = 18;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    nav.delegate = self;
    [nav setSummitBtnShow];
    [nav setController:self];
    
    [self isOpenGPS];
    self.addressView.layer.masksToBounds = YES;
    self.addressView.layer.cornerRadius = 5.0f;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 100.f;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    /**
     加载loading
     */
    loadingView *load = [[loadingView alloc]init];
    [self.view addSubview:load];
    load.alertTitle = @"系统正在定位您的位置，请稍等...";
    self.loadingView = load;
    
    
    //启动LocationService
    [_locService startUserLocationService];
    
    //初始化检索对象
    _search =[[BMKGeoCodeSearch alloc]init];
    _search.delegate = self;
    
    [self setUpAddressViewUnder:nav];
}
/**
 *  监听键盘的通知
 */
- (void)setUpAddressViewUnder:(NavigationBarView *)nav
{
    // 3.监听键盘的通知
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [MWNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.addressTextField.delegate = self;
    self.addressTextField.adjustsFontSizeToFitWidth = YES;
    self.CityBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.CityBtn setTitle:@"正在检测" forState:UIControlStateNormal];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addressTextField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addressTextField resignFirstResponder];
}
/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        self.addressView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height +(ScreenH - CGRectGetMaxY(self.addressView.frame) -5));
        [self setUpBgView];
    }];
}
- (void)setUpBgView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenW, ScreenH)];
    
    bgView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    
    self.bgView = bgView;
    [self.view insertSubview:bgView belowSubview:self.addressView];
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.addressView.transform = CGAffineTransformIdentity;
        [self.bgView removeFromSuperview];
    }];
}
//正向检索(当前未用到)
- (void)setUp1Search
{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"海淀区上地10街10号";
    BOOL flag = [_search geoCode:geoCodeSearchOption];
    geoCodeSearchOption = nil;
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)setUpReverseStart:(CLLocationCoordinate2D)coordinate
{
//    发起反向地理编码检索 (CLLocationCoordinate2D){39.915, 116.404}
    CLLocationCoordinate2D pt = coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
    reverseGeoCodeSearchOption =nil;
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
        [self.loadingView removeFromSuperview];
        [self showAlert:@"位置检索失败！请稍后再试..."];
        NSLog(@"反geo检索发送失败");
    }
    
    [_locService stopUserLocationService];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
//实现Deleage处理回调结果
//接收正向编码结果

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    [self.loadingView removeFromSuperview];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
    
    [self.loadingView removeFromSuperview];
  if (error == BMK_SEARCH_NO_ERROR) {
  
//      在此处理正常结果
      NSLog(@"地址：%@,%@",result.address,result.addressDetail.city);
//      self.CityBtn.titleLabel.text =[NSString stringWithFormat:@"%@,%@", result.addressDetail.province,result.addressDetail.city];
      [self.CityBtn setTitle:[NSString stringWithFormat:@"%@,%@", result.addressDetail.province,result.addressDetail.city] forState:UIControlStateNormal];
      
      resultData = result;
//      cityStr = [NSString stringWithFormat:@"%@",result.addressDetail.city];
      self.addressTextField.text = result.address;
  }
  else {
      NSLog(@"抱歉，未找到结果");
      [self showAlert:@"抱歉，未找到结果，请稍后再试！"];
      [self.CityBtn setTitle:@"未检测到结果" forState:UIControlStateNormal];
  }
}
#pragma mark 定位
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    [self setUpReverseStart:userLocation.location.coordinate];
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self.loadingView removeFromSuperview];
    [self showAlert:@"抱歉，定位失败，请稍后再试！"];
    [self.CityBtn setTitle:@"定位失败" forState:UIControlStateNormal];
}

- (BOOL)isOpenGPS
{
    CLAuthorizationStatus status2 = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status2 || kCLAuthorizationStatusRestricted == status2)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启定位服务，请在设置中开启后重新定位" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)summitBtnHaveClick
{
    [self.view endEditing:YES];
    
    if (self.addressTextField.text.length >100) {
        [self showAlert:@"商铺地址不允许超过100个字符"];
        return;
    }
    NSString *titleStr = self.CityBtn.titleLabel.text;
//    if (self.returnTextBlock != nil) {
//        self.returnTextBlock(self.CityBtn.titleLabel.text);
//    }
    if(![titleStr isEqualToString:@"未检测到结果"] && ![titleStr isEqualToString:@""] &&![titleStr isEqualToString:@"正在检测"]&&![titleStr isEqualToString:@"定位失败"]){
        self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:resultData.addressDetail.city,@"city",resultData.addressDetail.province,@"province",self.addressTextField.text,@"address" ,nil];
        self.item.subtitle = [NSString stringWithFormat:@"%@%@",resultData.addressDetail.province,self.addressTextField.text];
    }else{
        self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:self.addressTextField.text,@"address" ,nil];
        self.item.subtitle = [NSString stringWithFormat:@"%@",self.addressTextField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"****************");
}
@end

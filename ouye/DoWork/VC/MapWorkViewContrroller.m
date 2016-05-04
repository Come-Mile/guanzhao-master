//
//  MapWorkViewContrroller.m
//  ouye
//
//  Created by Sino on 16/4/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MapWorkViewContrroller.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "UIImage+ImagURL.h"
#import "NavigationBarView.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "WorkListModel.h"
#import "LWHttpTool.h"
#import "MapWorkModel.h"
#import "bsy_Window.h"
#import "loadingView.h"

@interface MapWorkViewContrroller()<UIGestureRecognizerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic ,strong)MapWorkModel *mapItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@property (nonatomic ,weak)bsy_Window *bsy;
@property (nonatomic ,weak)loadingView *loadingView;


@end

@implementation MapWorkViewContrroller
{
    BMKGeoCodeSearch *_search;
    BMKLocationService *_locService;
    MBProgressHUD *HUD;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _locService.delegate=nil;
    _mapView.delegate = nil; // 不用时，置nil
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;

    [self getDatas];
    
}

-  (void)getDatas
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"task_pack_id"] = self.workItem.p_id;
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"store_id"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:VIDEOINDEX params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"定位任务：%@",json);
        if ([json[@"code"]isEqualToNumber:@200]) {
            NSArray *datasArray = [NSArray arrayWithObjects:json, nil];
            self.mapItem = [[MapWorkModel alloc]init];
            if ([datasArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *questinDic in datasArray) {
                    [self.mapItem setValuesForKeysWithDictionary:questinDic];
                }
            }
            [self setUpSubViews];
        }else{
             [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        }
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)setUpSubViews
{
    self.titleLabel.text = self.mapItem.taskname;
    self.detailLabel.text = self.mapItem.note;
    CGRect tempR = self.detailLabel.frame;
    tempR.size = [self.detailLabel boundingRectWithSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT)];
    self.detailLabel.frame = tempR;
}
- (IBAction)starMapLocation:(id)sender {
    
    /**加载loading*/
    loadingView *load = [[loadingView alloc]init];
    [self.view addSubview:load];
    load.alertTitle = @"系统正在定位您的位置，请稍等...";
    self.loadingView = load;
    
    //初始化BMKLocationServic
    if (_locService ==nil) {
         _locService = [[BMKLocationService alloc]init];
        _locService.delegate=self;
    }
    //启动LocationService
    [_locService startUserLocationService];

    //    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
//调用代理方法会获取当前经纬度，获得经纬后 使用搜索 搜索坐标
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;//中心位置
    _mapView.zoomLevel=18;//缩放比例

    MWLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.mapItem.strLat =[NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    self.mapItem.strLng=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    // 建议获取完经纬后停止位置更新  否则会一直更新坐标
    if (userLocation.location.coordinate.latitude != 0) {
        [_locService stopUserLocationService];
    }
    //调用搜索
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    //这段代码不要删
    NSLog(@"%d",[search reverseGeoCode:rever]);
  
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self.loadingView removeFromSuperview];
    [self showAlert:@"抱歉，定位失败，请稍后再试！"];
}
//搜索代理方法里就能返回具体地址了
#pragma mark GeoCodeResult 返回地理位置
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    MWLog(@"%@",result.address);
    [self.loadingView removeFromSuperview];
    
    [self showAlertOfShopnum:self.mapItem.storenum shopName:self.mapItem.storename shopaddress:self.mapItem.address jingdu:[NSString stringWithFormat:@"%f",result.location.longitude] weidu:[NSString stringWithFormat:@"%f",result.location.latitude]];
}

-(void)showAlertOfShopnum:(NSString *)num shopName:(NSString *)name shopaddress:(NSString *)address jingdu:(NSString *)jingdu weidu:(NSString *)weidu{
    
    bsy_Window *bsy = [[bsy_Window alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [bsy addBsy_quitBtnMessage:@"取消" sureMessage:@"确定" shopNum:num shopName:name shopAddress:address jingdu:jingdu weidu:weidu];
    [self.view addSubview:bsy];
    self.bsy = bsy;
    [bsy.bsy_sureBtn addTarget:self action:@selector(bsy_Windowshow) forControlEvents:UIControlEventTouchDown];
}

#pragma mark--- 确定按钮的点击事件

-(void)bsy_Windowshow
{
//    UIImage *imageJietu=[UIImage screenShot:self.view];
    UIImage *imageJietu = [UIImage captureWithView:self.view];
    
//     UIImageWriteToSavedPhotosAlbum(imageJietu, self, @selector(image:didFinishSaveWithError:contextInfo:), nil);
    NSData *data = UIImagePNGRepresentation(imageJietu);
    NSString *strjietu = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self getUploadJietu:strjietu];
}
/**
 *  保存之后就会调用
 */
- (void)image:(UIImage *)image didFinishSaveWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        MWLog(@"保存失败");
        [CurrrentAppTool showMessage:@"截图保存到相册失败"];
    }else{
        MWLog(@"保存成功");
    }
}
/**
 *  上传截图
 *
 *  @param imageStr
 */
-(void)getUploadJietu:(NSString *)imageStr{

    [self.bsy bsy_Windowclose];
    HUD = [CurrrentAppTool showHUDMessageInView:self.view withTitle:@"正在上传"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"task_id"] = self.workItem.task_id;
    parameter[@"publishid"] = self.workItem.publish_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    parameter[@"user_mobile"] = [MWUserDefaul objectForKey:user_mobile];
    parameter[@"storeid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"status"] = @"0";
    parameter[@"task_pack_id"] = self.workItem.p_id;
    parameter[@"img1"] = imageStr;
    
    [ LWHttpTool postWithURL:LOCATIONTASKUP params:parameter formDataArray:nil success:^(id json) {
        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            [MWNotificationCenter postNotificationName:@"dowrkSucess" object:nil];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
    } failure:^(NSError *error) {
        MWLog(@"%@",error.localizedDescription);
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:error.localizedDescription];
    }];


}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
@end

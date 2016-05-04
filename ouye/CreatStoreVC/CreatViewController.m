//
//  CreatViewController.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CreatViewController.h"
#import "NavigationBarView.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MJSettingCell.h"
#import "MJSettingItem.h"
#import "MJSettingArrowItem.h"
#import "MJSettingLabelItem.h"

#import "MapViewController.h"
#import "MainTypesViewController.h"
#import "StoreOwerInfoController.h"
#import "StoreNameViewController.h"

#import "CurrrentAppTool.h"
#import "LWHttpTool.h"

#import <MBProgressHUD.h>

#import "ImagePickeVC.h"

#import "MyStoreViewController.h"
#import "storeItem.h"
#import "UIImage+ImagURL.h"
#import "MWPhotoBrower.h"
#import <UIButton+WebCache.h>

@interface CreatViewController ()<UITableViewDelegate , UITableViewDataSource , NavigationBarViewDelegate,ImagePickeVCDelegate>



@property (weak, nonatomic) IBOutlet UIButton *ImagPickerBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (weak, nonatomic) IBOutlet UILabel *ImagsCountLabel;
@property (nonatomic , strong)NSMutableArray *datas;

@property (nonatomic , strong)NSMutableArray *images;


@end

@implementation CreatViewController
{
    AppDelegate *_currentdelegate;
    MBProgressHUD *HUD;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.listTab reloadData];
    self.navigationController .navigationBarHidden = YES;
}
-(NSMutableArray *)datas
{
    if (_datas ==nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)images
{
    if (_images ==nil) {
        _images = [NSMutableArray array];
        
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = self.title;
    nav.delegate =self;
    [nav setSummitBtnShow];
    [nav setController:self];
    
    [self setUpDatas];
    
    self.ImagsCountLabel.text = [NSString stringWithFormat:@"%ld",self.images.count];
    
}
#pragma mark 提交
- (void)summitBtnHaveClick
{
    NSMutableDictionary *parameter2 = [NSMutableDictionary dictionary];
    MJSettingItem *item5 = self.datas[4];
    if ([self.title isEqualToString:@"商铺信息"]) {
        parameter2[@"shopowner"]= item5.dic[@"createusername"];
        parameter2[@"usersex"]= item5.dic[@"usersex"];
        parameter2[@"userphone"]= item5.dic[@"userphone"];
        parameter2[@"token"] = [MWUserDefaul objectForKey:Apptoken];
        parameter2[@"shopid"] = [MWUserDefaul objectForKey:SHOPID];
        [self httpStartForUpdataWith:parameter2];
        
    }else{
        
        if (self.images.count ==0) {
            [self showAlert:@"请至少拍摄一张商铺照片"];
            return;
        }
        
        MJSettingItem *item1 = self.datas[0];
        MJSettingItem *item2 = self.datas[1];
        MJSettingItem *item3 = self.datas[2];
        MJSettingItem *item4 = self.datas[3];
        
        if (![self checkWith:item1.dic[@"shopname"]]) {
            [self showAlert:@"请输入商铺名称"];
            return;
        }
        
        if (![self checkWith:item2.dic[@"address"]]) {
            [self showAlert:@"请输入商铺地址"];
            return;
        }
        if (![self checkWith:item3.dic[@"producttype"]]) {
            [self showAlert:@"请选择商铺主营类型"];
            return;
        }
        
        if (![self checkWith:item4.dic[@"shoparea"]]) {
            [self showAlert:@"请选择商铺面积"];
            return;
        }
        
        [self httpStartWith:[self setUpPostDicForCreat]];
    }
}

- (NSDictionary *)setUpPostDicForCreat
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    MJSettingItem *item1 = self.datas[0];
    MJSettingItem *item2 = self.datas[1];
    MJSettingItem *item3 = self.datas[2];
    MJSettingItem *item4 = self.datas[3];
    MJSettingItem *item5 = self.datas[4];
    
    parameter[@"shopname"] = item1.dic[@"shopname"];
    parameter[@"address"]= item2.dic[@"address"];
    parameter[@"province"] = item2.dic[@"province"];
    parameter[@"city"] = item2.dic[@"city"];
    parameter[@"producttype"] = item3.dic[@"producttype"];
    parameter[@"shoparea"]=item4.dic[@"shoparea"];
    
    parameter[@"shopowner"]= item5.dic[@"createusername"];
    parameter[@"usersex"]= item5.dic[@"usersex"];
    parameter[@"userphone"]= item5.dic[@"userphone"];
    parameter[@"token"] = [MWUserDefaul objectForKey:Apptoken];
    parameter[@"usermobile"]= [MWUserDefaul objectForKey:user_mobile];
    parameter[@"createusername"] = [MWUserDefaul objectForKey:UserName];
    
    MWLog(@"%@",[MWUserDefaul objectForKey:user_mobile]);
    for ( int i=0 ;i <self.images.count;i++) {
        
        //        NSString *imageStr = [self imagWithCount:i];
        //        NSString *strDic = [NSString stringWithFormat:@"%d",i];
        //        [parameter setObject:imageStr forKey:strDic];
        if (i==0) {
            parameter[@"img1"] = [self imagWithCount:0];
        }else if (i==1)
        {
            parameter[@"img2"] = [self imagWithCount:1];
        }else if (i==2)
        {
            parameter[@"img3"] = [self imagWithCount:2];
        }else if (i==3)
        {
            parameter[@"img4"] = [self imagWithCount:3];
        }else if (i==4)
        {
            parameter[@"img5"] = [self imagWithCount:4];
        }else if (i==5)
        {
            parameter[@"img6"] = [self imagWithCount:5];
        }else if (i==6)
        {
            parameter[@"img7"] = [self imagWithCount:6];
        }else if (i==7)
        {
            parameter[@"img8"] = [self imagWithCount:7];
        }else if (i==8)
        {
            parameter[@"img9"] = [self imagWithCount:8];
        }
    }
    //    int rec =0;
    //    for (UIImage *imag in self.images) {
    //        rec ++;
    //       NSString *Strdic = [NSString stringWithFormat:@"img%d",rec];
    //        NSString *dic = Strdic;
    //        MWLog(@"%@",Strdic);
    ////        [parameter setObject:[self imagZipWithImag:imag] forKey:Strdic];
    //        parameter[dic] = [self imagZipWithImag:imag];
    //    }
    
    return parameter;
}
- (NSString *)imagZipWithImag:(UIImage *)image
{
    NSData * imageData = UIImageJPEGRepresentation(image,0.5);
    NSString * imageStr = [imageData base64EncodedStringWithOptions:kNilOptions];
    return imageStr;
}

- (NSString *)imagWithCount:(int)count
{
    NSData * imageData = UIImageJPEGRepresentation(self.images[count],0.5);
    NSString * imageStr = [imageData base64EncodedStringWithOptions:kNilOptions];
    return imageStr;
}
- (BOOL)checkWith:(NSString *)str
{
    if (str.length ==0) {
        return NO;
    }else
    {
        return YES;
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
//创建商铺
- (void)httpStartWith:(NSDictionary *)parameter
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    [LWHttpTool postWithURL:CREATShopURL params:parameter formDataArray:nil success:^(id json) {
        MWLog(@"创建商铺：%@%@",json,parameter);
        if ([json[@"code"]isEqualToNumber:@200]) {
            
            [MWUserDefaul setObject:json[@"msg"] forKey:SHOPID];
            [MWUserDefaul synchronize];
            [MWNotificationCenter postNotificationName:@"creatstoreSucess" object:self.images];
            
            [self dismiss];
            
        }else{
            [CurrrentAppTool showMessage:json[@"msg"]];
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
//        [CurrrentAppTool showMessage:json[@"msg"]];
    }failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] HUD:HUD];
        MWLog(@"%@",error.localizedDescription);
    }];
}
//更新店铺信息
- (void)httpStartForUpdataWith:(NSDictionary *)pamer
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    
    [LWHttpTool postWithURL:UPDateShopURL params:pamer formDataArray:nil success:^(id json) {
        MWLog(@"主营类型：%@%@",json,pamer);
        if ([json[@"code"]isEqualToNumber:@200]) {
            [MWNotificationCenter postNotificationName:@"creatstoreSucess" object:self.images];
            [self dismiss];
           [CurrrentAppTool showMessage:json[@"msg"]];
        }else{
           [CurrrentAppTool showMessage:json[@"msg"]]; 
        }
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
    }failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] HUD:HUD];
        MWLog(@"%@",error.localizedDescription);
    }];
}

- (void)setUpDatas
{
    if ([self.title isEqualToString:@"商铺信息"]) {
        [self setUpDatasForInfo];
    }else{
        [self setUpDatasForCreat];
    }
}

- (void)setUpDatasForInfo
{
    if (self.storeInfo.count ==0) {
        [self showAlert:@"未获取到店铺信息"];
        return;
    }
    storeItem *item = self.storeInfo[0];
    self.images = item.picurls;
    
    [self.ImagPickerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:item.picurls[0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhan"]];
    
    MJSettingItem *name;
    if ([item.shop_name isKindOfClass:[NSString class]]) {
        name = [MJSettingItem itemWithIcon:@"_shangpumingchen" title:@"商铺名称"];
        name.subtitle = item.shop_name;
        name.dic = [NSDictionary dictionaryWithObjectsAndKeys:item.shop_name,@"shopname", nil];
    }else{
//        name = [MJSettingArrowItem itemWithIcon:@"_shangpumingchen" title:@"商铺名称" destVcClass:[StoreNameViewController class]];
        name = [MJSettingItem itemWithIcon:@"_shangpumingchen" title:@"商铺名称"];
    }
    MJSettingItem *address;
    if ([item.address isKindOfClass:[NSString class]]) {
//        address = [MJSettingArrowItem itemWithIcon:@"_dizhi" title:@"商铺地址" destVcClass:[MapViewController class]];
        address = [MJSettingItem itemWithIcon:@"_dizhi" title:@"商铺地址"];
        
        address.subtitle = item.address;
        NSMutableDictionary *addressDic = [NSMutableDictionary dictionary];
        addressDic[@"address"] = item.address;
        addressDic[@"province"] = item.province;
        addressDic[@"city"] = item.city;
        address.dic = addressDic;
    }
    else{
//        address = [MJSettingArrowItem itemWithIcon:@"_dizhi" title:@"商铺地址" destVcClass:[MapViewController class]];
        address = [MJSettingItem itemWithIcon:@"_dizhi" title:@"商铺地址"];
    }
    
    MJSettingItem *type;
    if (![item.product_type isKindOfClass:[NSNull class]]) {
        type = [MJSettingItem itemWithIcon:@"_liexing-0" title:@"主营类型"];
        type.subtitle = item.product_type;
        type.dic = [NSDictionary dictionaryWithObjectsAndKeys:item.product_type,@"producttype", nil];

    }else{
        
//        type = [MJSettingArrowItem itemWithIcon:@"_liexing-0" title:@"主营类型" destVcClass:[MainTypesViewController class]];
        type = [MJSettingItem itemWithIcon:@"_liexing-0" title:@"主营类型"];
    }
    
    MJSettingItem *mianji;
    if (![item.shop_area isKindOfClass:[NSNull class]]) {
        mianji = [MJSettingItem itemWithIcon:@"_mianji-0" title:@"商铺面积"];
        mianji.subtitle = item.shop_area;
        mianji.dic = [NSDictionary dictionaryWithObjectsAndKeys:item.shop_area,@"shoparea", nil];
    }else{
//        mianji = [MJSettingArrowItem itemWithIcon:@"_mianji-0" title:@"商铺面积" destVcClass:[MainTypesViewController class]];
        mianji = [MJSettingItem itemWithIcon:@"_mianji-0" title:@"商铺面积"];
    }
  
    MJSettingItem *owerInfo = [MJSettingArrowItem itemWithIcon:@"_dianzhuxinxi-0" title:@"店主信息" destVcClass:[StoreOwerInfoController class]];
    NSMutableString *subStr = [NSMutableString string];
    NSMutableDictionary *ifDic = [NSMutableDictionary dictionary];
    if ([item.shopowner isKindOfClass:[NSString class]]) {
        [subStr appendString:item.shopowner];
        ifDic[@"createusername"] = item.shopowner;
    }
    if ([item.usersex isEqualToString:@"0"]) {
        [subStr  appendString:@" 男 "];
        ifDic[@"usersex"] = @"0";
    }else if([item.usersex isEqualToString:@"1"] ){
        [subStr  appendString:@" 女 "];
         ifDic[@"usersex"] = @"1";
    }
    
    if([item.userphone isKindOfClass:[NSString class]]){
        [subStr  appendString:item.userphone];
        ifDic[@"userphone"] = item.userphone;
    }
    
    owerInfo.dic = ifDic;
    owerInfo.subtitle = subStr;
    MWLog(@"%@",item.shopowner);
   
    [self.datas addObjectsFromArray:@[name,address,type,mianji,owerInfo]];
}


- (void)setUpDatasForCreat
{
     MJSettingItem *name = [MJSettingArrowItem itemWithIcon:@"_shangpumingchen" title:@"商铺名称" destVcClass:[StoreNameViewController class]];
    MJSettingItem *address = [MJSettingArrowItem itemWithIcon:@"_dizhi" title:@"商铺地址" destVcClass:[MapViewController class]];
    MJSettingItem *type = [MJSettingArrowItem itemWithIcon:@"_liexing-0" title:@"主营类型" destVcClass:[MainTypesViewController class]];
    MJSettingItem *mianji = [MJSettingArrowItem itemWithIcon:@"_mianji-0" title:@"商铺面积" destVcClass:[MainTypesViewController class]];
    MJSettingItem *owerInfo = [MJSettingArrowItem itemWithIcon:@"_dianzhuxinxi-0" title:@"店主信息" destVcClass:[StoreOwerInfoController class]];

    [self.datas addObjectsFromArray:@[name,address,type,mianji,owerInfo]]; 
}

- (void)dismiss{

    if(self.navigationController.viewControllers.count<2){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJSettingCell *cell = [MJSettingCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    MJSettingItem *item = self.datas[indexPath.section];
    cell.item = item;
    MWLog(@"%@",item.dic);
    cell.lastRowInSection = (self.datas.count - 1 == indexPath.section);

    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingItem *item = self.datas[indexPath.section];
    if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StoreOwerInfoController * pushVC = [board instantiateViewControllerWithIdentifier:NSStringFromClass(arrowItem.destVcClass)];
        pushVC.title = item.title;
        pushVC.item = item;
        [self.navigationController pushViewController:pushVC  animated:YES];
    }
}


- (IBAction)imagePickeBtnClick:(id)sender {
    if ([self.title isEqualToString:@"商铺信息"]) {
        MWPhotoBrower *borwer = [[MWPhotoBrower alloc]init];
        borwer.images = self.images;
        [self.navigationController presentViewController:borwer animated:YES completion:nil];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ImagePickeVC * pushVC = [board instantiateViewControllerWithIdentifier:@"ImagePickeVC"];
        pushVC.delegate = self;
        pushVC.title = @"店铺照片";
        pushVC.images = self.images;
        [self.navigationController pushViewController:pushVC  animated:YES];
    }
}

// 照片拍完之后给拍照按钮设置背景图
- (void)popVCWithImages:(NSMutableArray *)images
{
    MWLog(@"照片：%@",images);
    if (images.count ==0) {
        return;
    }
    self.images = images;
    [self.ImagPickerBtn setBackgroundImage:images[0] forState:UIControlStateNormal];
    self.ImagsCountLabel.text = [NSString stringWithFormat:@"%ld",images.count];
    
}

@end

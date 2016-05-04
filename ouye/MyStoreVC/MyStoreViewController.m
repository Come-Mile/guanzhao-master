//
//  MyStoreViewController.m
//  ouye
//
//  Created by Sino on 16/3/21.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MyStoreViewController.h"
#import "CreatViewController.h"
#import "SettingVC.h"
#import "MessageViewController.h"
#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "MJSettingItem.h"
#import "storeItem.h"
#import "UIImage+ImagURL.h"
#import <UIButton+WebCache.h>
#import "MWPhotoBrower.h"

#import "DetailViewController.h"

#import "MyStoreListCell.h"
#import <MJRefresh.h>
#import "MWCustomLoadingView.h"
#import "StoreListItem.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MyStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *creatStoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *imagBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listTabTopCOnt;

@property (weak, nonatomic) IBOutlet UIView *MoneyBgView;
@property (nonatomic , strong)NSMutableArray *storeArray;
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (weak, nonatomic) IBOutlet UIImageView *headBgView;


@property (nonatomic , strong)NSMutableArray *listData;

@property (nonatomic , weak)UIView *noDataView;
@end

@implementation MyStoreViewController
{
    MBProgressHUD *HUD;
    MBProgressHUD *HUD2;
    NSString *shopID;
    
    int page;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutListTab];
   
    /***  设置下拉刷新 */
    page = 1;
    [self setUpMyStoreData];
    [MWNotificationCenter addObserver:self selector:@selector(setUpMyStoreData) name:@"creatstoreSucess" object:nil];
    
    [MWNotificationCenter addObserver:self selector:@selector(loadNewData) name:@"WORKDONE" object:nil];
    /**
     *  收到自定义消息
     */
    [MWNotificationCenter addObserver:self selector:@selector(getMessage:) name:@"registMessage" object:nil];
    [self example03];
}

- (void)getMessage:(NSNotification *)info
{
    //取到nav控制器当前显示的控制器
    UIViewController * baseVC = (UIViewController *)self.navigationController.visibleViewController;
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
    if([baseVC isKindOfClass:[MessageViewController class]])
    {
        MessageViewController * vc = (MessageViewController *)baseVC;
        [vc loadNewData];
        return;
    }
    [self messageBtnClick:self.messageBtn];
}

- (NSMutableArray *)storeArray
{
    if (!_storeArray) {
        _storeArray = [NSMutableArray array];
    }
    return _storeArray;
}

- (NSMutableArray *)listData
{
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (void)setUpMyStoreData
{
    /*** TODO如果没有店铺 ，到创建店铺页面 */
    NSString *shop_id = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:SHOPID]];
    MWLog(@"店铺编号：%@",shop_id);
    if (shop_id.length != 0) {
        shopID = shop_id;
        [self checkStoreWithShopeID:shop_id];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreatViewController * VC = [board instantiateViewControllerWithIdentifier:@"CreatViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        VC.title = @"创建商铺";
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)layoutListTab
{
    //TODO 隐藏 MoneyBgView
//    self.MoneyBgView.hidden = NO;
    if (self.MoneyBgView.hidden == NO) {
        self.listTabTopCOnt.constant =  self.MoneyBgView.frame.size.height+10;
    }
}

//开始加载数据
- (void)ViewDidStartLoadW:(UIView *)view {
    [[MWCustomLoadingView shareCustomLoadingView]showLoadingViewWithTitle:@"正在加载..." InView:view];
    
}

//数据加载完
- (void)ViewDidFinishLoadW:(UIView *)view {
    [[MWCustomLoadingView shareCustomLoadingView]stopShow];
}

- (void)checkStoreWithShopeID:(NSString *)shope_id
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shopid"] = shope_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    __weak MyStoreViewController *weakSelf = self;
    [LWHttpTool postWithURL:chechaveStoreURL params:parameter success:^(id json) {
      
        [weakSelf.storeArray removeAllObjects];
//        MWLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@200]) {
            
            /** 查询店铺成功刷新任务列表 */
            [weakSelf getMyStoreListDataWith:shope_id];
            storeItem *item = [[storeItem alloc]init];
            item.shop_name = json[@"shop_name"];
            item.product_type = json[@"product_type"];
            item.address = json[@"address"];
            item.province = json[@"province"];
            item.city = json[@"city"];
            item.shop_area = json[@"shop_area"];
            item.shopowner = json[@"shop_owner"];
            item.usersex = json[@"owner_sex"];
            item.userphone = json[@"owner_phone"];
            item.picurls = json[@"picurl"];
            [weakSelf.storeArray addObject:item];
            [weakSelf setUpCreatBtnView];
            
        }else if([json[@"code"]isEqualToNumber:@1]){
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreatViewController * VC = [board instantiateViewControllerWithIdentifier:@"CreatViewController"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
            VC.title = @"创建店铺";
            [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            [CurrrentAppTool showMessage:json[@"msg"]];
        }else{
            [CurrrentAppTool showMessage:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self.listTab.mj_header endRefreshing];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)getMyStoreListDataWith:(NSString *)shopId
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shopid"] = shopId;
    parameter[@"page"] = [NSNumber numberWithInt:1];
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TASKINDEX params:parameter success:^(id json) {
        [self.listTab.mj_header endRefreshing];
        NSMutableArray *dataArray = [NSMutableArray array];
        if ([json[@"code"] isEqualToNumber:@200]) {
            NSArray *datas = json[@"datas"];
            if ([datas isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in datas) {
                    StoreListItem *item = [[StoreListItem alloc]init];
                    [item setValuesForKeysWithDictionary:dic];
                    [dataArray addObject:item];
                }
            }
            self.listData = dataArray;
        }
        self.listTab.hidden = (self.listData.count ==0) ? YES:NO;
        if (self.listTab.hidden) {
            
            [self removeNoDataView];
            [self noDataViewWithMsg:json[@"msg"]];
            
        }else{
            [self setUpListHeaderView];
            [self.listTab reloadData];
        }
    } failure:^(NSError *error) {
        [self.listTab.mj_header endRefreshing];
         [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)loadMoreStoreListDataWith:(NSString *)shopId
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shopid"] = shopId;
    parameter[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TASKINDEX params:parameter success:^(id json) {
        MWLog(@"loadMore任务列表：%@ %@",json,shopId);
        [self.listTab.mj_footer endRefreshing];
        NSMutableArray *dataArray = [NSMutableArray array];
        if ([json[@"code"] isEqualToNumber:@200]) {
            NSArray *datas = json[@"datas"];
            if ([datas isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in datas) {
                    StoreListItem *item = [[StoreListItem alloc]init];
                    [item setValuesForKeysWithDictionary:dic];
                    [dataArray addObject:item];
                }
            }
            [self.listData addObjectsFromArray:dataArray];
        }
        self.listTab.hidden = (self.listData.count ==0) ? YES:NO;
        if (self.listTab.hidden) {
            [self removeNoDataView];
            [self noDataViewWithMsg:json[@"msg"]];
        }
        [self.listTab reloadData];
        
    } failure:^(NSError *error) {
        [self.listTab.mj_footer endRefreshing];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}
#pragma mark UITableView + 下拉刷新 隐藏时间
- (void)example03
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
//    [header beginRefreshing];
    
    // 设置header
    self.listTab.mj_header = header;
    /*** 下拉刷新 */
    [self example11];
}

- (void)loadNewData
{
    MWLog(@"下拉刷新");
    page = 1;
    [self setUpMyStoreData];
    
}

#pragma mark UITableView + 下拉刷新 默认
- (void)example11
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.listTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
- (void)loadMoreData
{
    page ++;
    [self loadMoreStoreListDataWith:shopID];
    MWLog(@"上啦加载 :%d",page);
}
#pragma mark 无数据视图
- (void)noDataViewWithMsg:(NSString *)msg
{
    //给图层添加背景图片：
    //myView.layer.contents = (id)[UIImage imageNamed:@"view_BG.png"].CGImage;
    //将图层的边框设置为圆脚
    
    CGFloat viewY = self.listTab.frame.size.height/4.0 +self.listTab.frame.origin.y;
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(40, viewY, self.view.frame.size.width -80, 40)];
    myView.layer.cornerRadius = 8;
    myView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    //    myWebView.layer.borderWidth = 5;
    //    myWebView.layer.borderColor = [[UIColor colorWithWhite:0.800 alpha:1.000] CGColor];
    UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height)];
    
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.backgroundColor = [UIColor whiteColor];
    noDataLabel.text = msg;
    [myView addSubview:noDataLabel];
    [self.view addSubview:myView];
    
    self.noDataView = myView;
}

- (void)removeNoDataView
{
    if (self.noDataView !=nil) {
       [self.noDataView removeFromSuperview];
    }
}

#pragma mark 给headView加载数据
- (void)setUpCreatBtnView
{
    [self.creatStoreBtn.layer setMasksToBounds:YES];
//    [self.creatStoreBtn.layer setCornerRadius:15.0];
    storeItem *item = self.storeArray[0];
    self.images = item.picurls;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",item.picurls.count];
    [self.imagBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:item.picurls[0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhan"]];
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@",item.shop_name];
    
}

- (IBAction)creatStoreBtnClick:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreatViewController * controller= [board instantiateViewControllerWithIdentifier:@"CreatViewController"];
    controller.title = @"商铺信息";
    controller.storeInfo = self.storeArray;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)settingBtnClick:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingVC * controller= [board instantiateViewControllerWithIdentifier:@"SettingVC"];
    [self.navigationController pushViewController:controller animated:YES];

}
- (IBAction)messageBtnClick:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController * controller= [board instantiateViewControllerWithIdentifier:@"MessageViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)imagBtnClick:(id)sender {
    MWPhotoBrower *borwer = [[MWPhotoBrower alloc]init];
    borwer.images = self.images;
    [self.navigationController presentViewController:borwer animated:YES completion:nil];
}

- (void)setUpPhotoBro
{
    int count = (int)self.images.count;
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        //        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        
        //        IWPhoto *iwphoto = self.images[i];
        //        NSString *photoUrl = [iwphoto.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
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

- (void)dealloc
{
    [self ViewDidFinishLoadW:nil];
    [MWNotificationCenter removeObserver:self];
}

#pragma mark tab代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStoreListCell *cell = [MyStoreListCell cellWithTableView:tableView];
    StoreListItem *item = self.listData[indexPath.row];
    cell.item = item;
    return cell;
}
- (void)setUpListHeaderView
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenW-10, 40)];
    titleLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    titleLabel.text = @"   可执行的任务列表:";
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.listTab.tableHeaderView = titleLabel;
    
    self.listTab.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreListItem *item = self.listData[indexPath.row];
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     DetailViewController* controller= [board instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.title = item.p_name;
    controller.item = item;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

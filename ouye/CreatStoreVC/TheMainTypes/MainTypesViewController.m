//
//  MainTypesViewController.m
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MainTypesViewController.h"
#import "MainTypeCell.h"
#import "MainTypeItem.h"
#import "NavigationBarView.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>
#import "LWHttpTool.h"
#import "MJSettingItem.h"

@interface MainTypesViewController ()<UITabBarDelegate , UITableViewDataSource ,NavigationBarViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic ,strong)NSMutableArray *datas;
@end

@implementation MainTypesViewController
{
     MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text =self.title;
    nav.delegate =self;
    [nav setSummitBtnShow];
    [nav setController:self];

    [self setUpDatasFor:self.title];
    
}

- (void)setUpDatasFor:(NSString *)tit
{
    if([tit isEqualToString:@"商铺面积"])
    {
        [self setUpDatasForStore];
    }else{
        [self setUpDatas];
    }
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
// 获取主营类型数据
- (void)setUpDatas
{
    NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:@"food",@"食品",@"yinliao",@"饮料",@"shenghuoyongpin",@"生活用品",@"huazhuangpin",@"化妆品",@"yaopin",@"保健药品",@"jiudian",@"饭店酒店",@"yanjiu",@"烟酒", @"shenghuoyongpin",@"其他",nil];
    
     HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [LWHttpTool postWithURL:PTypeURL params:nil success:^(id json) {
        MWLog(@"主营类型：%@%@",json,parameter);
    
        NSArray *datas = json[@"datas"];
        for (NSDictionary *dic in datas) {
            NSString *imageName = dic[@"name"];
            MainTypeItem *item = [MainTypeItem itemWithIcon:[NSString stringWithFormat:@"%@",imageDic[imageName]] title:imageName select:NO multiselect:YES];
            MWLog(@"%@",item.icon);
            if (imageDic[imageName] ==nil) {
                item = [MainTypeItem itemWithIcon:imageDic[@"其他"] title:imageName select:NO multiselect:YES];
            }
            
            if (self.item.dic) {
                if ([self.item.dic[@"producttype"] isKindOfClass:[NSString class]]) {
                    if ([self string:self.item.dic[@"producttype"] haveSubString: dic[@"name"]]) {
                        item.select = YES;
                    }
                }
            }
            [self.datas addObject:item];
        }
        [self.listTab reloadData];
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
    }failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] HUD:HUD];
        MWLog(@"%@",error.localizedDescription);
    }];
    
}

- (BOOL)string:(NSString *)str haveSubString:(NSString *)subStr
{
    NSRange range =  [str rangeOfString:subStr];
    if (range.location !=NSNotFound) {
        return YES;
    }else
    {
        return NO;
    }
}

// 获取店铺面积数据
- (void)setUpDatasForStore
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [LWHttpTool postWithURL:SHOPAREAURL params:nil success:^(id json) {
        MWLog(@"面积：%@%@",json,parameter);
        
        NSArray *datas = json[@"datas"];
        for (NSDictionary *dic in datas) {
            
        MainTypeItem *item = [MainTypeItem itemWithTitle:dic[@"name"] select:NO multiselect:NO];
            if (self.item.dic) {
                if ([self.item.dic[@"shoparea"] isKindOfClass:[NSString class]]) {
                    if ([self.item.dic[@"shoparea"] isEqualToString:dic[@"name"]]) {
                        item.select = YES;
                    }
                }
            }
            
            [self.datas addObject:item];
        }
        [self.listTab reloadData];
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:json[@"msg"]];
    }failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] HUD:HUD];
        MWLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark UitabViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeCell *cell = [MainTypeCell cellWithTableView:tableView];
    
    MainTypeItem *item = self.datas[indexPath.row];
    item.cellId = indexPath.row;
    cell.item = item;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTypeItem *item = self.datas[indexPath.row];
    item.select = !item.select;
    for (MainTypeItem *otherItem in self.datas) {
        if (item.multiSelect ==NO) {
            if (item.cellId != otherItem.cellId) {
                otherItem.select = NO;
            }else{
                otherItem.select = YES;
            }
        }
    }
    [tableView reloadData];
}

- (void)summitBtnHaveClick
{
    NSMutableString *selectStr = [NSMutableString string];
    for (MainTypeItem *item in self.datas) {
        if (item.select == YES) {
            if ([self.title isEqualToString:@"商铺面积"]) {
                [selectStr appendString:item.title];
                break;
            }else if ([self.title isEqualToString:@"主营类型"]){
                [selectStr appendString:item.title];
                [selectStr appendString:@","];
            }
        }
    }
    if ([self.title isEqualToString:@"主营类型"]){
        self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:[self removeCharWithStr:selectStr],@"producttype", nil];
    }else{
        self.item.dic = [NSDictionary dictionaryWithObjectsAndKeys:selectStr,@"shoparea", nil];
    }
     self.item.subtitle = [self removeCharWithStr:selectStr];
    [self.navigationController popViewControllerAnimated:YES];
}
//去掉首尾的特殊字符
- (NSString *)removeCharWithStr:(NSString *)str
{
    NSString *content = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    return content;
}
@end

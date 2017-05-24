//
//  IndianaShopDetailsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopDetailsVC.h"
#import "IndianaShopDetailsOneCell.h"
#import "IndianaShopDetailsTwoCell.h"
#import "IndianaShopDetailsThreeCell.h"
#import "IndianaShopDetailsFourCell.h"
#import "IndianaShopPayVC.h"
#import "CalculationDetailsVC.h"
#import "HistoryRevealedVC.h"
#import "CalculationDetailsVC.h"
#import "PhotoViewController.h"
#import "IndianaSunVC.h"
#import "IndianaShopWebVC.h"
#import "IndianaShopModel.h"
#import "IndianaUserSunModel.h"
#import "last_timeModel.h"
@interface IndianaShopDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSString* allNumber;
@property (nonatomic,strong)IndianaShopModel *ShopModel;
@property (nonatomic,strong)last_timeModel *lasttimeModel;

@end
@implementation IndianaShopDetailsVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"商品详情";
    [self showBackBtn];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5.0;
    [self setUpTableView];
    [self ShowNodataView];

    
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64-Width/6) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    //TableView滚动、自动收起键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndianaShopDetailsOneCell",@"IndianaShopDetailsTwoCell",@"IndianaShopDetailsThreeCell",@"IndianaShopDetailsFourCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    self.allNumber = @"1";
    //总计赋值
    [self  AllNmuber ];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    [self requestGoodsInfo];
    //上拉刷新下拉加载
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestGoodsInfo];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestGoodsInfo{
    NSMutableDictionary *dic  =[ @{@"goods_id":self.goods_id}mutableCopy];
    __weak typeof(self) weakself = self;
         BaseRequest *baseReq = [[BaseRequest alloc] init];
         baseReq.encryptionType = RequestMD5;
         baseReq.data =dic;
         [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbGoodsInfo sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];                        if (baseRes.resultCode ==1) {
                NSMutableDictionary * dataDic = baseRes.data;
                weakself.ShopModel  = [IndianaShopModel yy_modelWithJSON:dataDic[@"goods"]];
                NSLog(@"----%@", dataDic[@"goods"]);
                
                weakself.lasttimeModel = [last_timeModel yy_modelWithJSON:dataDic[@"lastTime"]];
                
                //刷新
                //[weakself.tableView reloadData];
                [weakself requestAction];
            }else{
                [weakself showToast:baseRes.msg];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
    

}

#pragma mark - 网络请求
-(void)requestAction{
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"times_id":self.ShopModel.times_id}mutableCopy];
    __weak typeof(self) weakself = self;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data =dic;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbJoinList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (weakself.pageIndex == 1) {
            [weakself.dataArray removeAllObjects];
        }
        if (baseRes.resultCode ==1) {
            NSMutableArray *arr = baseRes.data;
            for (NSDictionary *dicData in arr) {
                IndianaUserSunModel *model = [IndianaUserSunModel yy_modelWithJSON:dicData];
                [weakself.dataArray addObject:model];
            }
            //刷新
            [weakself.tableView reloadData];
            [weakself HiddenNodataView];
            if ([self.ShopModel.status isEqualToString:@"1"]) {
                weakself.submitBtn.userInteractionEnabled = YES;
                weakself.submitBtn.backgroundColor = [UIColor orangeColor];
                
            }else{
                weakself.submitBtn.userInteractionEnabled = NO;
                weakself.submitBtn.backgroundColor = [UIColor grayColor];
            }
            
        }else{
            [weakself showToast:baseRes.msg];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
}


#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    if (section==0) {
        return 3;
    }else{
    return self.dataArray.count;
    }
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    __weak typeof(self) weakSelf = self;
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row==0) {
                    IndianaShopDetailsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaShopDetailsOneCell" forIndexPath:indexPath];
                        cell.IndianaShopDetailsOneCellScrollViewImageBlock =^(NSInteger index){
                        [weakSelf IndianaShopDetailsOneCellScrollViewImageBlockTag:index];
                    };
                    //cell 赋值
                    cell.model = self.ShopModel;
                    // cell 其他配置
                    return cell;
                }
                else if (indexPath.row==1) {
                    IndianaShopDetailsTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaShopDetailsTwoCell" forIndexPath:indexPath];
                    cell.IndianaShopDetailsTwoCellBlock=^(NSInteger tag){
                        //Push 跳转
                        CalculationDetailsVC * VC = [[CalculationDetailsVC alloc]initWithNibName:@"CalculationDetailsVC" bundle:nil];
                        VC.lasttimeModel = self.lasttimeModel;
//                        VC.CalculationDetailsVCBlock = ^(){
//                            weakSelf.pageIndex =1;
//                            [weakSelf requestGoodsInfo];
//                        };
                        [weakSelf.navigationController  pushViewController:VC animated:YES];
                    };
                    //cell 赋值
                    if (self.lasttimeModel.luck_no.length !=0) {
                        cell.model = self.lasttimeModel;
                    }
                                     // cell 其他配置
                    return cell;
                }else{
                    IndianaShopDetailsThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaShopDetailsThreeCell" forIndexPath:indexPath];
                    __weak typeof(self) weakSelf = self;
                    cell.IndianaShopDetailsThreeCellBlock=^(NSInteger tag){
                        [weakSelf IndianaShopDetailsThreeCellBlock:tag];
                    };
                    cell. IndianaShopDetailsNumberCellBlock =^(NSString *number){
                        NSLog(@"%@",number);
                        weakSelf.allNumber = number;
                        //总计赋值
                        [weakSelf  AllNmuber ];
                    };
                    //cell 赋值
                    cell.model = self.ShopModel;

                    // cell 其他配置
                    return cell;
                }
                  break;
            }
            case 1:
            {
                IndianaShopDetailsFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaShopDetailsFourCell" forIndexPath:indexPath];
                //cell 赋值
                cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
                
                //cell.label.text = @"(IP:1992.168.0.1)\n参与时间 :2018-09-01 10:08\n本期购买:10分";
                return cell;
                break;
            }
            default:{
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                break;
                
            }
        }
        
    
}
#pragma mark - 轮播图点击事件
-(void)IndianaShopDetailsOneCellScrollViewImageBlockTag:(NSInteger)tag{
    
        PhotoViewController *photoVC = [[PhotoViewController alloc] init];
        photoVC.urlArray = self.ShopModel.images;
        //    SDCollectionViewCell * Cell=[cycleScrollView.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        photoVC.imgFrame = self.view.frame;
        photoVC.index = tag;
        //photoVC.frameArray = [_frameArray copy];
        photoVC.imgData = [self getImageDataWithUrl:[(NSArray*)self.ShopModel.images objectAtIndex:tag]];
    
    [self presentViewController:photoVC animated:NO completion:nil];
    
        photoVC.indexBlock = ^(NSInteger index){
    
    
            //[cycleScrollView ImageContentOffset:CGPointMake(index*Width,0)];
    
        };
    
        [photoVC setCompletedBlock:^(void){
            //        [_coverView removeFromSuperview];
            //        _coverView = nil;
        }];
    
    
}

- (NSData *)getImageDataWithUrl:(NSString *)url
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    return imageData;
}


#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                return self.tableView.rowHeight;
            }else if (indexPath.row==1) {
                return self.lasttimeModel.luck_no.length !=0 ? Width/5*2.0 : 0.0;
            }else{
                return   self.tableView.rowHeight ;
            }
            break;
        }
            
        case 1:
        {
            return self.tableView.rowHeight;
            break;
        }
            
        default:{
            return 0;
            break;
            
        }
    }
}


#pragma mark - 详情-历史-揭晓
-(void)IndianaShopDetailsThreeCellBlock:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            //商品详情
            //Push 跳转
            IndianaShopWebVC * VC = [[IndianaShopWebVC alloc]initWithNibName:@"IndianaShopWebVC" bundle:nil];
            VC.goods_content = self.ShopModel.goods_content;
            [self.navigationController  pushViewController:VC animated:YES];
            break;
        }
            
        case 1:
        {
            //晒单历史
            //Push 跳转
            IndianaSunVC * VC = [[IndianaSunVC alloc]initWithNibName:@"IndianaSunVC" bundle:nil];
            VC.title = @"历史晒单";
            VC.goods_id = self.ShopModel.goods_id;
            [self.navigationController  pushViewController:VC animated:YES];

            break;
        }
            
        case 2:
        {
            //往期揭晓
            HistoryRevealedVC * VC = [[HistoryRevealedVC alloc]initWithNibName:@"HistoryRevealedVC" bundle:nil];
            VC.goods_id = self.ShopModel.goods_id.length == 0 ? @"":self.ShopModel.goods_id;
            [self.navigationController  pushViewController:VC animated:YES];

            break;
        }
        default:{
            
            break;
            
        }
    }
}



#pragma mark - 总计赋值
-(void)AllNmuber{
    NSString* promptStr = @"夺宝有风险,参与需谨慎";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat: @"总计:%@份\n%@",self.allNumber,promptStr]];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:15]
     
                          range:NSMakeRange(3, self.allNumber.length+1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(3, self.allNumber.length+1)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
     
                          range:NSMakeRange(self.allNumber.length+5, promptStr.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor grayColor]
     
                          range:NSMakeRange(self.allNumber.length+5, promptStr.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [AttributedStr length])];
    self.AllLabel.attributedText = AttributedStr;
}
#pragma mark - 立即购买
- (IBAction)submitBtnAction:(UIButton *)sender {
    //Push 跳转
    IndianaShopPayVC * VC = [[IndianaShopPayVC alloc]initWithNibName:@"IndianaShopPayVC" bundle:nil];
    IndianaUserSunModel * model = [IndianaUserSunModel new];
    model.goods_id = self.ShopModel.goods_id;
    model.times_id = self.ShopModel.times_id;
    model.times_no = self.ShopModel.times_no;
    model.number = self.allNumber;
    model.pay_amount = self.allNumber;
    model.goods_name = self.ShopModel.goods_name;
    model.goods_image = self.ShopModel.goods_image;
    VC.UserSunModel = model;
    [self.navigationController  pushViewController:VC animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end


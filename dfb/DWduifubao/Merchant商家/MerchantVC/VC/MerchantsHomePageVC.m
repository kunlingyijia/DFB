//
//  MerchantsHomePageVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantsHomePageVC.h"
#import "TravelSetHeaderView.h"
#import "MerchantsHomePageOneCell.h"
#import "MerchantsHomePageTwoCell.h"
#import "MerchantsOrderListVC.h"
#import "AccountInformationVC.h"
#import "MerchantCertificationModel.h"
@interface MerchantsHomePageVC (){
    TravelSetHeaderView *headerView;
}
@property(nonatomic,strong)  TravelSetHeaderView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)MerchantCertificationModel *MCModel;

@end

@implementation MerchantsHomePageVC
//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES  animated:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      //  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES  animated:NO];
    // 设置导航框是否透明
    //self.navigationController.navigationBar.alpha = 0;
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.navigationView = [[TravelSetHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [self.navigationView.leftBtn addTarget:self action:@selector(doBack:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
    headerView=[[TravelSetHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [headerView.leftBtn addTarget:self action:@selector(doBack:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView tableViewregisterNibArray:@[@"MerchantsHomePageOneCell",@"MerchantsHomePageTwoCell"]];
    
    
}
- (void)doBack:(id)sender{
    self.MerchantsHomePageVCBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    [self requestMyShopInfo];
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself requestMyShopInfo];
        
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    
    
}
#pragma mark -我的店铺信息（商户）
-(void)requestMyShopInfo{
    
   
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"merchant_id":self.merchant_id} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestMyShopInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"我的店铺信息（商户）--%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                
               
               
                   weakSelf.MCModel = [MerchantCertificationModel yy_modelWithJSON:response[@"data"]];
                
                headerView.title.text =weakSelf.MCModel.merchant_name;
               weakSelf.navigationView.title.text =weakSelf.MCModel.merchant_name;
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            MerchantsHomePageOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantsHomePageOneCell" forIndexPath:indexPath];
            [cell CellGetData:self.MCModel];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            
            
            break;
        }
            
        case 1:
        {
            MerchantsHomePageTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantsHomePageTwoCell" forIndexPath:indexPath];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;

            cell.MerchantsHomePageTwoCellBlock =^(NSInteger tag){
                [weakSelf MerchantsHomePageTwoCellBtn:tag];
                
            };
            
            return cell;
            break;
        }
            
            
        default:{
            MerchantsHomePageTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantsHomePageTwoCell" forIndexPath:indexPath];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;

            break;
            
        }
    }

    }

#pragma mark - cell 上Btn 点击事件
-(void)MerchantsHomePageTwoCellBtn:(NSInteger )tag{
    switch (tag) {
        case 0:
        {
            //Push 跳转
            MerchantsOrderListVC * VC = [[MerchantsOrderListVC alloc]initWithNibName:@"MerchantsOrderListVC" bundle:nil];
            VC.merchant_id = @"22";
            [self.navigationController  pushViewController:VC animated:YES];

            
            
            break;
        }
            
        case 1:
        {
            //Push 跳转
            AccountInformationVC * VC = [[AccountInformationVC alloc]initWithNibName:@"AccountInformationVC" bundle:nil];
            VC.merchant_id = @"22";
            [self.navigationController  pushViewController:VC animated:YES];

            break;
        }
            
        case 2:
        {
            
            break;
        }
            
            
       
        default:{
            
            break;
            
        }
    }

    
    
}



#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
             return 0.3*Width;
            
            break;
        }
            
        case 1:
        {
             return Width/10*3;
            break;
        }
            
        
            
        default:{
             return 0;
            break;
            
        }
    }

   
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-20) {
        self.navigationView.hidden = YES;
    }else if(scrollView.contentOffset.y>-19){
        self.navigationView.hidden = NO;
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

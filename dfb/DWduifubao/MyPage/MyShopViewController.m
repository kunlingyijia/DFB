//
//  MyShopViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyShopViewController.h"
#import "MyShopModel.h"
#import "LoginController.h"
#import "MyShopOneCell.h"
#import "MyShopTwoCell.h"
#import "MyShopThreeCell.h"
@interface MyShopViewController ()
@property (nonatomic,strong)NSMutableDictionary *CanshuDic;
@property (nonatomic,strong)MyShopModel *shopModel;
@property (nonatomic,strong)NSString *guanzhu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)CGFloat CellHeight;

@end

@implementation MyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    
    [self ShowNodataView];
    _CellHeight =0;
    [self.tableView tableViewregisterNibArray:@[@"MyShopOneCell",@"MyShopTwoCell",@"MyShopThreeCell"]];
    self.tableView.tableFooterView = [UIView new];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = self.titleStr;
    
    self.CanshuDic = [NSMutableDictionary dictionaryWithCapacity:1];
    // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //请求数据
    [self requestAction];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    if ([self.titleStr isEqualToString:@"我的店铺"]) {
        
         if (Token.length!= 0) {
             [self requestMyShopAction];
            }
        
    }else{
        //消费者进行网络请求
        [self request];
    }
    
       
    
   
    
}
#pragma mark -  店家自己进行网络请求
-(void)requestMyShopAction{
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestMyMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        NSLog(@"%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            [weakSelf HiddenNodataView];
            NSDictionary *dic = response[@"data"];
            weakSelf.shopModel = [MyShopModel yy_modelWithJSON:dic];
            
            weakSelf.guanzhu = self.shopModel.is_collect;
            weakSelf.title = _shopModel.merchant_name;
            [weakSelf.tableView reloadData];
            
        }else{
            [
              weakSelf showToast:response[@"msg"]];

        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];

}
#pragma mark -  消费者进行网络请求
-(void)request{
    MyShopModel * model = [[MyShopModel alloc]init];
    model.merchant_id = (int)self.merchant_id;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestMerchantInfo" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        NSLog(@"%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            [weakSelf HiddenNodataView];
            NSDictionary *dic = response[@"data"];
            weakSelf.shopModel = [MyShopModel yy_modelWithJSON:dic];
            //控件赋值
            weakSelf.title = model.merchant_name;
            weakSelf.title = _shopModel.merchant_name;
            //[weakSelf KongJianFuZhi:_shopModel];
            weakSelf.guanzhu = self.shopModel.is_collect;
            [weakSelf.tableView reloadData];
        }else{
            [
             weakSelf showToast:response[@"msg"]];
            
        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
}


#pragma mark - 拨打电话
- (void)callPhoneAction:(NSString *)str1 {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",str1];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
}


#pragma mark - //关注
- (void)GuanZhu {
    NSString *Token =[AuthenticationModel getLoginToken];
    MyShopModel *model = [[MyShopModel alloc]init];
    model.merchant_id = self.shopModel.merchant_id;
    if ([self.guanzhu isEqualToString:@"1"]) {
        model.is_collect = @"0";
        self.guanzhu = @"0";

    }else{
        self.guanzhu = @"1";
        model.is_collect = @"1";

    }
    NSLog(@"--%d",model.merchant_id);
    __weak typeof(self) weakSelf = self;

    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchant" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"关注%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
               //添加通知刷新店铺界面
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh_StorePageVC" object:nil userInfo:nil];
                if ([weakSelf.shopModel.is_collect isEqualToString:@"1"]) {
                    [weakSelf showToast:@"取消关注"];
                    
                }else if ([weakSelf.shopModel.is_collect isEqualToString:@"0"]) {
                    [weakSelf showToast:@"关注成功"];
                    
                }

                [self requestAction];
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        [self pushLoginController];
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
    
    return 3;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            
            MyShopOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyShopOneCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;

            cell.cell =^(){
                [ weakSelf GuanZhu ];
            };
            //cell 赋值
            [cell CellGetData:self.shopModel];
            return cell;

            
            break;
        }
            
        case 1:
        {
            MyShopTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyShopTwoCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;

            cell.cell =^(NSString *str){
                [weakSelf callPhoneAction:str];
            };
            
            
            [cell CellGetData:self.shopModel];
            return cell;

            break;
        }
        case 2:
        {
            MyShopThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyShopThreeCell" forIndexPath:indexPath];
//            CGFloat  h1 =  [self heightWithWord:cell.content.text withSize:CGSizeMake(Width-100, 10000) withFont:14];
//            CGFloat  h2 =  [self heightWithWord:cell.address.text withSize:CGSizeMake(Width-100, 10000) withFont:14];
//            _CellHeight = h1+h2;
            //cell 赋值
            [cell CellGetData:self.shopModel];
            return cell;
            
            break;
        }

            
            
        default:{
            MyShopTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyShopTwoCell" forIndexPath:indexPath];
           
            //cell 赋值
            [cell CellGetData:self.shopModel];
            return cell;
            break;
            
        }
    }

    
    
    
    // cell 其他配置
    
    
    /*
     //cell选中时的颜色 无色
    
     //cell 背景颜色
     cell.backgroundColor = [UIColor yellowColor];
     //分割线
     
     */
   }
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return Width*2/5;

    }else{
        
//        MyShopTwoCell * cel = [tableView cellForRowAtIndexPath:indexPath];
        
       

        //用storyboard 进行自适应布局
        self.tableView.estimatedRowHeight = 2004;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        NSLog(@"---%f",_CellHeight);
        return self.tableView.rowHeight;
    }
    
    
}

//计算出文字的高度
-(CGFloat)heightWithWord:(NSString *)words withSize:(CGSize)wordSize withFont:(CGFloat )font{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    CGSize sizeForHeight = [words boundingRectWithSize:wordSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    NSLog(@"%f", sizeForHeight.height);
    return sizeForHeight.height;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    
    [VC LoginRefreshAction:^{
        
        [weakSelf requestAction];
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}

@end

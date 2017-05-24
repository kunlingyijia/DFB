//
//  MoneyViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MoneyViewController.h"
#import "ScoreRecordCell.h"
#import "ScoreRecordModel.h"
#import "PayViewController.h"
#import "SupplyShimingController.h"
#import "AuditViewController.h"
#import "MyShopViewController.h"
#import "FailureViewController.h"
#import "UPNembersViewController.h"
#import "BuyNemberViewController.h"
#import "LoginController.h"
#import "WithdrawalViewController.h"
#import "BackgroundService.h"
#import "ExchangeGoldVC.h"
@interface MoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
///请求类型
@property(nonatomic,assign) int type;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)BOOL isWithdraw;
@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];

     self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    if ([self.title isEqualToString:@"现金记录"]) {
        //创建现金充值/提现按钮
        [self addChongZhiAndTiXianBtn];
    }else if ([self.title isEqualToString:@"兑富金币记录"]){
        //兑富金币充值
        [self addChongZhiBtn];

    }
   
    self.pageIndex = 1;
    self.type = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
   
    self.titlelabel.text = self.titlelab;
   // self.virtual_glodAndcashLabel.text = [NSString stringWithFormat:@"%.2f",self.virtual_glodAndcash  ];
    //self.tableView.rowHeight = 61;
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreRecordCell" bundle:nil] forCellReuseIdentifier:@"ScoreRecord"];
    //请求数据
    //[self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
    self.tableView.tableFooterView = [[UIView alloc]init];

   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self requestMyselfAction];
    __weak typeof(self) weakSelf = self;
    //获取个人信息
    [BackgroundService requestPushVC:nil MyselfAction:^{
        if ([self.title isEqualToString:@"兑富金币记录"]) {
            weakSelf.virtual_glodAndcashLabel.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getvirtual_glod]floatValue]  ];
        }else{
            weakSelf.virtual_glodAndcashLabel.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getcash]floatValue]  ];
        }

    }];
    [self requestAction];

}

#pragma mark - 创建充值/提现按钮
-(void)addChongZhiAndTiXianBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 0, 80, 40);
    
    //[backBtn setTitle:@"充值/提现" forState:(UIControlStateNormal)];
    //backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn setImage: [UIImage imageNamed:@"现金记录-更多"] forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor colorWithHexString:kRedColor]forState:UIControlStateNormal];
   // [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(TopUp:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;

    
}

-(void)TopUp:(UIButton*)sender{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil    message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    __weak typeof(self) weakSelf = self;

    UIAlertAction * OKone = [UIAlertAction actionWithTitle:@"充值" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //Push 跳转
        PayViewController * VC = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
        VC.title = @"现金充值";
        [weakSelf.navigationController  pushViewController:VC animated:YES];
        
    }];
    UIAlertAction * OKtwo = [UIAlertAction actionWithTitle:@"提现" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _isWithdraw =YES;

       //去提现 进行会员判断
        [weakSelf ChongzhiPanduan];
        

        
    }];
    UIAlertAction * OKthree = [UIAlertAction actionWithTitle:@"兑换" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //去兑换 进行会员判断
        _isWithdraw =NO;
//        [weakSelf ChongzhiPanduan];
        //Push 跳转
        ExchangeGoldVC * VC = [[ExchangeGoldVC alloc]initWithNibName:@"ExchangeGoldVC" bundle:nil];
        VC.virtual_glodAndcash = [self.virtual_glodAndcashLabel.text floatValue];
        [self.navigationController  pushViewController:VC animated:YES];
        
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:OKone];
    [alertC addAction:OKtwo];
    
    [alertC addAction:OKthree];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
}
#pragma mark - 创建充值按钮
-(void)addChongZhiBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Golddeposits:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
   // self.navigationItem.rightBarButtonItem = backItem;
    
    
}
-(void)Golddeposits:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;

    [self alertActionSheetWithTitle:nil message:nil OKWithTitle:@"充值" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
        //Push 跳转
        PayViewController * VC = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
        VC.title = @"兑富金币充值";
        [weakSelf.navigationController  pushViewController:VC animated:YES];
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];
    
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}

-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:self.act sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"现金%@",response);
            if (self.pageIndex == 1) {
                [self.dataArray removeAllObjects];
            }
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    ScoreRecordModel *model = [ScoreRecordModel yy_modelWithJSON:dicdata];
                    [weakSelf.dataArray addObject:model];
                }
                
                //刷新
                [weakSelf.tableView reloadData];

            }else{
                [weakSelf showToast:response[@"msg"]];
 
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
   
    
}


#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
//设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreRecord" forIndexPath:indexPath];
    //设置点击tableViewCell不会变成灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ScoreRecordModel *model = self.dataArray [indexPath.row];
    if (model.type ==1) {
        cell.amount.text = [NSString stringWithFormat:@"+%.2f",model.amount];
    }else{
        cell.amount.text = [NSString stringWithFormat:@"-%.2f",model.amount];
    }
   // cell.amount.text = [NSString stringWithFormat:@"%ld",model.amount];
    cell.remark.text = [NSString stringWithFormat:@"%@",model.remark];
    cell.create_time.text = [NSString stringWithFormat:@"%@",model.create_time];
    
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 充值判断条件
-(void)ChongzhiPanduan{
   
    
   NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
   NSString *Token =[AuthenticationModel getLoginToken]
;

__weak typeof(self) weakSelf = self;

if (Token.length!= 0) {
    //Push 跳转
    //Push 跳转
    
    
    if ([type isEqualToString:@"2"]) {
        NSLog(@"认证成功");
        [self is_BuyHuiyuan];
    }  else if ([type  isEqualToString:@"1"]){
        NSLog(@"认证审核中");
        AuditViewController * adVC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
         adVC.titleStr =@"实名认证";
        [self.navigationController pushViewController:adVC animated:YES];
    }else if( [type  isEqualToString:@"3"]){
        NSLog(@"认证失败");
        FailureViewController * adVC = [[FailureViewController alloc]initWithNibName:@"FailureViewController" bundle:nil];
        [self.navigationController pushViewController:adVC animated:YES];
        
    }else{
        NSLog(@"未认证");
        UPNembersViewController * VC = [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
        VC.upBtnTitle =  @"实名认证";
        [self.navigationController pushViewController:VC animated:YES];
    }
}else{
    
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [weakSelf.navigationController  pushViewController:VC animated:YES];
    
}



}
#pragma mark - 我的代理  实名认证 成功 会员够买的状态
-(void)is_BuyHuiyuan{
    NSString*   user_type = [AuthenticationModel getuser_type];//会员状态 1 普通 2 创业
    if ([user_type isEqualToString:@"2"]) {
        
        
        if ( _isWithdraw ==YES) {
            //Push 跳转
            WithdrawalViewController * VC = [[WithdrawalViewController alloc]initWithNibName:@"WithdrawalViewController" bundle:nil];
            VC.virtual_glodAndcash = [self.virtual_glodAndcashLabel.text floatValue];
            [self.navigationController  pushViewController:VC animated:YES];
        }else if (_isWithdraw ==NO){
            
            //Push 跳转
            ExchangeGoldVC * VC = [[ExchangeGoldVC alloc]initWithNibName:@"ExchangeGoldVC" bundle:nil];
            VC.virtual_glodAndcash = [self.virtual_glodAndcashLabel.text floatValue];
            [self.navigationController  pushViewController:VC animated:YES];
        }
        
       
        }else{
        UPNembersViewController * UPVC= [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
        UPVC.upBtnTitle = @"立即升级";
        [self.navigationController pushViewController:UPVC animated:YES];
    }
    
    
    
}



@end

//
//  ScoreRecordController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ScoreRecordController.h"
#import "ScoreRecordCell.h"
#import "ScoreExchangeController.h"
#import "ScoreRecordModel.h"
#import "BackgroundService.h"
#import "ExchangeDFBaoController.h"

@interface ScoreRecordController ()<UITableViewDataSource,UITableViewDelegate>
//积分选择器
@property (weak, nonatomic) IBOutlet UISegmentedControl *JiFenSegmented;
@property (nonatomic, strong) UITableView *tableView; //积分的列表
///分页参数
@property(nonatomic,assign) int pageIndex;
///请求类型
@property(nonatomic,assign) int type;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ScoreRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"积分记录";
    self.pageIndex = 1;
    self.type = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    //个人总积分
    self.score.text = [NSString stringWithFormat:@"%ld",(long)self.scoreAll];
    //设置"兑换"的按钮样式
    UIButton *exchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    exchangeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [exchangeBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:exchangeBtn];
    
    //积分列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, Width, Height-144) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //设置TableView自定义Cell的样式
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ScoreRecordCell"];
       self.tableView.tableFooterView = [[UIView alloc]init];
     self.tableView.tableHeaderView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    //请求数据
    //[self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAction];
    __weak typeof(self) weakSelf = self;

    [BackgroundService requestPushVC:nil MyselfAction:^{
         weakSelf.score.text = [NSString stringWithFormat:@"%d",[[AuthenticationModel getscore]intValue]];
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
    //NSLog(@"Token----- %@",Token);
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"type":@(self.type)}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Score/requestScoreList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
           // NSLog(@"积分----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    ScoreRecordModel *model = [ScoreRecordModel yy_modelWithJSON:dicdata];
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
                
            }else{
                [weakself showToast:response[@"msg"]];

            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
      
    }
    
}


//设置"兑换"的按钮事件
- (void)exchangeBtnAction:(UIButton *)button {
    //Push 跳转
    ExchangeDFBaoController * VC = [[ExchangeDFBaoController alloc]initWithNibName:@"ExchangeDFBaoController" bundle:nil];
    VC.scoreAll = [[AuthenticationModel getscore]intValue];

    [self.navigationController  pushViewController:VC animated:YES];

//    ScoreExchangeController *scoreExchangeController = [[ScoreExchangeController alloc] initWithNibName:@"ScoreExchangeController" bundle:nil];
//    scoreExchangeController.scoreAll = [[AuthenticationModel getscore]intValue];
//    [self.navigationController pushViewController:scoreExchangeController animated:YES];
}

#pragma mark - UITableViewDataSource
//设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreRecordCell" forIndexPath:indexPath];
    //设置点击tableViewCell不会变成灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ScoreRecordModel *model = self.dataArray [indexPath.row];
//    if (model.type ==1 ) {
//        cell.amount.text = [NSString stringWithFormat:@"+%.2f",model.amount];
//    }else{
//         cell.amount.text = [NSString stringWithFormat:@"-%.2f",model.amount];
//    }
//   
//     cell.remark.text = [NSString stringWithFormat:@"%@",model.remark];
//    cell.create_time.text = [NSString stringWithFormat:@"%@",model.create_time];
    [cell cellGetData:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 240;
    return self.tableView.rowHeight;
    
}

//积分选择器点击事件
- (IBAction)JifenAction:(UISegmentedControl *)sender {
       switch (sender.selectedSegmentIndex) {
        case 0: {
            self.type =0;
            self.pageIndex = 1;
            [self requestAction];
        }
            break;
        case 1: {
            self.type =1;
            self.pageIndex = 1;

            [self requestAction];
            //NSLog(@"刷新收入");

        }
            break;
        case 2: {
            self.type =2;
            self.pageIndex = 1;
            [self requestAction];

        }
            break;
        default:{
            
        }
            break;
    }
}




@end

//
//  CalculationDetailsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CalculationDetailsVC.h"
#import "CalculationDetailsOneCell.h"
#import "IndianaUserSunModel.h"
#import "last_timeModel.h"
#define Controller  CalculationDetailsVC
@interface CalculationDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *luck_no;
@property (strong, nonatomic)  UITextView *computing_result;


@end
@implementation Controller
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
    self.title = @"计算详情";
    [self showBackBtn];
    ;
    [self setUpTableView];
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Width/9, Width, Height-64-Width*0.35-Width/9) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"CalculationDetailsOneCell"]];
    self. computing_result = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+5, Width-20, Width*0.35-40)];
    self.  computing_result.textColor = [UIColor whiteColor];
    self.  computing_result.backgroundColor = [UIColor clearColor];
    self.  computing_result.editable = NO;
    self.  computing_result.font = [UIFont systemFontOfSize:14];
    [self.  computing_result   setSelectable:NO];
    [self.view addSubview:self.computing_result];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    [self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
    NSLog(@"%@",[self.lasttimeModel yy_modelToJSONObject]);
     self.luck_no.text = [NSString stringWithFormat:@"  最终结果: %@  ",self.lasttimeModel.luck_no];
     self.computing_result.text = self.lasttimeModel.computing_result;
   
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
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 8.15 当期订单列表（计算结果）
-(void)requestAction{
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"times_id":(NSString*)self.lasttimeModel.times_id}mutableCopy];
    __weak typeof(self) weakself = self;
         BaseRequest *baseReq = [[BaseRequest alloc] init];
         baseReq.encryptionType = RequestMD5;
         baseReq.data =dic;
         [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbOrderCalList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {

            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];            if (weakself.pageIndex == 1) {
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
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    }else{
        CalculationDetailsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CalculationDetailsOneCell" forIndexPath:indexPath];
                //cell 赋值
        cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
                // cell 其他配置
        return cell;
        
        
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
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

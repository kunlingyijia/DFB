//
//  GoodsCommentsViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsCommentsViewController.h"
#import "Good_CommentsCell.h"
#import "CommentsModel.h"
@interface GoodsCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
//评价等级 1-好评 2-中评 3-差评
@property(nonatomic,strong)NSString *rank;

@end
@implementation GoodsCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //延迟
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"五秒");
        //[weakSelf  SET_DATA];
    });
 //[self SET_DATA];
        
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
   
   
    [self.tableView tableViewregisterNibArray: @[@"Good_CommentsCell"]];
    self.tableView.tableFooterView = [UIView new];
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.rank = @"";
    //上拉刷新下拉加载
    [self Refresh];
    //网络请求
    [self requestAction];
    
    
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
-(void)viewDidLayoutSubviews{
    self.viewConstraintsWidth.constant = 300;
}
#pragma mark - 网络请求
-(void)requestAction{
    
       CommentsModel *model = [[CommentsModel alloc]init];
    model.goods_id =self.goods_id;
    model.rank= self.rank;
    model.pageIndex =[NSString stringWithFormat:@"%d",self.pageIndex];
    model.pageCount = @"10";
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestCommentList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"评论列表----%@",response);
        if (baseRes.resultCode == 1) {
            if (_pageIndex ==1) {
                [weakself.dataArray removeAllObjects];

            }
            NSMutableArray *arr =response[@"data"][@"comment"];
            weakself.comment_num.text = [NSString stringWithFormat:@"%@",response[@"data"][@"comment_num"]];
             weakself.good_num.text = [NSString stringWithFormat:@"%@",response[@"data"][@"good_num"]];
            weakself.mid_num.text = [NSString stringWithFormat:@"%@",response[@"data"][@"mid_num"]];
            weakself.bad_num.text = [NSString stringWithFormat:@"%@",response[@"data"][@"bad_num"]];
            for (NSDictionary *dic in arr ) {
                CommentsModel *model = [CommentsModel  yy_modelWithJSON:dic];
                [weakself.dataArray addObject:model];
            }
            
        }
        [weakself.tableView reloadData];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return nil;
    }else{
    Good_CommentsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Good_CommentsCell" forIndexPath:indexPath];
    
    //cell 赋值
    [cell cellGetDAta:(CommentsModel *)self.dataArray[indexPath.row]];
       // cell 其他配置
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 全部评论
- (IBAction)AllCommentsAction:(UIButton *)sender {
    [self changeLabelColor:sender];
    self.rank = @"";
    self.pageIndex = 1;
    [self requestAction];
    
}
#pragma mark - 好评
- (IBAction)GoodCommentsAction:(UIButton *)sender {
    [self changeLabelColor:sender];
    self.rank = @"1";
    self.pageIndex = 1;
    [self requestAction];

}
#pragma mark - 中评
- (IBAction)MediumCommentsAction:(UIButton *)sender {
    [self changeLabelColor:sender];
    self.rank = @"2";
    self.pageIndex = 1;
    [self requestAction];



}
#pragma mark - 差评
- (IBAction)BadCommentsAction:(UIButton *)sender {
    [self changeLabelColor:sender];
    self.rank = @"3";
    self.pageIndex = 1;
    [self requestAction];

}
#pragma mark - 改变菜单label的颜色
-(void)changeLabelColor:(UIButton*)sender{
       for (id MainView in _bottomView.subviews) {
        if ([MainView isKindOfClass:[UIView class]]) {
            UIView *subView = MainView;
            
            for (id tempView in subView .subviews) {
                if ([tempView isKindOfClass:[UILabel class]]) {
                    UILabel *label = tempView;
                    label.textColor = [UIColor blackColor];
                }
            }
            
        }
        
        for (id tempView in sender.superview.subviews) {
            if ([tempView isKindOfClass:[UILabel class]]) {
                UILabel *label = tempView;
                label.textColor = [UIColor redColor];
            }
        }
    }

    
    
}
- (void)dealloc
{  [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
}
@end

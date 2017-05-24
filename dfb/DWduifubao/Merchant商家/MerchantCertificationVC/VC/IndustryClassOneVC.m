//
//  IndustryClassOneVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryClassOneVC.h"
#import "IndustryClassTwoVC.h"
#import "MyServiceCell.h"
#import "IndustryModel.h"
@interface IndustryClassOneVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation IndustryClassOneVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"选择经营品类";

    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"MyServiceCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    [self requestAction];
    
}

-(void)requestAction{
   NSString *Token= [AuthenticationModel getLoginToken];
   if (Token.length!= 0) {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
       __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Industry/requestIndustryList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"获取行业分类%@",response);
        if (baseRes.resultCode == 1) {
            NSMutableArray *arr = response[@"data"];
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary *dic in arr) {
                IndustryModel * model = [IndustryModel yy_modelWithJSON:dic];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showToast:baseRes.msg];
            
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
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyServiceCell" forIndexPath:indexPath];
    IndustryModel * model = self.dataArray[indexPath.row];
    cell.label.text = model.name;
       return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    IndustryClassTwoVC * VC = [[IndustryClassTwoVC alloc]initWithNibName:@"IndustryClassTwoVC" bundle:nil];
    
    IndustryModel * model = self.dataArray[indexPath.row];
    VC.dataArray = model._child;
    
    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.1;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

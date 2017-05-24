//
//  LeftMainViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LeftMainViewController.h"

#import "ClassModel.h"
#import "ClassLeftCell.h"
@interface LeftMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation LeftMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassLeftCell" bundle:nil] forCellReuseIdentifier:@"ClassLeftCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //数据请求
    [self requestAction];
       
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}







-(void)requestAction{
    NSMutableArray * marr = [AuthenticationModel objectForKey:@"leftVCData"];
    if (marr.count!=0) {
        [self.dataArray removeAllObjects];

        for (NSDictionary *dic in marr) {
            ClassModel *model = [ClassModel  yy_modelWithJSON:dic];
            [self.dataArray  addObject:model];
        }
        [self.tableView reloadData];
        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
        [    self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
        [self tableView: self.tableView
        didSelectRowAtIndexPath:path];
    }
    
    ClassModel *model = [[ClassModel alloc]init];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/C2CCategory/requestC2cCategoryList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakself.dataArray removeAllObjects];
            NSMutableArray * arr = response[@"data"];
            [AuthenticationModel setValue:response forkey:@"leftVCData"];
            for (NSDictionary *dic in arr) {
                ClassModel *model = [ClassModel  yy_modelWithJSON:dic];
                [weakself.dataArray  addObject:model];
            }
            
        }
        
        [weakself.tableView reloadData];
        if (weakself.dataArray.count !=0) {
            NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
            [    weakself.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
            NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
            [weakself tableView: weakself.tableView
        didSelectRowAtIndexPath:path];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"取消" object:nil];

        }else{
            
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"显示" object:nil];

        }
            } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return nil;
    }else{

    ClassLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassLeftCell" forIndexPath:indexPath];
    ClassModel *model = self.dataArray[indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"%@",model.category_name];
    return cell;
  }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    ClassModel *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftTabViewRefresh" object:self userInfo:[NSDictionary dictionaryWithObject:@(model.category_id )forKey:@"Leftcategory_id"]];
    //点cell 置顶
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //NSLog(@"%ld",indexPath.row);
    
}

@end

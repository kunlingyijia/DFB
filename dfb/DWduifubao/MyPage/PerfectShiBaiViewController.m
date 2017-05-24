//
//  PerfectShiBaiViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PerfectShiBaiViewController.h"
#import "PerfectDataController.h"
#import "PerfectDataMOdel.h"
@interface PerfectShiBaiViewController ()
    @property(nonatomic,strong) PerfectDataMOdel *perDataModel;
@end

@implementation PerfectShiBaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"完善资料";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.label.text = @"错误信息:";
    [self requestZiliaoAction];
    
}
#pragma mark -     请求完善资料接口
//请求完善资料接口

-(void)requestZiliaoAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestShopInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                self.label.text = [NSString stringWithFormat:@"错误信息:%@",            response[@"data"][@"remark"]
                                   ];
                self.perDataModel = [PerfectDataMOdel yy_modelWithJSON:response[@"data"]];
                //控件赋值
                self.perDataModel = [PerfectDataMOdel yy_modelWithJSON:response[@"data"]];
               // [self KongJianFuZhi:model];
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
}



- (IBAction)TiJiaoAction:(UIButton *)sender {
    //Push 跳转
    PerfectDataController * VC = [[PerfectDataController alloc]initWithNibName:@"PerfectDataController" bundle:nil];
     //修改
      VC.type = @"2";
      VC.perDataModel = self.perDataModel;
     NSLog(@"%@", VC.perDataModel.bank_name);
     [self.navigationController  pushViewController:VC animated:YES];

    
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

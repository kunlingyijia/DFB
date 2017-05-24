//
//  FailureViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "FailureViewController.h"
#import "RealNameCertificationController.h"
#import "PersonRenZhengModel.h"
@interface FailureViewController ()
    ///认证拒绝传的model
    @property (nonatomic, strong) PersonRenZhengModel *perModel ;
@end

@implementation FailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.label.text = @"错误信息:";
    [self requestAction];
    
}
-(void)requestAction{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestCertificationInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakSelf.view.userInteractionEnabled = YES;
                weakSelf.label.text = [NSString stringWithFormat:@"错误信息:%@",            response[@"data"][@"content"]
                                   ];
                weakSelf.perModel = [PersonRenZhengModel yy_modelWithJSON:response[@"data"]];
                
            }else{
                [weakSelf showToast:response[@"msg"]];

            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}

- (IBAction)BtnAction:(UIButton *)sender {
    RealNameCertificationController * VC = [[RealNameCertificationController alloc]initWithNibName:@"RealNameCertificationController" bundle:nil];
    VC.perModel = self.perModel;
    [self.navigationController pushViewController:VC animated:YES];
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

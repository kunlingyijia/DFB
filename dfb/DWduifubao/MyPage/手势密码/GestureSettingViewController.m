//
//  GestureSettingViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GestureSettingViewController.h"
#import "GestureSettingView.h"
#import "RequestFindPassword.h"
#import "DWTabBarController.h"
@interface GestureSettingViewController ()
@property(nonatomic,strong)GestureSettingView * gestureView;


@end

@implementation GestureSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title= @"设置手势密码";
     [self addGestureSettingViews
      ];
}
#pragma mark - 添加设置手势view
-(void)addGestureSettingViews{
    
    self.gestureView = [NIBHelper instanceFromNib:@"GestureSettingView"];
    _gestureView.frame = CGRectMake(0, -30, self.view.frame.size.width, Height+30);
    [self.view addSubview:_gestureView];
    
    __weak typeof(self) weakSelf = self;
    
    [_gestureView GestureReturnStr:^(NSString *password) {
        NSLog(@"%@",password);
       //设置成功--吊接口
        [weakSelf requestAction:password];
        
        
    }];

    
}
-(void)requestAction:(NSString * )password{
    NSString *Token =[AuthenticationModel getLoginToken];
    
    RequestFindPassword *model = [[RequestFindPassword alloc]init];
    model.handle_password = password;
    model.type = @"2";
    __weak typeof(self) weakSelf = self;

    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestHandlePassword" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"-手势密码-%@",response);
            if (baseRes.resultCode == 1) {
                //保存手势密码
                [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"myPassword"];
                //Push 跳转
                DWTabBarController * VC = [[DWTabBarController alloc]init];
                VC.selectedIndex = 3;
                [weakSelf presentViewController:VC animated:NO completion:nil];
  
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
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

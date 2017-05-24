//
//  GestureVerificationViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GestureVerificationViewController.h"
#import "GesturePasswordView.h"
#import "GestureSettingViewController.h"
#import "GestureFindPasswordViewController.h"
#import "RequestFindPassword.h"
@interface GestureVerificationViewController ()
@property(nonatomic,strong)GesturePasswordView * gestureView;
@end

@implementation GestureVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showBackBtn];
    self.title= @"验证手势密码";
    [self addgestureView];
}
#pragma mark -//添加手势密码锁
-(void)addgestureView{
    
    
    self.gestureView = [NIBHelper instanceFromNib:@"GesturePasswordView"];
    _gestureView.frame = CGRectMake(0, -30, self.view.frame.size.width, Height-30);
    _gestureView.gestureLabel.text = @"请输入原手势密码";
    _gestureView.logoutBtn.hidden = YES;
    [self.view addSubview:_gestureView];
    __weak typeof(self) weakSelf = self;
    [_gestureView GestureReturnStr:^(NSString *password) {
        NSLog(@"%@",password);
        
        [weakSelf requestAction:password];
        
        
    }];
    //忘记手势密码
    [_gestureView GestureForgetPassword:^() {
        // 跳转到找回密码
        [weakSelf FindPasswordPushViewController];
        
    }];
    //    //退出登录
    //    [_gestureView GestureLogOut:^() {
    //    [AuthenticationModel moveLoginToken];
    //    [AuthenticationModel moveLoginKey];
    //
    //
    //    }];
    
}

#pragma mark - 请求验证手势密码
-(void)requestAction:(NSString * )password{
    NSString *Token =[AuthenticationModel getLoginToken];
    
    RequestFindPassword *model = [[RequestFindPassword alloc]init];
    model.handle_password = password;
    model.type = @"1";
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
                //Push 跳转
                 [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"myPassword"];GestureSettingViewController * VC = [[GestureSettingViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
                [self.navigationController  pushViewController:VC animated:YES];
               
            }else if(baseRes.resultCode == 35){
   
                _gestureView.gestureLabel.textColor= [UIColor redColor];
                _gestureView.gestureLabel.text =response[@"msg"];
                
            }else if(baseRes.resultCode == 36){
                UIAlertController * alVC = [UIAlertController alertControllerWithTitle:@"" message:response[@"msg"] preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction * OK = [UIAlertAction actionWithTitle:@"重置手势密码" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf FindPasswordPushViewController];
                }];
                [alVC addAction:OK];
                [self presentViewController:alVC animated:YES completion:nil];
                //手势密码输入次数已达上限 --跳转到找回密码
                
                
            }else{
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
#pragma mark - 跳转到找回密码
-(void)FindPasswordPushViewController{
    GestureFindPasswordViewController * VC = [[GestureFindPasswordViewController alloc]initWithNibName:@"GestureFindPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _gestureView.gestureLabel.textColor= [UIColor blackColor];
    _gestureView.gestureLabel.text = @"请输入原手势密码";
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

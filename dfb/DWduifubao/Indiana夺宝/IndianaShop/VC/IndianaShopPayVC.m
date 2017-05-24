//
//  IndianaShopPayVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaShopPayVC.h"
#import "SetPayPasswordController.h"
#import "IndianaMyVC.h"
#import "IndianaUserSunModel.h"
#import "LoginController.h"
@interface IndianaShopPayVC ()<JHCoverViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JHCoverView *coverView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *times_no;
@property (weak, nonatomic) IBOutlet UILabel *allNumber;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;


@end

@implementation IndianaShopPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
   
    
}
- (IBAction)phoneTfAction:(UITextField *)sender {
    if (sender.text.length>0
) {
     self.submitBtn.backgroundColor = [UIColor redColor];
        self.submitBtn.userInteractionEnabled = YES;
    }else{
    self.submitBtn.userInteractionEnabled = NO;
    self.submitBtn.backgroundColor = [UIColor grayColor];
    }
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.submitBtn.backgroundColor = [UIColor grayColor];
    self.submitBtn.userInteractionEnabled = NO;
    [self.goods_image.layer setLaberMasksToBounds:YES cornerRadius:5.0 borderWidth:0.8 borderColor:[UIColor colorWithHexString:kViewBackgroundColor]];
    self.title = @"订单详情";
    [self showBackBtn];
    //密码支付锁
    [self MimaZhiFu];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
 
    [self.goods_image SD_WebimageUrlStr:self.UserSunModel.goods_image placeholderImage:nil];
    self.goods_name.text = self.UserSunModel.goods_name;
    self.times_no.text =[NSString stringWithFormat:@"第%@期", self.UserSunModel.times_no];
    self.allNumber.text =[NSString stringWithFormat:@"此单参与%@人次", self.UserSunModel.number];
    self.pay_amount.text =[NSString stringWithFormat:@"实付兑富币: %@", self.UserSunModel.number];
    NSLog(@"%@",[self.UserSunModel yy_modelToJSONObject]);
    
}
#pragma mark - 立即购买
- (IBAction)submitBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self IF]) {
    NSString * isset_paypwd  = [NSString stringWithFormat:@"%@",[AuthenticationModel getisset_paypwd]];
        __weak typeof(self) weakSelf = self;
    if ( [isset_paypwd isEqualToString:@"0"]) {
        //说明没有支付密码
        [self alertWithTitle:@"设置支付密码" message:nil OKWithTitle:@"去设置" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
            VC.title = @"设置支付密码";
            [weakSelf.navigationController pushViewController:VC animated:YES];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }else{
        self.coverView.hidden = NO;
        [self.coverView.payTextField becomeFirstResponder];
    }
}



}


#pragma mark - 密码支付锁
//密码支付锁
-(void)MimaZhiFu{
    [self.view layoutIfNeeded];
    
    JHCoverView *coverView = [[JHCoverView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    coverView.delegate = self;
    self.coverView = coverView;
    coverView.hidden = YES;
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:coverView];
}

/**
 忘记密码
 */
- (void)forgetPassWordCoverView:(JHCoverView *)control
{
    SetPayPasswordController *setPay = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
    setPay.title = @"修改支付密码";
    setPay.act = @"act=Api/User/requestUpdatePayPassword";
    [self.navigationController pushViewController:setPay animated:YES];
    
    NSLog(@"忘记密码");
}
//密码正确
- (void)inputCorrectCoverView:(JHCoverView *)control password:(NSString *)passWord
{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        self.UserSunModel.tel =self.phoneTf.text;
        self.UserSunModel.pay_password =[passWord MD5Hash];
        self.UserSunModel.ip =[NSString getIPAddress:NO];
        NSLog(@"%@",[self.UserSunModel yy_modelToJSONObject]);
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[self.UserSunModel yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbPayOrder sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                [weakself showToast:response[@"msg"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //刷新一元购首页
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshIndianaHomeVC" object:nil];
                    //Push 跳转
                    IndianaMyVC * VC = [[IndianaMyVC alloc]initWithNibName:@"IndianaMyVC" bundle:nil];
                    [weakself.navigationController  pushViewController:VC animated:YES];

                });
                
                
                
            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakself showToast:@"支付密码错误"];
                [weakself alertWithTitle:@"支付密码错误" message: response[@"msg"] OKWithTitle:@"重新支付" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    weakself.coverView.hidden = NO;
                    [weakself.coverView.payTextField becomeFirstResponder];
                } withCancel:^(UIAlertAction *cancelaction) {
                    SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                    VC.title = @"设置支付密码";
                    [weakself.navigationController pushViewController:VC animated:YES];
                }];
            }else if ([response[@"resultCode"] isEqualToString:@"34"]) {
                //                [weakself showToast:@"支付已被冻结，请隔天再试"];
                
                [ weakself alertWithTitle:@"支付已被冻结"message:response[@"msg"] OKWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    
                }];
                
                
            }else if ([response[@"resultCode"] isEqualToString:@"2006"]) {
                [weakself showToast:@"已经是创业会员"];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        [self pushLoginController];
    }
}

#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    if ([YanZhengOBject IsPhoneNumber:self.phoneTf.text]== NO) {
        [self showToast:@"请输入正确的手机号"];
        return NO;
    }
    
    
    return Y;
}



#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
    
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
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

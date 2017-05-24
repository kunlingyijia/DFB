//
//  ChageNameController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ChageNameController.h"
#import "PersonChangeModel.h"
@interface ChageNameController ()
@property (weak, nonatomic) IBOutlet UITextField *ChangeNameTextfield;

@end

@implementation ChageNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    self.ChangeNameTextfield.text = self.nick_name;
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    //4.配置right区域
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:    self    action:@selector(handleReply:)];
    
    rightButton.tintColor = [UIColor colorWithHexString:kTitleColor];
    
    
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
-(void)handleReply:(UIBarButtonItem*)sender{
    
    if ([self.nick_name isEqualToString:self.ChangeNameTextfield.text]) {
        [self showToast:@"新昵称不能和旧昵称相同"];
        return;
    }
    
    if (self.ChangeNameTextfield.text.length>1&&self.ChangeNameTextfield.text.length<21) {
        [self requestAction:self.ChangeNameTextfield.text];
    }else{
        [self showToast:@"请输入2-20个字符"];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clearTextfield:(UIButton *)sender {
    self.ChangeNameTextfield.text = @"";
}
-(void)requestAction:(NSString*)nick_name{
    
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];

    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"nick_name":nick_name} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUpdateUserInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                if ([weakself.delegate respondsToSelector:@selector(changenick_name:)]) {
                    [weakself.delegate changenick_name:nick_name];
                }
                //[weakself showToast:@"修改成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }else {
                [weakself showToast:response[@"msg"]];
            }
            NSLog(@"-------------%@",nick_name);
            
            
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            
        }];
        
    }else {
        [weakself showToast:@"请登录后修改"];
        //[weakself.navigationController popViewControllerAnimated:YES];
    }
    
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

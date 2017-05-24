//
//  BankChangeViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BankChangeViewController.h"
#import "PersonBankModel.h"
#import "PickerView.h"
#import "SetPayPasswordController.h"
#import "BackgroundService.h"
#import "DWBankViewController.h"
#import "PersonRenZhengModel.h"
#import "Bank_Region_Bank_Branch.h"
@interface BankChangeViewController ()<JHCoverViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
///
@property (nonatomic, strong) JHCoverView *coverView;
@property(nonatomic,strong)NSMutableArray*bankArray;
@end

@implementation BankChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
   
    self.title = @"修改银行卡";
    self.bankArray = [NSMutableArray arrayWithCapacity:1];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.bank_nameBtn setTitle:self.perModel.bank_name forState:(UIControlStateNormal)]  ;
    self.subbranchTF.text =self.perModel.subbranch;
    self.bank_account_numbertextf.text =self.perModel.bank_account_number;
    [DWHelper SD_WebImage:self.bankCardFacade imageUrlStr:self.perModel.bank_card_photo placeholderImage:nil];
    //密码支付锁
    [self MimaZhiFu];
    //请求配置信息网络请求
    [BackgroundService PeizhiPushVC:nil RequestAction:^{
    }];
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Bank_Region_Bank_BranchAction:) name:@"Bank_Region_Bank_Branch" object:nil];
    
}
#pragma mark - 创建观察者返回数据
-(void)Bank_Region_Bank_BranchAction:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"Bank_Region_Bank_Branch"];
     Bank_Region_Bank_BranchModel * model = [Bank_Region_Bank_BranchModel yy_modelWithJSON:dic];
    [self.bank_nameBtn setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.subbranchTF.text =model .bank_branch;
    self.perModel.provide = model.province_name;
    self.perModel.province_id = model.province_id;
    self.perModel.city = model.city_name;
    self.perModel.city_id = model.city_id;
    self.perModel.subbranch =model.bank_branch;
    self.perModel.bank_branch_no =model.bank_branch_no;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取个人资料
     [BackgroundService requestPushVC:self MyselfAction:^{
         
     }];
}

#pragma mark - 修改按钮
- (IBAction)ChangeBackAction:(UIButton *)sender {
    if (self.bank_account_numbertextf.text.length==16||self.bank_account_numbertextf.text.length==19) {
    }else{
        [self showToast:@"银行卡号输入错误"];
        return;
    }
   
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
#pragma mark ---- 银行列表网络请求
- (IBAction)BankRequestAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    DWBankViewController * VC = [[DWBankViewController alloc]initWithNibName:@"DWBankViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
    
}
#pragma mark -  上传"银行卡正面"的View事件
- (IBAction)bankCardFacadeViewAction:(UIButton *)sender {

    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType = EditedImage;
    VC.zoom= 0.5;
    __weak typeof(self) weakSelf = self;
    VC.ImageChooseVCBlock =^(UIImage *image){
        [[DWHelper shareHelper] UPImageToServer:@[image] toKb:70 success:^(NSArray *urlArr) {
            NSDictionary * dic = urlArr[0];
            weakSelf.perModel.bank_card_photo = dic[@"url"];
            weakSelf.bankCardFacade.image = image;
        } faild:^(id error) {
            
        }];
        
        
    };
    [self presentViewController:VC animated:NO completion:^{
    }];

    

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
    
}
/**
 JHCoverViewDelegate的代理方法，密码输入正确
 */
- (void)inputCorrectCoverView:(JHCoverView *)control password:(NSString *)passWord
{
    PersonRenZhengModel *Model = [[PersonRenZhengModel alloc]init ];
    Model.bank_account_number = self.bank_account_numbertextf.text;
    Model.bank_name = self.bank_nameBtn.titleLabel.text;
    Model.province_id = self.perModel.province_id;
    Model.city_id = self.perModel.city_id;
    Model.subbranch = self.perModel.subbranch;
    Model.bank_branch_no = self.perModel.bank_branch_no;
        Model.bank_card_photo = self.perModel.bank_card_photo;
    Model.pay_password = [passWord MD5Hash];
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[Model yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Finance/requestUpdateBank" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakSelf showToast:@"支付密码错误"];
                [weakSelf alertWithTitle:@"支付密码错误" message: response[@"msg"]OKWithTitle:@"重试" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    weakSelf.coverView.hidden = NO;
                    [weakSelf.coverView.payTextField becomeFirstResponder];
                } withCancel:^(UIAlertAction *cancelaction) {
                    SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                    VC.title = @"设置支付密码";
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }];
            }else if ([response[@"resultCode"] isEqualToString:@"34"]) {
                [ weakSelf alertWithTitle:@"支付已被冻结"message:response[@"msg"] OKWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    
                }];
                
            }else {
                [weakSelf showToast:response[@"msg"]];

            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }


}

#pragma mark ---    //图片上传请求
//图片上传请求
-(void)imageRequestAction:(UIImage*)image{
    NSString *password = [NSString stringWithFormat:@"%@%@%@",[AuthenticationModel getimage_account],[AuthenticationModel getimage_hostname],[AuthenticationModel getimage_password]];
    //NSLog(@"%@",password);
    NSDictionary * dic = @{@"image_account":[AuthenticationModel getimage_account],@"image_password":[password MD5Hash]};
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[AuthenticationModel getimage_hostname] parameters:[dic yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //1.把图片转换成二进制流
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        //2.上传图片
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"img.jpg" mimeType:@"jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr =responseObject[@"data"];
        
        // NSLog(@"上图%@",responseObject);
        for (NSDictionary *dic in arr) {
            NSLog(@"%@",dic[@"url"]);
            weakself.perModel.bank_card_photo = dic[@"url"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

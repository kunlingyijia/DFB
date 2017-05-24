//
//  BankChangeVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BankChangeVC.h"

#import "PersonBankModel.h"
#import "PickerView.h"
#import "SetPayPasswordController.h"
#import "BackgroundService.h"
#import "DWBankViewController.h"
#import "PersonRenZhengModel.h"
#import "Bank_Region_Bank_Branch.h"
@interface BankChangeVC ()<JHCoverViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
///
@property (nonatomic, strong) JHCoverView *coverView;
@property(nonatomic,strong)NSMutableArray*bankArray;
//imageView 记录被点击
@property(nonatomic,assign)BOOL is_one;
@property(nonatomic,assign)BOOL is_two;
@property(nonatomic,assign)BOOL is_three;
@property(nonatomic,assign)BOOL is_four;
@property(nonatomic,assign)BOOL is_five;
//图片标志
@property(nonatomic,strong) NSString * imageId;
//图片数组
@property(nonatomic,strong) NSMutableArray * imageArray;
@end

@implementation BankChangeVC
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray arrayWithCapacity:1];
    }return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    //获取个人资料
    [BackgroundService requestPushVC:self MyselfAction:^{
        
    }];
    self.is_one = NO;
    self.is_two = NO;
    self.is_three = NO;
    self.is_four = NO;
    self.is_five = NO;
    self.imageArray  = [NSMutableArray arrayWithObjects:_bankCardFacade,_bank_card_back_photo,nil];
    self.title = @"修改银行卡";
    self.bankArray = [NSMutableArray arrayWithCapacity:1];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.bank_nameBtn setTitle:self.perModel.bank_name forState:(UIControlStateNormal)]  ;
    self.subbranchTF.text =self.perModel.subbranch;
    self.bank_account_numbertextf.text =self.perModel.bank_account_number;
    self.reserved_mobile.text =self.perModel.reserved_mobile;
    [DWHelper SD_WebImage:self.bankCardFacade imageUrlStr:self.perModel.bank_card_photo placeholderImage:nil];
    [DWHelper SD_WebImage:self.bank_card_back_photo imageUrlStr:self.perModel.bank_card_back_photo placeholderImage:nil];
    
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
    
}

#pragma mark - 修改按钮
- (IBAction)ChangeBackAction:(UIButton *)sender {
    
    if (self.bankCardFacade.image ==nil) {
        [self showToast:@"请选择银行卡正面照"];
        return;
    }
    if (self.bank_card_back_photo.image ==nil) {
        [self showToast:@"请选择银行卡反面照"];
        return;
    }
    
    if (self.bank_account_numbertextf.text.length==16||self.bank_account_numbertextf.text.length==19) {
    }else{
        [self showToast:@"银行卡号输入错误"];
        return;
    }
    if ([self.reserved_mobile.text isPhoneNumber] ==NO) {
        [self showToast:@"手机号码格式不正确"];
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





#pragma mark - 上传"银行卡正面"的View事件
- (IBAction)bankCardFacadeViewAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"3";
    [self addImage];
    
}
#pragma mark - 上传"银行卡反面"的View事件
- (IBAction)bank_card_back_photoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"4";
    [self addImage];
}

#pragma mark - 添加照片
-(void)addImage{
    
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType = EditedImage;
    VC.zoom= 0.6;
    __weak typeof(self) weakSelf = self;
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        if ([weakSelf.imageId isEqualToString:@"3"]){
            weakSelf.bankCardFacade.image = image;
            weakSelf.is_three = YES;
            
        }else if ([weakSelf.imageId isEqualToString:@"4"]){
            weakSelf.bank_card_back_photo.image = image;
            weakSelf.is_four = YES;
        }
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}


//#pragma mark -  上传"银行卡正面"的View事件
//- (IBAction)bankCardFacadeViewAction:(UIButton *)sender {
//    
//    [self.view endEditing:YES];
//    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
//    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    VC.imageType = EditedImage;
//    VC.zoom= 0.5;
//    __weak typeof(self) weakSelf = self;
//    VC.ImageChooseVCBlock =^(UIImage *image){
//        [[DWHelper shareHelper] UPImageToServer:@[image] toKb:70 success:^(NSArray *urlArr) {
//            NSDictionary * dic = urlArr[0];
//            weakSelf.perModel.bank_card_photo = dic[@"url"];
//            weakSelf.bankCardFacade.image = image;
//        } faild:^(id error) {
//            
//        }];
//        
//        
//    };
//    [self presentViewController:VC animated:NO completion:^{
//    }];
//    
//    
//    
//}

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
    
    
    NSMutableArray *arr =[NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i< self.imageArray.count; i++) {
        UIImageView * imageview = self.imageArray [i];
        [arr addObject:imageview.image];
    }
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper]UPImageToServer:arr toKb:200 success:^(NSArray *urlArr) {
        //创业会员实名认证添加/修改
        [ weakSelf backChange:urlArr[0][@"url"] str2:urlArr[1][@"url"]password:passWord];
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;
    }];
    
    
    
    
    
    
    
    
}
#pragma mark - 银行卡修改
-(void)backChange:(NSString*)str1 str2:(NSString*)str2 password:(NSString *)passWord{
    
    
    PersonRenZhengModel *Model = [[PersonRenZhengModel alloc]init ];
    Model.bank_account_number = self.bank_account_numbertextf.text;
    Model.reserved_mobile = self.reserved_mobile.text;
    Model.bank_name = self.bank_nameBtn.titleLabel.text;
    Model.province_id = self.perModel.province_id;
    Model.city_id = self.perModel.city_id;
    Model.subbranch = self.perModel.subbranch;
    Model.bank_branch_no = self.perModel.bank_branch_no;
    
    Model.bank_card_photo =
    str1;
    Model.bank_card_back_photo =
    str2;
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
                weakSelf.view.userInteractionEnabled = YES;
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
                weakSelf.view.userInteractionEnabled = YES;
                [ weakSelf alertWithTitle:@"支付已被冻结"message:response[@"msg"] OKWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    
                }];
                
            }else {
                [weakSelf showToast:response[@"msg"]];
                weakSelf.view.userInteractionEnabled = YES;
                
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }

    
    
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

//
//  RealNameCertificationController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/11.
//  Copyright © 2016年 bianming. All rights reserved.
//
#import "RealNameCertificationController.h"
#import "MyPageController.h"
#import "PersonChangeModel.h"
#import "CityModel.h"
#import "PersonBankModel.h"
#import "PickerView.h"
#import "YanZhengOBject.h"
#import "PersonRenZhengModel.h"
#import "AuditViewController.h"
#import "DWBankViewController.h"
#import "Bank_Region_Bank_Branch.h"
@interface RealNameCertificationController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


//@property (nonatomic, strong) UIButton *imageBtn;
//验证
//图片数组
@property(nonatomic,strong) NSMutableArray * imageArray;
//图片标志
@property(nonatomic,strong) NSString * imageId;
//银行数组
//@property(nonatomic,strong)NSMutableArray *bankArray;
//imageView 记录被点击
@property(nonatomic,assign)BOOL is_one;
@property(nonatomic,assign)BOOL is_two;
@property(nonatomic,assign)BOOL is_three;
@property(nonatomic,assign)BOOL is_four;
@property(nonatomic,assign)BOOL is_five;
@property (nonatomic, strong) PersonRenZhengModel *personModel ;
@end
@implementation RealNameCertificationController
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray arrayWithCapacity:1];
    }return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"实名认证";
//赋值
    self.is_one = NO;
    self.is_two = NO;
    self.is_three = NO;
    self.is_four = NO;
    self.is_five = NO;
    self.personModel = [[PersonRenZhengModel alloc]init];
    self.address.placeholder = @"例如:XX省XX市XX县/区XX街道XX小区XX号门";
    self.imageArray  = [NSMutableArray arrayWithObjects:_identityCardFacade,_identityCardBack,_bankCardFacade,_bank_card_back_photo, _identityAndBankCard,nil];
    self.contentSizeHeight.constant = Height*1.8;
    NSLog(@"%f",_SubmitBtn.frame.origin.y);
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    
       if([type isEqualToString:@"3"]){
        NSLog(@"认证拒绝");
    self.personModel = self.perModel;
       //控件赋值
   [self KongjianFuzhi:self.personModel];
        
        
    }
    if ([self.personModel.is_old isEqualToString:@"1"]) {
        //是老客户
        [self OldXianZhi];
    }else{
        
    }

    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Bank_Region_Bank_BranchAction:) name:@"Bank_Region_Bank_Branch" object:nil];
    
}
#pragma mark - 创建观察者返回数据
-(void)Bank_Region_Bank_BranchAction:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"Bank_Region_Bank_Branch"];
    Bank_Region_Bank_BranchModel * model = [Bank_Region_Bank_BranchModel yy_modelWithJSON:dic];
    [self.bank_nameBtn setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.subbranchTF.text = model.bank_branch;
    self.personModel.provide = model.province_name;
    self.personModel.province_id = model.province_id;
    self.personModel.city = model.city_name;
    self.personModel.city_id = model.city_id;
    self.personModel.subbranch =model.bank_branch;
    self.personModel.bank_branch_no =model.bank_branch_no;
    self.personModel.zone = [NSString stringWithFormat:@"%@%@",model.province_name,model.city_name];
 NSLog(@"支行行号----%@",model.bank_branch_no);
}
-(void)OldXianZhi{
    
    //身份证正面
    self.identityCardFacadeBtn.userInteractionEnabled = NO;    //身份证反面
    self.identityCardBackBtn .userInteractionEnabled = NO;
    //银行卡正面
    self.bankCardFacadeBtn.userInteractionEnabled = NO;
    //银行卡反面
    self.bank_card_back_photoBtn.userInteractionEnabled = NO;
    //手持身份证＋银行卡
    self.identityAndBankCardBtn .userInteractionEnabled = NO;
    //姓名
    self.nameTextfield.userInteractionEnabled = NO;    //开户行
    self.subbranchTF.userInteractionEnabled = NO;
    ///身份证
    self.IDbankTextfield.userInteractionEnabled = NO;    ///银行卡号
    self.bank_account_numbertextf.userInteractionEnabled = NO;
    
}
#pragma mark ---- 选择开户行
- (IBAction)BankRequestAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    DWBankViewController * VC = [[DWBankViewController alloc]initWithNibName:@"DWBankViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
    
}
#pragma mark -  控件赋值
-(void)KongjianFuzhi:(PersonRenZhengModel*)model{
     //身份证正面
    [self.identityCardFacade sd_setImageWithURL:[NSURL URLWithString:model.id_card_photo]];
       //身份证反面
    [self.identityCardBack sd_setImageWithURL:[NSURL URLWithString:model.id_card_back_photo]];
    //银行卡正面
    [self.bankCardFacade sd_setImageWithURL:[NSURL URLWithString:model.bank_card_photo]];
    //银行卡反面
    [self.bank_card_back_photo sd_setImageWithURL:[NSURL URLWithString:model.bank_card_back_photo]];
      //手持身份证＋银行卡
    [self.identityAndBankCard sd_setImageWithURL:[NSURL URLWithString:model.person_photo]];
    //姓名
    self.nameTextfield.text  = model.real_name;
    //开户行
    [self.bank_nameBtn setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.subbranchTF.text = model.subbranch;
    ///身份证
    self.IDbankTextfield.text = model.id_card;
    ///银行卡号
    self.bank_account_numbertextf.text = model.bank_account_number;
    ///银行卡预留电话
    self.reserved_mobile.text = model.reserved_mobile;
    ///详细地址
    self.address.text = model.address;
    
}
#pragma mark -  上传"身份证正面"的View事件
- (IBAction)identityCardFacadeViewAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"1";
    //[self addImageOFaddressPerson];
    [self addImage];
}
#pragma mark - 上传"身份证反面"的View事件
- (IBAction)identityCardBackViewAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"2";
    //[self addImageOFaddressPerson];
    [self addImage];

}
#pragma mark - 上传"银行卡正面"的View事件
- (IBAction)bankCardFacadeViewAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"3";
    //[self addImageOFaddressPerson];
    [self addImage];

}
#pragma mark - 上传"银行卡反面"的View事件
- (IBAction)bank_card_back_photoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"4";
    //[self addImageOFaddressPerson];
    [self addImage];
}




#pragma mark - 上传"手持身份证＋银行卡"的View事件
- (IBAction)identityAndBankCardViewAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.imageId = @"5";
    //[self addImageOFaddressPerson];
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
        if ([weakSelf.imageId isEqualToString:@"1"]) {
            weakSelf.identityCardFacade.image = image;
            weakSelf.is_one = YES;
        }else if ([weakSelf.imageId isEqualToString:@"2"]){
            weakSelf.identityCardBack.image = image;
            weakSelf.is_two = YES;
        }else if ([weakSelf.imageId isEqualToString:@"3"]){
            weakSelf.bankCardFacade.image = image;
            weakSelf.is_three = YES;
            
        }else if ([weakSelf.imageId isEqualToString:@"4"]){
            weakSelf.bank_card_back_photo.image = image;
            weakSelf.is_four = YES;
        }else if ([weakSelf.imageId isEqualToString:@"5"]){
            weakSelf.identityAndBankCard.image = image;
            weakSelf.is_five = YES;
        }
        
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}




#pragma mark - 提交审核
- (IBAction)TiJiaoShenHeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    if ([type isEqualToString:@"3"]) {
        //认证拒绝的
        //图片上传
        [self imageRequestAction];
    }else {
    if (self.is_one == YES&& self.is_two == YES&&self.is_three == YES&&self.is_four == YES&&self.is_five == YES) {
        //图片上传
        [self imageRequestAction];

    }else{
        [self showToast:@"请正确选择照片"];
    }
        
    }
    
}
#pragma mark ---图片上传请求
//图片上传请求
-(void)imageRequestAction{
    
    if (self.identityCardFacade.image ==nil) {
        [self showToast:@"请选择身份证反面照片"];
        return;
        
    }
    if (self.identityCardBack.image ==nil) {
        [self showToast:@"请选择身份证反面照片"];
        return;
        
    }
    if (self.bankCardFacade.image ==nil) {
        [self showToast:@"请选择银行卡照片"];
        return;
        
    }

    if (self.bank_card_back_photo.image ==nil) {
        [self showToast:@"请选择银行反面照片"];
        return;

    }
    if (self.identityAndBankCard.image ==nil) {
        [self showToast:@"请选择手持身份证＋银行卡照片"];
        return;
        
    }
    if (self.IDbankTextfield.text.length ==18&&[YanZhengOBject isIDCorrect:self.IDbankTextfield.text]== YES ) {
    }else{
        [self showToast:@"身份证输入有误"];
        return;
    }
    if (self.bank_account_numbertextf.text.length==16||self.bank_account_numbertextf.text.length==19 ) {
    }else{
        [self showToast:@"银行卡输入有误"];
        return;
    }
    if ([self.reserved_mobile.text isPhoneNumber] ==NO) {
        [self showToast:@"手机号码格式不正确"];
        return;
    }
    if (self.nameTextfield.text.length ==0) {
        [self showToast:@"姓名不能为空"];
        return;
    }
    if ([self.bank_nameBtn.titleLabel.text isEqualToString:@"请输入开户行"]) {
        [self showToast:@"开户行输入有误"];
        return;
    }
    if (self.address.text.length ==0) {
        [self showToast:@"详细地址不能为空"];
        return;
    }
    // 限制控件属性
    self.view.userInteractionEnabled = NO;
    
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableArray *arr =[NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i< self.imageArray.count; i++) {
        UIImageView * imageview = self.imageArray [i];
        [arr addObject:imageview.image];
    }
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper]UPImageToServer:arr toKb:200 success:^(NSArray *urlArr) {
        //创业会员实名认证添加/修改
        [weakSelf shiMingRenZhengrequest:urlArr[0][@"url"] str2:urlArr[1][@"url"] str3:urlArr[2][@"url"] str4:urlArr[3][@"url"]str5:urlArr[4][@"url"]];
    } faild:^(id error) {
         weakSelf.view.userInteractionEnabled = YES;
    }];
//    NSString *password = [NSString stringWithFormat:@"%@%@%@",[AuthenticationModel getimage_account],[AuthenticationModel getimage_hostname],[AuthenticationModel getimage_password]];
//    NSDictionary * dic = @{@"image_account":[AuthenticationModel getimage_account],@"image_password":[password MD5Hash]};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    __weak typeof(self) weakSelf = self;
//    [manager POST:[AuthenticationModel getimage_hostname] parameters:[dic yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//       //NSLog(@"图片数组%@",self.imageArray);
//        for (int i= 0; i< self.imageArray.count; i++) {
//            UIImageView * imageview = self.imageArray [i];
//            //1.把图片转换成二进制流
//            NSData *imageData = UIImageJPEGRepresentation(imageview.image, 0.2);
//            //2.上传图片
//            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i]fileName:[NSString stringWithFormat:@"img%d.jpg",i] mimeType:@"jpg"];
//            
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *arr =responseObject[@"data"];
//        //创业会员实名认证添加/修改
//        [weakSelf shiMingRenZhengrequest:arr[0][@"url"] str2:arr[1][@"url"] str3:arr[2][@"url"] str4:arr[3][@"url"]];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        weakSelf.view.userInteractionEnabled  = YES;
//    }];
}
#pragma mark - 创业会员实名认证添加/修改
-(void)shiMingRenZhengrequest:(NSString*)str1 str2:(NSString*)str2 str3:(NSString*)str3 str4:(NSString*)str4 str5:(NSString*)str5{
    PersonRenZhengModel *Model = [[PersonRenZhengModel alloc]init ];
    Model.real_name = self.nameTextfield.text;
    Model.id_card = self.IDbankTextfield.text;
    Model.bank_account_number = self.bank_account_numbertextf.text;
    Model.bank_name = self.bank_nameBtn.titleLabel.text;
    Model.account_name =self.nameTextfield.text;
    Model.reserved_mobile =self.reserved_mobile.text;
    Model.address = self.address.text;
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    if([type isEqualToString:@"0"]) {
        //未认证
        Model.type = @"1";
    }else if([type isEqualToString:@"3"]){
        //认证失败
        Model.type = @"2";
        Model.cer_id = self.perModel.cer_id;
    }
    Model.province_id = self.personModel.province_id;
    Model.city_id = self.personModel.city_id;
    Model.zone = self.personModel.zone;
    Model.subbranch = self.personModel.subbranch;
    Model.bank_branch_no = self.personModel.bank_branch_no;
    
    Model.id_card_photo= str1;
    Model.id_card_back_photo = str2;
    Model.bank_card_photo = str3;
    Model.bank_card_back_photo = str4;
    Model.person_photo = str5;
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[Model yy_modelToJSONObject] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestCertification" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                //Push 跳转
                AuditViewController * VC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
                VC.titleStr =@"实名认证";
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            }else {
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }
}
//#pragma mark--拍摄照片上传图像
////拍摄照片上传图像
//-(void)addImageOFaddressPerson{
//    //提供相册 以及拍照两种读取图片的方式
//    //创建
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
//    [sheet showInView:self.view];
//}
//#pragma mark-----UIActionSheetDelegate
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:{
//            
//            //判断相册权限
//            
//            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
//                //无权限
//                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许兑富宝访问你的照片" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        //跳入当前App设置界面,
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    return;
//                }else{
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许兑富宝访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alertView show];
//                    return;
//                    
//                }
//                
//            }else{
//                
//                //有相册权限
//                //从相册中去读取
//                [self readImageFromAlbum];
//                
//            }
//            
//            
//        }
//            break;
//            
//        case 1:{
//            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            
//            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
//                //无权限
//                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
//                    
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许兑富宝访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        //跳入当前App设置界面,
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    
//                    [alertController addAction:cancelAction];
//                    
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    
//                    return;
//                    
//                    
//                    
//                }else{
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许兑富宝访问你的相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    
//                    [alertView show];
//                    
//                    return;
//                    
//                }
//                
//            }else{
//                
//                //有相机权限
//                
//                //拍照
//                [self readImageFromCamera];
//                
//            }
//            
//            
//            
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//}
//#pragma mark - 从相册中读取照片
//- (void)readImageFromAlbum {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//创建对象
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//（选择类型）表示仅仅从相册中选取照片
//    imagePicker.delegate = self;//指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//    imagePicker.allowsEditing = YES;//设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
//    [self presentViewController:imagePicker animated:YES completion:nil];//显示相册
//}
//#pragma mark - 拍照
//- (void)readImageFromCamera {
//    //判断选择的模式是否为相机模式，如果没有弹窗警告
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.allowsEditing = YES;//允许编辑
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.delegate = self;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    } else {
//        //弹出窗口响应点击事件
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];//警告。。确认按钮
//        [alert show];
//    }
//}
//#pragma mark --- UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage * image = [self fixOrientation:img];
//   
//    if ([self.imageId isEqualToString:@"1"]) {
//        self.identityCardFacade.image = image;
//        self.is_one = YES;
//    }else if ([self.imageId isEqualToString:@"2"]){
//        self.identityCardBack.image = image;
//        self.is_two = YES;
//    }else if ([self.imageId isEqualToString:@"3"]){
//        self.bankCardFacade.image = image;
//        self.is_three = YES;
//    }else if ([self.imageId isEqualToString:@"4"]){
//        self.identityAndBankCard.image = image;
//        self.is_four = YES;
//    }
//}
//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//



@end

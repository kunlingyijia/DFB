//
//  O2ORealNameVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/16.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2ORealNameVC.h"
#import "PersonChangeModel.h"
#import "CityModel.h"
#import "PersonBankModel.h"
#import "PickerView.h"
#import "YanZhengOBject.h"
#import "PersonRenZhengModel.h"
#import "RegionViewController.h"
#import "O2OCollectionViewController.h"
#import "O2OWithdrawalListViewController.h"
@interface O2ORealNameVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)NSString *province_id;
@property(nonatomic,strong)NSString *city_id;
@property(nonatomic,strong)NSString *region_id;

@property(nonatomic,strong)NSString *provinceName;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *regionName;

//验证
//图片数组
@property(nonatomic,strong) NSMutableArray * imageArray;
//图片标志
@property(nonatomic,strong) NSString * imageId;
//银行数组
@property(nonatomic,strong)NSMutableArray *bankArray;
//imageView 记录被点击
@property(nonatomic,assign)BOOL is_one;
@property(nonatomic,assign)BOOL is_two;
@property(nonatomic,assign)BOOL is_three;
@property(nonatomic,assign)BOOL is_four;



@end

@implementation O2ORealNameVC

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
    
    self.imageArray  = [NSMutableArray arrayWithObjects:_identityCardFacade,_identityCardBack,_bankCardFacade, _identityAndBankCard,nil];
   // NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
//    if ([type isEqualToString:@"2"]) {
//        NSLog(@"认证成功");
//        // 限制控件属性
//        [self changeSubView];
//        [self requestAction];
//        
//        
//    }else if([type isEqualToString:@"0"]) {
//        NSLog(@"未认证");
//        self.contentSizeHeight.constant = 650;
//        //self.imageArray = [NSMutableArray arrayWithCapacity:1];
//        self.bankArray = [NSMutableArray arrayWithCapacity:1];
//        [self addtargetAction];
//        
//        //地区选择 数据配置
//        [self DiQuPeiZhiAction];
//    }else if([type isEqualToString:@"3"]){
//        NSLog(@"认证拒绝");
        self.contentSizeHeight.constant = 650;
        self.bankArray = [NSMutableArray arrayWithCapacity:1];
        
        //控件赋值
        [self KongjianFuzhi:self.perModel];
        [self addtargetAction];
        //地区选择 数据配置
       // [self DiQuPeiZhiAction];
   // }
    
    NSLog(@"招聘--=======================%@",self.perModel.bank_card_photo);
}
#pragma mark - 认证成功状态
-(void)changeSubView{
    
    self.identityCardFacade.userInteractionEnabled = NO;   //身份证正面
    self.identityCardBack.userInteractionEnabled = NO; //身份证反面
    self.bankCardFacade.userInteractionEnabled = NO;      //银行卡正面
    self.identityAndBankCard.userInteractionEnabled = NO;  //手持身份证＋银行卡
    //姓名
    self.nameTextfield.userInteractionEnabled = NO;
    //开户行
    self.bank_nameBtn.userInteractionEnabled = NO;
    ///支行
    self.subbranchTextfield.userInteractionEnabled = NO;
    
    ///身份证
    self.IDbankTextfield.userInteractionEnabled = NO;
    
    ///银行卡号
    self.bank_account_numbertextf.userInteractionEnabled = NO;
    
    ///地区选择
    self.zoneBtn.userInteractionEnabled = NO;
    self.SubmitBtn.userInteractionEnabled = NO;
    
    
    
}
//
-(void)requestAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestCertificationInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                PersonRenZhengModel *renModel = [PersonRenZhengModel yy_modelWithJSON:response[@"data"]];
                //控件赋值
                [self KongjianFuzhi:renModel];
                
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
    }
}
//控件赋值
-(void)KongjianFuzhi:(PersonRenZhengModel*)model{
    
    
    //身份证正面
    [self.identityCardFacade sd_setImageWithURL:[NSURL URLWithString:model.id_card_photo]];
    //身份证反面
    [self.identityCardBack sd_setImageWithURL:[NSURL URLWithString:model.id_card_back_photo]];
    
    //银行卡正面
    [self.bankCardFacade sd_setImageWithURL:[NSURL URLWithString:model.bank_card_photo]];
    
    //手持身份证＋银行卡
    [self.identityAndBankCard sd_setImageWithURL:[NSURL URLWithString:model.person_photo]];
    //姓名
    self.nameTextfield.text  = model.real_name;
   // NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
//    if ([type isEqualToString:@"2"]) {
//        NSLog(@"认证成功");
//        //开户行
//        [self.bank_nameBtn setTitle:model.bank_name forState:(UIControlStateNormal)]  ;
//        ///地区选择
//        [self.zoneBtn setTitle:model.zone forState:(UIControlStateNormal)] ;
//        
//        
//    }else {
        //开户行
        [self.bank_nameBtn setTitle: model.bank_name forState:(UIControlStateNormal)]  ;
        ///地区选择
//    self.provinceName = model.provide;
//    self.cityName = model.city;
//    self.regionName = model.area;
//    NSString * zone = [NSString stringWithFormat:@"%@ %@ %@",model.provide,model.city,model.area];
    [self.zoneBtn setTitle:@"请选择地区" forState:(UIControlStateNormal)] ;
   // }
    
    
    ///身份证
    self.IDbankTextfield.text = model.id_card;
    
    ///银行卡号
    self.bank_account_numbertextf.text = model.bank_account_number;
    
    
    
}

//为View添加点击事件
- (void)addtargetAction {
    //上传"身份证正面"
    UITapGestureRecognizer *identityCardFacadeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityCardFacadeViewAction:)];
    [self.identityCardFacade addGestureRecognizer:identityCardFacadeViewTap];
    //上传"身份证反面"
    UITapGestureRecognizer *identityCardBackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityCardBackViewAction:)];
    [self.identityCardBack addGestureRecognizer:identityCardBackViewTap];
    //上传"银行卡正面"
    UITapGestureRecognizer *bankCardFacadeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankCardFacadeViewAction:)];
    [self.bankCardFacade addGestureRecognizer:bankCardFacadeViewTap];
    //上传"手持身份证＋银行卡"
    UITapGestureRecognizer *identityAndBankCardViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityAndBankCardViewAction:)];
    [self.identityAndBankCard addGestureRecognizer:identityAndBankCardViewTap];
}

//上传"身份证正面"的View事件
- (void)identityCardFacadeViewAction:(UITapGestureRecognizer *)sender {
    //    [self showToast:@"请上传身份证正面照片"];
    self.imageId = @"1";
    [self addImageOFaddressPerson];
    
}

//上传"身份证反面"的View事件
- (void)identityCardBackViewAction:(UITapGestureRecognizer *)sender {
    //    [self showToast:@"请上传身份证反面照片"];
    self.imageId = @"2";
    
    [self addImageOFaddressPerson];
    
    
}

//上传"银行卡正面"的View事件
- (void)bankCardFacadeViewAction:(UITapGestureRecognizer *)sender {
    //    [self showToast:@"请上传银行卡正面照片"];
    self.imageId = @"3";
    [self addImageOFaddressPerson];
    
}

//上传"手持身份证＋银行卡"的View事件
- (void)identityAndBankCardViewAction:(UITapGestureRecognizer *)sender {
    //    [self showToast:@"请上传手持身份证＋银行卡照片"];
    self.imageId = @"4";
    
    [self addImageOFaddressPerson];
    
}
#pragma mark -//提交审核
- (IBAction)TiJiaoShenHeAction:(UIButton *)sender {
    
   // NSLog(@"图片数组%@",self.imageArray);
    [self imageRequestAction];

//    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
//    if ([type isEqualToString:@"3"]) {
//        //认证拒绝的
//        //图片上传
//        [self imageRequestAction];
//    }else {
//        if (self.is_one == YES&& self.is_two == YES&&self.is_four == YES&&self.is_three == YES) {
//            //图片上传
//            [self imageRequestAction];
//            
//        }else{
//            [self showToast:@"请正确选择照片"];
//        }
//        
//    }
    
}


#pragma mark--拍摄照片上传图像
//拍摄照片上传图像
-(void)addImageOFaddressPerson{
    //提供相册 以及拍照两种读取图片的方式
    //创建
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view];
}
#pragma mark-----UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
            
            //判断相册权限
            
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                
                //无权限
                
                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许兑富宝访问你的照片" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //跳入当前App设置界面,
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return;
                    
                    
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许兑富宝访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    return;
                    
                }
                
            }else{
                
                //有相册权限
                //从相册中去读取
                [self readImageFromAlbum];
                
            }
            
            
        }
            break;
            
        case 1:{
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                
                
                
                //无权限
                
                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许兑富宝访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //跳入当前App设置界面,
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return;
                    
                    
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许兑富宝访问你的相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    return;
                    
                }
                
            }else{
                
                //有相机权限
                
                //拍照
                [self readImageFromCamera];
                
            }
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}
//从相册中读取照片
- (void)readImageFromAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self;//指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    imagePicker.allowsEditing = YES;//设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
    [self presentViewController:imagePicker animated:YES completion:nil];//显示相册
}
//拍照
- (void)readImageFromCamera {
    //判断选择的模式是否为相机模式，如果没有弹窗警告
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;//允许编辑
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        //弹出窗口响应点击事件
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];//警告。。确认按钮
        [alert show];
    }
}
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * image = [self fixOrientation:img];
   
    if ([self.imageId isEqualToString:@"1"]) {
        self.identityCardFacade.image = image;
        self.is_one = YES;
    }else if ([self.imageId isEqualToString:@"2"]){
        self.identityCardBack.image = image;
        self.is_two = YES;
    }else if ([self.imageId isEqualToString:@"3"]){
        self.bankCardFacade.image = image;
        self.is_three = YES;
        
    }else if ([self.imageId isEqualToString:@"4"]){
        self.identityAndBankCard.image = image;
        self.is_four = YES;
    }
    else{
        
    }
   
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma mark ---    //图片上传请求
//图片上传请求
-(void)imageRequestAction{
    if (self.IDbankTextfield.text.length ==18&&[YanZhengOBject isIDCorrect:self.IDbankTextfield.text]== YES ) {
    }else{
        [self showToast:@"身份证错误"];
        return;
    }
    if (self.bank_account_numbertextf.text.length==16||self.bank_account_numbertextf.text.length==19 ) {
        // [self showToast:@"银行卡正确"];
    }else{
        [self showToast:@"银行卡错误"];
        return;
    }
    if (self.nameTextfield.text.length ==0) {
        [self showToast:@"姓名不能为空"];
        return;
    }
//    if (self.subbranchTextfield.text.length==0) {
//        [self showToast:@"支行不能为空"];
//        return;
//        
//    }
//    
//    if (self.subbranchTextfield.text.length==0) {
//        [self showToast:@"支行不能为空"];
//        return;
//        
//    }
    if ([self.bank_nameBtn.titleLabel.text isEqualToString:@"请输入开户行"]) {
        [self showToast:@"开户行不能为空"];
        return;
    }
    if ([self.zoneBtn.titleLabel.text isEqualToString:@"请选择地区"]) {
        [self showToast:@"地区不能为空"];
        return;
    }
    // 限制控件属性
    self.view.userInteractionEnabled = NO;
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *password = [NSString stringWithFormat:@"%@%@%@",[AuthenticationModel getimage_account],[AuthenticationModel getimage_hostname],[AuthenticationModel getimage_password]];
    NSDictionary * dic = @{@"image_account":[AuthenticationModel getimage_account],@"image_password":[password MD5Hash]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[AuthenticationModel getimage_hostname] parameters:[dic yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //NSLog(@"图片数组%@",self.imageArray);
        for (int i= 0; i< self.imageArray.count; i++) {
            UIImageView * imageview = self.imageArray [i];
            //1.把图片转换成二进制流
            NSData *imageData = UIImageJPEGRepresentation(imageview.image, 0.2);
            //2.上传图片
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i]fileName:[NSString stringWithFormat:@"img%d.jpg",i] mimeType:@"jpg"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr =responseObject[@"data"];
        for (NSDictionary *dic in arr) {
            NSLog(@"----%@",dic);
          }
        //创业会员实名认证添加/修改
        [self shiMingRenZhengrequest:arr[0][@"url"] str2:arr[1][@"url"] str3:arr[2][@"url"] str4:arr[3][@"url"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        [self hideProgress];
    }];
    
    
}
//创业会员实名认证添加/修改
-(void)shiMingRenZhengrequest:(NSString*)str1 str2:(NSString*)str2 str3:(NSString*)str3 str4:(NSString*)str4{
    
    PersonRenZhengModel *PRZModel = [[PersonRenZhengModel alloc]init ];
    PRZModel.real_name = self.nameTextfield.text;
    PRZModel.id_card = self.IDbankTextfield.text;
    PRZModel.bank_account_number = self.bank_account_numbertextf.text;
    PRZModel.bank_name = self.bank_nameBtn.titleLabel.text;
    PRZModel.account_name =self.nameTextfield.text;
    PRZModel.province_id = self.province_id;
    PRZModel.city_id =self.city_id;
    PRZModel.region_id =self.region_id;
    PRZModel.zone = self.zoneBtn.titleLabel.text;
    //PRZModel.type = @"2";
   // PRZModel.cer_id = self.perModel.cer_id;
        
   // PRZModel.subbranch = self.subbranchTextfield.text;
    PRZModel.id_card_photo= str1;
    PRZModel.id_card_back_photo = str2;
    PRZModel.bank_card_photo = str3;
    PRZModel.person_photo = str4;
    NSLog(@"测试-----%@",[PRZModel yy_modelToJSONObject]);
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        //baseReq.data = PRZModel;
        baseReq.data = [AESCrypt encrypt:[[PRZModel yy_modelToJSONObject] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestZidaoCertification" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
         
                if ([self.pushTypeOfO2O isEqualToString:@"收款列表"]) {
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[O2OCollectionViewController
                                                 class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }

                }
                
                if([self.pushTypeOfO2O isEqualToString:@"收款列表"]){
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[O2OWithdrawalListViewController
                                                 class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }

                }
                
               
                
            }else {
                self.view.userInteractionEnabled = YES;
                [weakSelf showToast:response[@"msg"]];
            }
            
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            self.view.userInteractionEnabled = YES;
        }];
        
    }


    
    
}

#pragma mark - 地区选择
//选择城市
- (IBAction)zoneAction:(UIButton *)sender {
    //NSLog(@"图片数组%@",self.imageArray);
    
    [self.view endEditing:YES];
    RegionViewController * VC = [[RegionViewController alloc]initWithNibName:@"RegionViewController" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [VC ReqionReturn:^(NSDictionary *reqionDic) {
        NSLog(@"---------------------%@",reqionDic);
        [self.zoneBtn setTitle:reqionDic[@"name"] forState:(UIControlStateNormal)] ;
        
//        self.provinceName = reqionDic[@"provinceName"];
//        self.cityName = reqionDic[@"cityName"];
//        self.regionName = reqionDic[@"regionName"];
        self.province_id = reqionDic[@"province_id"];
        self.city_id = reqionDic[@"city_id"];
        self.region_id = reqionDic[@"region_id"];

        
    }];
    [self presentViewController:VC animated:YES completion:^{
    }];

}

#pragma mark ---- 银行列表网络请求

- (IBAction)BankRequestAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.bankArray removeAllObjects];
    
    __weak typeof(self) weakself = self;
    //读取银行name 读取
    NSMutableArray * duQuBankNameArray = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:@"MbankName"]];
    //数据归零
    
    if (duQuBankNameArray.count ==0) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:@"http://91zidao.com/Api/User/bank" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([@"1" isEqualToString: responseObject[@"resultCode"]]) {
                NSArray *arr = responseObject[@"data"];
                for (NSDictionary *dic in arr) {
                    
                    //[self.bankArray addObject:dic[@"bankName"]];
                    [self.bankArray addObject:dic[@"bankName"]];
                }
                
                NSArray * array = [NSArray arrayWithArray:self.bankArray];
                //数据存储
                [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"MbankName"];
                
                
                
                [PickerView showPickerWithOptions:self.bankArray title:@"选择银行卡" selectionBlock:^(NSString *selectedOption) {
                    
                    [weakself.bank_nameBtn setTitle:selectedOption forState:(UIControlStateNormal)];
                    
                    
                }];
                
                
                
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }else{
        
        [PickerView showPickerWithOptions:duQuBankNameArray title:@"选择银行卡" selectionBlock:^(NSString *selectedOption) {
            
            [weakself.bank_nameBtn setTitle:selectedOption forState:(UIControlStateNormal)];
            
            
        }];
        
    }
    
    
    
}



@end

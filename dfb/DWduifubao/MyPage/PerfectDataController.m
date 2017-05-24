//
//  PerfectDataController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PerfectDataController.h"
#import "CityModel.h"
#import "PerfectDataMOdel.h"
#import "PickerView.h"
#import "YanZhengOBject.h"
#import "PersonBankModel.h"
//行业
#import "IndustryModel.h"
#import "AuditViewController.h"
#import "ValuePickerView.h"
//银行
#import "DWBankViewController.h"
#import "Bank_Region_Bank_Branch.h"
#import "RegionViewController.h"
@interface PerfectDataController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
//@property(nonatomic,strong)NSMutableArray *bankArray;
//行业数组
@property(nonatomic,strong)NSMutableArray * industryArray;
//行业一级数组
@property (nonatomic,strong)NSMutableArray * LevelOneArr;
///行业二级数组
@property (nonatomic,strong)NSMutableArray * LevelTwoArr;
//行业id
@property(nonatomic,strong)NSString *industryid;
///商户id;
@property(nonnull,strong)NSString *merchant_id;
    //imageView 记录被点击
@property(nonatomic,assign)BOOL is_one;
@property(nonatomic,assign)BOOL is_two;
@property(nonatomic,assign)BOOL is_three;
@property(nonatomic,assign)BOOL is_four;
@property(nonatomic,assign)BOOL is_five;
@property (nonatomic, strong) ValuePickerView *industryView;
///数据
@property (nonatomic,strong)NSMutableArray * industryViewArr;
@property(nonatomic,strong) PerfectDataMOdel *PerfectModel;
@end

@implementation PerfectDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.title = @"完善资料";
    //赋值
    self.is_one = NO;
    self.is_two = NO;
    self.is_three = NO;
    self.is_four = NO;
    self.is_five = NO;
   // NSLog(@"%@",self.perDataModel.bank_name);
     self.PerfectModel = [[PerfectDataMOdel alloc]init];
    //行业
    self.industryView = [[ValuePickerView alloc]init];
    self.industryViewArr = [NSMutableArray arrayWithCapacity:1];
    self.imageArray  = [NSMutableArray arrayWithObjects:_id_card_photo,_id_card_back_photo,_bank_card_photo, _license_url,_merchant_logo,nil];
    self.LevelOneArr = [NSMutableArray arrayWithCapacity:1];
    self.LevelTwoArr = [NSMutableArray arrayWithCapacity:1];
    [self endEditingAction:self.view];
    self.contentSizeHeight.constant = Height*0.95+650;
    ;
    //完善资料的状态
     NSString * openshop_status = [NSString stringWithFormat:@"%@",[AuthenticationModel getopenshop_status]];
    if ([openshop_status isEqualToString:@"3"]){
        NSLog(@"审核拒绝");
        self.PerfectModel = self.perDataModel;
        //控件赋值
        self.industryArray = [NSMutableArray arrayWithCapacity:1];
        [self KongJianFuZhi: self.PerfectModel];
    }else if ([openshop_status isEqualToString:@"0"]){
        self.type = @"1";
        self.industryArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Bank_Region_Bank_BranchAction:) name:@"Bank_Region_Bank_Branch" object:nil];
    
}
#pragma mark - 创建观察者返回数据
-(void)Bank_Region_Bank_BranchAction:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"Bank_Region_Bank_Branch"];
    Bank_Region_Bank_BranchModel * model = [Bank_Region_Bank_BranchModel yy_modelWithJSON:dic];
    [self.bank_name setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.subbranch.text = model.bank_branch;
    self.PerfectModel.subbranch =model.bank_branch;
    self.PerfectModel.bank_branch_no =model.bank_branch_no;
    
}
#pragma mark - 控件赋值
-(void)KongJianFuZhi:(PerfectDataMOdel*)model{
    self.merchant_name.text = model.merchant_name;
    self.merchant_mobile.text = model.merchant_mobile;
    self.content.text = model.content;
    [self.bank_name setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.bank_account_number.text = model.bank_account_number;
    self.license_no.text = model.license_no;
    self.id_card.text = model.id_card;
    
    [self.industry_id setTitle:model.industry_name forState:(UIControlStateNormal)];
    NSLog(@"----%@",model.industry_name);
    self.zone.titleLabel.text = model.zone;
    [self.zone setTitle:model.zone forState:(UIControlStateNormal)];
    [DWHelper SD_WebImage:self.id_card_photo imageUrlStr:model.id_card_photo placeholderImage:nil];
    [DWHelper SD_WebImage:self.id_card_back_photo imageUrlStr:model.id_card_back_photo placeholderImage:nil];
    [DWHelper SD_WebImage:self.bank_card_photo imageUrlStr:model.bank_card_photo placeholderImage:nil];
    [DWHelper SD_WebImage:self.license_url imageUrlStr:model.license_url placeholderImage:nil];
    [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:model.merchant_logo placeholderImage:nil];
     self.subbranch.text = model.subbranch;
     self.detailAddress.text = model.address;
     self.merchant_id = model.merchant_id;
     self.province_id = self.PerfectModel.province_id;
     self.city_id = self.PerfectModel.region_id;
     self.region_id =self.PerfectModel.region_id;
     self.industryid = self.PerfectModel.industry_id;
}
///上传"法人身份证正面"的按钮事件
- (IBAction)id_card_photoBtnAction:(id)sender {
    //[self showToast:@"请上传身份证正面照片"];
    [self.view endEditing:YES];
    self.imageId = @"1";
    [self addImageOFaddressPerson];

}

///上传"法人身份证反面"的按钮事件
- (IBAction)id_card_back_photoBtnAction:(id)sender {
//    [self showToast:@"请上传身份证反面照片"];
    self.imageId = @"2";
    [self.view endEditing:YES];

    [self addImageOFaddressPerson];
    

}

///上传"对公银行卡正面"的按钮事件
- (IBAction)bank_card_photoBtnAction:(id)sender {
//    [self showToast:@"请上传银行卡正面照片"];
    self.imageId = @"3";
    [self.view endEditing:YES];

    [self addImageOFaddressPerson];
}

///上传"营业执照"的按钮事件
- (IBAction)license_urlBtnAction:(id)sender {
//    [self showToast:@"营业执照"];
    self.imageId = @"4";
    [self.view endEditing:YES];

    [self addImageOFaddressPerson];

}

///上传"logo图片"的按钮事件
- (IBAction)logoImageBtnAction:(id)sender {
    [self showToast:@"logo图片"];
    self.imageId = @"5";
    [self.view endEditing:YES];

    [self addImageOFaddressPerson];
}


#pragma mark - 提交"的按钮事件
///"提交"的按钮事件
- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];

    //    //完善资料的状态
        NSString * openshop_status = [NSString stringWithFormat:@"%@",[AuthenticationModel getopenshop_status]];
        if ([openshop_status isEqualToString:@"3"]){
            NSLog(@"审核拒绝");
            //审核拒绝 ()
            //图片上传
            [self imageRequestAction];
        }else{
    
    if (self.is_one == YES&& self.is_two == YES&&self.is_four == YES&&self.is_three == YES&&self.is_five ==YES) {
        //图片上传
        [self imageRequestAction];
        
    }else{
        [self showToast:@"请正确选择照片"];
    }
        }
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
        self.id_card_photo.image = image;
        self.is_one= YES;

    }else if ([self.imageId isEqualToString:@"2"]){
        self.id_card_back_photo.image = image;
        self.is_two= YES;


        
        
    }else if ([self.imageId isEqualToString:@"3"]){
        self.bank_card_photo.image = image;
        self.is_three =YES;

        
    }else if ([self.imageId isEqualToString:@"4"]){
        self.license_url.image = image;
        self.is_four = YES;

        
    }else if ([self.imageId isEqualToString:@"5"]){
        self.merchant_logo.image = image;
        self.is_five = YES;

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
    
    //资料提交判断条件
    //[self DataSubmitted];
    if (self.merchant_name.text.length ==0) {
        [self showToast:@"请填写店名哦"];
        return;
    }
    ///简介
    
    if (self.content.text.length ==0) {
        [self showToast:@"简介不能为空哦"];
        return;
    }
    
    ///手机号
    if ([YanZhengOBject IsPhoneNumber:self.merchant_mobile.text]== NO) {
        [self showToast:@"手机号不正确哦"];
        return;
    }
    if ([_bank_name.titleLabel.text isEqualToString:@"请选择开户行"]
        ) {
        [self showToast:@"请选择开户行哦"];
        return;
    }
    ///支行
    if (self.subbranch.text.length ==0) {
        [self showToast:@"支行不能为空哦"];
        return;
    }
    ///代理行业
    if ([_industry_id.titleLabel.text isEqualToString:@"请选择代理行业"]
        ) {
        [self showToast:@"请选择代理行业哦"];
        return;
    }
    ///请选择地区
    if ([_zone.titleLabel.text isEqualToString:@"请选择地区"]
        ) {
        [self showToast:@"请选择地区哦"];
        return;
    }
    ///地址
    if (self.detailAddress.text.length ==0) {
        [self showToast:@"地址不能为空哦"];
        return;
    }
    ///收款银行卡
    if (self.bank_account_number.text.length ==0) {
        [self showToast:@"银行卡不能为空哦"];
        return;
    }
    if (_license_no.text.length==0) {
        [self showToast:@"营业执照号码哦"];
        return;
    }
    if (_id_card.text.length ==18&&[YanZhengOBject isIDCorrect:_id_card.text]== YES) {
    }else{
        [self showToast:@"身份证不正确哦"];
        return;

    }
    
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    //取消子视图相应事件
    //[self CancelResponseEvent];
    self.view.userInteractionEnabled = NO;
    NSString *password = [NSString stringWithFormat:@"%@%@%@",[AuthenticationModel getimage_account],[AuthenticationModel getimage_hostname],[AuthenticationModel getimage_password]];
    NSDictionary * dic = @{@"image_account":[AuthenticationModel getimage_account],@"image_password":[password MD5Hash]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[AuthenticationModel getimage_hostname] parameters:[dic yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        NSLog(@"图片上传%@",arr);
        //创业会员实名认证添加/修改
        [self shiMingRenZhengrequest:arr[0][@"url"] str2:arr[1][@"url"] str3:arr[2][@"url"] str4:arr[3][@"url"] str5:arr[4][@"url"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgress];
    }];
    
    
}
//创业会员实名认证添加/修改

-(void)shiMingRenZhengrequest:(NSString*)str1 str2:(NSString*)str2 str3:(NSString*)str3 str4:(NSString*)str4 str5:(NSString*)str5{
    PerfectDataMOdel *PRZModel = [[PerfectDataMOdel alloc]init ];
    PRZModel.merchant_name = self.merchant_name.text;
    PRZModel.merchant_mobile = self.merchant_mobile.text;
    PRZModel.content = self.content.text;
    PRZModel.type =self.type;
    PRZModel.bank_name = self.bank_name.titleLabel.text;
    PRZModel.bank_account_number = self.bank_account_number.text;
    PRZModel.license_no = self.license_no.text;
    PRZModel.id_card = self.id_card.text;
    PRZModel.merchant_id = self.merchant_id;
    PRZModel.id_card_photo= str1;
    PRZModel.id_card_back_photo = str2;
    PRZModel.bank_card_photo = str3;
    PRZModel.license_url = str4;
    PRZModel.merchant_logo = str5;
    PRZModel.province_id = self.province_id;
    PRZModel.city_id =self.city_id;
    PRZModel.region_id = self.region_id;
    PRZModel.zone = self.zone.titleLabel.text;
    PRZModel.subbranch  = self.subbranch.text;
    PRZModel.bank_branch_no =self.PerfectModel.bank_branch_no;
    PRZModel.address  = self.detailAddress.text;
    PRZModel.industry_id = self.industryid;
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;

    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        //baseReq.data = PRZModel;
        baseReq.data = [AESCrypt encrypt:[[PRZModel yy_modelToJSONObject] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestCompleteShopInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            
           // [self showToast:@"认证成功"];
           // [self.navigationController popToRootViewControllerAnimated:YES];
            if ([response[@"resultCode"]isEqualToString:@"1"]) {
                //Push 跳转
                AuditViewController * VC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
                 VC.titleStr =@"我要供货";
                [weakSelf.navigationController  pushViewController:VC animated:YES];

            }else{
                self.view.userInteractionEnabled = YES;
                [weakSelf showToast:response[@"msg"]];

            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            self.view.userInteractionEnabled = YES;
            [self showToast:@"认证失败"];
            
        }];
        
    }else {
        
    }
    
    
}

#pragma mark - 地区选择
//选择城市
///选择"地区"的按钮事件
- (IBAction)chooseAreaBtnAction:(id)sender {
    [self.view endEditing:YES];
    RegionViewController * VC = [[RegionViewController alloc]initWithNibName:@"RegionViewController" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [VC ReqionReturn:^(NSDictionary *reqionDic) {
        NSLog(@"---------------------%@",reqionDic);
        [self.zone setTitle:reqionDic[@"name"] forState:(UIControlStateNormal)] ;
        
        //        self.provinceName = reqionDic[@"provinceName"];
        //        self.cityName = reqionDic[@"cityName"];
        //        self.regionName = reqionDic[@"regionName"];
        self.province_id = reqionDic[@"province_id"];
        self.city_id = reqionDic[@"city_id"];
        self.region_id = reqionDic[@"region_id"];
        
        
    }];
    [self presentViewController:VC animated:YES completion:^{
    }];
    //调用
   // [self createPickerView];
    
}

//-(void)DiQuPeiZhiAction{
//    self.firstIndex = 0;
//    self.secondIndex = 0;
//    self.thirdIndex = 0;
//    
//    for (NSDictionary *dic in [DWHelper getCityData]) {
//        CityModel *model = [CityModel yy_modelWithDictionary:dic];
//        if (model.regionType == 1) {
//            [self.firstDataSource addObject:model];
//        }else if (model.regionType == 2) {
//            [self.secondDataSource addObject:model];
//        }else if (model.regionType == 3||model.regionType == 4) {
//            [self.thirdDataSource addObject:model];
//        }
//    }
//    CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
//    for (CityModel *model in self.secondDataSource) {
//        if (beijingModel.regionId == model.superId) {
//            [self.secondCity addObject:model];
//        }
//    }
//    CityModel *secondModel = self.secondCity[0];
//    for (CityModel *model in self.thirdDataSource) {
//        if (secondModel.regionId == model.superId) {
//            [self.thirdCity addObject:model];
//        }
//    }
//    
//    
//    
//}
//- (void)createPickerView {
//    self.bgView = [[UIView alloc] initWithFrame:Bounds];
//    self.bgView.backgroundColor = [UIColor blackColor];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canaelTapAction:)];
//    [self.bgView addGestureRecognizer:tap];
//    
//    self.bgView.alpha = 0.2;
//    [self.view addSubview:self.bgView];
//    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Height, Width, 300)];
//    self.pickerBgView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.pickerBgView];
//    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 170)];
//    self.pickerView.userInteractionEnabled = YES;
//    self.pickerView.backgroundColor = [UIColor whiteColor];
//    self.pickerView.delegate = self;
//    self.pickerView.dataSource = self;
//    [self.pickerView selectRow:self.firstIndex inComponent:0 animated:NO];
//    [self.pickerView selectRow:self.secondIndex inComponent:1 animated:NO];
//    [self.pickerView selectRow:self.thirdIndex inComponent:2 animated:NO];
//    [self.pickerBgView addSubview:self.pickerView];
//    
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor whiteColor];
//    [btn setTitle:@"确定" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
//    [self.pickerBgView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pickerBgView);
//        make.right.equalTo(self.pickerBgView).with.offset(-10);
//        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
//        
//    }];
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.backgroundColor = [UIColor whiteColor];
//    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
//    [self.pickerBgView addSubview:cancelBtn];
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pickerBgView);
//        make.left.equalTo(self.pickerBgView).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
//    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.pickerBgView.frame = CGRectMake(0, Height - 300, Width, 300);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//
//
//- (void)sureAction:(UIButton *)sender {
//    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
//        
//    }else {
//        self.cityModel = self.thirdCity[self.thirdIndex];
//        self.secondModel = self.secondCity[self.secondIndex];
//        self.provinceModel = self.firstDataSource[self.firstIndex];
//        
//        CityModel *firstModel = self.firstDataSource[self.firstIndex];
//        CityModel *secondModel = self.secondCity[self.secondIndex];
//        
//        if ([secondModel.regionName isEqualToString:@"北京市"]) {
//            [self.zone setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
//            [self.zone setTitle:[NSString stringWithFormat:@"%@ %@", firstModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
//        }else {
//            [self.zone setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
//            [self.zone setTitle:[NSString stringWithFormat:@"%@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
//        }
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
//    } completion:^(BOOL finished) {
//        [self.bgView removeFromSuperview];
//        [self.pickerBgView removeFromSuperview];
//    }];
//}
//
//- (void)cancelAction:(UIButton *)sender {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
//    } completion:^(BOOL finished) {
//        [self.bgView removeFromSuperview];
//        [self.pickerBgView removeFromSuperview];
//    }];
//}
//- (void)canaelTapAction:(UITapGestureRecognizer *)sender {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
//    } completion:^(BOOL finished) {
//        [self.bgView removeFromSuperview];
//        [self.pickerBgView removeFromSuperview];
//    }];
//}
//#pragma mark - UIPickerViewDelegate
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
//    if (component == 0) {
//        CityModel *model = self.firstDataSource[row];
//        return model.regionName;
//    }else if (component == 1) {
//        CityModel *model = self.secondCity[row];
//        return model.regionName;
//    }else {
//        CityModel *model = self.thirdCity[row];
//        return model.regionName;
//    }
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED {
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        // Setup label properties - frame, font, colors etc
//        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        pickerLabel.textAlignment = NSTextAlignmentCenter;
//        pickerLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    }
//    // Fill the label text here
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}
//
//#pragma mark - UIPickerViewDataSource
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    
//    return 3;
//}
//
//// returns the # of rows in each component..
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (component == 0) {
//        //NSLog(@"%ld", self.firstDataSource.count);
//        return self.firstDataSource.count;
//    }else if (component == 1) {
//        return self.secondCity.count;
//    }else {
//        return self.thirdCity.count;
//    }
//    return 10;
//}
//
//
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
//    if (component == 0) {
//        self.firstIndex = row;
//        CityModel *model = self.firstDataSource[row];
//        [self.secondCity removeAllObjects];
//        [self.thirdCity removeAllObjects];
//        
//        if (row == 0) {
//            CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
//            for (CityModel *model in self.secondDataSource) {
//                if (beijingModel.regionId == model.superId) {
//                    [self.secondCity addObject:model];
//                }
//            }
//            CityModel *secondModel = self.secondCity[0];
//            for (CityModel *model in self.thirdDataSource) {
//                if (secondModel.regionId == model.superId) {
//                    [self.thirdCity addObject:model];
//                }
//            }
//        }else {
//            self.firstRegionID = model.regionId;
//            for (CityModel *addressModel in self.secondDataSource) {
//                if (addressModel.superId == model.regionId) {
//                    [self.secondCity addObject:addressModel];
//                }
//            }
//            CityModel *secondModel = self.secondCity[0];
//            for (CityModel *thirdModel in self.thirdDataSource) {
//                if (secondModel.regionId == thirdModel.superId) {
//                    [self.thirdCity addObject:thirdModel];
//                }
//            }
//            [self.pickerView selectRow:0 inComponent:1 animated:YES];
//            
//        }
//        [self.pickerView reloadAllComponents];
//    }else if (component == 1) {
//        [self.thirdCity removeAllObjects];
//        self.secondIndex = row;
//        CityModel *model = self.secondCity[row];
//        self.secondRegionID = model.regionId;
//        for (CityModel *addressModel in self.thirdDataSource) {
//            if (addressModel.superId == model.regionId) {
//                [self.thirdCity addObject:addressModel];
//            }
//        }
//        [self.pickerView selectRow:0 inComponent:2 animated:YES];
//        [self.pickerView reloadAllComponents];
//    }else {
//        self.thirdIndex = row;
//    }
//}
//
//- (NSMutableArray *)firstDataSource {
//    if (!_firstDataSource) {
//        self.firstDataSource = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _firstDataSource;
//}
//- (NSMutableArray *)secondDataSource {
//    if (!_secondDataSource) {
//        self.secondDataSource = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _secondDataSource;
//}
//- (NSMutableArray *)thirdDataSource {
//    if (!_thirdDataSource) {
//        self.thirdDataSource = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _thirdDataSource;
//}
//- (NSMutableArray *)secondCity {
//    if (!_secondCity) {
//        self.secondCity = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _secondCity;
//}
//- (NSMutableArray *)thirdCity {
//    if (!_thirdCity) {
//        self.thirdCity = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _thirdCity;
//}
#pragma mark - 选择"所属行业"的按钮事件
///选择"所属行业"的按钮事件
- (IBAction)chooseTradeBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.view endEditing:YES];
    [self.LevelOneArr removeAllObjects];
    [self.LevelTwoArr removeAllObjects];
    [self.industryArray removeAllObjects];
    NSString *Token =[AuthenticationModel getLoginToken];
    //读取行业列表第一级读取
    NSMutableArray * OneArr = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:@"LevelOneArr"]];
    NSMutableArray * TwoArr = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:@"LevelTwoArr"]];
   // if (TwoArr.count==0||OneArr.count ==0) {
        
    
   
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Industry/requestIndustryList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            if ([@"1" isEqualToString: response[@"resultCode"]]) {
                NSMutableArray *arr = response[@"data"];
             //   NSMutableDictionary *DDD = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSDictionary *dic in arr) {
                    IndustryModel *model = [IndustryModel yy_modelWithJSON:dic];
                 //   [ DDD  setObject:model.industry_id forKey:model.name];
                    NSString * str = [NSString stringWithFormat:@"%@",model.name];
                    [weakSelf.industryArray addObject:str];
                    if ([model.level isEqualToString:@"1"]) {
                        [self.LevelOneArr addObject:model];
                        
                    }else{
                        [self.LevelTwoArr addObject:model];
                    }
                    
                    
                }
                NSArray * arrayOne = [NSArray arrayWithArray:self.LevelOneArr];
                //数据存储
              //  [[NSUserDefaults standardUserDefaults]setObject:arrayOne forKey:@"LevelOneArr"];
                NSArray * arrayTwo = [NSArray arrayWithArray:self.LevelTwoArr];
                //数据存储
               // [[NSUserDefaults standardUserDefaults]setObject:arrayTwo
//                                                    forKey:@"LevelTwoArr"];
                self.industryView.leaveOneArr = self.LevelOneArr;
                self.industryView.leaveTwoArr = self.LevelTwoArr;
                self.industryView.valueDidSelect = ^(IndustryModel*value){
                    
                    //  NSLog(@"------%@",value.name);
                    [weakSelf.industry_id setTitle:value.name forState:(UIControlStateNormal)];
                    weakSelf.industryid = value.industry_id;
                }
                ;self.industryView.pickerTitle = @"所选行业";
                [self.industryView show];
                //                [PickerView showPickerWithOptions:weakSelf.industryArray title:@"选择行业" selectionBlock:^(NSString *selectedOption) {
                //
                //                    [weakSelf.industry_id setTitle:selectedOption forState:(UIControlStateNormal)];
                //                    weakSelf.industryid = DDD[selectedOption];
                //
                //
                //
                //                }];
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
//    }else{
//        self.industryView.leaveOneArr = OneArr;
//        self.industryView.leaveTwoArr = TwoArr;
//        self.industryView.valueDidSelect = ^(IndustryModel*value){
//            [weakSelf.industry_id setTitle:value.name forState:(UIControlStateNormal)];
//            weakSelf.industryid = value.industry_id;
//        }
//        ;self.industryView.pickerTitle = @"所选行业";
//        [self.industryView show];
//    }
    
}


#pragma mark ---- 银行列表网络请求

- (IBAction)BankRequestAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    //Push 跳转
    DWBankViewController * VC = [[DWBankViewController alloc]initWithNibName:@"DWBankViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
    
}

@end

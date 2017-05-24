//
//  PersonalCenterController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PersonalCenterController.h"
#import "AuditViewController.h"
#import "FailureViewController.h"
#import "PersonalCell1.h"
#import "PersonalCell2.h"
#import "UpdateSexController.h"
#import "RealNameCertificationController.h"
#import "AddressManageController.h"
#import "ImproveTicketController.h"
#import "SecurityCertificateController.h"
#import "PersonModel.h"
#import "ChageNameController.h"
#import "PersonChangeModel.h"
#import "BackgroundService.h"
#import "SucessRealNameCertificationController.h"
#import "UploadImage.h"
#import "UpLoadImageVC.h"
#import "ImageChooseVC.h"
#import "UIImage+DWImage.h"
@interface PersonalCenterController ()<UITableViewDataSource, UITableViewDelegate,UpdateSexControllerDelegate,ChageNameControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation PersonalCenterController

//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.scrollsToTop= YES;
    //获取个人资料
    [BackgroundService requestPushVC:self MyselfAction:^{
        
    }];

    
}

//视图即将消失、被覆盖或是隐藏时调用
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    if ([self.delegate respondsToSelector:@selector(PersonalCenterControllerBack)]) {
         [self.delegate  PersonalCenterControllerBack];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    // 设置导航框是否透明
    self.navigationController.navigationBar.alpha = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.dataSource = @[@[@"用户名",@"昵称",@"兑富宝号",@"会员等级",@"性别"],@[@"实名认证",@"地址管理"],@[@"安全认证"]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, Width, 650)];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *headerV = [[UIView alloc] init];
    //红色背景图
    UIImageView *redBgPicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"图层-2"]];
    if (Height>600) {
        headerV.frame =CGRectMake(0, 0, self.view.frame.size.width, Width/5*2.1);
        redBgPicture.frame = CGRectMake(0, 0, self.view.frame.size.width, Width/5*2.1);
       
    }else{
        headerV.frame =CGRectMake(0, 0, self.view.frame.size.width, 160);
 
         redBgPicture.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
        
    }

    
    //设置可交互
    redBgPicture.userInteractionEnabled = YES;
    
    //个人中心
    UILabel *personalCenter = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 20, 80, 25)];
    personalCenter.text = @"个人中心";
    personalCenter.textColor = [UIColor whiteColor];
   // [personalCenter setBackgroundColor:[UIColor yellowColor]];
    personalCenter.textAlignment = NSTextAlignmentCenter;
    personalCenter.font = [UIFont systemFontOfSize:kFirstTitleFont];
    UITapGestureRecognizer *userPhotoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userPhotoTap:)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 0, 40, 40);
    backBtn.center = CGPointMake(20, personalCenter.center.y);
    
    
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左-白"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //头像照片
    UIImageView *userPhotoPicture = [[UIImageView alloc] init];
    userPhotoPicture.frame = CGRectMake(self.view.frame.size.width/2-40, 70, 80, 80);
    userPhotoPicture.tag = 20001;
    userPhotoPicture.layer.cornerRadius = 40;
    userPhotoPicture.layer.masksToBounds = YES;
    [userPhotoPicture addGestureRecognizer:userPhotoTap];
    userPhotoPicture.userInteractionEnabled = YES;
    [userPhotoPicture sd_setImageWithURL:[NSURL URLWithString:self.personModel.avatar_url] placeholderImage:[UIImage imageNamed:@"敬请期待"]];
    //为TableView添加HeaderView
    [redBgPicture addSubview:backBtn];
    [redBgPicture addSubview:personalCenter];
    [redBgPicture addSubview:userPhotoPicture];
    [headerV addSubview:redBgPicture];
    self.tableView.tableHeaderView = headerV;
    
    //设置TableView自定义Cell的样式
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalCell2"];
    
    //设置TableViewCell的高度
    self.tableView.rowHeight = 50;
    //设置TableView的脚视图
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 65)];
    footV.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footV;
    //设置TableView可滑动的高度
    if (self.tableView.frame.size.height > Height) {
        self.tableView.scrollEnabled = YES;
    }else {
        self.tableView.scrollEnabled = NO;
    }
    [self.view addSubview:self.tableView];
    
}
//头像点击事件
-(void)userPhotoTap:(UITapGestureRecognizer*)sender{


    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType = EditedImage;
    VC.zoom= 1;
    __weak typeof(self) weakSelf = self;
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        [weakSelf imageRequestAction:image];

    };
    [self presentViewController:VC animated:NO completion:^{
    }];
}
//"返回"的按钮事件
- (void)backBtnAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
//设置分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//设置每个分区的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //"用户名"
        if (indexPath.row == 0) {
            PersonalCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell1" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            NSString *tel = [ self.personModel.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell1.cellInfo.text = tel;

            //cell1.cellInfo.text = self.personModel.mobile;
            cell1.cellInfo.textColor = [UIColor colorWithHexString:kRedColor];
            return cell1;
        }
        //"昵称"
        if (indexPath.row == 1) {
            PersonalCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell1" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            cell1.cellInfo.tag = 11112;
            cell1.cellInfo.text = self.personModel.nick_name;
            return cell1;
        }
        //"兑富宝号"
        if (indexPath.row == 2) {
            PersonalCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell1" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            cell1.cellInfo.text = [NSString stringWithFormat:@"%ld",self.personModel.inviter_code];
            return cell1;
        }
        //"会员等级"
        if (indexPath.row == 3) {
            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            if (self.personModel.user_type==1) {
                cell2.cellInfo.text = @"注册会员";
            }else if (self.personModel.user_type==2){
                cell2.cellInfo.text = @"创业会员";
            }else{
                cell2.cellInfo.text = @"";
            }
            
            return cell2;
        }
        //"性别"
        if (indexPath.row == 4) {
            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            cell2.cellInfo.tag = 11111;
            NSLog(@"性别---%@",[AuthenticationModel getgender]);
            if ([[AuthenticationModel getgender] isEqualToString:@"1"]) {
                cell2.cellInfo.text = @"男";
            }else if ([[AuthenticationModel getgender] isEqualToString:@"2"]){
                cell2.cellInfo.text = @"女";

            }else if ([[AuthenticationModel getgender] isEqualToString:@"3"]){
                cell2.cellInfo.text = @"保密";

            }else{
                cell2.cellInfo.text = @"";

            }

            return cell2;
        }
    }
    
    if (indexPath.section == 1) {
        //"实名认证"
        if (indexPath.row == 0) {
            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
            if ([type isEqualToString:@"2"]) {
                cell2.cellInfo.text = @"已经认证";
                NSLog(@"认证成功");}
            return cell2;
        }
        //"地址管理"
        if (indexPath.row == 1) {
            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            return cell2;
        }
//        //"增票资质"
//        if (indexPath.row == 2) {
//            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
//            //设置点击tableViewCell不会变成灰色
//            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
//            return cell2;
//        }
    }
    
    //"安全认证"
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
            //设置点击tableViewCell不会变成灰色
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.cellName.text = self.dataSource[indexPath.section][indexPath.row];
            return cell2;
        }
    }

    PersonalCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell2" forIndexPath:indexPath];
    return cell2;
}

#pragma mark - UITableViewDelegate
//每个分区分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//每个分区分区脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0;
    }
    return 10;
}

//每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //"修改昵称"
        if (indexPath.row == 1) {
            ChageNameController * CNC = [[ChageNameController alloc]initWithNibName:@"ChageNameController" bundle:nil];
            CNC.nick_name = [AuthenticationModel getnick_name];
            CNC.delegate = self;
            
            [self.navigationController pushViewController:CNC animated:YES];
        }
        //"会员等级"
        if (indexPath.row == 3) {
            
        }
        //"性别"
        if (indexPath.row == 4) {
            UpdateSexController *updateSexController = [[UpdateSexController alloc] initWithNibName:@"UpdateSexController" bundle:nil];
            updateSexController.delegate = self;

            if ([[AuthenticationModel getgender]isEqualToString:@"1"]) {
                 updateSexController.gender = @"男";
            }else if ([[AuthenticationModel getgender]isEqualToString:@"2"]){
               updateSexController.gender = @"女";
                
            }else if ([[AuthenticationModel getgender]isEqualToString:@"3"]){
               updateSexController.gender = @"保密";
            
            updateSexController.gender = [AuthenticationModel getgender];
            
            }else{
                updateSexController.gender = @"";
                
            }

            [self.navigationController pushViewController:updateSexController animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        //"实名认证"
        if (indexPath.row == 0) {
            NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
            NSLog(@"type%@",type);
            
            if ([type isEqualToString:@"2"]) {
                NSLog(@"认证成功");

                //Push 跳转
                SucessRealNameCertificationController * VC = [[SucessRealNameCertificationController alloc]initWithNibName:@"SucessRealNameCertificationController" bundle:nil];
                [self.navigationController  pushViewController:VC animated:YES];

            }
            else if ([type  isEqualToString:@"1"]){
                NSLog(@"认证审核中");
                AuditViewController * adVC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
                 adVC.titleStr =@"实名认证";
                [self.navigationController pushViewController:adVC animated:YES];
            }else if( [type  isEqualToString:@"3"]){
                NSLog(@"认证失败");
                FailureViewController * adVC = [[FailureViewController alloc]initWithNibName:@"FailureViewController" bundle:nil];
                [self.navigationController pushViewController:adVC animated:YES];
                
            }else{
                NSLog(@"未认证");
    RealNameCertificationController *realNameCertification = [[RealNameCertificationController alloc] initWithNibName:@"RealNameCertificationController" bundle:nil];
                            [self.navigationController pushViewController:realNameCertification animated:YES];
            }


        }
        
        //"地址管理"
        if (indexPath.row == 1) {
            AddressManageController *addressManageController = [[AddressManageController alloc] init];
            [self.navigationController pushViewController:addressManageController animated:YES];
        }
        
//        //"增票资质"
//        if (indexPath.row == 2) {
//            ImproveTicketController *improveTicketController = [[ImproveTicketController alloc] init];
//          //  [self.navigationController pushViewController:improveTicketController animated:YES];
//        }
    }
    
    if (indexPath.section == 2) {
        //"安全认证"
        if (indexPath.row == 0) {
            SecurityCertificateController *securityCertificateController = [[SecurityCertificateController alloc] initWithNibName:@"SecurityCertificateController" bundle:nil];
            [self.navigationController pushViewController:securityCertificateController animated:YES];
        }
    }
}
//代理方法
-(void)changesex:(int)inter{
    UILabel * genterLabel = [self.view viewWithTag:11111];
    if (inter==1) {
        genterLabel.text = @"男";
    }else if (inter==2){
        genterLabel.text = @"女";
        
    }else if (inter==3){
        genterLabel.text= @"保密";
        
    }else{
        genterLabel.text = @"";
        
    }

}
-(void)changenick_name:(NSString *)nick_name{
    UILabel * genterLabel = [self.view viewWithTag:11112];
    NSLog(@"%@",nick_name);
    genterLabel.text = nick_name;
}
#pragma mark ---    //图片上传请求
//图片上传请求

-(void)imageRequestAction:(UIImage*)image{
    
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] UPImageToServer:@[image] toKb:40 success:^(NSArray *urlArr) {
        NSDictionary * dic = urlArr[0];
        [weakSelf requestAction:dic[@"url"]image :image];
    } faild:^(id error) {
        
    }];
    
}

-(void)requestAction:(NSString*)Url image:(UIImage*)image{
    
    //控件赋值
    NSString *Token =[AuthenticationModel getLoginToken];
//    PersonChangeModel * model = [[PersonChangeModel alloc ]init ];
//    model.avatar_url = Url;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"avatar_url":Url} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUpdateUserInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
           
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                UIImageView * imageView = [weakself.view viewWithTag:20001];
                imageView.image = image;
            }else {
                [weakself showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            
        }];
        
    }else {
        [weakself showToast:@"请登录后修改"];
    }
    
}

@end

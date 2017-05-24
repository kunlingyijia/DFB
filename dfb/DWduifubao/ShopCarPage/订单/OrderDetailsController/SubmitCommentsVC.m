//
//  SubmitCommentsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SubmitCommentsVC.h"
#import "GoodsModel.h"
#import "CommentsModel.h"
@interface SubmitCommentsVC ()
@property(nonatomic,strong)NSString *rank ;
@end

@implementation SubmitCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"评价晒单";
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
   // NSLog(@"*****---%@", self.order_no);
    [DWHelper SD_WebImage:_goods_logo imageUrlStr:self.Gmodel.goods_logo placeholderImage:nil];
    self.name.text = self.Gmodel.goods_spec_name;
    self.goods_name.text =self.Gmodel.goods_name;
}
#pragma mark - 网络请求
-(void)requestAction{
   
    if (self.content.text.length<15||self.content.text.length>100) {
        [self showToast:@"评论字数在15至100个之间"];
        return;
    }
    NSString *Token =[AuthenticationModel getLoginToken];
   CommentsModel *model = [[CommentsModel  alloc]init];
    model.goods_id =self.Gmodel.goods_id;
    model.order_no = self.order_no;
    model.content = self.content.text;
    model.order_goods_id = self.Gmodel.order_goods_id;
    NSLog(@"%@",self.Gmodel.order_goods_id);
    //评价等级 1-好评 2-中评 3-差评
    model.rank = self.rank;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestComment" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"评价信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.Gmodel.is_comment =@"1";
                [weakself.navigationController popViewControllerAnimated:YES];
                
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}
#pragma mark - 好评
- (IBAction)oneBtnAction:(UIButton *)sender {
    [self changeView:sender];
    self.rank = @"1";
    
}
#pragma mark - 中评
- (IBAction)twoBtnAction:(UIButton *)sender {
    [self changeView:sender];
    self.rank = @"2";
}
#pragma mark - 差评
- (IBAction)threeBtn:(UIButton *)sender {
    [self changeView:sender];
    self.rank = @"3";
}

#pragma mark - 修改评论图片
-(void)changeView:(UIButton*)sender{
    self.commentBtn.backgroundColor = [UIColor redColor];
    self.commentBtn.userInteractionEnabled = YES;
    if ([sender isEqual:self.OneBtn]) {
        self.oneImageView.image = IMG_Name(@"好评") ;
        self.twoImageView.image= IMG_Name(@"中评-灰色");
        self.threeImageView.image= IMG_Name(@"差评-灰色");


    }else if ([sender isEqual:self.twoBtn]) {

        self.oneImageView.image = IMG_Name(@"好评-灰色") ;
        self.twoImageView.image= IMG_Name(@"中评");
        self.threeImageView.image= IMG_Name(@"差评-灰色");
        
    }else if ([sender isEqual:self.ThreeBtn]) {

        self.oneImageView.image = IMG_Name(@"好评-灰色") ;
        self.twoImageView.image= IMG_Name(@"中评-灰色");
        self.threeImageView.image= IMG_Name(@"差评");
    }

    
    
}

- (IBAction)commentBtnAction:(UIButton *)sender {
    [self requestAction];
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

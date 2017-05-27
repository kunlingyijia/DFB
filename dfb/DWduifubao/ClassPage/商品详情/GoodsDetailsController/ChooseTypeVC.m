//
//  ChooseTypeVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ChooseTypeVC.h"
#import "BricklayingView.h"
#import "PublicTF.h"
#import "PublicBtn.h"
#import "specModel.h"
#import "imagesModel.h"
#import "GoodsModel.h"
#import "CarModel.h"
@interface ChooseTypeVC ()
@property(nonatomic,strong)specModel *specmodel;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///数据
@property (nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * choseArr;
@end

@implementation ChooseTypeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated
     ];
    
    
    for (NSMutableDictionary *dic in self.gModel.spec) {
        specModel *model = [specModel yy_modelWithJSON:dic];
        [self.dataArray addObject:model];
        [self.nameArray addObject:model.name];
    }
    [DWHelper SD_WebImage:__goods_logo imageUrlStr:self.gModel.goods_logo placeholderImage:nil];
    _price.text = self.gModel.price;
    __weak typeof(self) weakSelf = self;
    BricklayingView *bricklaying = [[BricklayingView alloc] initWithFrame:CGRectMake(0, 10, Width, Width/2-20) andItems:self.nameArray andItemClickBlock:^(NSInteger i) {
        _price.text = ((specModel*)weakSelf. dataArray[i]).price;
        _gModel.price =  _price.text;
        _gModel.name =((specModel*)weakSelf. dataArray[i]).name;
        _gModel.goods_spec_id =((specModel*)weakSelf. dataArray[i]).goods_spec_id;
    }];
   
    [self.ChooseView addSubview:bricklaying];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle =UIModalPresentationCustom;
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
   
    
}

#pragma mark - 关于UI
-(void)SET_UI{
    
   
    self.AddAndDelView.layer.cornerRadius= 3.0;
    self.AddAndDelView.layer.masksToBounds = YES;
    self.AddAndDelView.layer.borderWidth= 0.5;
    self.AddAndDelView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textTf.userInteractionEnabled = YES;

    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.choseArr = [NSMutableArray arrayWithCapacity:0];
    self.specmodel = [[specModel alloc]init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)BackAction:(UIButton *)sender {
    _gModel.number = _textTf.text;
    self.back(self.gModel);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)back:(Back)back{
    self.back = back;
}
#pragma mark - 减号
- (IBAction)deleteACtion:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>1) {
        a--;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        
    }
    
}

- (IBAction)TFChangeACtion:(PublicTF *)sender {
    if (sender.text.length==0||[self.textTf.text intValue]==0) {
        sender.text=@"1";
    }
    int a=  [self.textTf.text intValue];
    self.textTf.text = [NSString stringWithFormat:@"%d",a];
}

#pragma mark - 加号
- (IBAction)addAction:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>0) {
        a++;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
    }
 
}
#pragma mark - 添加购物车

- (IBAction)AddGoosCar:(UIButton *)sender {
    [self.choseArr removeAllObjects];
    CarModel *model = [[CarModel alloc]init];
    model.merchant_id = self.gModel.merchant_id;
    model.number = _textTf.text;
    NSLog(@"%@",_textTf.text);
    model.goods_spec_id = _gModel.goods_spec_id;
    model.goods_id = _gModel.goods_id;
    [self.choseArr addObject:model];
        NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[self.choseArr yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Cart/requestAddCart" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
                
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                NSLog(@"添加购物车----%@",response);
                if (baseRes.resultCode == 1) {
                    [self.choseArr removeAllObjects];
                    NSInteger CarNumber =0;
                    CarNumber = [[AuthenticationModel getCarNumber] integerValue];
                    CarNumber = (CarNumber+[weakSelf.textTf.text integerValue]);
                     [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)CarNumber] forKey:@"CarNumber"];
                    //添加通知刷新购物车
                    [[NSNotificationCenter defaultCenter ]postNotificationName:@"RefreshGoodsCar" object:nil userInfo:nil];
                    [weakSelf showToast:@"已添加购物车"];
                }else{
                    [weakSelf showToast:baseRes.msg];
                }
                
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
            
        }else {
            [self showToast:@"请登录"];
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

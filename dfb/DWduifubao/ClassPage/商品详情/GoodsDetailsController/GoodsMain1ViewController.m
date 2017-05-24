//
//  GoodsMain1ViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsMain1ViewController.h"
#import "GoodsDetailsViewController.h"
#import "GoodsCommentsViewController.h"
#import "StorePageVC.h"
#import "SubmitOrdersVC.h"
#import "GoodsHomeHeaderView.h"
#import "Good_CommentsCell.h"
#import "GoodsHomeOneCell.h"
#import "ChooseTypeVC.h"
#import "GoodsModel.h"
#import "imagesModel.h"
#import "specModel.h"
#import "CommentsModel.h"
#import "CarModel.h"
#import "SubmitOrdersVC.h"
#import "StorePageVC.h"
#import "LoginController.h"
#import "PhotoViewController.h"
#import "SDCollectionViewCell.h"

@interface GoodsMain1ViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (strong, nonatomic)  SDCycleScrollView *cycleScrollView;
///商品model
@property(nonatomic,strong)GoodsModel *gModel;
//is_collect 是否关注0否/1是
@property(nonatomic,strong)NSString *is_collect;
///评论总数
@property(nonatomic,strong)NSString * comment_num;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///添加购物车Array
@property (nonatomic,strong)NSMutableArray * choseArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *bigUrlArray;
@end

@implementation GoodsMain1ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Goods_BackTo_List" object:nil userInfo:[NSDictionary dictionaryWithObject:@(animated)forKey:@"Goods_BackTo_List"]];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
          //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    //添加子控制器
    [self addSubController];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    
    self.bottomView.userInteractionEnabled = NO;
    _payBtn.backgroundColor = [UIColor grayColor];
    self.mainScrollView = [[UIScrollView
                            alloc]initWithFrame:CGRectMake(0, 0, Width, Height-50-64)];
    _mainScrollView .contentSize = CGSizeMake(Width*3, Height-50-64);
    _mainScrollView.bounces = NO;
    //水平方向
    _mainScrollView.showsHorizontalScrollIndicator = YES;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    UIView  *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,-10, Width-140, 44)];
    UIButton *one = [UIButton buttonWithType:(UIButtonTypeCustom)];
    one.frame = CGRectMake(0, 0, titleView.frame.size.width/3, 42);
    [one setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [one addTarget:self action:@selector(oneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [one setTitle:@"商品" forState:(UIControlStateNormal)];
    one.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:one];
    UIButton *two = [UIButton buttonWithType:(UIButtonTypeCustom)];
    two.frame = CGRectMake(CGRectGetMaxX(one.frame), 0, titleView.frame.size.width/3, 42);
    [two setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [two addTarget:self action:@selector(twoBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [two setTitle:@"详情" forState:(UIControlStateNormal)];
    two.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:two];
    UIButton *three = [UIButton buttonWithType:(UIButtonTypeCustom)];
    three.frame = CGRectMake(CGRectGetMaxX(two.frame), 0, titleView.frame.size.width/3, 42);
    [three setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [three addTarget:self action:@selector(threeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [three setTitle:@"评价" forState:(UIControlStateNormal)];
    three.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:three];
    self.RedView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(one.frame), titleView.frame.size.width/3, 2)];
    _RedView.backgroundColor = [UIColor redColor];
    
    [titleView addSubview:_RedView];
    self.navigationItem.titleView =titleView;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, Width, Height-50-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.mainScrollView addSubview:_tableView];
    [self.tableView tableViewregisterNibArray: @[@"Good_CommentsCell",@"GoodsHomeOneCell"]];
    self.tableView.tableFooterView = [UIView new];
    
}
#pragma mark - 添加子控制器
-(void)addSubController{
    
    //详情
    GoodsDetailsViewController * GoodsDetailsVC = [[GoodsDetailsViewController alloc]initWithNibName:@"GoodsDetailsViewController" bundle:nil];
    GoodsDetailsVC.view.frame = CGRectMake(Width, 0, Width, Height-50-64);
    GoodsDetailsVC.goods_id = self.goods_id;

        [self.mainScrollView addSubview:GoodsDetailsVC.view];
    [self addChildViewController:GoodsDetailsVC];
    //评论
   GoodsCommentsViewController* GoodsCommentsView = [[GoodsCommentsViewController alloc]initWithNibName:@"GoodsCommentsViewController" bundle:nil];
    GoodsCommentsView.view.frame = CGRectMake(2*Width, 0, Width, Height-50-64);
    GoodsCommentsView.goods_id = self.goods_id;
    [self.mainScrollView addSubview:GoodsCommentsView.view];
    [self addChildViewController:GoodsCommentsView];
    
}

#pragma mark - 商品事件
-(void)oneBtnAction:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    }];
   
    
}
#pragma mark - 详情事件
-(void)twoBtnAction:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(Width, 0);
    }];
   
    
}
#pragma mark - 评论事件
-(void)threeBtnAction:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(2*Width, 0);
    }];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.choseArr = [NSMutableArray arrayWithCapacity:1];
    self.bigUrlArray = [NSMutableArray arrayWithCapacity:1];
    _gModel =  [[GoodsModel alloc]init];
    self.comment_num = @"";
    
        //1, 创建并行队列
    dispatch_queue_t queue = dispatch_queue_create("商品", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue, ^{
        //商品网络请求
        [weakSelf requestAction];
    }) ;
    dispatch_async(queue, ^{
        //商品网络请求
        [weakSelf requestCommentsAction];
    }) ;

    //购物车 数量赋值
    NSString *Token =[AuthenticationModel getLoginToken];
       if (Token.length!=0&& ![[AuthenticationModel getCarNumber]isEqualToString:@"0"]) {
           self.CarNumber.hidden = NO;
           self.CarNumber.text = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
       }else{
           self.CarNumber.hidden = YES;
       }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.RedView.frame = CGRectMake(0+scrollView.contentOffset.x*(Width-140)/3/Width, 42, (Width-140)/3,2);
}
#pragma mark - 跳转到店铺中
- (IBAction)PushStorePageVC:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //Push 跳转
    StorePageVC * VC = [[StorePageVC alloc]initWithNibName:@"StorePageVC" bundle:nil];
    VC.merchant_id =[NSString stringWithFormat:@"%@", self.gModel.merchant_id];

    [self.navigationController  pushViewController:VC animated:YES];

   

}
#pragma mark - 关注事件
- (IBAction)FocusAction:(UIButton *)sender {
    NSString * is_collect ;
    for (id tempView in sender.superview.subviews) {
        if ([tempView isKindOfClass:[UILabel class]]) {
            UILabel *label = tempView;
            
            if ([label.text isEqualToString:@"关注"]) {
                is_collect = @"1";
            }else if ([label.text isEqualToString:@"已关注"]) {
                is_collect = @"0";
            }
        }
    }
    CarModel *model = [[CarModel alloc]init];
    model.goods_id = _gModel.goods_id;
    model.is_collect = is_collect;
    NSString *Token =[AuthenticationModel getLoginToken];
    
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_CollectGoods sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"关注----%@",response);
            if (baseRes.resultCode == 1) {
              
                if ([weakSelf.GuanZhuLabel.text isEqualToString:@"关注"]) {
                    [weakSelf showToast:@"关注成功"];
                    weakSelf.GuanZhuLabel.text = @"已关注";
                    weakSelf.GuanZhuImageView.image = IMG_Name(@"已关注");
                }else{
                    [weakSelf showToast:@"取消关注"];
                    weakSelf.GuanZhuLabel.text = @"关注";
                    weakSelf.GuanZhuImageView.image = IMG_Name(@"未关注");
                    
                }

                
            }else if(baseRes.resultCode == 2007) {
                //商品已关注
                if ([weakSelf.GuanZhuLabel.text isEqualToString:@"关注"]) {
                    weakSelf.GuanZhuLabel.text = @"已关注";
                    weakSelf.GuanZhuImageView.image = IMG_Name(@"已关注");
                }else{
                    weakSelf.GuanZhuLabel.text = @"关注";
                    
                }

            }else {
                [weakSelf showToast:baseRes.msg];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
        [self pushLoginController];
        //Push 跳转
        
        
        
        
    }

    
}

#pragma mark - 添加购物车
- (IBAction)AddShopCarAction:(UIButton *)sender {
    [self.choseArr removeAllObjects];
    CarModel *model = [[CarModel alloc]init];
    model.merchant_id = self.gModel.merchant_id;
    model.number = self.gModel.number;
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
                NSInteger CarNumber =0;
                CarNumber = [[AuthenticationModel getCarNumber] integerValue];
                CarNumber = (CarNumber+[self.gModel.number integerValue]);
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",CarNumber] forKey:@"CarNumber"];
                if (![[AuthenticationModel getCarNumber] isEqualToString:@"0"]) {
                    weakSelf.CarNumber.hidden = NO;
                     weakSelf.CarNumber.text = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
                }
                    //else{
//                  weakSelf.CarNumber.text = [AuthenticationModel getCarNumber];
//                }
//               
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
        
        [self pushLoginController];
        
    }

    
    
}
#pragma mark - 立即购买
- (IBAction)BuyAction:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSString *Token =[AuthenticationModel getLoginToken];
    NSLog(@"%@",[self.gModel yy_modelToJSONString]);
    if (Token.length!= 0) {
        [self.choseArr removeAllObjects];
        self.gModel.goods_spec_name = self.gModel.name;
        [self.choseArr addObject:self.gModel];
        //去支付下订单
        SubmitOrdersVC * VC = [[SubmitOrdersVC alloc]initWithNibName:@"SubmitOrdersVC" bundle:nil];
        VC.choseArr = self.choseArr;
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    

    
    

}
#pragma mark - 商品网络请求
-(void)requestAction{
    
    GoodsModel *model = [[GoodsModel alloc]init];
    model.goods_id = self.goods_id;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    NSString * token = [AuthenticationModel getLoginToken];
    baseReq.token = token;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_GoodsInfo sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"商品----%@",response);
        if (baseRes.resultCode == 1) {
            self.gModel = [GoodsModel  yy_modelWithJSON:response[@"data"]];
            
            for (NSDictionary *imageUrlDic in self.gModel.images) {
                [_bigUrlArray addObject:imageUrlDic[@"image_url"]];
            }

            if ([weakself.gModel.is_collect isEqualToString:@"0"]) {
                //未关注
                weakself.GuanZhuLabel.text = @"关注";
                weakself.GuanZhuImageView.image = IMG_Name(@"未关注");
            }else{
                weakself.GuanZhuLabel.text = @"已关注";
                weakself.GuanZhuImageView.image = IMG_Name(@"已关注");
            }
            
            if (token.length!= 0&&
                ![[AuthenticationModel getCarNumber]isEqualToString:@"0"]) {
                self.CarNumber.hidden = NO;
                self.CarNumber.text = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
            }else{
                self.CarNumber.hidden = YES;
            }

            weakself.bottomView.userInteractionEnabled = YES;
            _payBtn.backgroundColor = [UIColor redColor];

        }
        //NSLog(@"%@",self.gModel);
        [weakself.tableView reloadData];
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark - 评论网络请求
-(void)requestCommentsAction{
        GoodsModel *model = [[GoodsModel alloc]init];
    model.goods_id = self.goods_id;
    model.remark = @"";
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestCommentList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"评论----%@",response);
        if (baseRes.resultCode == 1) {
            [weakself.dataArray removeAllObjects];

            NSMutableArray *arr =response[@"data"][@"comment"];
            for (NSDictionary *dic in arr ) {
                CommentsModel *model = [CommentsModel  yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            
            self.comment_num = [NSString stringWithFormat:@" %@ ",response[@"data"][@"comment_num"]];
        }
        
        [weakself.tableView reloadData];
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if([_comment_num isEqualToString:@""] ){
             return 0;
            }else{
                return 1;
            }
            
           break;
        }
           
        case 1:
        {
            return self.dataArray.count;
        }
            break;
        default:
            break;
    }
    return 10;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (indexPath.section==0) {
        
        GoodsHomeOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsHomeOneCell" forIndexPath:indexPath];
        if (!_cycleScrollView) {
            // 网络加载图片的轮播器
            self.cycleScrollView = [SDCycleScrollView   cycleScrollViewWithFrame:CGRectMake(0, 0, Width, Width) delegate:self placeholderImage:[UIImage imageNamed:[NSString stringWithFormat: @"正在加载中..."]]];
            _cycleScrollView.autoScroll = YES;
            _cycleScrollView. infiniteLoop =YES;
            _cycleScrollView.autoScrollTimeInterval =3.0;
            [cell.contentView addSubview:_cycleScrollView];
        }
        
        
        NSMutableArray * imageUrlArr=[NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *imageUrlDic in self.gModel.images) {
            [imageUrlArr addObject:imageUrlDic[@"image_url"]];
        }
        if (_cycleScrollView) {
            _cycleScrollView.imageURLStringsGroup = imageUrlArr;
        }
        cell.comment_num.text = [NSString stringWithFormat:@"%@人评论" ,self.comment_num];
        //cell赋值
        [cell cellGetData:self.gModel];
        //cell选中时的无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加类型事件
        [cell.typeBtn addTarget:self action:@selector(typeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.MoreCommentsBtn addTarget:self action:@selector(MoreCommentsBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }else if (indexPath.section==1){
        Good_CommentsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Good_CommentsCell" forIndexPath:indexPath];
        [cell cellGetDAta:(CommentsModel*)self.dataArray[indexPath.row]];
        //cell选中时的颜色 无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
#pragma mark - 更多版本类型
-(void)typeBtnAction:(UIButton*)sender{
    //NSString *Token =[AuthenticationModel getLoginToken];
    //if (Token.length!= 0) {
        //Push 跳转
        ChooseTypeVC * VC = [[ChooseTypeVC alloc]initWithNibName:@"ChooseTypeVC" bundle:nil];
        VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        VC.gModel = self.gModel;
        __weak typeof(self) weakSelf = self;
        [VC back:^(GoodsModel *model) {
            //购物车 数量赋值
            NSString *Token =[AuthenticationModel getLoginToken];
            if (Token.length!= 0&& ![[AuthenticationModel getCarNumber]isEqualToString:@"0"]) {
                                    weakSelf.CarNumber.hidden = NO;
                weakSelf.CarNumber.text = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
            }

            [weakSelf.tableView reloadData];
        }];
        [self presentViewController:VC animated:YES completion:nil];
    }
//else{
        
       // [self pushLoginController];
        
    //}
    
    
//}


#pragma mark - 更多评论
-(void)MoreCommentsBtnAction:(UIButton*)sender{
  
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(2*Width, 0);
    }];
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = Height;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
}



#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    [VC LoginRefreshAction:^{
        [BackgroundService  requestPushVC:weakSelf MyselfAction:^{
            [weakSelf requestAction];
        }];
       
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
#pragma mark -/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.urlArray = _bigUrlArray;
//    SDCollectionViewCell * Cell=[cycleScrollView.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    photoVC.imgFrame = self.view.frame;
    photoVC.index = index;
    //photoVC.frameArray = [_frameArray copy];
    photoVC.imgData = [self getImageDataWithUrl:[_bigUrlArray objectAtIndex:index]];
    
    [self presentViewController:photoVC animated:NO completion:nil];
    
    photoVC.indexBlock = ^(NSInteger index){
      
       
        //[cycleScrollView ImageContentOffset:CGPointMake(index*Width,0)];
        
    };
    
    [photoVC setCompletedBlock:^(void){
//        [_coverView removeFromSuperview];
//        _coverView = nil;
    }];
}

- (NSData *)getImageDataWithUrl:(NSString *)url
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    return imageData;
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
}
@end

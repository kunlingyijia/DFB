//
//  RightViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RightViewController.h"

#import "ClassRightCell.h"
#import "ClassModel.h"
#import "PublicViewController.h"
#import "GoodsListViewController.h"
@interface RightViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RightViewController

-(void)reloadViewOfSelf:(NSNotification *)notification{
    ClassModel *model = [[ClassModel alloc]init];
    model.category_id =[[notification.userInfo objectForKey:@"Leftcategory_id"]intValue] ;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/C2CCategory/requestC2cCategoryList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        // NSLog(@"%@",response);
        if (baseRes.resultCode == 1) {
        [weakself.dataArray removeAllObjects];

            NSMutableArray * arr = response[@"data"];
            for (NSDictionary *dic in arr) {
                ClassModel *model = [ClassModel  yy_modelWithJSON:dic];
                [weakself.dataArray  addObject:model];
            }
            [weakself.collectionView reloadData];
            
        }else{
            //[weakself showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // NSLog(@"%@",NSHomeDirectory());
    [[NSNotificationCenter defaultCenter]addObserver : self selector:@selector(reloadViewOfSelf:) name:@"LeftTabViewRefresh"  object:nil];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClassRightCell" bundle:nil] forCellWithReuseIdentifier:@"ClassRightCell"];
    //网络请求
    [self requestAction];
}
//网络请求
-(void)requestAction{
    [self.dataArray removeAllObjects];
    NSMutableArray * arr = [AuthenticationModel objectForKey:@"RightVCDAta"];
    if (arr.count!=0 ) {
        for (NSDictionary *dic in arr) {
            ClassModel *model = [ClassModel  yy_modelWithJSON:dic];
            [self.dataArray  addObject:model];
        }
        
    }
    ClassModel *model = [[ClassModel alloc]init];
    model.category_id = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/C2CCategory/requestC2cCategoryList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakself.dataArray removeAllObjects];
            [AuthenticationModel setValue:response forkey:@"RightVCDAta"];
            NSMutableArray * arr = response[@"data"];
            for (NSDictionary *dic in arr) {
                ClassModel *model = [ClassModel  yy_modelWithJSON:dic];
                [weakself.dataArray  addObject:model];
            }
            [weakself.collectionView reloadData];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return nil;
    }else{
    
    ClassRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassRightCell" forIndexPath:indexPath];
    ClassModel *model = self.dataArray[indexPath.row];
    cell.label.font = [UIFont systemFontOfSize:15];
    cell.label.text = [NSString stringWithFormat:@"%@",model.category_name];
    [DWHelper SD_WebImage:cell.imageView imageUrlStr:model.image_url placeholderImage:nil];
       return cell;
        
    }
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake(Width/4, Width/4+30);
    
    
}
//定义每个UICollectionView 的
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0 ;
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    GoodsListViewController * VC = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
    NSLog(@"-----%@",[NSString stringWithFormat:@"%d", ((ClassModel*)self.dataArray[indexPath.row]).category_id]);
    VC.category_id =[NSString stringWithFormat:@"%d", ((ClassModel*)self.dataArray[indexPath.row]).category_id];
    [self.navigationController  pushViewController:VC animated:YES];

    
//    PublicViewController *PBVc = [[PublicViewController alloc]initWithNibName:@"PublicViewController" bundle:nil];
//    [self.navigationController pushViewController:PBVc animated:YES];
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 移除观察者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LeftTabViewRefresh" object:nil];
}

@end

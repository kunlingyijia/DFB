//
//  FocusMainVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "FocusMainVC.h"
#import "FocusGoodsVC.h"
#import "FocusStoreVC.h"
@interface FocusMainVC ()

@end

@implementation FocusMainVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]
    ;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    self.mainScrollView = [[UIScrollView
                            alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    _mainScrollView .contentSize = CGSizeMake(Width*2, Height-64);
    
    _mainScrollView.bounces = NO;

    //水平方向
    _mainScrollView.showsHorizontalScrollIndicator = YES;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    self. titleView = [[UIView alloc]initWithFrame:CGRectMake(0,-10, Width/2, 44)];
    UIButton *one = [UIButton buttonWithType:(UIButtonTypeCustom)];
    one.frame = CGRectMake(0, 0,  self.titleView.frame.size.width/2, 42);
    [one setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [one addTarget:self action:@selector(oneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [one setTitle:@"商品" forState:(UIControlStateNormal)];
    one.titleLabel.font = [UIFont systemFontOfSize:15];
    [ self.titleView addSubview:one];
    UIButton *two = [UIButton buttonWithType:(UIButtonTypeCustom)];
    two.frame = CGRectMake(CGRectGetMaxX(one.frame), 0,  self.titleView.frame.size.width/2, 42);
    [two setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [two addTarget:self action:@selector(twoBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [two setTitle:@"店铺" forState:(UIControlStateNormal)];
    two.titleLabel.font = [UIFont systemFontOfSize:15];
    [ self.titleView addSubview:two];
    self.RedView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(one.frame),  self.titleView.frame.size.width/2, 2)];
    _RedView.backgroundColor = [UIColor redColor];
    [ self.titleView addSubview:_RedView];
    self.navigationItem.titleView = self.titleView;
}
#pragma mark - 关于数据
-(void)SET_DATA{
    if ([self.titlestr isEqualToString:@"店铺"]) {
        _mainScrollView.contentOffset = CGPointMake(Width, 0);
    }
    
    
}
#pragma mark - 添加子控制器
-(void)addSubController{
    //商品
    FocusGoodsVC * focusGoodsVC = [[FocusGoodsVC alloc]initWithNibName:@"FocusGoodsVC" bundle:nil];
    focusGoodsVC. view.frame = CGRectMake(0,0, Width, Height-64);
    [self.mainScrollView addSubview:focusGoodsVC.view];
    [self addChildViewController:focusGoodsVC];
    //店铺
    FocusStoreVC * focusStoreVC = [[FocusStoreVC alloc]initWithNibName:@"FocusStoreVC" bundle:nil];
    focusStoreVC.view.frame = CGRectMake(Width,0, Width, Height-64);
    [self.mainScrollView addSubview:focusStoreVC.view];
    [self addChildViewController:focusStoreVC];
    


}
#pragma mark - 商品事件
-(void)oneBtnAction:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FocusMainVC_Goods" object:nil userInfo:nil];
    
}
#pragma mark - 店铺事件
-(void)twoBtnAction:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        _mainScrollView.contentOffset = CGPointMake(Width, 0);
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FocusMainVC_Store" object:nil userInfo:nil];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.RedView.frame = CGRectMake(0+scrollView.contentOffset.x*(Width/2)/2/Width, 42, (Width/2)/2,2);
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

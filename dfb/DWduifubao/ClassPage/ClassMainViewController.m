//
//  ClassMainViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ClassMainViewController.h"
#import "LeftMainViewController.h"
#import "RightViewController.h"
#import "NavigationView.h"
#import "PublicViewController.h"
#import "EWMViewController.h"
#import "MessageViewController.h"
#import "LoginController.h"
#import "SearchHistoryViewController.h"
@interface ClassMainViewController ()<NavigationViewdelegate>
@property(nonatomic,strong)UIView * baseBottomView1;

@end

@implementation ClassMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(XianShi) name:@"显示" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Quxiao) name:@"取消" object:nil];
    // Do any additional setup after loading the view.
    //添加子控制器
    [self addSubController];
    //创建导航条
    [self addSubViews];
    
}
#pragma mark - 创建导航条
-(void)addSubViews{
    
    NavigationView *NGView =   ( NavigationView *)[NIBHelper instanceFromNib:@"NavigationView"];
    NGView.delegate = self;
    NGView.backgroundColor = [UIColor whiteColor];
    NGView.frame = CGRectMake(0, 0, Width, 64);
    [NGView.SaoYiSaoBtn setImage:[UIImage imageNamed:@"首页-扫一扫图标-灰色"] forState:(UIControlStateNormal)];
    [NGView.sousuoBtn setImage:[UIImage imageNamed:@"首页-搜索框-搜索按钮-灰色"] forState:(UIControlStateNormal)];
    [NGView.XiaoXiBtn setImage:[UIImage imageNamed:@"首页-信息图标-灰色"] forState:(UIControlStateNormal)];
    [self.view addSubview:NGView];
    
}
#pragma mark  - NavigationViewdelegate
-(void)NavErWeiMaPush{
    EWMViewController * VC = [[EWMViewController alloc]initWithNibName:@"EWMViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(void)NavSouSuoPush{
//    //Push 跳转
    SearchHistoryViewController * VC = [[SearchHistoryViewController alloc]initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

   // [self GetPublicController];
}
-(void)NavMassagePush{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        MessageViewController * VC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else{
        //Push 跳转
        LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        [VC LoginRefreshAction:^{
            
        }];

        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 添加字控制器
-(void)addSubController{
    LeftMainViewController * LeftVC = [[LeftMainViewController alloc]initWithNibName:@"LeftMainViewController" bundle:nil];
    LeftVC.view.frame = CGRectMake(0, 44, Width/4, Height-44-44);
    [self.view addSubview:LeftVC.view];
    [self addChildViewController:LeftVC];
    RightViewController * RightVC = [[RightViewController alloc]initWithNibName:@"RightViewController" bundle:nil];
    RightVC.view.frame = CGRectMake(Width/4, 64, Width/4*3, Height-64-44);
    [self.view addSubview:RightVC.view];
    [self addChildViewController:RightVC];

    
    
}
#pragma mark - 跳转公共
-(void)GetPublicController{
    PublicViewController *PBVC = [[PublicViewController alloc] initWithNibName:@"PublicViewController" bundle:nil];
    [self.navigationController pushViewController:PBVC animated:YES];
}
-(void)XianShi{
    
    if (!_baseBottomView1) {
        __weak typeof(self) weakSelf = self;
        self.baseBottomView1 = [[UIView alloc]initWithFrame:CGRectZero];
        [UIView animateWithDuration:0.0000001 animations:^{
            weakSelf.baseBottomView1.frame =  CGRectMake(0, 64, Width, Height-64);
            self.baseBottomView1.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
            [self.view addSubview:_baseBottomView1];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
            imageView.image = [UIImage imageNamed:@"暂无数据"];
            imageView.contentMode =  UIViewContentModeCenter;
            imageView.clipsToBounds  = YES;
            [_baseBottomView1 addSubview:imageView];
        } ];
        
        
    }
    
    
}
-(void)Quxiao{
    
    if (_baseBottomView1) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            [_baseBottomView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weakSelf.baseBottomView1.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [weakSelf.baseBottomView1 removeFromSuperview];
            weakSelf.baseBottomView1 = nil;
        }];
        
    }

    
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

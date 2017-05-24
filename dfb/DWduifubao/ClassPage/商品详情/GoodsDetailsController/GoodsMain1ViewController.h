//
//  GoodsMain1ViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@interface GoodsMain1ViewController : BaseViewController<UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *mainScrollView;
///红色View
@property (nonatomic, strong) UIView  *RedView ;
///商品id
@property (nonatomic, strong) NSString  *goods_id ;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *payBtn;

@property (weak, nonatomic) IBOutlet UIImageView *GuanZhuImageView;
@property (weak, nonatomic) IBOutlet UILabel *GuanZhuLabel;
///购物车数量
@property (weak, nonatomic) IBOutlet UILabel *CarNumber;






@end

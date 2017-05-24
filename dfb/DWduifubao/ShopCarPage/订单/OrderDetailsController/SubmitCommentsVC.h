//
//  SubmitCommentsVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class GoodsModel;
@interface SubmitCommentsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;

@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

///属性传值 --商品model
@property (nonatomic, strong) GoodsModel  *Gmodel ;
///属性传值-订单号
@property (nonatomic, strong) NSString  *order_no ;



@end

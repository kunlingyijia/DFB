//
//  MyOrderController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"


@interface MyOrderController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *allOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *WaitingPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *WaitingGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *WaitingCommentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@property (strong, nonatomic)  UIView *redView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

///属性传值
@property (nonatomic, strong) NSString  *titleStr;


@end

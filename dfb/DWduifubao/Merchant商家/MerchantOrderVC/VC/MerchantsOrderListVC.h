//
//  MerchantsOrderListVC.h
//  自定义弹窗
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsOrderListVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *MiddleBtn;
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
@property (weak, nonatomic) IBOutlet UITextField *TF;
///merchant_id
@property (nonatomic, strong) NSString  *merchant_id ;


@end

//
//  PayGoodsVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface PayGoodsVC : BaseViewController
//总价格
@property (weak, nonatomic) IBOutlet UILabel *price;
///现金
@property (weak, nonatomic) IBOutlet UILabel *cashlabel;
//属性传值(总价格)
@property(nonatomic,strong)NSString * allPrice;
///订单数据
@property (nonatomic, strong) NSDictionary  *orderData;



@end

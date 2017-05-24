//
//  IndianaShopListVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndianaShopClassModel;
@interface IndianaShopListVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *AllGoogs;

///选中分类
@property (nonatomic, strong) IndianaShopClassModel  *ClassModel ;
///分类数组
@property (nonatomic, strong) NSMutableArray  *ClassArr ;

@end

//
//  StorePageHeaderView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;
@interface StorePageHeaderView : UIView
//merchant_name		String	45	店铺名称
//merchant_logo			255	店铺logo
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;

@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
@property (weak, nonatomic) IBOutlet UIImageView *GuanZhuImageView;
@property (weak, nonatomic) IBOutlet UILabel *GuanZhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *collect_peoples;
@property (weak, nonatomic) IBOutlet UIImageView *main_image;

@property (weak, nonatomic) IBOutlet UIButton *GuanZhuBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;
///跳转店铺详情
@property (weak, nonatomic) IBOutlet PublicBtn *merchantBtn;

-(void)cellGetData:(MyShopModel*)model;

@end

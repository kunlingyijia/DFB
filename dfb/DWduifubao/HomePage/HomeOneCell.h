//
//  HomeOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeOneCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *myPropertyBtn;       //"我的资产"的按钮
@property (weak, nonatomic) IBOutlet UIButton *dfSnatchGemBtn;      //我要开店
@property (weak, nonatomic) IBOutlet UIButton *dfFinanceBtn;//我的服务
///O2OCollectMoneyBtn
@property (weak, nonatomic) IBOutlet  UIButton  *O2OCollectMoneyBtn ;


@property (weak, nonatomic) IBOutlet UIButton *FiveBtn;  //我要办卡
@property (weak, nonatomic) IBOutlet UIButton *SixBtn;  //我要贷款
@property (weak, nonatomic) IBOutlet UIButton *SevenBtn;  //我要推荐
@property (weak, nonatomic) IBOutlet UIButton *EightBtn;  //我要财富

///HomeOneCellBlock
@property (nonatomic, copy) void(^HomeOneCellBlock)(NSInteger tag)  ;


@end

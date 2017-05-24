//
//  IndianaShopDetailsOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaShopModel;
@interface IndianaShopDetailsOneCell : UITableViewCell<SDCycleScrollViewDelegate>
///model
@property (nonatomic, strong) IndianaShopModel *model ;
///轮播图
@property (nonatomic, copy) void(^IndianaShopDetailsOneCellScrollViewImageBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *times_no;

@property (weak, nonatomic) IBOutlet UILabel *counts;

@property (weak, nonatomic) IBOutlet UILabel *players;
///剩余
@property (weak, nonatomic) IBOutlet UILabel *remaining;

@property (weak, nonatomic) IBOutlet WTProgressView *progressV;


@end

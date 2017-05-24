//
//  IndianaShopListOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaShopModel;
@interface IndianaShopListOneCell : UITableViewCell
///model
@property (nonatomic, strong) IndianaShopModel *model ;
@property (weak, nonatomic) IBOutlet WTProgressView *progressV;
@property (weak, nonatomic) IBOutlet PublicBtn *OneBtn;

@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *times_counts;
@property (weak, nonatomic) IBOutlet UILabel *players;



@end

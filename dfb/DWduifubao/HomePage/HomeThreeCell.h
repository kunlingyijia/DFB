//
//  HomeThreeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface HomeThreeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *spec;
-(void)cellGetData:(GoodsModel*)model;
@end

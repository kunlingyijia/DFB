//
//  collectionTwoCell.h
//  改变布局--集合视图
//
//  Created by 席亚坤 on 16/11/21.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface collectionTwoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *comment_num;
@property (weak, nonatomic) IBOutlet UILabel *sales_num;

-(void)cellGetData:(GoodsModel*)model;
@end

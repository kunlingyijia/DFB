//
//  GoodsHomeOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface GoodsHomeOneCell : UITableViewCell
///更多版本
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
///更多评论
@property (weak, nonatomic) IBOutlet UIButton *MoreCommentsBtn;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *comment_num;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *total_freight;


-(void)cellGetData:(GoodsModel*)model;
@end

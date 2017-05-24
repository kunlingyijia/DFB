//
//  OrderCommentsListCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class GoodsModel;
@interface OrderCommentsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet PublicBtn *commentsBtn;

-(void)cellGetData:(GoodsModel*)model;
@end

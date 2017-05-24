//
//  GoodsCommentsViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsCommentsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraintsWidth;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *comment_num;
@property (weak, nonatomic) IBOutlet UILabel *good_num;
@property (weak, nonatomic) IBOutlet UILabel *mid_num;

@property (weak, nonatomic) IBOutlet UILabel *bad_num;
///商品id
@property (nonatomic, strong) NSString  *goods_id;


@end

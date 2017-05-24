//
//  ChooseTypeVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class PublicBtn;
@class PublicTF;
@class GoodsModel;
typedef void(^Back) (GoodsModel *model);
@interface ChooseTypeVC : BaseViewController
@property(nonatomic,copy)Back back;
-(void)back:(Back)back;
@property (weak, nonatomic) IBOutlet UIImageView *_goods_logo;

@property (weak, nonatomic) IBOutlet UIView *ChooseView;
@property (weak, nonatomic) IBOutlet UIView *AddAndDelView;
@property (weak, nonatomic) IBOutlet PublicTF *textTf;
@property (weak, nonatomic) IBOutlet PublicBtn *deleteBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *price;

///属性传值
@property (nonatomic, strong) GoodsModel  *gModel ;


@end

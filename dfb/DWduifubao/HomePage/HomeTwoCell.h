//
//  HomeTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class GoodsModel;
@interface HomeTwoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Onegoods_logo;
@property (weak, nonatomic) IBOutlet UIImageView *Twogoods_logo;
@property (weak, nonatomic) IBOutlet UIImageView *Threegoods_logo;
@property (weak, nonatomic) IBOutlet UIImageView *Fourgoods_logoFour;
@property (weak, nonatomic) IBOutlet UIImageView *Fivegoods_logo;
@property (weak, nonatomic) IBOutlet PublicBtn *oneBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *twoBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *threeBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *fourBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *FiveBtn;
-(void)cellGetData:(NSMutableArray*)arr;
@end

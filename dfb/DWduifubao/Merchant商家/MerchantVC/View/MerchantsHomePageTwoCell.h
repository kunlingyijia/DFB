//
//  MerchantsHomePageTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsHomePageTwoCell : UITableViewCell
///MerchantsHomePageTwoCellBlock
@property (nonatomic, copy) void(^MerchantsHomePageTwoCellBlock)(NSInteger tag)  ;


@property (weak, nonatomic) IBOutlet PublicBtn *oneBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *twoBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *threeBtn;

@end

//
//  SelectSubCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SelectSubCell.h"

@implementation SelectSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
  self.price.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
}

@end

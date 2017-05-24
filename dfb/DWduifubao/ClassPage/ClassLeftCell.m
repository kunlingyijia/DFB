//
//  ClassLeftCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ClassLeftCell.h"

@implementation ClassLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"111111111");
    
    if (selected) {
        self.label.textColor = [UIColor redColor];
        self.label.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    }else
    {
        self.label.textColor = [UIColor blackColor];
        self.label.backgroundColor = [UIColor whiteColor];
        
    }
}


@end

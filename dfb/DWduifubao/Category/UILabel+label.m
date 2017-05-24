//
//  UILabel+label.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UILabel+label.h"

@implementation UILabel (label)
-(void)labelSetFout:(LabelFout)labelFout{
    switch (labelFout) {
        case LabelFoutOne:{
            self.font = [UIFont systemFontOfSize:(int)(SizeScale*kFirstTitleFont)];
            self.textColor = [UIColor redColor];
            NSLog(@"--%d",(int)(SizeScale*kFirstTitleFont));
        }
        break;
        case LabelFoutTwo:{
             self.font = [UIFont systemFontOfSize:SizeScale*ksecondTitleFont];
             NSLog(@"--%d",(int)(SizeScale*ksecondTitleFont));
        }
        break;
        case LabelFoutThree:{
            self.font = [UIFont systemFontOfSize:SizeScale*kthirdTitleFont]; NSLog(@"--%d",(int)(SizeScale*kthirdTitleFont));
        }
            
        break;

        default:
            break;
    }
    
}
@end

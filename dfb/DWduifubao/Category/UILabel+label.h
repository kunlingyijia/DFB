//
//  UILabel+label.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    LabelFoutOne,
    LabelFoutTwo,
    LabelFoutThree,
} LabelFout;


@interface UILabel (label)
///hh

-(void)labelSetFout:(LabelFout)labelFout;



@end

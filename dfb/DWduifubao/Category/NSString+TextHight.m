//
//  NSString+TextHight.m
//  
//
//  Created by kkk on 16/5/3.
//
//

#import "NSString+TextHight.h"

@implementation NSString (TextHight)

+ (CGFloat)getTextHight:(NSString *)text withSize:(CGFloat )wordSize withFont:(CGFloat )font {
    NSDictionary *attrinbtes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [text boundingRectWithSize:CGSizeMake(wordSize, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrinbtes context:nil].size.height;
}



@end

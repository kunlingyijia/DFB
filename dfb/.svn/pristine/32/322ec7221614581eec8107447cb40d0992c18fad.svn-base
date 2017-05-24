//
//  NSString+TextHight.m
//  
//
//  Created by kkk on 16/5/3.
//
//

#import "NSString+TextHight.h"

@implementation NSString (TextHight)

+ (CGFloat)getTextHight:(NSString *)text size:(NSInteger)size {
    NSDictionary *attrinbtes = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    return [text boundingRectWithSize:CGSizeMake(Bounds.size.width-20, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrinbtes context:nil].size.height;
}



@end

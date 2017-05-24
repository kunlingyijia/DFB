//
//  DFBPickerView.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFBPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
///PickerViews
//@property (nonatomic, strong) UIPickerView *pickerview ;
///rightArr
-(instancetype)initWithFrame:(CGRect)frame
                    rightArr:(NSMutableArray*)rightArr leftArr:(NSMutableArray*)leftArr title:(NSString   * )title;
@property (nonatomic, strong) NSMutableArray *rightArr ;
///leftArr
@property (nonatomic, strong) NSMutableArray *leftArr ;
///title
@property (nonatomic, strong) NSString *title ;






@end

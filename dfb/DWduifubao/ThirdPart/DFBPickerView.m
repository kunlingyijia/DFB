//
//  DFBPickerView.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DFBPickerView.h"

@implementation DFBPickerView{
    UIPickerView *pickerView;
}
-(instancetype)initWithFrame:(CGRect)frame
                     rightArr:(NSMutableArray*)rightArr leftArr:(NSMutableArray*)leftArr title:(NSString   * )title{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];

        self.backgroundColor = [UIColor clearColor];
         self.rightArr = rightArr;
        self.leftArr = leftArr;
        self.title = title;
        NSLog(@"代表左侧的滚筒---%@",_rightArr);
        [self addUI];
    }
    return self;
}


-(void)addUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-240, self.frame.size.width, 40)];
   view .userInteractionEnabled = YES;
    [self addSubview:view];
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    leftBtn.frame = CGRectMake(0, 0, 50, 40);
    [leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:leftBtn];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, self.frame.size.width-100, 40)];
    titleLabel.backgroundColor = [UIColor yellowColor];
    titleLabel.text = self.title;
    [view addSubview:titleLabel];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 50, 40);
    [rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:rightBtn];
   pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, 200)];
    pickerView.backgroundColor = [UIColor blueColor];
    pickerView.userInteractionEnabled = YES;
    pickerView.showsSelectionIndicator = YES;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    [view addSubview:pickerView];
    
    
    
}
#pragma mark - 取消按钮
-(void)leftBtn:(UIButton*)sender{
    
    
    
}



#pragma mark - 确定按钮
-(void)rightBtn:(UIButton*)sender{
    
    
    
}
//滚筒个数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//每个滚筒上的几条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        //代表左侧的滚筒
        return [_rightArr count];
    }else{
        return [_rightArr count];
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component==0) {
        //代表左侧的滚筒
        
        return [_rightArr objectAtIndex:row];
    }else{
        return [_rightArr objectAtIndex:row];
    }
    
    return nil;
}
//点击事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSLog(@"选择%@",[_rightArr objectAtIndex:row]);
    }else{
        NSLog(@"选择了%@",[_rightArr objectAtIndex:row]);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

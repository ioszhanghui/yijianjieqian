//
//  ZHHomeViewController.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "ZHHomeViewController.h"
#import "TTScrollRulerView.h"

@interface ZHHomeViewController ()<rulerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *debtMoneyLabel;
@property (weak, nonatomic) IBOutlet TTScrollRulerView *rulerScrollView;

@end

@implementation ZHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rulerScrollView.rulerDelegate = self;
    //在执行此方法前，可先设定参数：最小值，最大值，横向，纵向等等   ------若不设定，则按照默认值绘制
    [self.rulerScrollView customRulerWithLineColor:customColorMake(232, 232, 232) NumColor:UIColorFromRGB(0xd7d7d7) scrollEnable:YES];
}

#pragma mark 标尺代理方法
- (void)rulerWith:(NSInteger)days {
    
    //即时打印出标尺滑动位置的数值
    self.debtMoneyLabel.text = [NSString stringWithFormat:@"%ld.00",days];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (IBAction)meBtnAction:(id)sender {
}
- (IBAction)applyBtnAction:(id)sender {
}

@end

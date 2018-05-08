//
//  CALayer+LayerColor.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (LayerColor)
/*设置边框颜色*/
- (void)setBorderColorFromUIColor:(UIColor *)color;
@end

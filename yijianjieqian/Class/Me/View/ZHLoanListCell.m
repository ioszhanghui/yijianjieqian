//
//  ZHLoanListCell.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/22.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "ZHLoanListCell.h"
#import "ZHProductModel.h"

@interface ZHLoanListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@end


@implementation ZHLoanListCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (IBAction)applyBtnAction:(id)sender {
    
}

-(void)setProductModel:(ZHProductModel *)productModel{
    _productModel =productModel;
    
    [self.iconImageView downloadImage:[[UD_URL_HOME stringByAppendingPathComponent:@"YJJQWebService"] stringByAppendingString:productModel.product_icon_path] placeholder:@""];
    self.titleLabel.text = productModel.product_name;
}

@end

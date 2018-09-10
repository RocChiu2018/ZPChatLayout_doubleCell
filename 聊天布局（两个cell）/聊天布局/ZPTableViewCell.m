//
//  ZPTableViewCell.m
//  聊天布局
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPTableViewCell.h"
#import "ZPMessage.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ZPTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ZPTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    //设置按钮的内容文字自动换行
    self.contentButton.titleLabel.numberOfLines = 0;
    
    //设置UIButton控件的内边距
    self.contentButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
}

-(void)setMessage:(ZPMessage *)message
{
    _message = message;
    
    if (message.isHideTime)  //隐藏时间
    {
        self.timeLabel.hidden = YES;
        
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    }else  //显示时间
    {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = message.time;
        
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21);
        }];
    }
    
    [self.contentButton setTitle:message.text forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    
    /**
     用Masonry设置UIButton控件的高度就是它里面的titleLabel控件的高度；
     要想更改UIButton控件的高度的话就要在xib文件中把控件的Type由System改成Custom。
     */
    [self.contentButton updateConstraints:^(MASConstraintMaker *make) {
        CGFloat buttonHeight = self.contentButton.titleLabel.frame.size.height + 30;
        
        make.height.equalTo(buttonHeight);
    }];
    
    [self layoutIfNeeded];
    
    CGFloat buttonMaxY = CGRectGetMaxY(self.contentButton.frame);
    CGFloat iconImageViewY = CGRectGetMaxY(self.iconImageView.frame);
    message.cellHeight = MAX(buttonMaxY, iconImageViewY) + 10;
}

@end

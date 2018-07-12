//
//  JagainBaseTableViewCell.m
//  Location
//
//  Created by Jagain on 2018/7/11.
//  Copyright © 2018年 Jagain. All rights reserved.
//

#import "JagainBaseTableViewCell.h"


@implementation JagainBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.textLabel.frame = CGRectMake(15, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end

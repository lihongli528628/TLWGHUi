//
//  ActivitiesCell.m
//  TaoLiWangGongHui
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 Mac OS X. All rights reserved.
//

#import "ActivitiesCell.h"

@implementation ActivitiesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.activityImage.backgroundColor = UIColorFromRGB(0xF0ECEC);
}

- (void)setObject:(NSDictionary *)dict{
    self.activityModel = [[MyActivityModel alloc] initWithDataDic:dict];
    [self.activityImage setImageWithURL:[NSURL URLWithString:self.activityModel.activityPic]];
    self.activityDescription.text = self.activityModel.activityTitle;
    self.activityTime.text = self.activityModel.publishDatetime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

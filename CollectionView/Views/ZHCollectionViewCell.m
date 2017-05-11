//
//  ZHCollectionViewCell.m
//  CollectionView
//
//  Created by aimoke on 2017/5/11.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import "ZHCollectionViewCell.h"

@implementation ZHCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = [UIColor redColor];
}
@end

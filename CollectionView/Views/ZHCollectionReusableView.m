//
//  ZHCollectionReusableView.m
//  CollectionView
//
//  Created by aimoke on 2017/5/11.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import "ZHCollectionReusableView.h"

@implementation ZHCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.textColor = [UIColor redColor];
    self.backgroundColor = [UIColor blueColor];
    // Initialization code
}

@end

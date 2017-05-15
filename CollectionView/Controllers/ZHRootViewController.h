//
//  ZHRootViewController.h
//  CollectionView
//
//  Created by aimoke on 2017/5/11.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHCollectionViewFlowLayout;

@interface ZHRootViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *showCollectionView;
@property (weak, nonatomic) IBOutlet ZHCollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *models;
@end

//
//  ZHCollectionViewFlowLayout.m
//  CollectionView
//
//  Created by aimoke on 2017/5/15.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import "ZHCollectionViewFlowLayout.h"
#import "ZHDecorationCollectionReusableView.h"

@implementation ZHCollectionViewFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemAttributes = [NSMutableArray new];
    id<UICollectionViewDelegateFlowLayout> delegate = (id)self.collectionView.delegate;
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < numberOfSection; section ++) {
        
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        if (lastIndex < 0)
            continue;
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
            sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        frame.origin.x -= sectionInset.left;
        frame.origin.y -= sectionInset.top;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            frame.size.width += sectionInset.left + sectionInset.right;
            frame.size.height = self.collectionView.frame.size.height;
        }
        else
        {
            frame.size.width = self.collectionView.frame.size.width;
            frame.size.height += sectionInset.top + sectionInset.bottom;
        }
        
        if (section % 2 == 0) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"ZHDecorationCollectionReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attributes.zIndex = -1;
            attributes.frame = frame;
            [self.itemAttributes addObject:attributes];
            [self registerNib:[UINib nibWithNibName:@"ZHDecorationCollectionReusableView" bundle:[NSBundle mainBundle]] forDecorationViewOfKind:@"ZHDecorationCollectionReusableView"];
        }else{
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"ZHDecorationCollectionReusableView1" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attributes.zIndex = -1;
            attributes.frame = frame;
            [self.itemAttributes addObject:attributes];
            [self registerNib:[UINib nibWithNibName:@"ZHDecorationCollectionReusableView1" bundle:[NSBundle mainBundle]] forDecorationViewOfKind:@"ZHDecorationCollectionReusableView1"];
        }
       
    }
    
}



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}


@end

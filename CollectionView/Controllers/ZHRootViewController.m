//
//  ZHRootViewController.m
//  CollectionView
//
//  Created by aimoke on 2017/5/11.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import "ZHRootViewController.h"
#import "ZHCollectionModel.h"
#import "ZHCollectionViewCell.h"
#import "ZHHeaderCollectionReusableView.h"
#import "ZHDecorationCollectionReusableView.h"
#import "ZHCollectionViewFlowLayout.h"

@interface ZHRootViewController ()

@end

@implementation ZHRootViewController

#pragma mark - initial
- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(15, 10, 10, 15);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger numbersOfLine = 2;
    CGFloat itemWidth = screenWidth/numbersOfLine - sectionInset.left - sectionInset.right;
    CGFloat itemHeight = itemWidth + 40.0;
    
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向设置
    self.collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemHeight);//设置item大小
    switch (self.collectionViewLayout.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            self.collectionViewLayout.headerReferenceSize = CGSizeMake(screenWidth, 40.0);//设置Header View 大小
            break;
        case UICollectionViewScrollDirectionHorizontal:
            self.collectionViewLayout.headerReferenceSize = CGSizeMake(80, screenHeight);//设置Header View 大小
            break;
        default:
            break;
    }
    
    self.collectionViewLayout.sectionInset =sectionInset; //设置section上下左右的边距
    self.collectionViewLayout.minimumLineSpacing = 5.0;//竖向滑动上下行的最小间距，横向滑动相邻列最小间距
    self.collectionViewLayout.minimumInteritemSpacing = 10.0;//竖向滑动同行的item最小间距，横向滑动同一列上下item最小间距
    
    [self initialModels];// 获取数据源
    self.showCollectionView.delegate = self;
    self.showCollectionView.dataSource = self;
    [self.showCollectionView registerNib:[UINib nibWithNibName:@"ZHHeaderCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZHHeaderCollectionReusableView"];//注册SectionHeader复用
    
    
    // Do any additional setup after loading the view.
}


-(void)initialModels
{
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSInteger i = 1; i <=8 ; i++) {
        ZHCollectionModel *model = [[ZHCollectionModel alloc]init];
        NSString *imgName = [NSString stringWithFormat:@"img%ld",i];
        NSString *title = [NSString stringWithFormat:@"美食%ld",i];
        model.imgName = imgName;
        model.title = title;
        [muArray addObject:model];
    }
    self.models = @[muArray,muArray,muArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   NSArray *array = [self.models objectAtIndex:section];
   return array.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCollectionViewCell *cell = [self.showCollectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    NSArray *datas = [self.models objectAtIndex:indexPath.section];
    ZHCollectionModel *model = [datas objectAtIndex:indexPath.row];
    cell.showImgView.image = [self getMainBundleImgWithImgName:model.imgName withType:@"jpg"];
    cell.titleLabel.text = model.title;
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.models.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        ZHHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZHHeaderCollectionReusableView" forIndexPath:indexPath];
        header.contentLabel.text = [NSString stringWithFormat:@"Header%ld",indexPath.section];
        return header;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select item section:%ld row:%ld",indexPath.section,indexPath.row);
}



#pragma mark - private method
-(UIImage *)getMainBundleImgWithImgName:(NSString *)imgName withType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle]pathForResource:imgName ofType:type];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    return img;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

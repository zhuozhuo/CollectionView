>为何写这个Demo讲述UICollectionView 的基本使用。事情要从13年时有人问[UIcollectionView 如何设置 每个section (不是cell) 不同背景图片](http://www.cocoachina.com/bbs/read.php?tid-253145-page-1.html)由于他说是新人刚接触iOS开发，我就回答让他先看看苹果接口文档，并截了图（虽然图片已经挂了），本来是告诉新人遇到问题后应该怎么解决问题的思路。文档可以解决90%的问题，而不是一遇到问题马上提问或者寻找现成代码。但是后来的一群想找寻答案的人一看没代码，马上露出没教养的本性，马上开骂。有朋友在后面回复说，教的是渔不是鱼 ，也被骂。当时并没和这群没教养的人说话，今天再次登录CocoaChina发现还有没教养的人在这叽歪，实在忍不住，希望学习开发的人员养成一个看文档的好习惯，提问不要没教养。

>作为一个程序员，如果说文档看都没看，不自己先尝试解决问题，直接百度搜索答案Copy现成代码，我想这样的程序员也高明不到哪里去，学习能力为负数，HR,CTO特别需要注意是否招这种人进公司。

对于我前面所说的那位同学提的问题[UIcollectionView 如何设置 每个section (不是cell) 不同背景图片](http://www.cocoachina.com/bbs/read.php?tid-253145-page-1.html)如何从文档中找到解决的办法？

我们先看苹果的文档说明，选择`UICollectionView`并按住`Command`键点击`Class Reference`查看详细说明文档，如下图所示：

![](http://upload-images.jianshu.io/upload_images/2926059-424547b780c7bd8c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这时我们会看见苹果官方的一个描述说明图:
![](http://upload-images.jianshu.io/upload_images/2926059-4d456a128f817d6e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个说明图用一个实例概括了`UICollectionView`各个组成部分，其中就有`Decoration view`，`Cell`, `Supplementary view`，我们也大概知道它们各自的位置，和作用。那如何使用它们呢？

文档我们通读了，知道如何使用`UICollectionView`，但是其中的属性和接口我们还是得看看接口，会比较直观。我们点击 `Command` 键 + `UICollectionView`，通常来说接口中会透露出它的大部分属性和相关方法。如下所示：
![](http://upload-images.jianshu.io/upload_images/2926059-604fe80751f31aa0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当然上面只是截图的一部分，但是我们往下看会发现这几个方法:

```objective-c
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;


- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier; ​
```

前面两个接口一看是` Cell`的注册，如果使用过`UITableView`的同学一看就知道这是干什么的了。后面两个函数其中一个关键字：`Supplementary` 字面意思是附属，补充，增补物，我们结合前面文档中的图片猜测它也许是`Section`的`Header`和`Footer`有关。

看完`UICollectionView`我们并没有发现`Decoration view`相关属性和接口，别急，我们继续看它属性中的属性。首先`UICollectionViewLayout`，同样点击 `Command` 键 + `UICollectionViewLayout`进入后我们看到了：
![](http://upload-images.jianshu.io/upload_images/2926059-7d5c34b68387852e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中有两个函数：
```
- (void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString *)elementKind;
- (void)registerNib:(nullable UINib *)nib forDecorationViewOfKind:(NSString *)elementKind;

```
这两个函数就是我们前面所说的`Decoration view`注册接口了，到这里我们前面所需的几个属性都找到了相应的接口。当然如果你第一次看，最好还是看完文档和介绍。


找到解决方法后，如何实现？

*  新建一个工程例如XXXX。我这里叫`CollectionView`在`storyboard`中拉取一`Collection view`至初始化的`Controller`中,然后对里面的`Collection view cell`自定义。如下图所示:

![](http://upload-images.jianshu.io/upload_images/2926059-94a13aee799e5356.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 新建一个继承`UICollectionViewCell`的 `ZHCollectionViewCell`并建立与上面中的`Collection view cell`属性关联。

```
@interface ZHCollectionViewCell : UICollectionViewCell 
@property (weak, nonatomic) IBOutlet UIImageView *showImgView; 
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; ​ 
@end
```

* 新建一个继承与`UICollectionReusableView`的`ZHCollectionReusableView`来展示`Header`这里我们带`Xib`


```
@interface ZHCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZHCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.textColor = [UIColor redColor];
    self.backgroundColor = [UIColor blueColor];
    // Initialization code
}

```

* 新建`ZHCollectionViewCell`数据来源`Model`

```
@interface ZHCollectionModel : NSObject
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *title;

@end

```

* 分别新建两个继承于`UICollectionReusableView`的`ZHDecorationCollectionReusableView`和`ZHDecorationCollectionReusableView1`来展示`Decoration view`带上`xib`并设置好颜色值。这里只设置了颜色，当然可以放置图片。

![](http://upload-images.jianshu.io/upload_images/2926059-5c9ce9f59a626964.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/2926059-6c50a7868186d20c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



* 新建一个继承于`UICollectionViewFlowLayout`的`ZHCollectionViewFlowLayout`来自定义`collectionViewLayout`属性。

```
#import <UIKit/UIKit.h>

@interface ZHCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (strong, nonatomic) NSMutableArray *itemAttributes;

@end

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

```

* `UICollectionView`初始化和实现，具体看注释

```
#import <UIKit/UIKit.h>
@class ZHCollectionViewFlowLayout;

@interface ZHRootViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *showCollectionView;
@property (weak, nonatomic) IBOutlet ZHCollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *models;
@end

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


```

### 效果展示：


![222.gif](http://upload-images.jianshu.io/upload_images/2926059-f8e257cfef4b59bc.gif?imageMogr2/auto-orient/strip)
### 下载地址
[GitHub](https://github.com/zhuozhuo/CollectionView)
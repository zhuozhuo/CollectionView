>>为何写这个Demo讲述UICollectionView 的基本使用。事情要从13年时有人问[UIcollectionView 如何设置 每个section (不是cell) 不同背景图片](http://www.cocoachina.com/bbs/read.php?tid-253145-page-1.html)由于他说是新人刚接触iOS开发，我就回答让他先看看苹果接口文档，并截了图（虽然图片已经挂了），本来是告诉新人遇到问题后应该怎么解决问题的思路。文档可以解决90%的问题，而不是一遇到问题马上提问或者寻找现成代码。但是后来的一群想找寻答案的人一看没代码，马上露出没教养的本性，马上开骂。有朋友在后面回复说，教的是渔不是鱼 ，也被骂。当时并没和这群没教养的人说话，今天再次登录CocoaChina发现还有没教养的人在这叽歪，实在忍不住，希望学习开发的人员养成一个看文档的好习惯，提问不要没教养。
>
>>作为一个程序员，如果说文档看都没看，不自己先尝试解决问题，直接百度搜索答案Copy现成代码，我想这样的程序员也高明不到哪里去，学习能力为负数，HR,CTO特别需要注意是否招这种人进公司。
>
>对于我前面所说的那位同学提的问题[UIcollectionView 如何设置 每个section (不是cell) 不同背景图片](http://www.cocoachina.com/bbs/read.php?tid-253145-page-1.html)如何从文档中找到解决的办法？
>
>首先我们点击 `Command` 键 + `UICollectionView`这个类看看接口，通常来说接口中会透露出它的大部分属性和相关方法。如下所示：
>![](http://upload-images.jianshu.io/upload_images/2926059-604fe80751f31aa0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>
>当然上面只是截图的一部分，但是我们往下看会发现这两个方法:
>
>```objective-c
>- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
>- (void)registerNib:(nullable UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier; ​
>```
>
>其中一个关键字：`Supplementary` 字面意思是附属，补充，增补物。看到这里也许你还是不太明白这个是干什么的，没关系，我们继续看苹果的文档说明，在刚才你点进去的地方选择`UICollectionView`并按住`Command`键点击`Class Reference`查看详细说明文档，如下图所示：
>
>![](http://upload-images.jianshu.io/upload_images/2926059-424547b780c7bd8c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>
>
>这时我们会看见苹果官方的一个描述说明图:
>![](http://upload-images.jianshu.io/upload_images/2926059-4d456a128f817d6e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>
>看到这里然后结合上面所找到的方法，我想可以猜测这个函数是干嘛的了，如果你再找找方法中的`elementKind`就可以基本确定这个函数可以解决您的问题。
>
>```
>UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader NS_AVAILABLE_IOS(6_0); 
>UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter NS_AVAILABLE_IOS(6_0);
>```
>
>找到解决方法后，如何实现？
>
>*  新建一个工程例如XXXX。我这里叫`CollectionView`在`storyboard`中拉取一`Collection view`至初始化的`Controller`中,然后对里面的`Collection view cell`自定义。如下图所示:
>
>![](http://upload-images.jianshu.io/upload_images/2926059-94a13aee799e5356.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>
>* 新建一个继承`UICollectionViewCell`的 `ZHCollectionViewCell`并建立与上面中的`Collection view cell`属性关联。
>
>```
>@interface ZHCollectionViewCell : UICollectionViewCell 
>@property (weak, nonatomic) IBOutlet UIImageView *showImgView; 
>@property (weak, nonatomic) IBOutlet UILabel *titleLabel; ​ 
>@end
>```
>
>* 新建一个继承与`UICollectionReusableView`的`ZHCollectionReusableView`来展示`Header`这里我们带`Xib`
>
>
>```
>@interface ZHCollectionReusableView : UICollectionReusableView
>@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
>
>@end
>
>@implementation ZHCollectionReusableView
>
>- (void)awakeFromNib {
>    [super awakeFromNib];
>    self.contentLabel.textColor = [UIColor redColor];
>    self.backgroundColor = [UIColor blueColor];
>    // Initialization code
>}
>
>```
>
>* 新建`ZHCollectionViewCell`数据来源`Model`
>
>```
>@interface ZHCollectionModel : NSObject
>@property (nonatomic, strong) NSString *imgName;
>@property (nonatomic, strong) NSString *title;
>
>@end
>
>```
>
>* `UICollectionView`初始化和实现，具体看注释
>
>```
>
>#import "ZHRootViewController.h"
>#import "ZHCollectionModel.h"
>#import "ZHCollectionViewCell.h"
>#import "ZHCollectionReusableView.h"
>
>@interface ZHRootViewController ()
>
>@end
>
>@implementation ZHRootViewController
>
>#pragma mark - initial
>- (void)viewDidLoad {
>    [super viewDidLoad];
>    UIEdgeInsets sectionInset = UIEdgeInsetsMake(15, 10, 10, 15);
>    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
>    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
>    NSInteger numbersOfLine = 2;
>    CGFloat itemWidth = screenWidth/numbersOfLine - sectionInset.left - sectionInset.right;
>    CGFloat itemHeight = itemWidth + 40.0;
>    
>    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向设置
>    self.collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemHeight);//设置item大小
>    switch (self.collectionViewLayout.scrollDirection) {
>        case UICollectionViewScrollDirectionVertical:
>            self.collectionViewLayout.headerReferenceSize = CGSizeMake(screenWidth, 40.0);//设置Header View 大小
>            break;
>        case UICollectionViewScrollDirectionHorizontal:
>            self.collectionViewLayout.headerReferenceSize = CGSizeMake(80, screenHeight);//设置Header View 大小
>            break;
>        default:
>            break;
>    }
>    
>    self.collectionViewLayout.sectionInset =sectionInset; //设置section上下左右的边距
>    self.collectionViewLayout.minimumLineSpacing = 5.0;//竖向滑动上下行的最小间距，横向滑动相邻列最小间距
>    self.collectionViewLayout.minimumInteritemSpacing = 10.0;//竖向滑动同行的item最小间距，横向滑动同一列上下item最小间距
>    
>    [self initialModels];// 获取数据源
>    self.showCollectionView.delegate = self;
>    self.showCollectionView.dataSource = self;
>    [self.showCollectionView registerNib:[UINib nibWithNibName:@"ZHCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZHCollectionReusableView"];//注册SectionHeader复用
>    
>    // Do any additional setup after loading the view.
>}
>
>
>-(void)initialModels
>{
>    NSMutableArray *muArray = [NSMutableArray array];
>    for (NSInteger i = 1; i <=8 ; i++) {
>        ZHCollectionModel *model = [[ZHCollectionModel alloc]init];
>        NSString *imgName = [NSString stringWithFormat:@"img%ld",i];
>        NSString *title = [NSString stringWithFormat:@"美食%ld",i];
>        model.imgName = imgName;
>        model.title = title;
>        [muArray addObject:model];
>    }
>    self.models = @[muArray,muArray,muArray];
>}
>
>
>- (void)didReceiveMemoryWarning {
>    [super didReceiveMemoryWarning];
>    // Dispose of any resources that can be recreated.
>}
>
>
>#pragma mark - UICollectionViewDataSource
>- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
>{
>   NSArray *array = [self.models objectAtIndex:section];
>   return array.count;
>}
>
>// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
>- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
>{
>    ZHCollectionViewCell *cell = [self.showCollectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
>    NSArray *datas = [self.models objectAtIndex:indexPath.section];
>    ZHCollectionModel *model = [datas objectAtIndex:indexPath.row];
>    cell.showImgView.image = [self getMainBundleImgWithImgName:model.imgName withType:@"jpg"];
>    cell.titleLabel.text = model.title;
>    return cell;
>}
>
>
>- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
>{
>    return self.models.count;
>}
>
>- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
>{
>    if (kind == UICollectionElementKindSectionHeader) {
>        ZHCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZHCollectionReusableView" forIndexPath:indexPath];
>        header.contentLabel.text = [NSString stringWithFormat:@"Header%ld",indexPath.section];
>        return header;
>    }
>    return nil;
>}
>
>
>#pragma mark - UICollectionViewDelegate
>-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
>{
>    NSLog(@"select item section:%ld row:%ld",indexPath.section,indexPath.row);
>}
>
>
>
>#pragma mark - private method
>-(UIImage *)getMainBundleImgWithImgName:(NSString *)imgName withType:(NSString *)type
>{
>    NSString *path = [[NSBundle mainBundle]pathForResource:imgName ofType:type];
>    UIImage *img = [UIImage imageWithContentsOfFile:path];
>    return img;
>}
>
>```
>
>### 效果展示：
>
>![](http://upload-images.jianshu.io/upload_images/2926059-274e5922dd039d7c.gif?imageMogr2/auto-orient/strip)
>
>### 下载地址
>[GitHub](https://github.com/zhuozhuo/CollectionView)

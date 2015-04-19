
#import "ScrollViewController.h"
#import "TableVC.h"

@interface ScrollViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGRect frame;

// 定义的都是缓存相关的属性
// 可重用的视图集合
@property (nonatomic, strong) NSMutableSet *reusableViewSet;
// 使用数组下标记录的子视图字典(可见的子视图)
@property (nonatomic, strong) NSMutableDictionary *visuableViewDict;
// 显示当前数组索引的属性
@property (nonatomic, assign) NSInteger currentIndex;
// 拖放过程中，要显示的下一个页面的索引
@property (nonatomic, assign) NSInteger nextIndex;
// 显示当前页面页数  数值范围 0 1 2
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ScrollViewController

#pragma mark - getter & setter方法
- (NSMutableSet *)reusableViewSet
{
    if (!_reusableViewSet) _reusableViewSet = [NSMutableSet set];
    return _reusableViewSet;
}

- (NSMutableDictionary *)visuableViewDict
{
    if (!_visuableViewDict) _visuableViewDict = [NSMutableDictionary dictionary];
    return _visuableViewDict;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        // 关闭滚动指示
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        // 关闭弹簧效果
        _scrollView.bounces = NO;
        // 允许分页
        _scrollView.pagingEnabled = YES;
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    
    // 设置滚动视图的滚动区域     最大为3  就是三个视图的大小
    int count = dataList.count > 3 ? 3 : dataList.count;
    
    //scrollview的内容大小按照要count数来确定
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * count, self.frame.size.height);
    
    // 显示第一张图像
    self.currentIndex = 0;
    self.currentPage = 0;
    //调用显示第一个TableView
    [self subviewWithIndex:self.currentIndex page:self.currentPage];
}

#pragma mark - 视图控制器方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        
      //  NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    }
    return self;
}

- (void)loadView
{
    self.view = self.scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.view.backgroundColor = [UIColor redColor];
   
}

#pragma mark - ScrollView的代理方法
// 滚动视图一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 找出滚动方向的办法
    // 1> scrollView的bounds.origin实际上就是contentOffset
    // 2> 可以根据contentOffset结合当前显示的视图的位置知道视图的滚动方向
    //    NSLog(@"%@", NSStringFromCGRect(scrollView.bounds));
    //    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 当前显示的视图     当前有一个@（0）
    UIViewController *controller = self.visuableViewDict[@(self.currentIndex)];
    UIView *subview = controller.view;
    int offset = 0;
    //向左滑动
    if (subview.frame.origin.x < scrollView.contentOffset.x) {
        // NSLog(@"下一页");
        offset = 1;
    } else if (subview.frame.origin.x > scrollView.contentOffset.x) {
        // NSLog(@"上一页");
        offset = -1;
    }
    
    self.nextIndex = self.currentIndex + offset;
    [self subviewWithIndex:self.nextIndex page:self.currentPage + offset];
}

// 滚动视图停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 判断停下来的页号
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // NSLog(@"第%d页 %d", page, self.view.subviews.count);
    
    // 显示页面改变后两个值肯定不一样    停止之后的页号是否与当前页号相等
    if (self.currentPage != page) {
        //        UIView *subview = self.visuableViewDict[@(self.currentIndex)];
        //取出字典中的可见页面    此时self.currentPage =0;  @(0)
        UIViewController *controller = self.visuableViewDict[@(self.currentIndex)];
        
        // 将当前索引的视图(离开了屏幕) 从可视字典中移除
        [self.visuableViewDict removeObjectForKey:@(self.currentIndex)];
        // 将当前索引的视图，从屏幕上删除
        [controller.view removeFromSuperview];
        // 将视图控制器从当前视图控制器中删除
        [controller removeFromParentViewController];
        // 将刚才显示的视图放入缓冲区集合中 备用
        [self.reusableViewSet addObject:controller];
        
        // 判断当前视图应该所在的位置(页号)
        // 如果停止后，前后都有数据，页号应该为1
        // subviewWithIndex:可以新建视图，并调整位置
        
        if (self.nextIndex > 0 && self.nextIndex < self.dataList.count - 1) {
            self.currentPage = 1;//当前显示视图的位置一直在中间
         //   NSLog(@"什么情况调用");
            [self subviewWithIndex:self.nextIndex page:self.currentPage];
        } else {//最左边以及最右边的情况
            self.currentPage = page;
        }
        // 记录住最新的索引数值
        self.currentIndex = self.nextIndex;
        
        // 根据页号调整contentOffset
        scrollView.contentOffset = CGPointMake(self.currentPage * self.frame.size.width, 0);
        // 从字典中取出当前屏幕上可见的视图
        
        //NSLog(@"%@ %@", self.visuableViewDict, self.reusableViewSet);
    }
}

#pragma mark - 私有方法
// 使用数组下标显示子视图，在对应的页面上
- (void)subviewWithIndex:(NSInteger)index page:(NSInteger)page
{
    // 判断字典中是否已经包含该视图
    TableVC *controller = self.visuableViewDict[@(index)];
    if (!controller) {
        // 查询可重用子视图   没有则自动创建一个
        controller = [self dequeueReusableSubview];
        
        // TableView 的数据赋值
        controller.dataList  = self.dataList;
        NSString *str =[NSString stringWithFormat:@"%@  指针%p",self.dataList[index],controller];
        controller.newsString =str;
        
        // 控制器添加
        [self addChildViewController:controller];
        //视图添加
#warning 用self 也可以
        [self.view addSubview:controller.view];
        // 将子视图添加到字典     @（0）被添加进入可视字典
        [self.visuableViewDict setObject:controller forKey:@(index)];
    }
    
    // 根据页数确定设置View的位置  主要是x的值
    CGRect frame = self.frame;
    frame.origin.x = page * self.frame.size.width;
    controller.view.frame = frame;
}

// 查询可重用的视图
- (id)dequeueReusableSubview
{
    // 1. 如果集合中没有数据，实例化一个新对象
    if (self.reusableViewSet.count == 0) {
        return [[TableVC alloc] initWithStyle:UITableViewStylePlain];
    } else {
        UIViewController *controller = [self.reusableViewSet anyObject];
        // 将对象从可重用集合中删除
        [self.reusableViewSet removeObject:controller];
        return controller;
    }
}

@end


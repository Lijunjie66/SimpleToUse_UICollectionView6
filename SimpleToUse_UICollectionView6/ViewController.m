//
//  ViewController.m
//  SimpleToUse_UICollectionView6
//
//  Created by Geraint on 2018/11/26.
//  Copyright © 2018 kilolumen. All rights reserved.
//

/*
1.初识与简单实用UICollectionView：https://my.oschina.net/u/2340880/blog/522613

2.UICollectionView的代理方法：https://my.oschina.net/u/2340880/blog/522682

3.实用FlowLayout进行更灵活布局：https://my.oschina.net/u/2340880/blog/522748

4.自定义FlowLayout进行瀑布流布局：https://my.oschina.net/u/2340880/blog/522806

5.平面圆环布局的实现：https://my.oschina.net/u/2340880/blog/523064

6.将布局从平面应用到空间：https://my.oschina.net/u/2340880/blog/523341

7.三维中的球型布局：https://my.oschina.net/u/2340880/blog/523494
 */

#import "ViewController.h"
#import "MyLayout.h"
#import <Masonry/Masonry.h>

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 创建一个layout布局类
    MyLayout *layout = [[MyLayout alloc] init];
    
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) collectionViewLayout:layout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor lightGrayColor];
    
    // 这里设置的偏移量是为了无缝进行循环的滚动
    // 因为咱们的环状布局，上面的逻辑刚好可以无缝对接，但是会有新的问题，一开始运行，滚轮就是出现在最后一个item的位置，而不是第一个，并且有些相关的地方，我们也需要一些适配：
    // 一开始将collectionView的偏移量设置为 1屏 的偏移量
    collect.contentOffset = CGPointMake(320, 400);
    
    // 注册item类型，这里使用系统的类型 (在完成代理回调前，必须注册一个cell)
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];
    
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        // Masonry 布局，覆盖上面的 layout布局  -- CGRectMake(0, 0, 320, 400)
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 10, 10, 10)); // 边距：上、左、下、右
    }];
    
}

#pragma mark -- 代理方法（前两必写）
// 分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区之中的 item 的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255/255.0 green:arc4random() % 255/255.0 blue:arc4random() % 255/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row]; // 上面我们创建了10个item，并且在每个item上添加了一个标签，标写的是几
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 在这里对滑动的contentOffset进行监控，实现循环滚动 (做了横坐标的兼容)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 200) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + 10*400);
    } else if (scrollView.contentOffset.y > 11*400) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - 10*400);
    } else if (scrollView.contentOffset.x < 160) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + 10*320, scrollView.contentOffset.y);
    } else if (scrollView.contentOffset.x >11*320) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - 10*320, scrollView.contentOffset.y);
    }
}


@end

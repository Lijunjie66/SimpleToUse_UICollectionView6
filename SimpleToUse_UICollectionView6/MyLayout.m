//
//  MyLayout.m
//  SimpleToUse_UICollectionView6
//
//  Created by Geraint on 2018/11/26.
//  Copyright © 2018 kilolumen. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark -- 上面的是 静态布局 ，下面我们要想让 滚轮滑动起来
// 首先，我们需要给collectionViewu一个滑动范围，我们以一屏collectionView的滑动距离来当做滚轮滚动一下的参照，我们在布局类中的如下方法中h返回滑动区域:
// 返回的滚动范围增加了对 X轴 的兼容
- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width * ([self.collectionView numberOfItemsInSection:0] + 2), self.collectionView.frame.size.height * ([self.collectionView numberOfItemsInSection:0] + 2));
}

// 上面方法写完之后，我们的collectionView已经可以进行滑动，但是并不是我们想要的效果，滚轮并没有滚动，而是随着滑出了屏幕，因此，我们需要在滑动的时候不停的动态布局，将滚轮始终固定在collectionView的中心，先需要在布局类中实现如下方法：
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 在布局类中 重写 LlayoutAttitudesForItemAtIndexpath: 方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *atti = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 获取item的个数
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    atti.center = CGPointMake(self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x, self.collectionView.frame.size.height / 2 + self.collectionView.contentOffset.y);
    
    atti.size = CGSizeMake(30, 30);
    
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D.m34 = -1 / 900.0;
    
    CGFloat radius = 10 / tanf(M_PI*2 / itemCounts/2);
    // 根据偏移量 改变角度
    // 添加了一个 x的偏移量
    float offset_y = self.collectionView.contentOffset.y;
    float offset_x = self.collectionView.contentOffset.x;
    // 分别计算偏移的角度
    float angleOffset_y = offset_y / self.collectionView.frame.size.height;
    float angleOffset_x = offset_x / self.collectionView.frame.size.width;
    CGFloat angle1 = (float)(indexPath.row + angleOffset_y - 1) / itemCounts * M_PI * 2;
    // x，y 的默认方向相反
    CGFloat angle2 = (float)(indexPath.row - angleOffset_x - 1) / itemCounts * M_PI * 2;
    
    // 这里我们进行四个方向的排序
    if (indexPath.row % 4 == 1) {
        trans3D = CATransform3DRotate(trans3D, angle1, 1.0, 0, 0);
    } else if (indexPath.row % 4 == 2) {
        trans3D = CATransform3DRotate(trans3D, angle2, 0, 1, 0);
    } else if (indexPath.row % 4 == 3) {
        trans3D = CATransform3DRotate(trans3D, angle1, 0.5, 0.5, 0);
    } else {
        trans3D = CATransform3DRotate(trans3D, angle1, 0.5, -0.5, 0);
    }
    
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    
    atti.transform3D = trans3D;
    return atti;
    
}

// 在我们自定义的布局类中重写layoutAttitudesForElementsInRect，在其中返回我们的布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    // 遍历设置每个item的布局属性
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}



@end

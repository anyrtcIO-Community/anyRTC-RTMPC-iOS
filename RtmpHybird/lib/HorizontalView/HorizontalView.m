//
//  HorizontalView.m
//  HorizontalCollectionView
//
//  Created by jianqiangzhang on 16/6/21.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "HorizontalView.h"
#import "HeadCollectionViewCell.h"
#import "Masonry.h"
#import "PersonItem.h"

#define HEAD_CELL_IMAGEVIEW @"HEAD_CELL_IMAGEVIEW"
@interface HorizontalView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionData;
@end

@implementation HorizontalView

- (void)setMumberArray:(NSArray*)array {
    
    self.collectionData= [array mutableCopy];
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionData = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(45, 45);
        flowLayout.minimumLineSpacing = 10;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView setCollectionViewLayout:flowLayout];
        [self.collectionView registerClass:[HeadCollectionViewCell class] forCellWithReuseIdentifier:HEAD_CELL_IMAGEVIEW];
        [self addSubview:self.collectionView];
        [self.collectionView reloadData];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.collectionView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height -20);
}
#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSMutableArray *)collectionData {
    
    _collectionData = [collectionData mutableCopy];
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HEAD_CELL_IMAGEVIEW" forIndexPath:indexPath];
    PersonItem *item = [self.collectionData objectAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonItem *item = [self.collectionData objectAtIndex:indexPath.row];
    if (self.DidSelectedItemBlock) {
        
        self.DidSelectedItemBlock(item);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

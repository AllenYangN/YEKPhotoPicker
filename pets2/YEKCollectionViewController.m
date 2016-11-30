//
//  YEKCollectionViewController.m
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "YEKCollectionViewController.h"
#import "ViewController.h"
#import "YEKShowHDPhotoViewController.h"

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface YEKCollectionViewController ()<UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)NSMutableArray *isSelectedArray;
@end

@implementation YEKCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRightButton];
    //设置允许多选
    self.collectionView.allowsMultipleSelection = YES;
    
    self.photoALAssetArray = [NSMutableArray new];
    [YEKAssetsManager groupForURL:self.groupURL resultBlock:^(ALAssetsGroup *group) {
        self.group = group;
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            {
                if (result != nil)
                {
                    [self.photoALAssetArray addObject:result];
                }
                else
                {
                    self.isSelectedArray = [NSMutableArray new];
                    for (int i = 0; i < self.photoALAssetArray.count; i++) {
                        NSString * isSelected = @"NO";
                        [self.isSelectedArray addObject:isSelected];
                    }
                    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }
            }
        }];
    }];
    // Register cell classes
    [self.collectionView registerClass:[YEKCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}
- (void)initRightButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitInfo:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}
//提交信息
- (void)submitInfo:(id)sender
{
    NSMutableArray * tempArray = [NSMutableArray new];
    for (int i = 0; i<_isSelectedArray.count; i++)
    {
        if ([[_isSelectedArray objectAtIndex:i] isEqualToString:@"YES"])
        {
            [tempArray addObject:[_photoALAssetArray objectAtIndex:i]];
        }
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"ALAsset" object:nil userInfo:@{@"ALAssetArray":tempArray}];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    //返回到你的feedback页面
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoALAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YEKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    ALAsset *photoAsset = [self.photoALAssetArray objectAtIndex:indexPath.row];
    [cell setImage:[UIImage imageWithCGImage:[photoAsset thumbnail]]];
    if ([[_isSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"YES"])
    {
        [cell setIsButtonSelected:YES];
    }
    else
    {
        [cell setIsButtonSelected:NO];
    }
    [cell setPhotoAssetPropertyType:[photoAsset valueForProperty:ALAssetPropertyType]];
    return cell;
}

#pragma mark <YEKSelectedCellButtonDelegate>
- (void)clickCellSelectButtonStatus:(BOOL)selected withCollectionCell:(id)cell
{
    int i = 0;
    for (NSString *isSelect in _isSelectedArray) {
        if ([isSelect isEqualToString:@"YES"]) {
            i++;
        }
    }
    if (i >= _maxPhotoCounts) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"由于您已经选定了%ld张，本次最多可选择%ld张照片",9 - _maxPhotoCounts,(long)_maxPhotoCounts] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    YEKCollectionCell * mCell = cell;
    [mCell.selectButton setSelected:selected];
    
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    NSString * isSelected = @"NO";
    if (selected) {
        isSelected = @"YES";
    }
    [_isSelectedArray replaceObjectAtIndex:indexPath.row withObject:isSelected];
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
    YEKShowHDPhotoViewController *showHDPhotoViewController = [storyboard instantiateViewControllerWithIdentifier:@"kYEKShowHDPhotoViewController"];
    ALAsset *photoAsset = [self.photoALAssetArray objectAtIndex:indexPath.row];

    showHDPhotoViewController.photoAsset = photoAsset;
    [self.navigationController pushViewController:showHDPhotoViewController animated:YES];
}
/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
#pragma mark <UICollectionViewDelegateFlowLayout>

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH-10)/4.0f, (SCREENWIDTH-10)/4.0f);
}
//通过调整inset使单元格顶部和底部都有间距(inset次序: 上，左，下，右边)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.0f, 0.0f, 2.0f, 0.0f);
}
//设置纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}
//设置单元格间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

@end

//
//  YEKCollectionViewController.h
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YEKAssetsManager.h"
#import "YEKCollectionCell.h"

@interface YEKCollectionViewController : UICollectionViewController<YEKSelectedCellButtonDelegate>

@property (nonatomic, strong) NSURL * groupURL;    //存放照片组URL的对象
@property (nonatomic, strong) ALAssetsGroup* group;    //存放照片组的对象
@property (nonatomic, strong) NSMutableArray  * photoALAssetArray;          //存放所有照片的数组对象
@property (nonatomic)NSInteger maxPhotoCounts;         //这个参数是个动态的传入参数

@end

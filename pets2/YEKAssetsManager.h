//
//  YEKAssetsManager.h
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#warning 因为考虑到要兼容iOS8一下 所以这里用的是旧的照片库，新的Photokit目前不支持低版本，所以包黄比较多，因为都是弃用api

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YEKAssetsManager : NSObject

//@property (nonatomic, copy) ALAssetGroupBlock block;                        //资源组进行的回调
@property (nonatomic, strong) NSMutableArray  * groupArray;    //存放所有照片组的数组对象
@property (nonatomic, strong) NSMutableArray  * photos;          //存放所有照片的数组对象
+ (ALAssetsLibrary *)defaultAssetsLibrary;
+ (void)getALAssetsGroupArray:(void(^)(NSMutableArray *groupArray))complete;
+ (void)groupForURL:(NSURL *)groupURL resultBlock:(void(^)(ALAssetsGroup* group))complete;
+ (void)assetForURL:(NSURL *)assetForURL resultBlock:(void(^)(ALAsset* asset))complete;
@end

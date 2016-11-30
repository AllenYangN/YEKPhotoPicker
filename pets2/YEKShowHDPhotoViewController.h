//
//  YEKShowHDPhotoViewController.h
//  pets2
//
//  Created by macPro on 16/11/24.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YEKAssetsManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface YEKShowHDPhotoViewController : UIViewController
//@property (nonatomic, strong) NSMutableArray  * photoALAssetArray;          //存放所有照片的数组对象
//@property(nonatomic, strong)NSMutableArray *isSelectedArray;//是否选中，存的是nsstring @“YES” or @“NO”
//@property(nonatomic)NSInteger currentIndex;//进入页面时候的index
@property(nonatomic, strong)ALAsset  *photoAsset;
@end

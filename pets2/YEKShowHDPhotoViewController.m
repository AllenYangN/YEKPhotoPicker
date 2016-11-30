//
//  YEKShowHDPhotoViewController.m
//  pets2
//
//  Created by macPro on 16/11/24.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "YEKShowHDPhotoViewController.h"

@interface YEKShowHDPhotoViewController ()
{
    UIImageView *imageViewCenter;
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    UIButton * playButton;
    BOOL isPlay;
}
@end

@implementation YEKShowHDPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    CGRect rect = self.view.frame;
     if ([[_photoAsset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypePhoto"])
     {
         imageViewCenter = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height - 64)];
         [imageViewCenter setBackgroundColor:[UIColor grayColor]];
         [self.view addSubview:imageViewCenter];
         ALAssetRepresentation* representationCenter = [_photoAsset defaultRepresentation];
         UIImageOrientation orientation = UIImageOrientationUp;
         NSNumber* orientationValue = [_photoAsset valueForProperty:@"ALAssetPropertyOrientation"];
         if (orientationValue != nil) {
             orientation = [orientationValue intValue];
         }
         
//         CGFloat scale  =  [[UIScreen mainScreen] scale];
         UIImage* image = [UIImage imageWithCGImage:[representationCenter fullResolutionImage]
                                              scale:1 orientation:orientation];
         //获取资源图片的高清图
         //    [representation fullResolutionImage];
         //获取资源图片的全屏图
         //    [representation fullScreenImage];
         
         [imageViewCenter setImage:image];
         CGFloat imageHeight = rect.size.width / (image.size.width / image.size.height);
         if (imageHeight > (rect.size.height - 64)) {
             imageHeight = rect.size.height - 64;
         }
         imageViewCenter.frame = CGRectMake(0, 64, rect.size.width, imageHeight);
         imageViewCenter.center = CGPointMake(rect.size.width / 2, (rect.size.height - 64)/2 + 64);
         [imageViewCenter setContentMode:UIViewContentModeScaleToFill];
     }
    else
    {
        ALAssetRepresentation* assetRepresentation = [_photoAsset defaultRepresentation];
        //create player and player layer
        player = [AVPlayer playerWithURL:[assetRepresentation url]];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        playerLayer.frame = CGRectMake(0, 64, rect.size.width, rect.size.height - 64);
        [self.view.layer addSublayer:playerLayer];
        
        //play the video
//        [player play];
        playButton = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width/2, rect.size.height/2, 66, 66)];
        [playButton setImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateSelected];
        [playButton setImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateHighlighted];
        [playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playButton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickPlayButton:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
    }
    
}

- (void)clickPlayButton:(UIButton *)sender
{
    isPlay = !isPlay;
    [playButton setHighlighted:isPlay];
    [playButton setSelected:isPlay];
    if (isPlay) {
        [player play];
    }
    else
    {
        [player pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

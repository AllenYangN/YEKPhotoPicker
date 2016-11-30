//
//  YEKCollectionCell.h
//  pets2
//
//  Created by macPro on 16/11/24.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YEKSelectedCellButtonDelegate
@optional
- (void)clickCellSelectButtonStatus:(BOOL)selected withCollectionCell:(id)cell;
@end

@interface YEKCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id <YEKSelectedCellButtonDelegate> delegate;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *photoAssetPropertyType;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) UIImageView *videoImageView;

@property (nonatomic) BOOL isButtonSelected;


@end

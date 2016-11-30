//
//  YEKCollectionCell.m
//  pets2
//
//  Created by macPro on 16/11/24.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "YEKCollectionCell.h"

@implementation YEKCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
    
}
//在这里做控件的添加，collectionview和tableview的cell重用机制不太一样，只能重写某个setter里面去做控件的赋值添加操作
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imageView.image = image;
    [self.contentView addSubview:_imageView];
}

- (void)setIsButtonSelected:(BOOL)isButtonSelected
{
    _isButtonSelected = isButtonSelected;
    
    [_selectButton removeFromSuperview];
    CGRect rect = self.bounds;
    rect.origin.x = rect.size.width - 22;
    rect.origin.y = 0;
    rect.size.height = 22;
    rect.size.width = 22;
    _selectButton = [[UIButton alloc]initWithFrame:rect];
    [_selectButton setImage:[UIImage imageNamed:@"cellDeselected@2x.png"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"cellSelected@2x.png"] forState:UIControlStateSelected];
    [_selectButton setImage:[UIImage imageNamed:@"cellSelected@2x.png"] forState:UIControlStateHighlighted];
    [_selectButton addTarget:self action:@selector(clickCellSelectButton:) forControlEvents:UIControlEventTouchDown];
    [_selectButton setSelected:_isButtonSelected];
    [self.contentView addSubview:_selectButton];
}

- (void)setPhotoAssetPropertyType:(NSString *)photoAssetPropertyType
{
    [_videoImageView removeFromSuperview];
    if ([photoAssetPropertyType isEqualToString:@"ALAssetTypeVideo"])
    {
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 20;
        rect.size.height = 20;
        _videoImageView  = [[UIImageView alloc]initWithFrame:rect];
        _videoImageView.image = [UIImage imageNamed:@"video@2x.png"];
        [self.contentView addSubview:_videoImageView];
    }
    else
    {
    
    }
}

- (void)clickCellSelectButton:(UIButton *)sender
{
    [_delegate clickCellSelectButtonStatus:!sender.selected withCollectionCell:self];
}
//这里设置选中状态
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
//    [_selectButton setSelected:selected];
    if (selected) {
        //选中时
    }else{
        //非选中
    }
    
    // Configure the view for the selected state
}
@end

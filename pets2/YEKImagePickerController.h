//
//  YEKImagePickerController.h
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YEKImagePickerController : UITableViewController
@property (nonatomic)NSInteger maxPhotoCounts;         //这个参数是个动态的传入参数
@property (nonatomic)NSInteger isFirstIn;         //这个参数是做一个第一次进入的判断

@end

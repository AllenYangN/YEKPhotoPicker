//
//  ViewController.h
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "YEKAssetsManager.h"

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  * photoALAssetArray;          //存放所有照片的数组对象
- (IBAction)editingPhotoArray:(UIButton *)sender;
@end


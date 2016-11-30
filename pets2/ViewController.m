//
//  ViewController.m
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "ViewController.h"
#import "YEKImagePickerController.h"

@interface ViewController ()
{
    UIImagePickerController *_imagePickerController;
    UIView *footerView;
    UIScrollView *footerScrollView;
    NSInteger imageNameCount;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取通知中心单例对象
    self.photoALAssetArray = [NSMutableArray new];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(submitInfoChanged:) name:@"ALAsset" object:nil];
    [self loadTableFooterView];
}

- (void)loadTableFooterView
{
    if (footerView == nil)
    {
        CGRect rectFooterView = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 169);
        footerView = [[UIView alloc]initWithFrame:rectFooterView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 250, 22)];
        label.text = @"附件";
        [footerView addSubview:label];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, [[UIScreen mainScreen] bounds].size.width - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1];
        [footerView addSubview:line];
        
        CGRect rectScrollView = CGRectMake(0, 45, [[UIScreen mainScreen] bounds].size.width, 124);
        footerScrollView =  [[UIScrollView alloc]initWithFrame:rectScrollView];
        [footerScrollView setContentSize:CGSizeMake((15+72+10) + 15, rectScrollView.size.height)];
        [footerScrollView setShowsHorizontalScrollIndicator:NO];
        [footerScrollView setShowsVerticalScrollIndicator:NO];
        [footerView addSubview:footerScrollView];
        [self.tableView setTableFooterView:footerView];
    }
    for(UIView *view in [footerScrollView subviews])
    {
        [view removeFromSuperview];
    }

    UIButton * addButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 72, 72)];
    [addButton setImage:[UIImage imageNamed:@"QQ20161125-0@2x.png"] forState:UIControlStateNormal];
    addButton.tag = 2001;
    [addButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    [footerScrollView addSubview:addButton];
    imageNameCount = 1;
    for (int i = 0; i < self.photoALAssetArray.count; i++)
    {
        CGRect rect = CGRectMake((15+72+10)+(72+10)*i, 10, 72, 72);
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 8.0;
        imageView.layer.masksToBounds = YES;
        ALAsset *photoAsset = [self.photoALAssetArray objectAtIndex:i];
        ALAssetRepresentation* representationCenter = [photoAsset defaultRepresentation];
        NSString * nsALAssetPropertyURLs = [photoAsset valueForProperty:ALAssetPropertyType] ;
        
        [imageView setImage:[UIImage imageWithCGImage:[photoAsset thumbnail]]];
        
        UIButton * deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(72 - 22, 0, 22, 22)];
        deleteButton.tag = i;
        [deleteButton setImage:[UIImage imageNamed:@"QQ20161125-1@2x.png"] forState:UIControlStateNormal];
        
        [deleteButton addTarget:self action:@selector(editingPhotoArray:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteButton];
        
        CGRect rectNameLabel = CGRectMake((15+72+10)+(72+10)*i, 85, 72, 15);
        UILabel*nameLabel = [[UILabel alloc]initWithFrame:rectNameLabel];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:10.0]];
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMdd"];
        NSString *currentDateStr = [format stringFromDate:[NSDate date]];
        
        if ([[photoAsset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypePhoto"]) {
            nameLabel.text = [NSString stringWithFormat:@"%@_%ld.jpg",currentDateStr,imageNameCount];
        }
        else
        {
            nameLabel.text = [NSString stringWithFormat:@"%@_%ld.mov",currentDateStr,imageNameCount];
        }
        
        imageNameCount ++;
        [footerScrollView addSubview:nameLabel];
        nameLabel.text = [representationCenter filename];
        CGRect rectSizeLabel = CGRectMake((15+72+10)+(72+10)*i, 103, 72, 11);
        UILabel*sizeLabel = [[UILabel alloc]initWithFrame:rectSizeLabel];
        [sizeLabel setTextAlignment:NSTextAlignmentCenter];
        [sizeLabel setFont:[UIFont systemFontOfSize:8.0]];
        double size = [representationCenter size]/1024.0/1024.0;
        [sizeLabel setText:[NSString stringWithFormat:@"%.2fM",size]];//文件尺寸，以byte为单位
        if ((int)size <= 0) {
            size = [representationCenter size]/1024.0;
            [sizeLabel setText:[NSString stringWithFormat:@"%.2fK",size]];
        }
        [footerScrollView addSubview:sizeLabel];

        [footerScrollView setContentSize:CGSizeMake((15+72+10) + (72+10)*(i+1), 124)];
        [footerScrollView addSubview:imageView];
    }
}

- (IBAction)editingPhotoArray:(UIButton *)sender
{
    [self.photoALAssetArray removeObjectAtIndex:sender.tag];
    [self performSelectorOnMainThread:@selector(loadTableFooterView) withObject:nil waitUntilDone:YES];}

- (void)submitInfoChanged:(NSNotification *)sender
{
    NSLog(@"%@",sender);
    NSDictionary *sDict = [[NSDictionary alloc] init];
    sDict = sender.userInfo;
    [self.photoALAssetArray addObjectsFromArray:[sDict objectForKey:@"ALAssetArray"]];
    [self loadTableFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)jump:(id)sender
{
    if (_photoALAssetArray.count >= 9) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择9张照片或视频"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
#warning 重点看，这个是actionSheet的替代品 支持iOS8以上  你别黑用了
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
        YEKImagePickerController *imagePickerController = [storyboard instantiateViewControllerWithIdentifier:@"kYEKImagePickerController"];
        imagePickerController.isFirstIn = 1;
        imagePickerController.maxPhotoCounts = 9 - _photoALAssetArray.count;
        [self.navigationController pushViewController:imagePickerController animated:NO];
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self selectImageFromCamera];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage* image = info[UIImagePickerControllerEditedImage];
        //如果是图片,保存图片至相册,然后拿到assetURL再取出ALAsset存到feedback的cell相册数组中
        NSInteger orientation = image.imageOrientation;
        [[YEKAssetsManager defaultAssetsLibrary] writeImageToSavedPhotosAlbum:[image CGImage] orientation:orientation completionBlock:^(NSURL *assetURL, NSError *error) {
            [YEKAssetsManager assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                [self.photoALAssetArray addObject:asset];
                [self performSelectorOnMainThread:@selector(loadTableFooterView) withObject:nil waitUntilDone:YES];
            }];
        }];
    }
    else
    {
        //如果是视频,同样处理方式，只是这次存的是视频
        [[YEKAssetsManager defaultAssetsLibrary] writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
            [YEKAssetsManager assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                [self.photoALAssetArray addObject:asset];
                [self performSelectorOnMainThread:@selector(loadTableFooterView) withObject:nil waitUntilDone:YES];
            }];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma tablviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0f;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kShowPicsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: @"kShowPicsCell"];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    cell.textLabel.text =@"这个不用，只是展示cell而已";
    return cell;
}

@end

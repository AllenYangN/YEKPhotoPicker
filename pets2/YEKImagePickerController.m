//
//  YEKImagePickerController.m
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "YEKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YEKCollectionViewController.h"
#import "YEKAssetsManager.h"

@interface YEKImagePickerController ()

@property (nonatomic, strong) NSMutableArray  * groupArray;    //存放所有照片组的数组对象
@end

@implementation YEKImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"相册"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.groupArray = [NSMutableArray new];
    [YEKAssetsManager getALAssetsGroupArray:^(NSMutableArray *groupArray) {
        self.groupArray = groupArray;
        if (_isFirstIn == 1)
        {
            [self performSelectorOnMainThread:@selector(pushToDefaultPage) withObject:nil waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)pushToDefaultPage
{
    _isFirstIn = 2;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YEKCollectionViewController * mYEKCollectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"kYEKCollectionViewController"];
    ALAssetsGroup* group = [_groupArray lastObject];
    mYEKCollectionViewController.title = [group valueForProperty:ALAssetsGroupPropertyName];
    mYEKCollectionViewController.maxPhotoCounts = _maxPhotoCounts;
    mYEKCollectionViewController.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
    [self.navigationController pushViewController:mYEKCollectionViewController animated:YES];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    ALAssetsGroup* group = [_groupArray objectAtIndex:indexPath.row];
    NSString* groupName = [group valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [group numberOfAssets];
    CGImageRef poster = [group posterImage];
    cell.textLabel.text = groupName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共%ld张",count];
    cell.imageView.image = [UIImage imageWithCGImage:poster];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YEKCollectionViewController * mYEKCollectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"kYEKCollectionViewController"];
    ALAssetsGroup* group = [_groupArray objectAtIndex:indexPath.row];
    mYEKCollectionViewController.title = [group valueForProperty:ALAssetsGroupPropertyName];
    mYEKCollectionViewController.maxPhotoCounts = _maxPhotoCounts;
    mYEKCollectionViewController.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
    [self.navigationController pushViewController:mYEKCollectionViewController animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  YEKAssetsManager.m
//  pets2
//
//  Created by macPro on 16/11/23.
//  Copyright © 2016年 yanger. All rights reserved.
//

#import "YEKAssetsManager.h"

@implementation YEKAssetsManager

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

+ (void)getALAssetsGroupArray:(void(^)(NSMutableArray *groupArray))complete
{
    NSMutableArray  * groupArray = [NSMutableArray new];
    ALAssetsLibraryGroupsEnumerationResultsBlock
    libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop)
    {
        if (group!=nil)
        {
            [groupArray addObject:group];
        }
        else
        {
            complete(groupArray);
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock =
    ^(NSError *myerror)
    {
        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
        }else{
            NSLog(@"相册访问失败.");
        }
    };
    [[YEKAssetsManager defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupsEnumeration failureBlock:failureblock];
}

+ (void)groupForURL:(NSURL *)groupURL resultBlock:(void(^)(ALAssetsGroup* group))complete
{
    [[YEKAssetsManager defaultAssetsLibrary] groupForURL:groupURL resultBlock:^(ALAssetsGroup *group) {
        complete(group);
    } failureBlock:^(NSError *error) {
        NSLog(@"ALAssetsGroup访问失败.");
    }];
}

+ (void)assetForURL:(NSURL *)assetForURL resultBlock:(void(^)(ALAsset* asset))complete
{
    [[YEKAssetsManager defaultAssetsLibrary] assetForURL:assetForURL resultBlock:^(ALAsset *asset) {
        complete(asset);
    } failureBlock:^(NSError *error) {
        NSLog(@"ALAsset访问失败.");
    }];
}

@end

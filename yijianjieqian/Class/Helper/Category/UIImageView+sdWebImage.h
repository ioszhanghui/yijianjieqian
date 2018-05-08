//
//  UIImageView+sdWebImage.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/27.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadImageSuccessBlock)(UIImage *image);
typedef void(^DownloadImageFailedBlock)(NSError *error);
typedef void(^DownloadImageProgressBlock)(CGFloat progress);

@interface UIImageView (sdWebImage)
/*加载图片*/
- (void)downloadImage:(NSString *)url placeholder:(NSString *)imageName;

/*加载图片 有进度显示*/
- (void)downloadImage:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress;
@end

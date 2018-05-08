 //
//  HttpTool.m
//  05-二次封装AFN
//
//  Created by 大欢 on 16/8/4.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#include <netinet/in.h>
#import "NetWorkStatus.h"


NSString * baseUrl= UD_URL_HOME;

@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (void)initialize{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (instancetype)sharedClient {
    
  static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        //将token封装入请求头
        [client.requestSerializer setValue:@"I" forHTTPHeaderField:@"channel"];
        [client.requestSerializer setValue:@"YJJQ" forHTTPHeaderField:@"appName"];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 60;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    
    return client;
}

@end

@implementation HttpTool

#pragma mark - 网络请求前处理，无网络不请求
+(BOOL)requestBeforeCheckNetWorkWithFailureBlock:(failureBlocks)errorBlock{
    BOOL isFi=[NetWorkStatus isFi];
    if(!isFi){//无网络
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(errorBlock!=nil){
                errorBlock(nil);
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        });
    }else{//有网络
        [NetWorkStatus startNetworkActivity];
    }
    
    return isFi;
}

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [baseUrl stringByAppendingPathComponent:path];
    
    [[AFHttpClient sharedClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
         [SVProgressHUD showInfoWithStatus:@"网络错误,请稍后重试"];
    }];

}

#pragma mark 清理cookie
+(void)clearCookies{
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

/*没有弹框提示*/
+ (void)PostWithPath:(NSString *)path
              params:(NSDictionary *)dict
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure {
    
    if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
        
        [SVProgressHUD dismiss];
        return;
    }
    //获取完整的url路径
    NSString * url = [baseUrl stringByAppendingPathComponent:path];
    
    //请求的参数
    if (dict) {
        dict=@{@"paramJson":[ZHStringFilterTool dictionaryToJson:dict]};
    }
    //清理缓存
    [HttpTool clearCookies];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    // 2.发送请求
    [[AFHttpClient sharedClient] POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary * responseDict=responseObject;
        
        if (!kDictIsEmpty(responseDict)) {
            success(responseObject);
            if ([responseObject[@"code"] isEqualToString:@"300"] || [responseObject[@"code"] isEqualToString:@"100"]) {
                
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            } else {
                [SVProgressHUD dismiss];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        failure(error);
    }];
}

+ (void)postWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    
    if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
        return;
    }
    
    [SVProgressHUD showWithStatus:@"玩命加载中..."];
    
    //设置提示框样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

    //获取完整的url路径
    NSString * url = [baseUrl stringByAppendingPathComponent:path];
    
    //请求的参数
    if (params) {
        
        params=@{@"paramJson":[ZHStringFilterTool dictionaryToJson:params]};
    }
    // 2.发送请求
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary * responseDict=responseObject;
        
        if (!kDictIsEmpty(responseDict)) {
            
            if (success) {
                
                if ([responseObject[@"code"] isEqualToString:@"300"] || [responseObject[@"code"] isEqualToString:@"100"]) {
                    
                    [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
                } else {
                    
                    [SVProgressHUD dismiss];
                }
                
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        failure(error);
    }];
}

+(void)uploadImageArrWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSArray *)imagekeys
                      image:(NSArray*)images
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
        return;
    }
    
    [SVProgressHUD showWithStatus:@"玩命加载中..."];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //获取完整的url路径
    NSString * urlString = [baseUrl stringByAppendingPathComponent:path];
    
    //请求的参数
    NSDictionary* param =@{@"paramJson":[ZHStringFilterTool dictionaryToJson:params]};

    [[AFHttpClient sharedClient] POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i =0;i<images.count;i++){
            
            UIImage * upLoadImage=[images objectAtIndex:i];
            NSData * imageData=UIImageJPEGRepresentation(upLoadImage, 1.0);;
            
            //设置需要上传的文件
            [formData appendPartWithFileData:imageData name:@"imageFile" fileName:[imagekeys objectAtIndex:i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary * responseDict=responseObject;
        
        if (!kDictIsEmpty(responseDict)) {
            
            NSInteger code =[[responseObject objectForKey:@"code"] integerValue];
            NSString * message=[responseObject objectForKey:@"message"];
            if (code==200) {
                
                [SVProgressHUD dismiss];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:message];
            }
            
            success(responseObject);
        }
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
          [SVProgressHUD dismiss];
          [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        failure(error);
        
    }];
}

@end

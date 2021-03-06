//
//  NetworkingManager.m
//  GengNiuEnglish
//
//  Created by luzegeng on 15/12/22.
//  Copyright © 2015年 luzegeng. All rights reserved.
//

#import "NetworkingManager.h"
#import "AFNetworking.h"

@implementation NetworkingManager

+(NSURLSessionTask*)httpRequest:(RequestType)type url:(RequestURL)url parameters:(NSDictionary*)parameters progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock success:(nullable void (^)( NSURLSessionTask * _Nullable task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionTask * _Nullable task, NSError * _Nullable error))failure completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSString *link=[NetworkingManager requestURL:url];
    if (!link) {
        link=[parameters objectForKey:@"url"];
    }
    switch (type) {
        case RTGet:
            return [NetworkingManager httpGet:link parameters:parameters success:success failure:failure];
            break;
        case RTPost:
            return nil;
        case RTDownload:
            return [NetworkingManager httpDownload:link parameters:parameters progress:downloadProgressBlock completionHandler:completionHandler];
        case RTUpload:
            return nil;
        default:
            return nil;
    }
}
+(const NSString *)requestURL:(RequestURL)url
{
    switch (url)
    {
        case RUText_list:
            return URLForTextList;
        case RUText_detail:
            return URLForTextDetai;
        case RUGrade_list:
            return URLForGradeList;
        case RUCustom:
            return nil;
        default:
            return nil;
    }
}
+(NSURLSessionDataTask *)httpGet:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task=[manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        //        NSLog(@"log for the response data%@",responseObject);
        
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"your request has failed%@",error);
        failure(task,error);
    }];
    return task;
}
+(NSURLSessionDataTask *)httpPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSURLSessionDataTask *task=[manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        //        NSLog(@"log for the response data%@",responseObject);
        
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"your request has failed%@",error);
        failure(task,error);
    }];
    return task;
}
+(NSURLSessionDownloadTask *)httpDownload:(NSString *)url parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    [downloadTask resume];
    return downloadTask;
}
@end

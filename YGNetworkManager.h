//
//  YGNetworkManager.h
//  PackageAFNetworking
//
//  Created by 王永刚 on 2016/11/30.
//  Copyright © 2016 PackageAFNetworking. All rights reserved.
//
//  网络manager

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, YGNetworkStatus){
    YGNetworkStatusWiFi  = 0,   //wifi
    YGNetworkStatusWWAN  = 1,   //蜂窝流量
    YGNetworkStatusNoNet = 2,   //无网络
    YGNetworkStatusUnknow = 3   //未知
};


typedef void(^YGNetworkStatusBlock)(YGNetworkStatus status);
typedef void(^YGRequestSuccessBlock)(id responseData);  //请求成功&服务端返回内容正确
typedef void(^YGRequestFailBlock)(id responseData);     //请求成功&服务端返回内容错误
typedef void(^YGServerErrorBlock)(NSError *error);      //请求失败
typedef void(^YGProgressBlock)(double progress);

/** 请求任务 */
typedef NSURLSessionTask YGURLSessionTask;

@interface YGNetworkManager : NSObject

@property (nonatomic, assign) NSTimeInterval timeoutValue;
@property (nonatomic, assign) NSInteger requestMaxCount;

@property (nonatomic,   copy) YGNetworkStatusBlock statusBlock;

/**
 单例方法

 @return 类对象
 */
+ (instancetype)shareManager; 

/**
 开始监听网络状态
 */
- (void)startMonitoringNetworkStatus; 



/**
 get请求

 @param url             请求URL
 @param paramDict       请求参数
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)getRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock;


/**
 post请求

 @param url             请求URL
 @param paramDict       请求参数
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)postRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock;


/**
 上传文件请求

 @param url             请求URL
 @param paramDict       请求参数
 @param fileData        文件data
 @param name            文件对应的服务端名称
 @param fileName        文件名
 @param mimeType        文件类型
 @param progressBlock   上传进度回调
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)uploadFileWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(YGProgressBlock)progressBlock successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock;



/**
 下载文件请求

 @param url             请求URL
 @param filePath        下载保存的文件路径
 @param progressBlock   下载进度回调
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)downloadFileWithURL:(NSString *)url filePath:(NSString *)filePath progressBlock:(YGProgressBlock)progressBlock successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock;


@end


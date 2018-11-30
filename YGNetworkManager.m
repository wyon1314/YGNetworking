//
//  YGNetworkManager.m
//  PackageAFNetworking
//
//  Created by 王永刚 on 2016/11/30.
//  Copyright © 2016 PackageAFNetworking. All rights reserved.
//

#import "YGNetworkManager.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define kMaxRequestCount 5
#define kTimeoutValue      30.0

@interface YGNetworkManager ()

@end

@implementation YGNetworkManager

static YGNetworkManager *_networkManager;
//单例方法
+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _networkManager = [[YGNetworkManager alloc] init];
    });
    
    return _networkManager;
    
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [super allocWithZone:zone];
    });
    return _networkManager;
    
}
+ (instancetype)init {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [super init];
        [_networkManager setDefaultValue];
        [_networkManager startMonitoringNetworkStatus];
    });
    return _networkManager;
}

//设置默认值
- (void)setDefaultValue {
    
    _timeoutValue    = kTimeoutValue;
    _requestMaxCount = kMaxRequestCount;
    
}

//设置超时时间
- (void)setTimeoutValue:(NSTimeInterval)timeoutValue {
    
    _timeoutValue = timeoutValue;
    
}
//设置最大并发数
- (void)setRequestMaxCount:(NSInteger)requestMaxCount {
    
    _requestMaxCount = requestMaxCount;
    
}


/**
 开始监听网络状态
 */
- (void)startMonitoringNetworkStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    __weak typeof(self) weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                weakSelf.statusBlock(YGNetworkStatusUnknow);
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                weakSelf.statusBlock(YGNetworkStatusNoNet);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                weakSelf.statusBlock(YGNetworkStatusWWAN);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                weakSelf.statusBlock(YGNetworkStatusWiFi);
                break;
        }
    }];
    
    [manager startMonitoring];
    
}



/**
 get请求
 
 @param url             请求URL
 @param paramDict       请求参数
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)getRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    YGURLSessionTask *sessionTask = [manager GET:url parameters:paramDict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //和服务端约定返回字典
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *respDict = (NSDictionary *)responseObject;
            
            if ([respDict[@"code"] integerValue] == 1) {
                //和服务端约定的code = 1时为正确 回调字典
                successBlock ? successBlock(respDict) : nil;
                
            } else {
                //code != 1 回调字典的msg+code
                failBlock ? failBlock([NSString stringWithFormat:@"%@(%@)", respDict[@"msg"], respDict[@"code"]]) : nil;
                
            }
            
        } else {
            //不为字典 服务端问题
            failBlock ? failBlock(@"返回格式有误") : nil;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock ? errorBlock(error) : nil;
        
    }];
    
    return sessionTask;
    
}


/**
 post请求
 
 @param url             请求URL
 @param paramDict       请求参数
 @param successBlock    请求成功回调
 @param failBlock       请求失败回调
 @param errorBlock      error回调
 @return                返回请求任务
 */
- (YGURLSessionTask *)postRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    YGURLSessionTask *sessionTask = [manager POST:url parameters:paramDict headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //和服务端约定返回字典
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *respDict = (NSDictionary *)responseObject;
            
            if ([respDict[@"code"] integerValue] == 1) {
                //和服务端约定的code = 1时为正确 回调字典
                successBlock ? successBlock(respDict) : nil;
                
            } else {
                //code != 1 回调字典的msg+code
                failBlock ? failBlock([NSString stringWithFormat:@"%@(%@)", respDict[@"msg"], respDict[@"code"]]) : nil;
                
            }
            
        } else {
            //不为字典 服务端问题
            failBlock ? failBlock(@"返回格式有误") : nil;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock ? errorBlock(error) : nil;
        
    }];
    
    return sessionTask;
    
}


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
- (YGURLSessionTask *)uploadFileWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(YGProgressBlock)progressBlock successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    YGURLSessionTask *sessionTask = [manager POST:url parameters:paramDict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传文件，以数据流的格式
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progressBlock ? progressBlock(uploadProgress.completedUnitCount/(uploadProgress.totalUnitCount * 1.0)) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //和服务端约定返回字典
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *respDict = (NSDictionary *)responseObject;
            
            if ([respDict[@"code"] integerValue] == 1) {
                //和服务端约定的code = 1时为正确 回调字典
                successBlock ? successBlock(respDict) : nil;
                
            } else {
                //code != 1 回调字典的msg+code
                failBlock ? failBlock([NSString stringWithFormat:@"%@(%@)", respDict[@"msg"], respDict[@"code"]]) : nil;
                
            }
            
        } else {
            //不为字典 服务端问题
            failBlock ? failBlock(@"返回格式有误") : nil;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock ? errorBlock(error) : nil;
        
    }];
    
    return sessionTask;
    
}



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
- (YGURLSessionTask *)downloadFileWithURL:(NSString *)url filePath:(NSString *)filePath progressBlock:(YGProgressBlock)progressBlock successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock {
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    YGURLSessionTask *sessionTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progressBlock ? progressBlock(downloadProgress.completedUnitCount/(downloadProgress.totalUnitCount * 1.0)) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //保存文件路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            
            //返回文件下载路径
            successBlock ? successBlock(filePath) : nil;
            
        } else {
            
            errorBlock ? errorBlock(error) : nil;
            
        }
        
    }];
    
    //开始下载
    [sessionTask resume];
    
    return sessionTask;
    
}



//!!!!:辅助方法
- (AFHTTPSessionManager *)getSessionManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = _timeoutValue;
    //请求队列的最大并发数
    manager.operationQueue.maxConcurrentOperationCount = _requestMaxCount;
    //打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    //设置请求参数的类型:HTTP
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置服务器返回结果的类型:JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置响应数据的基本类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/css",
                                                         @"text/xml",
                                                         @"text/plain",
                                                         @"application/javascript",
                                                         @"image/*", nil];
    
    
    //适配https(无CA证书)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    return manager;
    
}


@end

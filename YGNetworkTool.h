//
//  YGNetworkTool.h
//  PackageAFNetworking
//
//  Created by 王永刚 on 2016/11/30.
//  Copyright © 2016 PackageAFNetworking. All rights reserved.
//
//  网络工具类(项目中所有的请求全在这个类中处理)

#import "YGNetworkManager.h"

@interface YGNetworkTool : YGNetworkManager

//example post request
/**
 example post request

 @param url             请求链接
 @param paramDict       参数
 @param successBlock    业务成功回调
 @param failBlock       业务失败回调
 @param errorBlock      error回调
 */
- (void)getUserSpaceInfoRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock;

@end



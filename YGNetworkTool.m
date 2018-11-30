//
//  YGNetworkTool.m
//  PackageAFNetworking
//
//  Created by 王永刚 on 2016/11/30.
//  Copyright © 2016 PackageAFNetworking. All rights reserved.
//

#import "YGNetworkTool.h"

@implementation YGNetworkTool

/**
 example post request
 
 @param url             请求链接
 @param paramDict       参数
 @param successBlock    业务成功回调
 @param failBlock       业务失败回调
 @param errorBlock      error回调
 */
- (void)getUserSpaceInfoRequestWithURL:(NSString *)url paramDict:(NSDictionary *)paramDict successBlock:(YGRequestSuccessBlock)successBlock failBlock:(YGRequestFailBlock)failBlock errorBlock:(YGServerErrorBlock)errorBlock {
    
    [self postRequestWithURL:url paramDict:paramDict successBlock:^(id responseData) {
        
        //解析responseData 组装model 回调对应的model
        id model = responseData;
        
        successBlock ? successBlock(model) : nil;
        
    } failBlock:^(id responseData) {
        
        //回调msg
        failBlock ? failBlock(responseData) : nil;
        
    } errorBlock:^(NSError *error) {
        
        //回调error
        errorBlock ? errorBlock(error) : nil;
        
    }];
    
}

@end

//
//  MHttpEngine.h
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface MHttpEngine : NSObject<ASIHTTPRequestDelegate>{
    NSTimeInterval _m_timeInterval_timeout; // 请求超时秒数。
    int _m_int_numberOfTimesToRetryOnTimeout; // 请求超时时重新请求次数。
    BOOL _m_bool_allowCompressedResponse;
    NSDictionary* _m_dict_header;           // 请求数据头。
    NSMutableArray* _m_mutArray_request;    // 请求数据; 所有的请求将被放置此数组中。
}

@property (nonatomic,assign) NSTimeInterval m_timeInterval_timeout;
@property (nonatomic,assign) int m_int_numberOfTimesToRetryOnTimeout;
@property (nonatomic,assign) BOOL m_bool_allowCompressedResponse;
@property (nonatomic,strong) NSDictionary* m_dict_header;
@property (nonatomic,strong) NSMutableArray* m_mutArray_request;

/**
 创建一个CCSHttpEngine。
 @param headerParams: 请求头
 @return CCSHttpEngine: http请求引擎,该类作为所有请求的容器。
 */
+(MHttpEngine*)engineWithHeaderParams:(NSDictionary *)headerParams;

/**
 创建一个数据请求，需要自己开启请求。
 @param url: 请求的url
 @param postParams: 请求的Post参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return requestID
 */
-(ASIFormDataRequest*)buildRequest:(NSString *)url
                        postParams:(NSDictionary *)postParams
                            object:(id)object
                  onFinishedAction:(SEL)finishedAction
                    onFailedAction:(SEL)failedAction;

/**
 创建一个数据请求，需要自己开启请求。
 @param url: 请求的url
 @param getParams: 请求的Get参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return request
 */
-(ASIFormDataRequest*)buildRequest:(NSString *)url
                         getParams:(NSDictionary *)getParams
                            object:(id)object
                  onFinishedAction:(SEL)finishedAction
                    onFailedAction:(SEL)failedAction;

/**
 创建一个数据请求，处理分发服务器得请求格式。
 @param url: 请求的url
 @param getParams: 请求的Get参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return request
 */
-(ASIFormDataRequest*)buildDistributeRequest:(NSString *)url
                                   getParams:(NSDictionary *)getParams
                                      object:(id)object
                            onFinishedAction:(SEL)finishedAction
                              onFailedAction:(SEL)failedAction;

/**
 创建一个默认的数据请求，需要自己开启请求。
 @param url: 请求的url
 @param postParams: 请求的Post参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return requestID
 */
-(ASIFormDataRequest*)buildDefaultRequest:(NSString *)url
                               postParams:(NSDictionary *)postParams
                                   object:(id)object
                         onFinishedAction:(SEL)finishedAction
                           onFailedAction:(SEL)failedAction;

/**
 创建一个默认的数据异步请求。
 @param url: 请求的url
 @param postParams: 请求的Post参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return requestID
 */
-(NSNumber*)startDefaultAsynchronousRequest:(NSString *)url
                                 postParams:(NSDictionary *)postParams
                                     object:(id)object
                           onFinishedAction:(SEL)finishedAction
                             onFailedAction:(SEL)failedAction;

/**
 创建一个默认的数据同步请求。
 @param url: 请求的url
 @param postParams: 请求的Post参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return requestID
 */
-(NSNumber*)startDefaultSynchronousRequest:(NSString *)url
                                postParams:(NSDictionary *)postParams
                                    object:(id)object
                          onFinishedAction:(SEL)finishedAction
                            onFailedAction:(SEL)failedAction;

/**
 创建一个默认的数据异步请求。
 @param url: 请求的url
 @param getParams: 请求的Get参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return request
 */
-(ASIFormDataRequest*)startDefaultAsynchronousRequest:(NSString *)url
                                            getParams:(NSDictionary *)getParams
                                               object:(id)object
                                     onFinishedAction:(SEL)finishedAction
                                       onFailedAction:(SEL)failedAction;

/**
 创建一个默认的数据同步请求。
 @param url: 请求的url
 @param getParams: 请求的Get参数
 @param object: 请求代理对象，成功或失败的回调对象。
 @param finishedAction: 请求成功的回调方法。
 @param failedAction: 请求失败的回调方法。
 @return request
 */
-(ASIFormDataRequest*)startDefaultSynchronousRequest:(NSString *)url
                                           getParams:(NSDictionary *)getParams
                                              object:(id)object
                                    onFinishedAction:(SEL)finishedAction
                                      onFailedAction:(SEL)failedAction;

/**
 根据requestID获取数据请求。
 @param requestID: 数据请求ID。
 @return 数据请求。
 */
-(ASIFormDataRequest*)findRequestByRequestID:(NSNumber*)requestID;

/**
 根据requestID终止数据请求，并从Engine的请求数组中移出该请求(释放请求)。
 */
-(void)cancelRequestByID:(NSNumber *)requestID;

/**
 终止所有数据请求。
 */
-(void)cancelAllRequest;


@end

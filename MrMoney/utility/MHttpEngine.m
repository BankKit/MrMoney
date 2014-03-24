//
//  MHttpEngine.m
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "MHttpEngine.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



@interface MHttpEngine (PrivateMethods)
-(void)fillupHeaderParams:(ASIFormDataRequest *)_request;
-(void)fillupPostParams:(ASIFormDataRequest *)_request;

-(void)setupDefaultConfig:(ASIFormDataRequest *)_request;
-(void)addRequest:(ASIHTTPRequest *)_request;
-(void)removeRequest:(ASIHTTPRequest *)_request;
@end


@implementation MHttpEngine
@synthesize m_timeInterval_timeout = _m_timeInterval_timeout;
@synthesize m_int_numberOfTimesToRetryOnTimeout = _m_int_numberOfTimesToRetryOnTimeout;
@synthesize m_bool_allowCompressedResponse = _m_bool_allowCompressedResponse;
@synthesize m_dict_header = _m_dict_header;
@synthesize m_mutArray_request = _m_mutArray_request;

-(void)dealloc{
    self.m_mutArray_request = nil;
    self.m_dict_header = nil;
 
}

- (id)init{
    self = [super init];
    if (self) {
        _m_mutArray_request = [[NSMutableArray alloc] initWithCapacity:10];
        
        _m_timeInterval_timeout = 60;              // 默认超时20秒
        _m_int_numberOfTimesToRetryOnTimeout = 0;  // 超时重试0次
        _m_bool_allowCompressedResponse = YES;     // 默认支持gzip
    }
    return self;
}

#pragma mark -
#pragma mark 私有接口
-(void)fillupHeaderParams:(ASIFormDataRequest *)_request{
    if (self.m_dict_header!=nil) {
        NSLog(@"URL:%@\nHeaderParams: %@",_request.url, self.m_dict_header==nil?@"":[self.m_dict_header description]);
        for(id key in [self.m_dict_header allKeys]){
            id val=[self.m_dict_header objectForKey:key];
            [_request addRequestHeader:key value:val];
        }
    }
}

-(void)fillupPostParams:(ASIFormDataRequest *)_request
         withPostParams:(NSDictionary *)postParams{
    if (postParams!=nil) {
        NSLog(@" **** URL:%@\nPostParams: %@",_request.url,postParams);
//        NSArray *sortArray = [[postParams allKeys] sortedArrayUsingSelector:@selector(compare:)];

        
        for(id key in [postParams allKeys]){
            id val=[postParams objectForKey:key];
            
//            NSString *subKey = nil;
//            if ([[key substringToIndex:1] intValue] > 0) {
//                subKey =   [key substringFromIndex:1];
//            }else{
//                subKey = key;
//            }
            
//            NSLog(@"post请求参数 ----  %@: %@",subKey,val);
            [_request setPostValue:val forKey:key];
        }
    }
}

-(void)setupDefaultConfig:(ASIFormDataRequest *)_request{
    [_request setTimeOutSeconds:_m_timeInterval_timeout]; // 设置超时秒数
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setNumberOfTimesToRetryOnTimeout:_m_int_numberOfTimesToRetryOnTimeout]; // 设置请求超时时重新请求的次数
    [_request setAllowCompressedResponse:_m_bool_allowCompressedResponse];    // 是否支持gzip的格式
}

-(void)addRequest:(ASIHTTPRequest *)_request{
    [self.m_mutArray_request addObject:_request];
}

-(void)removeRequest:(ASIHTTPRequest *)_request{
    [self.m_mutArray_request removeObject:_request];
}

#pragma mark -
#pragma mark 对外接口
+(MHttpEngine*)engineWithHeaderParams:(NSDictionary *)headerParams{
    MHttpEngine* _httpEngine = [[MHttpEngine alloc] init];
    _httpEngine.m_dict_header = headerParams;
    return _httpEngine;
}

-(ASIFormDataRequest*)buildRequest:(NSString *)url
                        postParams:(NSDictionary *)postParams
                            object:(id)object
                  onFinishedAction:(SEL)finishedAction
                    onFailedAction:(SEL)failedAction{
    ASIFormDataRequest* _request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self fillupHeaderParams:_request];   // 填充Header参数
    [self fillupPostParams:_request withPostParams:postParams];     // 填充Post参数
    [_request setDelegate:self];      // 设置请求代理
    [_request setRequestMethod:@"POST"]; //请求默认为GET方式，修改为POST方式，请见ASIHTTPRequest头文件
    
    NSValue *finishedActionValue = [NSValue valueWithBytes:&finishedAction objCType:@encode(SEL)];
    NSValue *failedActionValue = [NSValue valueWithBytes:&failedAction objCType:@encode(SEL)];
    
    NSDictionary* _dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           object, @"object",
                           finishedActionValue, @"finishedAction",
                           failedActionValue, @"failedAction",nil];
    [_request setUserInfo:_dict]; // 设置上下文
    [self addRequest:_request];
 
    return _request;
}

-(ASIFormDataRequest*)buildRequest:(NSString *)url
                         getParams:(NSDictionary *)getParams
                            object:(id)object
                  onFinishedAction:(SEL)finishedAction
                    onFailedAction:(SEL)failedAction{
    

     NSString *paramUrl = [self buildGetParamList:url getParams:getParams];
 
    NSLog(@"\n\n\n get URL ---- :  %@ \n\n\n",paramUrl);
    
    NSURL *getUrl = [NSURL URLWithString:[paramUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest* _request=[[ASIFormDataRequest alloc] initWithURL:getUrl];
    
    [self fillupHeaderParams:_request];                           // 填充Header参数
    [_request setDelegate:self];      // 设置请求代理
    
    NSValue *finishedActionValue = [NSValue valueWithBytes:&finishedAction objCType:@encode(SEL)];
    NSValue *failedActionValue = [NSValue valueWithBytes:&failedAction objCType:@encode(SEL)];
    
    NSDictionary* _dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           object, @"object",
                           finishedActionValue, @"finishedAction",
                           failedActionValue, @"failedAction",nil];
    [_request setUserInfo:_dict]; // 设置上下文
    [self addRequest:_request];
 
    return _request;
}

/**
 *  分发服务器的请求处理
 */
-(ASIFormDataRequest*)buildDistributeRequest:(NSString *)url
                         getParams:(NSDictionary *)getParams
                            object:(id)object
                  onFinishedAction:(SEL)finishedAction
                    onFailedAction:(SEL)failedAction{
    
    
//     NSString *paramUrl = [self joinParamList:url getParams:getParams];
    
    
    NSURL *getUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 
      
    ASIFormDataRequest* _request=[[ASIFormDataRequest alloc] initWithURL:getUrl];
    
    [self fillupHeaderParams:_request];                           // 填充Header参数
    [_request setDelegate:self];      // 设置请求代理
    
    NSValue *finishedActionValue = [NSValue valueWithBytes:&finishedAction objCType:@encode(SEL)];
    NSValue *failedActionValue = [NSValue valueWithBytes:&failedAction objCType:@encode(SEL)];
    
    NSDictionary* _dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           object, @"object",
                           finishedActionValue, @"finishedAction",
                           failedActionValue, @"failedAction",nil];
    [_request setUserInfo:_dict]; // 设置上下文
    [self addRequest:_request];
    
    return _request;
}
-(NSString*)joinParamList:(NSString*)url getParams:(NSDictionary *)getParams{
    
    NSMutableString* _paramList = [[NSMutableString alloc] init];
    
    for ( int i=0; i<[getParams count]; i++ ) {
        NSString* key = [[getParams allKeys] objectAtIndex:i];
        
        NSString* formatString = nil;
        
        if ( i == 0 ) {
            formatString = @"?%@"; //启始位置以?开始
        }else{
            formatString = @"_%@"; //参数之间用&连接
        }
        
        
        NSString* _appendParamStr = [NSString stringWithFormat:formatString,(NSString*)[getParams objectForKey:key]];
         [_paramList appendString:_appendParamStr];
        
    }
    
    NSString* resultUrl = [NSString stringWithFormat:@"%@%@", url, _paramList];
//     NSLog(@"get resultUrl----- %@",resultUrl);
    return resultUrl;
}





-(ASIFormDataRequest*)buildDefaultRequest:(NSString *)url
                               postParams:(NSDictionary *)postParams
                                   object:(id)object
                         onFinishedAction:(SEL)finishedAction
                           onFailedAction:(SEL)failedAction{
    ASIFormDataRequest* _request = [self buildRequest:url
                                           postParams:postParams
                                               object:object
                                     onFinishedAction:finishedAction
                                       onFailedAction:failedAction];
    [self setupDefaultConfig:_request];
    return _request;
}

-(NSNumber*)startDefaultAsynchronousRequest:(NSString *)url
                                 postParams:(NSDictionary *)postParams
                                     object:(id)object
                           onFinishedAction:(SEL)finishedAction
                             onFailedAction:(SEL)failedAction{
    ASIFormDataRequest* _request = [self buildRequest:url
                                           postParams:postParams
                                               object:object
                                     onFinishedAction:finishedAction
                                       onFailedAction:failedAction];
    [self setupDefaultConfig:_request];
    [_request startAsynchronous];
    return _request.requestID;
}

-(NSNumber*)startDefaultSynchronousRequest:(NSString *)url
                                postParams:(NSDictionary *)postParams
                                    object:(id)object
                          onFinishedAction:(SEL)finishedAction
                            onFailedAction:(SEL)failedAction{
    ASIFormDataRequest* _request = [self buildRequest:url
                                           postParams:postParams
                                               object:object
                                     onFinishedAction:finishedAction
                                       onFailedAction:failedAction];
    [self setupDefaultConfig:_request];
    [_request startSynchronous];
    return _request.requestID;
}

-(NSString*)buildGetParamList:(NSString*)url getParams:(NSDictionary *)getParams{
 
    NSMutableString* _paramList = [[NSMutableString alloc] init];
    
    for ( int i=0; i<[getParams count]; i++ ) {
        
        NSString* key = [[getParams allKeys] objectAtIndex:i];
        
//        NSLog(@"key **************** %@",key);
        NSString* formatString = nil;

        if ( i == 0 ) {
            formatString = @"?%@=%@"; //启始位置以?开始
        }else{
            formatString = @"&%@=%@"; //参数之间用&连接
        }
        
//        NSString *subKey = nil;
//        if ([[key substringToIndex:1] intValue] > 0) {
//              subKey =   [key substringFromIndex:1];
//        }else{
//            subKey = key;
//        }
        NSString* _appendParamStr = [NSString stringWithFormat:formatString, key,(NSString*)[getParams objectForKey:key]];

        [_paramList appendString:_appendParamStr];
    
    }
    
    NSString* resultUrl = [NSString stringWithFormat:@"%@%@", url, _paramList];

    
    return resultUrl;
}

-(ASIFormDataRequest*)startDefaultAsynchronousRequest:(NSString *)url
                                            getParams:(NSDictionary *)getParams
                                               object:(id)object
                                     onFinishedAction:(SEL)finishedAction
                                       onFailedAction:(SEL)failedAction{
    
    
    ASIFormDataRequest* _request = [self buildRequest:[self buildGetParamList:url getParams:getParams]
                                            getParams:nil
                                               object:object
                                     onFinishedAction:finishedAction
                                       onFailedAction:failedAction];
    
    [self setupDefaultConfig:_request];
    [_request startAsynchronous];
    return _request;
}

-(ASIFormDataRequest*)startDefaultSynchronousRequest:(NSString *)url
                                           getParams:(NSDictionary *)getParams
                                              object:(id)object
                                    onFinishedAction:(SEL)finishedAction
                                      onFailedAction:(SEL)failedAction{
    
    ASIFormDataRequest* _request = [self buildRequest:[self buildGetParamList:url getParams:getParams]
                                            getParams:nil
                                               object:object
                                     onFinishedAction:finishedAction
                                       onFailedAction:failedAction];
    [self setupDefaultConfig:_request];
    [_request startSynchronous];
    return _request;
}

-(ASIFormDataRequest*)findRequestByRequestID:(NSNumber*)requestID{
    ASIFormDataRequest* _request = nil;
    for (ASIFormDataRequest* _r in _m_mutArray_request) {
        if ([_r.requestID isEqualToNumber:requestID]) {
            _request = _r;
            break;
        }
    }
    return _request;
}

-(void)cancelRequestByID:(NSNumber *)requestID{
    ASIFormDataRequest* _request = [self findRequestByRequestID:requestID];
    [_request cancel];
}

-(void)cancelAllRequest{
    for (ASIFormDataRequest* _r in _m_mutArray_request) {
        [_r clearDelegatesAndCancel];
    }
}

#pragma -
#pragma mark ASIHTTPRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"\n[SYS] Request totalBytesSent : %lld bytes, %.2lf kb \nRequest totalBytesRead : %lld bytes, %.2lf kb \nSuccess responseString: %@",
//          [request totalBytesSent], [request totalBytesSent]/1024.0,
//          [request totalBytesRead], [request totalBytesRead]/1024.0, [request responseString]);
    
    id object = [[request userInfo] objectForKey:@"object"];
    SEL finishedAction;
    [(NSValue *)[[request userInfo] objectForKey:@"finishedAction"] getValue:&finishedAction];
    if ([object respondsToSelector:finishedAction]) {
        /**
         *  使用宏定义解决arc下 performSelector may cause a leak because its selector is unknown 警告
         */
        SuppressPerformSelectorLeakWarning(
                [object performSelector:finishedAction withObject:request];
        );

    }
    [self removeRequest:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Error responseString: %@", [request error]);
    id object = [[request userInfo] objectForKey:@"object"];
    SEL failedAction;
 
    [(NSValue *)[[request userInfo] objectForKey:@"failedAction"] getValue:&failedAction];
    if ([object respondsToSelector:failedAction]) {
        SuppressPerformSelectorLeakWarning(
                [object performSelector:failedAction withObject:request];
        );

    }
    [self removeRequest:request];
}

@end

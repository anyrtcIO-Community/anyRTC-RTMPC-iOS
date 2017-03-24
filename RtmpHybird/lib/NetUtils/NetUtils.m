//
//  NetUtils.m
//  RtmpHybird
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "NetUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <RTMPCHybirdEngine/RTMPCHybirdEngineKit.h>

@interface NetUtils()<NSURLSessionDataDelegate>
{
    GetLivingListsBlock listBlock;
    GetRecordDictBlock  recordBlock;
    CloseRecordBlock closeRecordBlock;
}
// 请求list
@property (nonatomic, strong) NSURLSession *listSession;
@property (nonatomic, strong) NSMutableData *listResponseData;
@property (nonatomic, strong) NSString *listRequestUrl;
@property (nonatomic, assign) int requestLivingListNum;

// 录像
@property (nonatomic, strong) NSURLSession *recordSession;
@property (nonatomic, strong) NSMutableData *recordResponseData;
@property (nonatomic, strong) NSString *recordRequestUrl;
@property (nonatomic, assign) int requesRecordNum;

// 关闭录像
@property (nonatomic, strong) NSURLSession *closeRecordSession;
@property (nonatomic, strong) NSMutableData *closeRecordResponseData;
@property (nonatomic, strong) NSString *closeRecordRequestUrl;
@property (nonatomic, assign) int closeRequesRecordNum;

@end

@implementation NetUtils
static NetUtils *_netUtils = nil;
+ (NetUtils*)shead {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netUtils = [[NetUtils alloc] init];
    });
    return _netUtils;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 列表
        self.listResponseData = [[NSMutableData alloc] initWithCapacity:5];
        _requestLivingListNum = 0;
        
        // 录制
        self.recordResponseData = [[NSMutableData alloc] initWithCapacity:5];
        _requesRecordNum = 0;
        
        self.closeRecordResponseData = [[NSMutableData alloc] initWithCapacity:5];
        _closeRequesRecordNum = 0;
        
    }
    return self;
}
- (void)getLivingList:(GetLivingListsBlock)resultBlock {
    listBlock = resultBlock;
    [self.listResponseData setLength:0];
    _requestLivingListNum = 0;
    // 发起请求(第一步)
    //.根据会话对象创建一个Task(发送请求）
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _listSession = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    self.listRequestUrl = [NSString stringWithFormat:@"http://%@/anyapi/V1/livelist?AppID=%@&DeveloperID=%@",[RTMPCHybirdEngineKit GetHttpAddr],appID,developerID];
    self.listRequestUrl  = [self.listRequestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSessionDataTask *task = [_listSession dataTaskWithURL:[NSURL URLWithString:self.listRequestUrl]];
    
    [task resume];
}

- (void)recordRtmpSteam:(NSString *)strRtmpUrl withAnyrtcID:(NSString*)anyrtcID withResID:(NSString*)resID withResult:(GetRecordDictBlock)resultBlock{
    
    recordBlock = resultBlock;
    [self.recordResponseData setLength:0];
    _requesRecordNum = 0;
    // 发起请求(第一步)
    //.根据会话对象创建一个Task(发送请求）
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _recordSession = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    self.recordRequestUrl = [NSString stringWithFormat:@"http://%@/anyapi/V1/recordrtmp?AppID=%@&DeveloperID=%@&AnyrtcID=%@&Url=%@&ResID=%@",[RTMPCHybirdEngineKit GetHttpAddr],appID,developerID,anyrtcID,strRtmpUrl,resID];
    self.recordRequestUrl  = [self.recordRequestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSessionDataTask *task = [_recordSession dataTaskWithURL:[NSURL URLWithString:self.recordRequestUrl]];
    
    [task resume];
}

- (void)closerEecRtmpStream:(NSString*)strVodSvrId withVodResTag:(NSString*)strVodResTag withResult:(CloseRecordBlock)resultBlock {
    closeRecordBlock = resultBlock;
    [self.closeRecordResponseData setLength:0];
    _closeRequesRecordNum = 0;
    // 发起请求(第一步)
    //.根据会话对象创建一个Task(发送请求）
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _closeRecordSession = [NSURLSession sessionWithConfiguration:configuration
                                                   delegate:self
                                              delegateQueue:[NSOperationQueue mainQueue]];
    self.closeRecordRequestUrl = [NSString stringWithFormat:@"http://%@/anyapi/V1/closerecrtmp?AppID=%@&DeveloperID=%@&VodSvrID=%@&VodResTag=%@",[RTMPCHybirdEngineKit GetHttpAddr],appID,developerID,strVodSvrId,strVodResTag];
    self.closeRecordRequestUrl  = [self.closeRecordRequestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSessionDataTask *task = [_closeRecordSession dataTaskWithURL:[NSURL URLWithString:self.closeRecordRequestUrl]];
    
    [task resume];

}

#pragma mark -

//1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
   // NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    // 列表请求
    if (_listSession == session) {
        //在该方法中可以得到响应头信息，即response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
       // NSLog(@"%ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode == 401 && _requestLivingListNum == 0) {
            _requestLivingListNum++;
            completionHandler(NSURLSessionResponseAllow);
            goto secondRequest;
        }else if(httpResponse.statusCode !=200){
            completionHandler(NSURLSessionResponseCancel);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
            listBlock(nil,error,201);
            return;
        }else if(httpResponse.statusCode ==200){
            if (self.requestLivingListNum == 1) {
                _requestLivingListNum++;
                completionHandler(NSURLSessionResponseAllow);
                return;
            }else{
                completionHandler(NSURLSessionResponseCancel);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                listBlock(nil,error,201);
                return;
            }
        }
    secondRequest:
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            //得到头信息，然后进行第二次请求
            if (dictionary) {
                //  获取realm
                NSString *RealmStr=[self getRealmStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (RealmStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    listBlock(nil,error,201);
                    return;
                }
                //  获取nounce
                NSString *nounceStrStr=[self getNounceStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (nounceStrStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    listBlock(nil,error,201);
                    return;
                }
                // 获取response
                NSString *responseAfterMd5 = [self getRsponseStr:[dictionary objectForKey:@"Www-Authenticate"]withRealm:RealmStr withNonce:nounceStrStr withUrl:self.listRequestUrl];
                if (responseAfterMd5==nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    listBlock(nil,error,201);
                    return;
                }
                
                NSString *strdic=[NSString stringWithFormat:@"Digest username=\"%@\",realm=\"%@\",nonce=\"%@\",uri=\"%@\",response=\"%@\"",appID,RealmStr,nounceStrStr,self.listRequestUrl,responseAfterMd5];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.listRequestUrl]];
                
                [request setValue:strdic forHTTPHeaderField:@"Authorization"];
                
                dataTask = [session dataTaskWithRequest:request];
                
                [dataTask resume];
                
            }
        }
    }else if(session == _recordSession){
        //在该方法中可以得到响应头信息，即response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
      //  NSLog(@"%ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode == 401 && _requesRecordNum == 0) {
            _requesRecordNum++;
            completionHandler(NSURLSessionResponseAllow);
            goto secondRequestRecoder;
        }else if(httpResponse.statusCode !=200){
            completionHandler(NSURLSessionResponseCancel);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
            recordBlock(nil,error,201);
            return;
        }else if(httpResponse.statusCode ==200){
            if (self.requesRecordNum == 1) {
                _requesRecordNum++;
                completionHandler(NSURLSessionResponseAllow);
                return;
            }else{
                completionHandler(NSURLSessionResponseCancel);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                recordBlock(nil,error,201);
                return;
            }
        }
        
    secondRequestRecoder:
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            //得到头信息，然后进行第二次请求
            if (dictionary) {
                //  获取realm
                NSString *RealmStr=[self getRealmStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (RealmStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    recordBlock(nil,error,201);
                    return;
                }
                //  获取nounce
                NSString *nounceStrStr=[self getNounceStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (nounceStrStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    recordBlock(nil,error,201);
                    return;
                }
                // 获取response
                NSString *responseAfterMd5 = [self getRsponseStr:[dictionary objectForKey:@"Www-Authenticate"]withRealm:RealmStr withNonce:nounceStrStr withUrl:self.recordRequestUrl];
                if (responseAfterMd5==nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    recordBlock(nil,error,201);
                    return;
                }
                
                NSString *strdic=[NSString stringWithFormat:@"Digest username=\"%@\",realm=\"%@\",nonce=\"%@\",uri=\"%@\",response=\"%@\"",appID,RealmStr,nounceStrStr,self.recordRequestUrl,responseAfterMd5];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.recordRequestUrl]];
                
                [request setValue:strdic forHTTPHeaderField:@"Authorization"];
                
                dataTask = [session dataTaskWithRequest:request];
                
                [dataTask resume];
                
            }
        }
    }else if (session == _closeRecordSession){
        //在该方法中可以得到响应头信息，即response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
      //  NSLog(@"%ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode == 401 && _closeRequesRecordNum == 0) {
            _closeRequesRecordNum++;
            completionHandler(NSURLSessionResponseAllow);
            goto secondRequestCloseRecoder;
        }else if(httpResponse.statusCode !=200){
            completionHandler(NSURLSessionResponseCancel);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
            closeRecordBlock(error,201);
            return;
        }else if(httpResponse.statusCode ==200){
            if (self.closeRequesRecordNum == 1) {
                _closeRequesRecordNum++;
                completionHandler(NSURLSessionResponseAllow);
                return;
            }else{
                completionHandler(NSURLSessionResponseCancel);
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                closeRecordBlock(error,201);
                return;
            }
        }
        
    secondRequestCloseRecoder:
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            //得到头信息，然后进行第二次请求
            if (dictionary) {
                //  获取realm
                NSString *RealmStr=[self getRealmStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (RealmStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    closeRecordBlock(error,201);
                    return;
                }
                //  获取nounce
                NSString *nounceStrStr=[self getNounceStr:[dictionary objectForKey:@"Www-Authenticate"]];
                if (nounceStrStr == nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    closeRecordBlock(error,201);
                    return;
                }
                // 获取response
                NSString *responseAfterMd5 = [self getRsponseStr:[dictionary objectForKey:@"Www-Authenticate"]withRealm:RealmStr withNonce:nounceStrStr withUrl:self.recordRequestUrl];
                if (responseAfterMd5==nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求出错..." forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.dync.RtmpHybird" code:-1000 userInfo:userInfo];
                    closeRecordBlock(error,201);
                    return;
                }
                
                NSString *strdic=[NSString stringWithFormat:@"Digest username=\"%@\",realm=\"%@\",nonce=\"%@\",uri=\"%@\",response=\"%@\"",appID,RealmStr,nounceStrStr,self.recordRequestUrl,responseAfterMd5];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.recordRequestUrl]];
                
                [request setValue:strdic forHTTPHeaderField:@"Authorization"];
                
                dataTask = [session dataTaskWithRequest:request];
                
                [dataTask resume];
                
            }
        }
    }
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
   // NSLog(@"didReceiveData--%@",[NSThread currentThread]);
    // 列表请求
    if (session == _listSession) {
        //拼接服务器返回的数据
        [self.listResponseData appendData:data];
    }else if(session == _recordSession){
        [self.recordResponseData appendData:data];
    }else if(session == _closeRecordSession){
        [self.closeRecordResponseData appendData:data];
    }
   
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(session == _listSession) {
        if(error == nil)
        {
            if (self.listResponseData.length>0) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.listResponseData options:kNilOptions error:nil];
                NSArray *listArray = [dict objectForKey:@"LiveList"];
                NSArray *mumberArray  = [dict objectForKey:@"LiveMembers"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:5];
                for (int i=0; i<listArray.count;i++) {
                    NSDictionary *tempDict = [self JSONValue:[listArray objectAtIndex:i]];
                    LivingItem *item = [[LivingItem alloc] init];
                    item.hosterId = [tempDict objectForKey:@"hosterId"];
                    item.rtmp_url = [tempDict objectForKey:@"rtmp_url"];
                    item.hls_url = [tempDict objectForKey:@"hls_url"];
                    item.topic = [tempDict objectForKey:@"topic"];
                    item.isAudioOnly = [tempDict objectForKey:@"isAudioOnly"];
                    item.isVideoAudioLiving = [tempDict objectForKey:@"isVideoAudioLiving"];
                    if (i<mumberArray.count) {
                        item.LiveMembers = [NSString stringWithFormat:@"%@",[mumberArray objectAtIndex:i]];
                    }
                    item.andyrtcId = [tempDict objectForKey:@"anyrtcId"];
                    [tempArray addObject:item];
                }
                listBlock(tempArray,nil,200);
               // NSLog(@"%@",listArray);
            }
        }else{
            if (listBlock) {
                listBlock(nil,error,201);
            }
        }
    }else if(session == _recordSession){
        if(error == nil)
        {
            if (self.recordResponseData.length>0) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.recordResponseData options:kNilOptions error:nil];
                recordBlock(dict,nil,200);
            }
        }else{
            if (recordBlock) {
                recordBlock(nil,error,201);
            }
        }
    }else if(session == _closeRecordSession){
        if(error == nil)
        {
            if (self.closeRecordResponseData.length>0) {
                closeRecordBlock(nil,200);
            }
        }else{
            if (closeRecordBlock) {
                closeRecordBlock(error,201);
            }
        }
    }
}

#pragma mark - private method
- (id)JSONObjectWithData:(NSData *)data {
    
    // 如果没有数据返回，则直接不解析
    if (data.length == 0) {
        
        return nil;
    }
    
    // 初始化解析错误
    NSError *error = nil;
    
    // JSON解析
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return object;
}
- (id)JSONValue:(NSString*)jsonStrong
{
    if ([jsonStrong isKindOfClass:[NSDictionary class]]) {
        return jsonStrong;
    }
    NSData* data = [jsonStrong dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSString *)getNounceStr:(NSString *)str
{
    NSString *nounceStr=nil;
    NSRange range1=[str rangeOfString:@"nonce="];
    NSRange range={range1.location+range1.length+1,32};
    if (str.length>range.location+range.length) {
        nounceStr =[str substringWithRange:range];
       // NSLog(@"%@",nounceStr);
        return nounceStr;
    }
    return nil;
}




- (NSString *)getRealmStr:(NSString *)str
{
    NSString *realmStr=nil;
    NSRange range1=[str rangeOfString:@"realm="];
    NSRange range2=[str rangeOfString:@", nonce"];
    NSRange range={range1.location + range1.length+1 ,range2.location-1-range1.location-range1.length-1};
    NSLog(@"%@",NSStringFromRange(range));
    if (str.length>range.location+range.length) {
        realmStr=[str substringWithRange:range];
        NSLog(@"%@",realmStr);
        
        return realmStr;
    }
    return nil;
}
- (NSString *)getRsponseStr:(NSString *)str withRealm:(NSString*)realm withNonce:(NSString*)nonce withUrl:(NSString*)url
{
    if (str)
    {
        
        NSString* ha1=[self md5OfString:[NSString stringWithFormat:@"%@:%@:%@",appID,realm,token]];
       // NSLog(@"ha1:%@",ha1);
        //得到ha2
        NSString* ha2=[self md5OfString:[NSString stringWithFormat:@"GET:%@",url]];
      //  NSLog(@"ha2:%@",ha2);
        
        //得到qop
        NSString* qop=@"auth";
        
        //产生随机字符串cnonce
        NSMutableString * cnonce = [[NSMutableString alloc] initWithCapacity:1];
        
        [cnonce setString:@""];
        for (int i=0; i<32;i++ )
        {
            [cnonce insertString:[NSString stringWithFormat:@"%c",'a'+arc4random_uniform(26)] atIndex:0];
        }
        NSString * nc = @"00000001";
        
        NSString *middle = [NSString stringWithFormat:@"%@:%@:%@:%@",nonce,nc,cnonce,qop];
//        NSLog(@"middle:%@",middle);
//        //得到ha3(response)
//        NSLog(@"ha1=%@",ha1);
//        NSLog(@"nonce=%@",nonce);
//        NSLog(@"nc=%@",nc);
//        NSLog(@"cnonce=%@",cnonce);
//        NSLog(@"qop=%@",qop);
//        NSLog(@"ha2=%@",ha2);
        NSString  *ha3=[self md5OfString:[NSString stringWithFormat:@"%@:%@:%@",[ha1 lowercaseString],[middle lowercaseString],[ha2 lowercaseString]]];
       // NSLog(@"ha3:%@",ha3);
        //进行拼接得到字符串authorization
        NSString  *_authorization = [NSString stringWithFormat:@"%@\",qop=\"%@\",nc=\"00000001\",cnonce=\"%@",ha3,qop,cnonce];
        return [_authorization lowercaseString];
    }
    return nil;
}
- (NSString *)md5OfString:(NSString *)aOriginal;
{
    const char *cStr = [aOriginal UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)(strlen(cStr)), result );
    
    return [NSString
            stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

@end

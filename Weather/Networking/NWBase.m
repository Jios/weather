//
//  NWBase.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "NWBase.h"
#import "Keys.h"



@interface NWBase()
<
    NSURLSessionDelegate
>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSession *downloadSession;

@end



@implementation NWBase

// MARK: - # getters

- (NSURLSession *)session
{
    if (!_session)
    {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 5;
        operationQueue.name = @"Default operation queue";
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration: configuration
                                                 delegate: self
                                            delegateQueue: operationQueue];
    }
    
    return _session;
}

-(NSURLSession *)downloadSession
{
    if (!_downloadSession)
    {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.name = @"Download operation queue";
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _downloadSession = [NSURLSession sessionWithConfiguration: configuration
                                                         delegate: self
                                                    delegateQueue: operationQueue];
    }
    
    return _downloadSession;
}


// MARK: - #

-(void)dataTaskWithRequest: (NSURLRequest * _Nonnull)request
             responseBlock: (DictionaryBlock)responseBlock
                errorBlock: (ErrorBlock)errorBlock
{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest: request
                                                 completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     
                                                     NSDictionary *json;
                                                     
                                                     if (data)
                                                     {
                                                         json = [NSJSONSerialization JSONObjectWithData: data
                                                                                                options: kNilOptions
                                                                                                  error: &error];
                                                         
                                                         if ([json isKindOfClass: [NSArray class]])
                                                         {
                                                             json = @{kResults: json};
                                                         }
                                                     }
                                                     
                                                     if (error)
                                                     {
                                                         [Dispatch dispatchObject: error
                                                                         viaBlock: errorBlock];
                                                     }
                                                     else
                                                     {
                                                         [Dispatch dispatchObject: json
                                                                         viaBlock: responseBlock];
                                                     }
                                                 }];
    
    [task resume];
}

-(void)downloadRequest: (NSURLRequest * _Nonnull)request
         responseBlock: (DictionaryBlock)responseBlock
            errorBlock: (ErrorBlock)errorBlock
{
    NSURLSessionTask *task = [self.downloadSession dataTaskWithRequest: request
                                                     completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                         
                                                         if (error)
                                                         {
                                                             [Dispatch dispatchObject: error
                                                                             viaBlock: errorBlock];
                                                         }
                                                         else if (data)
                                                         {
                                                             NSDictionary *dict = @{kData: data,
                                                                                    kResponseURL: request.URL};
                                                             
                                                             [Dispatch dispatchObject: dict
                                                                             viaBlock: responseBlock];
                                                         }
                                                     }];
    
    [task resume];
}

@end

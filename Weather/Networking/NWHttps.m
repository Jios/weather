//
//  NWHttps.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "NWHttps.h"
#import "NWBase_Protected.h"
#import "Keys.h"



@implementation NWHttps

// MARK: - # singlton

+(NWHttps *)sharedInstance
{
    static NWHttps *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}


// MARK: - #

+(void)getURL: (NSURL * _Nonnull)url
responseBlock: (DictionaryBlock)responseBlock
   errorBlock: (ErrorBlock)errorBlock
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        request.HTTPMethod = @"GET";
        request.URL        = url;
        
        [[NWHttps sharedInstance] dataTaskWithRequest: request
                                        responseBlock: responseBlock
                                           errorBlock: errorBlock];
    }];
}

+(void)downloadURL: (NSURL * _Nonnull)url
     responseBlock: (DictionaryBlock)responseBlock
        errorBlock: (ErrorBlock)errorBlock
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
        [request setHTTPMethod: @"GET"];
        
        // cache request
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest: request];

        if (cachedResponse.data)
        {
            NSDictionary *dict = @{kData: cachedResponse.data,
                                   kResponseURL: request.URL};

            [Dispatch dispatchObject: dict
                            viaBlock: responseBlock];
        }
        else
        {
            [[NWHttps sharedInstance] downloadRequest: request
                                        responseBlock: responseBlock
                                           errorBlock: errorBlock];
        }
    }];
}


@end

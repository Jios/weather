//
//  Dispatch.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "Dispatch.h"



@implementation Dispatch

+(void)dispatchAsyncToMainQueue: (VoidBlock _Nonnull)task
{
    if ([NSThread isMainThread])
    {
        task();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), task);
    }
}

+(void)dispatchAsyncToGlobalQueue: (VoidBlock _Nonnull)task
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

+(void)dispatchAsyncToGlobalQueue: (VoidBlock _Nonnull)globalTask
                 asyncToMainQueue: (VoidBlock _Nonnull)mainTask
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        globalTask();
        
        [Dispatch dispatchAsyncToMainQueue: ^{
            
            mainTask();
        }];
    }];
}

+(void)dispatchObject: (id _Nullable)object
             viaBlock: (void(^ _Nonnull)(id _Nullable))block
{
    if (block)
    {
        [Dispatch dispatchAsyncToMainQueue: ^{
            
            block(object);
        }];
    }
}


@end

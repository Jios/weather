//
//  Dispatch.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"



@interface Dispatch : NSObject

+(void)dispatchAsyncToMainQueue: (VoidBlock _Nonnull)task;
+(void)dispatchAsyncToGlobalQueue: (VoidBlock _Nonnull)task;
+(void)dispatchAsyncToGlobalQueue: (VoidBlock _Nonnull)globalTask
                 asyncToMainQueue: (VoidBlock _Nonnull)mainTask;

+(void)dispatchObject: (id _Nullable)object
             viaBlock: (void(^ _Nonnull)(id _Nullable))block;

@end

//
//  SelfMacros.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#ifndef SelfMacros_h
#define SelfMacros_h



/*
 references:
     https://halfrost.com/ios_block_retain_circle/
     http://holko.pl/2015/05/31/weakify-strongify/
     https://github.com/jspahrsummers/libextobjc
 */


// weakSelf & strongSelf
#define weakself(var)   __weak   typeof(var) weakself   = var
#define strongself(var) __strong typeof(var) strongself = weakself;

// weakify & strongify
#define weakify(var)   __weak typeof(var) Weak_##var = var;
#define strongify(var)  _Pragma("clang diagnostic push") \
                        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
                        __strong typeof(var) var = Weak_##var; \
                        _Pragma("clang diagnostic pop")



#endif /* SelfMacros_h */

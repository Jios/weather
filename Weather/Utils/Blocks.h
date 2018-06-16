//
//  Blocks.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#ifndef Blocks_h
#define Blocks_h



typedef void (^DictionaryBlock) (NSDictionary * _Nonnull dictionary);
typedef void (^ArrayBlock     ) (NSArray      * _Nonnull array);
typedef void (^ErrorBlock     ) (NSError      * _Nonnull error);
typedef void (^VoidBlock      ) (void);



#endif /* Blocks_h */

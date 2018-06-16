//
//  NWBase_Protected.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#ifndef NWBase_Protected_h
#define NWBase_Protected_h



@interface NWBase ()

-(void)dataTaskWithRequest: (NSURLRequest * _Nonnull)request
             responseBlock: (DictionaryBlock)responseBlock
                errorBlock: (ErrorBlock)errorBlock;

-(void)downloadRequest: (NSURLRequest * _Nonnull)request
         responseBlock: (DictionaryBlock)responseBlock
            errorBlock: (ErrorBlock)errorBlock;

@end



#endif /* NWBase_Protected_h */

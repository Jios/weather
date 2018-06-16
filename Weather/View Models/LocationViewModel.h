//
//  LocationViewModel.h
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
#import "SelfMacros.h"
#import "Dispatch.h"



@interface LocationViewModel : NSObject

@property (nonatomic, assign) BOOL isSearching;


-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock;

-(void)requestDeviceLocation;
-(void)fetchLocationsByName: (NSString *)name;


-(NSInteger)numberOfLocations;

-(NSString *)locationNameAtIndex: (NSInteger)index;
-(NSString *)locationIDAtIndex: (NSInteger)index;
-(NSString *)locationTypeAtIndex: (NSInteger)index;


@end

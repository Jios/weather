//
//  UIImageView+NWHttps.m
//  Weather
//
//  Created by Jian on 6/15/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "UIImageView+NWHttps.h"
#import "NWHttps.h"
#import "Keys.h"

#import <objc/runtime.h>



@interface UIImageView ()

@property (nonatomic, strong) NSURL   *url;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, strong) UIActivityIndicatorView *actIndicator;

@end



@implementation UIImageView (NWHttps)

// MARK: - # ＜Associated Objects＞

// MARK: # getters

-(NSURL *)url
{
    return objc_getAssociatedObject(self, @selector(url));
}

-(UIImage *)placeholder
{
    return objc_getAssociatedObject(self, @selector(placeholder));
}

-(UIActivityIndicatorView *)actIndicator
{
    return objc_getAssociatedObject(self, @selector(actIndicator));
}


// MARK: # setters

-(void)setUrl:(NSURL *)object
{
    objc_setAssociatedObject(self, @selector(url), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setPlaceholder: (UIImage *)object
{
    objc_setAssociatedObject(self, @selector(placeholder), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setActIndicator:(UIActivityIndicatorView *)object
{
    objc_setAssociatedObject(self, @selector(actIndicator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// MARK: - # public

-(void)setImageURL: (NSURL *)url
   withPlaceholder: (UIImage *)placeholder
{
    self.url         = url;
    self.placeholder = placeholder;
    self.image       = self.placeholder;
    
    if (!self.actIndicator)
    {
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [self.actIndicator startAnimating];
        self.actIndicator.center = CGPointMake(CGRectGetWidth(self.frame)  * 0.5,
                                               CGRectGetHeight(self.frame) * 0.5);
        
        [self addSubview: self.actIndicator];
    }
    else if (self.actIndicator.hidden)
    {
        self.actIndicator.hidden = NO;
    }
    
    weakify(self);
    
    [UIImageView setImageURL: url
                  imageBlock: ^(UIImage *image, NSURL *responseURL) {
                      
                      strongify(self);
                      
                      if ([self.url.absoluteString isEqualToString: responseURL.absoluteString])
                      {
                          self.actIndicator.hidden = YES;
                          self.image = image;
                      }
                  }
                  errorBlock: ^(NSError * _Nonnull error) {
                      
                      self.actIndicator.hidden = YES;
                  }];
}

+(void)setImageURL: (NSURL *)url
        imageBlock: (ImageBlock)imageBlock
        errorBlock: (ErrorBlock)errorBlock
{
    [NWHttps downloadURL: url
           responseBlock: ^(NSDictionary *response) {
               
               NSURL *responseURL = response[kResponseURL];
               
               [Dispatch dispatchAsyncToGlobalQueue: ^{
                   
                   NSData  *data  = response[kData];
                   UIImage *image = [UIImage imageWithData: data];
                   
                   if (!image)
                   {
                       NSDictionary *dictUserInfo = @{NSLocalizedDescriptionKey: @"Image data error."};
                       NSError *error = [[NSError alloc] initWithDomain: @"com.weather.image"
                                                                   code: -1
                                                               userInfo: dictUserInfo];
                       
                       errorBlock(error);
                   }
                   else if (image && imageBlock)
                   {
                       [Dispatch dispatchAsyncToMainQueue: ^{
                           
                           imageBlock(image, responseURL);
                       }];
                   }
               }];
           }
              errorBlock: errorBlock];
}


@end

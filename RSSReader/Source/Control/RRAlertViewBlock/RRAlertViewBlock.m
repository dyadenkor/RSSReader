//
//  RRAlertViewBlock.m
//  RSSReader
//
//  Created by admin on 1/14/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAlertViewBlock.h"

@interface RRAlertViewBlock ()
@property (copy, nonatomic) void (^completion)(BOOL, NSInteger, NSString *);
@end

@implementation RRAlertViewBlock

@synthesize completion=_completion;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
          textfield:(BOOL)needTextField
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *text)) completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
   
    if (needTextField)
    {
        [self setAlertViewStyle:UIAlertViewStylePlainTextInput];
    }
    
    if (self) {
        _completion = completion;
        
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.completion(buttonIndex==self.cancelButtonIndex, buttonIndex, [[alertView textFieldAtIndex:0] text]);
}

@end
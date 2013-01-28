//
//  RRAlertViewBlock.h
//  RSSReader
//
//  Created by admin on 1/14/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRAlertViewBlock : UIAlertView <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
          textfield:(UITextField *)textField
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *text))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

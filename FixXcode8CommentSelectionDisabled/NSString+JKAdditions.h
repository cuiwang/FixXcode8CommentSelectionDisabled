//
//  NSString+JKAdditions.h
//  JKBlockCommenter
//
//  Created by Johnykutty on 31/08/14.
//  Copyright (c) 2014 Johnykutty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JKAdditions)

- (NSString *)jk_commentedString;
- (NSString *)jk_commentRemovedString;
- (BOOL)jk_isAcomment;
- (NSString *)jk_commented2String;
- (NSString *)jk_commentRemoved2String;
- (BOOL)jk_isAcomment2;

@end

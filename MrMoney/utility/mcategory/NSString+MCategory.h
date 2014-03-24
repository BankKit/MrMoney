//
//  NSString+StringSizeWithFont.h
//  MrMoney
//
//  Created by xingyong on 13-12-6.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MCategory)
/**
 *  计算内容占用的大小
 *
 *  @param fontToUse 字体大小
 *
 *  @return string 的大小
 */
- (CGSize) sizeWithMyFont:(UIFont *)fontToUse;


/** Returns `YES` if a string is a valid email address, otherwise `NO`.
 @return True if the string is formatted properly as an email address.
 */
- (BOOL) isEmail;

/** Returns a `NSString` that is URL friendly.
 @return A URL encoded string.
 */
- (NSString*) URLEncode;

/** Returns a `NSString` that properly replaces HTML specific character sequences.
 @return An escaped HTML string.
 */
- (NSString *) escapeHTML;

/** Returns a `NSString` that properly formats text for HTML.
 @return An unescaped HTML string.
 */
- (NSString *) unescapeHTML;

/** Returns a `NSString` that removes HTML elements.
 @return Returns a string without the HTML elements.
 */
- (NSString*) stringByRemovingHTML;

/** Returns an MD5 string of from the given `NSString`.
 @return A MD5 string.
 */
- (NSString *) md5sum;

/** Returns `YES` is a string has the substring, otherwise `NO`.
 @param substring The substring.
 @return `YES` if the substring is contained in the string, otherwise `NO`.
 */
- (BOOL) hasString:(NSString*)substring;

 
- (NSString *)sha1;
- (NSString *)summarizeString:(NSInteger)length;
- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;
+ (NSString *)uuid;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;


+ (NSString *)getBundlePathForFile:(NSString *)fileName;
+ (NSString *)getDocumentsDirectoryForFile:(NSString *)fileName;
+ (NSString *)getLibraryDirectoryForFile:(NSString *)fileName;
+ (NSString *)getCacheDirectoryForFile:(NSString *)fileName;

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

@end

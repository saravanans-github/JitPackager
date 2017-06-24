//
//  NSData+FastHex.h
//  Pods
//
//  Created by Jonathon Mah on 2015-05-13.
//  Updated to V2 by Saravanan on 2017-06-24.
//
//

#import <Foundation/Foundation.h>

#ifndef NSData_FastHex_h
#define NSData_FastHex_h

@interface NSData (FastHexV2)

#pragma mark - String Conversion

/** Returns an NSData instance constructed from the hex characters of the passed string.
 * A convenience method for \p -initWithHexString:ignoreOtherCharacters: with the value
 * YES for \p ignoreOtherCharacters . */
+ (nullable instancetype)dataWithHexString:(NSString *_Nonnull)hexString;
+ (nullable instancetype)dataWithHexCString:(const char *_Nonnull)hexString;

/** Initializes the NSData instance with data from the hex characters of the passed string.
 *
 * \param hexString A string containing ASCII hexadecimal characters (uppercase and lowercase accepted).
 * \param ignoreOtherCharacters If YES, skips non-hexadecimal characters, and trailing characters.
 *  If NO, non-hexadecimal or trailing characters will abort parsing and this method will return nil.
 *
 * \return the initialized data instance, or nil if \p ignoreOtherCharacters is NO and \p hexString
 * contains a non-hex or trailing character. If \p hexString is the empty string, returns an empty
 * (non-nil) NSData instance. */
- (nullable instancetype)initWithHexString:(NSString *_Nonnull)hexString ignoreOtherCharacters:(BOOL)ignoreOtherCharacters;
- (nullable instancetype)initWithHexCString:(const char *_Nonnull)hexString ignoreOtherCharacters:(BOOL)ignoreOtherCharacters;

- (nullable NSString *)hexStringRepresentationUppercase:(BOOL)uppercase;

@end

#endif /* NSData_FastHex_h */

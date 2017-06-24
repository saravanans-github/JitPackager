//
//  Encryptor.h
//  JitPackager
//
//  Created by Saravanan on 6/24/17.
//  Copyright © 2017 Saravanan. All rights reserved.
//

#ifndef Encryptor_h
#define Encryptor_h

#import <Foundation/Foundation.h>

@interface Encryptor : NSObject

+ (NSData*) encryptData:(NSData*)data withKey:(const char*)key andIv:(const char*)iv;

@end


#endif /* Encryptor_h */


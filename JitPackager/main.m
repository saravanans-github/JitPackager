//
//  main.m
//  JitPackager
//
//  Created by Saravanan on 6/24/17.
//  Copyright © 2017 Saravanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Encryptor.h"
#import "NSData+FastHex.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        const char *key = "9e1072262511871d6d4a5f9a36a7362f";
        const char *iv = "8ef6bc1ce8edd1d81d9553d34e141cce";
                
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding]];
        
        NSData *eData = [Encryptor encryptData:data withMethod:kCCModeCTR withKey:key andIv:iv];
//        NSData *eData = [Encryptor encryptData:data withKey:key andIv:iv];
        
        NSLog(@"Encrypted: %@", [eData hexStringRepresentationUppercase:NO]);

    }
    return 0;
}

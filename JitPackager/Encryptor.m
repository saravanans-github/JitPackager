//
//  Encryptor.m
//  JitPackager
//
//  Created by Saravanan on 6/24/17.
//  Copyright © 2017 Saravanan. All rights reserved.
//

#import "Encryptor.h"
#import "NSData+FastHex.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Encryptor

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

+ (NSData*) encryptData:(NSData*)data withKey:(const char*)key andIv:(const char*)iv {
    size_t outLength;
    
    // AES 128 bit encryption requires data to be in blocks of 16 bytes. So pad the data with 0x0.
    int noOfPaddingBytes = 16 - data.length%16;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + noOfPaddingBytes];
    
    // Get the key & iv in NSData (bytes)
    NSData *keyInData = [NSData dataWithHexCString:key];
    NSData *ivInData = [NSData dataWithHexCString:iv];

    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     keyInData.bytes, // key
                     keyInData.length, // keylength
                     ivInData.bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        NSLog(@"%@", [cipherData hexStringRepresentationUppercase:NO]);
        return cipherData;
    }
    else {
        return nil;
    }
}

@end

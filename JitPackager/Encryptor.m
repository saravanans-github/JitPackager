//
//  Encryptor.m
//  JitPackager
//
//  Created by Saravanan on 6/24/17.
//  Copyright © 2017 Saravanan. All rights reserved.
//

#import "Encryptor.h"
#import "NSData+FastHex.h"

@implementation Encryptor

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

+ (NSData *) encryptData:(NSData*)data withKey:(const char*)key andIv:(const char*)iv {
    size_t outLength;

    // AES 128 bit encryption requires data to be in blocks of 16 bytes. So pad the data with 0x0.
    int noOfPaddingBytes = 16 - data.length%16;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + noOfPaddingBytes];

    
    // Get the key & iv in NSData (bytes)
    NSData *keyInData = [NSData dataWithHexCString:key];
    NSData *ivInData = [NSData dataWithHexCString:iv];

    // Encrypt the data
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
    
    // TODO: DO ERROR HANDLING
    if (result == kCCSuccess) {
        return cipherData;
    }
    else {
        return nil;
    }
}

+ (NSData *) encryptData:(NSData*)data withMethod:(CCMode)mode withKey:(const char*)key andIv:(const char*)iv {
    // Get the key & iv in NSData (bytes)
    NSData *keyInData = [NSData dataWithHexCString:key];
    NSData *ivInData = [NSData dataWithHexCString:iv];

    // Init cryptor
    CCCryptorRef cryptor = NULL;
    
    // AES 128 bit encryption requires data to be in blocks of 16 bytes. So pad the data with an addition 16 bytes.
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];

    //Create Cryptor
    CCCryptorStatus  create = CCCryptorCreateWithMode(kCCEncrypt,
                                                      mode, // kCCModeCBC or kCCModeCTR
                                                      kCCAlgorithmAES,
                                                      ccPKCS7Padding,
                                                      ivInData.bytes, // can be NULL, because null is full of zeros
                                                      keyInData.bytes,
                                                      keyInData.length,
                                                      NULL,
                                                      0,
                                                      0,
                                                      kCCModeOptionCTR_BE,
                                                      &cryptor);
    
    if (create == kCCSuccess)
    {
        //alloc number of bytes written to data Out
        size_t outLength;
        
        //Update Cryptor
        CCCryptorStatus  update = CCCryptorUpdate(cryptor,
                                                  data.bytes,
                                                  data.length,
                                                  cipherData.mutableBytes,
                                                  cipherData.length,
                                                  &outLength);
        if (update == kCCSuccess)
        {
            // if the length is not 0, cut data out with nedded length
            // this is important because for CBC mode, there is no Update required
            if(outLength != 0)
                cipherData.length = outLength;
            
            //Final Cryptor
            CCCryptorStatus final = CCCryptorFinal(cryptor, //CCCryptorRef cryptorRef,
                                                   cipherData.mutableBytes, //void *dataOut,
                                                   cipherData.length, // size_t dataOutAvailable,
                                                   &outLength); // size_t *dataOutMoved)
            
            if (final == kCCSuccess)
            {
                //Release Cryptor
                //CCCryptorStatus release =
                CCCryptorRelease(cryptor ); //CCCryptorRef cryptorRef
                
                // if the length is not 0, cut data out with nedded length
                if(outLength != 0)
                    cipherData.length = outLength;
                
                return cipherData;
            }
            else
            {
                // TODO: THROW ERROR
                return nil;
            }
        }
    }
    else
    {
        // TODO: THROW ERROR
        
    }
    
    return nil;
}

@end

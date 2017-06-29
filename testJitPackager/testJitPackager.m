//
//  testJitPackager.m
//  testJitPackager
//
//  Created by Saravanan on 6/24/17.
//  Copyright © 2017 Saravanan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../JitPackager/Encryptor.h"
#import "NSData+FastHex.h"

@interface testJitPackager : XCTestCase

@end

@implementation testJitPackager

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSData *)doAES128CBCEncryption {
    // Use this hardcoded key and iv pair
    const char *key = "9e1072262511871d6d4a5f9a36a7362f";
    const char *iv = "8ef6bc1ce8edd1d81d9553d34e141cce";
    
    void *data = "Hello World!";
    
    return [Encryptor encryptData:[NSData dataWithBytes:data length:sizeof(data)] withKey:key andIv:iv];
}

- (void)test_AES128CBCEncryption {
    // Use this hardcoded key and iv pair
    const NSString *encryptedHex = @"d9d1cd1aaf057c9cbf0f8bce1e46825e";
        
    NSData *encryptedData = [self doAES128CBCEncryption];
    XCTAssertEqualObjects([encryptedData hexStringRepresentationUppercase:NO], encryptedHex, @"Success");
}

- (void)testPerformance_AES128CBCEncryption {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self doAES128CBCEncryption];
    }];
}

@end

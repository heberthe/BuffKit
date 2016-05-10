//
//  CryptoBuff.m
//  ABCryptoDemo
//
//  Created by BoWang on 16/5/3.
//  Copyright © 2016年 BoWang. All rights reserved.
//

#import "CryptoBuff.h"
#import <CommonCrypto/CommonCrypto.h>
#pragma mark - NSData extension
#pragma mark NSData functions

//MD5
NSData* _buffMD5FromData(NSData *source)
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(source.bytes, (CC_LONG)source.length, result);
    NSData *md5=[[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    NSData *data;
    [data bytes];
    return md5;
    
}
//SHA1
NSData *_buffSHA1FromData(NSData *source)
{
    uint8_t result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(source.bytes, (CC_LONG)source.length, result);
    NSData *sha1 = [[NSData alloc] initWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
    return sha1;
}
//SHA224
NSData *_buffSHA224FromData(NSData *source)
{
    uint8_t result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(source.bytes, (CC_LONG)source.length, result);
    NSData *sha224 = [[NSData alloc] initWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
    return sha224;
}
NSData *_buffSHA256FromData(NSData *source)
{
    uint8_t result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(source.bytes, (CC_LONG)source.length, result);
    NSData *sha256 = [[NSData alloc] initWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
    return sha256;
}
NSData *_buffSHA384FromData(NSData *source)
{
    uint8_t result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(source.bytes, (CC_LONG)source.length, result);
    NSData *sha384 = [[NSData alloc] initWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
    return sha384;
}
NSData *_buffSHA512FromData(NSData *source)
{
    uint8_t result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(source.bytes, (CC_LONG)source.length, result);
    NSData *sha512 = [[NSData alloc] initWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
    return sha512;
}
NSData *_buffCryptoFromData(CCOperation op,BuffCryptoMode mode,CCAlgorithm al,BOOL isPadding,NSData *source,NSString *iv,NSString *key,int keySize)
{
    CCCryptorRef cryptor;
    int padding=isPadding?1:0;
    NSData *ivData=[iv dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData=[key dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus result = CCCryptorCreateWithMode(op,
                                                     mode,
                                                     al,
                                                     padding,
                                                     [ivData bytes],
                                                     [keyData bytes],
                                                     keySize,
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    size_t bufferLength = CCCryptorGetOutputLength(cryptor, [source length], false);
    size_t outLength;
    NSMutableData *outData=[[NSMutableData alloc]initWithLength:bufferLength];
    if (result==kCCSuccess) {
        result = CCCryptorUpdate(cryptor,
                                 [source bytes],
                                 [source length],
                                 [outData mutableBytes],
                                 bufferLength,
                                 &outLength);
        if (result==kCCSuccess) {
            if (isPadding) {
                bufferLength = CCCryptorGetOutputLength(cryptor, [source length], true);
                result = CCCryptorFinal(cryptor,
                                        [outData mutableBytes],
                                        bufferLength,
                                        &outLength);
                if (result==kCCSuccess) {
                    result = CCCryptorRelease(cryptor);
                }
                else
                {
                    outData=nil;
                }
            }
        }
        else
        {
            outData=nil;
        }
    }
    else
    {
        outData=nil;
    }
    return outData;
}

NSData *_buffAESEncodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCEncrypt, mode, kCCAlgorithmAES, isPadding, source, iv, key, kCCKeySizeAES256);
}
NSData *_buffAESDecodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCDecrypt, mode, kCCAlgorithmAES, isPadding, source, iv, key, kCCKeySizeAES256);
}
NSData *_buffDESEncodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCEncrypt, mode, kCCAlgorithmDES, isPadding, source, iv, key, kCCKeySizeDES);
}
NSData *_buffDESDecodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCDecrypt, mode, kCCAlgorithmDES, isPadding, source, iv, key, kCCKeySizeDES);
}
NSData *_buff3DESEncodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCEncrypt, mode, kCCAlgorithm3DES, isPadding, source, iv, key, kCCKeySize3DES);
}
NSData *_buff3DESDecodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key)
{
    return _buffCryptoFromData(kCCDecrypt, mode, kCCAlgorithm3DES, isPadding, source, iv, key, kCCKeySize3DES);
}
NSData *_buffBlowFishEncodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key,int keySize)
{
    return _buffCryptoFromData(kCCEncrypt, mode, kCCAlgorithmBlowfish, isPadding, source, iv, key,keySize);
}
NSData *_buffBlowFishDecodeFromData(NSData *source,BuffCryptoMode mode,BOOL isPadding,NSString *iv,NSString *key,int keySize)
{
    return _buffCryptoFromData(kCCDecrypt, mode, kCCAlgorithmBlowfish, isPadding, source, iv, key, keySize);
}
@implementation NSData (CryptoBuff)
#pragma mark MD5,SHA1,SHA2,

-(NSData *)bfCryptoMD5
{
    return _buffMD5FromData(self);
}
-(void)bfCryptoMD5Async:(void (^)(NSData *))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffMD5FromData(self));
    });
}
-(NSData *)bfCryptoSHA1
{
    return _buffSHA1FromData(self);
}
-(void)bfCryptoSHA1Async:(void (^)(NSData *))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA1FromData(self));
    });
}
-(NSData *)bfCryptoSHA224
{
    return _buffSHA224FromData(self);
}
-(void)bfCryptoSHA224Async:(void (^)(NSData *))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA224FromData(self));
    });
}
-(NSData *)bfCryptoSHA256
{
    return _buffSHA256FromData(self);
}
-(void)bfCryptoSHA256Async:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA256FromData(self));
    });
}
-(NSData *)bfCryptoSHA384
{
    return _buffSHA384FromData(self);
}
-(void)bfCryptoSHA384Async:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA384FromData(self));
    });
}
-(NSData *)bfCryptoSHA512
{
    return _buffSHA512FromData(self);
}
-(void)bfCryptoSHA512Async:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA512FromData(self));
    });
}
#pragma mark AES


-(void)bfCryptoAESEncodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffAESEncodeFromData(self, mode, isPadding, iv, key));
    });
}
-(void)bfCryptoAESDecodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffAESEncodeFromData(self, mode, isPadding, iv, key));
    });
}
#pragma mark DES


-(void)bfCryptoDESEncodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffDESEncodeFromData(self, mode, isPadding, iv, key));
    });
}
-(void)bfCryptoDESDecodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffDESDecodeFromData(self, mode, isPadding, iv, key));
    });
}
#pragma mark 3DES
-(void)bfCrypto3DESEncodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buff3DESEncodeFromData(self, mode, isPadding, iv, key));
    });
}

-(void)bfCrypto3DESDecodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buff3DESDecodeFromData(self, mode, isPadding, iv, key));
    });

}
#pragma mark BlowFish

-(void)bfCryptoBlowFishEncodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key keySize:(int)keySize  completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffBlowFishEncodeFromData(self, mode, isPadding, iv, key,keySize));
    });
}
-(void)bfCryptoBlowFishDecodeWithMode:(BuffCryptoMode )mode padding:(BOOL)isPadding iv:(NSString *)iv key:(NSString *)key keySize:(int)keySize  completion:(void(^)(NSData *cryptoData))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffBlowFishDecodeFromData(self, mode, isPadding, iv, key,keySize));
    });
}

@end

#pragma mark - NSString extension
NSString* _buffMD5FromString(NSString *source)
{
    const char *cStr = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5=[NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3],
                   result[4], result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11],
                   result[12], result[13], result[14], result[15]
                   ];
    return md5;
}
NSString* _buffSHA1FromString(NSString *source)
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha1 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [sha1 appendFormat:@"%02x", digest[i]];
    }
    return sha1;
}

NSString* _buffSHA224FromString(NSString *source)
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha224 = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [sha224 appendFormat:@"%02x", digest[i]];
    }
    return sha224;
}
NSString* _buffSHA256FromString(NSString *source)
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha256 = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [sha256 appendFormat:@"%02x", digest[i]];
    }
    return sha256;
}
NSString* _buffSHA384FromString(NSString *source)
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha384 = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [sha384 appendFormat:@"%02x", digest[i]];
    }
    return sha384;
}
NSString* _buffSHA512FromString(NSString *source)
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha512 = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [sha512 appendFormat:@"%02x", digest[i]];
    }
    return sha512;
}
@implementation NSString (CryptoBuff)
#pragma mark MD5,SHA1,SHA2,
-(NSString *)bfCryptoMD5
{
    return _buffMD5FromString(self);
}
-(void)bfCryptoMD5Async:(void (^)(NSString *))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffMD5FromString(self));
    });
}
-(NSString *)bfCryptoSHA1
{
    return _buffSHA1FromString(self);
}
-(void)bfCryptoSHA1Async:(void (^)(NSString *))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA1FromString(self));
    });
}
-(NSString *)bfCryptoSHA224
{
    return _buffSHA224FromString(self);

}
-(void)bfCryptoSHA224Async:(void(^)(NSString *cryptoString))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA224FromString(self));
    });
}
-(NSString *)bfCryptoSHA256
{
    return _buffSHA256FromString(self);
}
-(void)bfCryptoSHA256Async:(void(^)(NSString *cryptoString))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA256FromString(self));
    });
}
-(NSString *)bfCryptoSHA384
{
    return _buffSHA384FromString(self);
}
-(void)bfCryptoSHA384Async:(void(^)(NSString *cryptoString))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA384FromString(self));
    });
}
-(NSString *)bfCryptoSHA512
{
    return _buffSHA512FromString(self);
}
-(void)bfCryptoSHA512Async:(void(^)(NSString *cryptoString))cryptoBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cryptoBlock(_buffSHA512FromString(self));
    });
}
@end


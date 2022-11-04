/*
    File: JailbreakiOS.h
    Function: crifan's common iOS jailbreak functions
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/iOS/JailbreakiOS.h
    Updated: 20220303_1402
*/

#import <Foundation/Foundation.h>

/*==============================================================================
 Define
==============================================================================*/
//#define FILE_PREFIX = "file://"

/*==============================================================================
 Const
==============================================================================*/
//const char* _Nonnull FILE_PREFIX = "file://";
extern const char* _Nonnull FILE_PREFIX;

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakiOS : NSObject

/*==============================================================================
 Jailbreak Path
==============================================================================*/

+ (NSArray *) jbPathList;
+ (BOOL) isJailbreakPath_iOS: (NSString*)curPath;

+ (NSArray *) jbDylibList;
+ (BOOL) isJbDylib: (NSString*)curPath;

/*==============================================================================
 Phone Type
==============================================================================*/

//+ (NSDictionary*) phoneTypeDict;
//+ (NSMutableArray *) phoneTypeList;

+ (NSArray *) phoneTypeList;

+ (NSString *) getPhoneName:(NSString *)phoneId;


@end

NS_ASSUME_NONNULL_END

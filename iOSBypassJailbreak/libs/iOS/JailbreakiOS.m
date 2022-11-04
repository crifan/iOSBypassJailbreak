/*
    File: JailbreakiOS.m
    Function: crifan's common iOS jailbreak functions
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/iOS/JailbreakiOS.m
    Updated: 20220308_1002
*/

#import "JailbreakiOS.h"
#import "JailbreakPathList.h"
#import "CrifanLibiOS.h"

const char* _Nonnull FILE_PREFIX = "file://";

@implementation JailbreakiOS

/*==============================================================================
 Jailbreak Path
==============================================================================*/

+ (NSArray *) jbPathList
{
    NSMutableArray * jbPathArr = [NSMutableArray array];

    const char** jailbreakPathList = getJailbreakPathList();
//    char** jailbreakPathList = getJailbreakPathList();
    
    if (jailbreakPathList) {
        //    //for debug
        //    NSArray* additionalTestPathList = @[
        //        // 20211112_0915 test abnormal path
        //        @"/Library/dpkg",
        //        @"/./Library/../Library/dpkg/",
        //        @"/Applications/Cydia.app/../Cydia.app",
        //        @"/Applications/Cydia.app/Info.plist",
        ////        @"/var/root/iOSOpenDevPackages/", // not jb file, just for test
        //        @"/var/NotExisted",
        //        // for EPERM = Operation not permitted
        //        @"/./bin/../bin/./bash",
        //        @"/private/./etc/ssh/../ssh/sshd_config",
        //        @"/usr/././../usr/bin/ssh-keyscan",
        //    ];
        //
        //    for (NSString* curAdditionalTestPach in additionalTestPathList){
        //        [jbPathArr addObject: curAdditionalTestPach];
        //    }

        jbPathArr = [CrifanLibiOS strListToNSArray:jailbreakPathList listCount:jailbreakPathListLen];

        // final: free char** self
        free(jailbreakPathList);
    }

    return jbPathArr;
}

+ (BOOL) isJailbreakPath_iOS: (NSString*)curPath{
    BOOL isJbPath = FALSE;

    if (NULL != curPath){
        const char* curPathStr = [curPath UTF8String];
//        isJbPath = isJailbreakPath(curPathStr);

//        const char* pathNoFilePrefix = removeHead(curPathStr, FILE_PREFIX);
        char* toFreePtr = NULL;
        const char* pathNoFilePrefix = removeHead(curPathStr, FILE_PREFIX, &toFreePtr);

        isJbPath = isJailbreakPath(pathNoFilePrefix);

//        free(pathNoFilePrefix);
//        if (NULL != toFreePtr) {
//        NSLog(@"Now to free: toFreePtr=%p", toFreePtr);
        free(toFreePtr);
//        }
    }
//    NSLog(@"curPath=%@ -> isJbPath=%d", curPath, isJbPath);
    return isJbPath;
}

+ (NSArray *) jbDylibList
{
    return [CrifanLibiOS strListToNSArray:jailbreakPathList_Dylib listCount:jailbreakPathListLen_Dylib];
}

+ (BOOL) isJbDylib: (NSString*)curPath{
    BOOL isJbLib = FALSE;
    if([JailbreakiOS.jbDylibList containsObject:curPath]){
        isJbLib = TRUE;
    }
    return isJbLib;
}

/*==============================================================================
 Phone Type
==============================================================================*/

+ (NSArray *) phoneTypeList
{
    // https://stackoverflow.com/questions/18414032/how-to-identify-a-hw-machine-identifier-reliable
    // https://www.theiphonewiki.com/wiki/Models
    return @[
        @[@"iPhone7,2", @"iPhone 6"],
        @[@"iPhone7,1", @"iPhone 6 Plus"],
        // added by Crifan Li, 20211014
        @[@"iPhone8,1", @"iPhone 6s"],
        @[@"iPhone8,2", @"iPhone 6s Plus"],
        @[@"iPhone8,4", @"iPhone SE 一代"], //(1st generation)
        @[@"iPhone9,1", @"iPhone 7"],
        @[@"iPhone9,3", @"iPhone 7 美版"],
        @[@"iPhone9,2", @"iPhone 7 Plus"],
        @[@"iPhone9,4", @"iPhone 7 Plus 美版"],
        @[@"iPhone10,1", @"iPhone 8"],
        @[@"iPhone10,4", @"iPhone 8 美版"],
        @[@"iPhone10,2", @"iPhone 8 Plus"],
        @[@"iPhone10,5", @"iPhone 8 Plus 美版"],
        @[@"iPhone10,3", @"iPhone X"],
        @[@"iPhone10,6", @"iPhone X 美版"],
        @[@"iPhone11,8", @"iPhone XR"],
        @[@"iPhone11,2", @"iPhone XS"],
        @[@"iPhone11,4", @"iPhone XS Max"],
        @[@"iPhone11,6", @"iPhone XS Max 美版"],
        @[@"iPhone12,1", @"iPhone 11"],
        @[@"iPhone12,3", @"iPhone 11 Pro"],
        @[@"iPhone12,5", @"iPhone 11 Pro Max"],
        @[@"iPhone12,8", @"iPhone SE 二代"], //(2nd generation)
        @[@"iPhone13,1", @"iPhone 12 mini"],
        @[@"iPhone13,2", @"iPhone 12"],
        @[@"iPhone13,3", @"iPhone 12 Pro"],
        @[@"iPhone13,4", @"iPhone 12 Pro Max"],
        @[@"iPhone14,4", @"iPhone 13 mini"],
        @[@"iPhone14,5", @"iPhone 13"],
        @[@"iPhone14,2", @"iPhone 13 Pro"],
        @[@"iPhone14,3", @"iPhone 13 Pro Max"],
    ];
}

//+ (NSDictionary *) phoneTypeDict
//{
//    // https://stackoverflow.com/questions/18414032/how-to-identify-a-hw-machine-identifier-reliable
//    // https://www.theiphonewiki.com/wiki/Models
//    return @{
//        /*
//            Identifier : Generation(Name)
//         */
//        //iPhone.
////        @"iPhone1,1" : @"iPhone 2G",
////        @"iPhone1,2" : @"iPhone 3G",
////        @"iPhone2,1" : @"iPhone 3GS",
////        @"iPhone3,1" : @"iPhone 4",
////        @"iPhone3,2" : @"iPhone 4",
////        @"iPhone3,3" : @"iPhone 4",
////        @"iPhone4,1" : @"iPhone 4S",
////        @"iPhone5,1" : @"iPhone 5",
////        @"iPhone5,2" : @"iPhone 5",
////        @"iPhone5,3" : @"iPhone 5C",
////        @"iPhone5,4" : @"iPhone 5C",
////        @"iPhone6,1" : @"iPhone 5S",
////        @"iPhone6,2" : @"iPhone 5S",
//        @"iPhone7,2" : @"iPhone 6",
//        @"iPhone7,1" : @"iPhone 6 Plus",
//        // added by Crifan Li, 20211014
//        @"iPhone8,1" : @"iPhone 6s",
//        @"iPhone8,2" : @"iPhone 6s Plus",
//        @"iPhone8,4" : @"iPhone SE 一代", //(1st generation)
//        @"iPhone9,1" : @"iPhone 7",
//        @"iPhone9,3" : @"iPhone 7 美版",
//        @"iPhone9,2" : @"iPhone 7 Plus",
//        @"iPhone9,4" : @"iPhone 7 Plus 美版",
//        @"iPhone10,1" : @"iPhone 8",
//        @"iPhone10,4" : @"iPhone 8 美版",
//        @"iPhone10,2" : @"iPhone 8 Plus",
//        @"iPhone10,5" : @"iPhone 8 Plus 美版",
//        @"iPhone10,3" : @"iPhone X",
//        @"iPhone10,6" : @"iPhone X 美版",
//        @"iPhone11,8" : @"iPhone XR",
//        @"iPhone11,2" : @"iPhone XS",
//        @"iPhone11,4" : @"iPhone XS Max",
//        @"iPhone11,6" : @"iPhone XS Max 美版",
//        @"iPhone12,1" : @"iPhone 11",
//        @"iPhone12,3" : @"iPhone 11 Pro",
//        @"iPhone12,5" : @"iPhone 11 Pro Max",
//        @"iPhone12,8" : @"iPhone SE 二代", //(2nd generation)
//        @"iPhone13,1" : @"iPhone 12 mini",
//        @"iPhone13,2" : @"iPhone 12",
//        @"iPhone13,3" : @"iPhone 12 Pro",
//        @"iPhone13,4" : @"iPhone 12 Pro Max",
//        @"iPhone14,4" : @"iPhone 13 mini",
//        @"iPhone14,5" : @"iPhone 13",
//        @"iPhone14,2" : @"iPhone 13 Pro",
//        @"iPhone14,3" : @"iPhone 13 Pro Max",
//    };
//}


//+ (NSMutableArray *) phoneTypeList{
//    NSMutableArray * phoneTypeArr = [NSMutableArray array];
//    for (NSString* curPhoneId in [self phoneTypeDict]){
//        NSString* curPhoneName = self.phoneTypeDict[curPhoneId];
//        NSLog(@"phone id %@ -> phone name %@", curPhoneId, curPhoneName);
//
//        NSMutableArray * curPhoneArry =  [NSMutableArray array];
//        [curPhoneArry addObject: curPhoneId];
//        [curPhoneArry addObject: curPhoneName];
//        NSLog(@"curPhoneArry=%@", curPhoneArry);
//
//        [phoneTypeArr addObject: curPhoneArry];
//        NSLog(@"Latest phoneTypeArr=%@", phoneTypeArr);
//    }
//
//    return phoneTypeArr;
//}


+ (NSString *) getPhoneName:(NSString *)phoneId {
//    NSString * phoneName = [[self phoneTypeDict] objectForKey:phoneId];
    NSString * phoneName = NULL;

//    for (int i=0; i < [self.phoneTypeList count]; i++){
//        NSArray* curPhoneIdNameArr = self.phoneTypeList[i];
    for (int i=0; i < [JailbreakiOS.phoneTypeList count]; i++){
        NSArray* curPhoneIdNameArr = JailbreakiOS.phoneTypeList[i];
    //        NSLog(@"[%d]: %@", i, curPhoneIdNameArr);
        NSString *curPhoneId = curPhoneIdNameArr[0];
        NSString *curPhoneName = curPhoneIdNameArr[1];
        if ([curPhoneId isEqualToString:phoneId]){
            NSLog(@"Found same phoneId: %@s", phoneId);
            phoneName = curPhoneName;
            break;
        }
    }
    
    NSLog(@"phone: id=%@s -> name=%@s", phoneId, phoneName);
    return phoneName;
}

@end

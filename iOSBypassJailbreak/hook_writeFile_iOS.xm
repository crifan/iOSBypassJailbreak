/*
 File: hook_writeFile_iOS.xm
 Function: iOS tweak to hook write file of iOS level related function
 Author: Crifan Li
*/

#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"

bool shouldHookWritePath(const char* path);
bool shouldHookWritePath_NSString(NSString* pathNs);
bool shouldHookWritePath_NSURL(NSURL* url);

/*==============================================================================
 Common Functions
==============================================================================*/

// /private/testWriteToFile.txt -> true
// /private/var/mobile/Containers/Data/Application/EEFACEA4-2ADB-4D25-9DB4-B5D643EA8943/Documents/bd.turing/ -> false
bool shouldHookWritePath(const char* path){
    const char* Path_Private = "/private/";
    const char* Path_FilePrivate = "file:///private/";

    bool shouldHook = false;

    char* purePath = toPurePath(path);
    iosLogDebug("path=%{public}s -> purePath=%s", path, purePath);
    bool isStartWithPrivate = strStartsWith(purePath, Path_Private);
    bool isStartWithFilePrivate = strStartsWith(purePath, Path_FilePrivate);
    iosLogDebug("isStartWithPrivate=%s, isStartWithFilePrivate=%s",boolToStr(isStartWithPrivate), boolToStr(isStartWithFilePrivate));

    if (isStartWithPrivate || isStartWithFilePrivate){
        // is /private/ path
        char* pathNoPrivateHead = NULL;
//        int origMallocStrPointerMovePrevLen = 0;
        char* toFreeRemoveHeadPathPrivate = NULL;
        char* toFreeRemoveHeadPathFilePrivate = NULL;

        if(isStartWithPrivate){
//            pathNoPrivateHead = removeHead(purePath, Path_Private);
//            origMallocStrPointerMovePrevLen = strlen(Path_Private);
            pathNoPrivateHead = removeHead(purePath, Path_Private, &toFreeRemoveHeadPathPrivate);
        }

        if(isStartWithFilePrivate){
//            pathNoPrivateHead = removeHead(purePath, Path_FilePrivate);
//            origMallocStrPointerMovePrevLen = strlen(Path_FilePrivate);
            pathNoPrivateHead = removeHead(purePath, Path_FilePrivate, &toFreeRemoveHeadPathFilePrivate);
        }
//        iosLogDebug("purePath=%s -> pathNoPrivateHead=%s, origMallocStrPointerMovePrevLen=%d", purePath, pathNoPrivateHead, origMallocStrPointerMovePrevLen);
        iosLogDebug("purePath=%s -> pathNoPrivateHead=%s, toFreeRemoveHeadPathPrivate=%p, toFreeRemoveHeadPathFilePrivate=%p", purePath, pathNoPrivateHead, toFreeRemoveHeadPathPrivate, toFreeRemoveHeadPathFilePrivate);

        // testWriteToFile.txt
        // var/mobile/Containers/Data/Application/EEFACEA4-2ADB-4D25-9DB4-B5D643EA8943/Documents/xxx
        if (NULL != pathNoPrivateHead){
            char* foundSlash = strstr(pathNoPrivateHead, "/");
            iosLogDebug("foundSlash=%s", foundSlash);
            if (NULL != foundSlash){
                // var/mobile/Containers/Data/Application/EEFACEA4-2ADB-4D25-9DB4-B5D643EA8943/Documents/xxx
                shouldHook = false;
            } else {
                // testWriteToFile.txt
                shouldHook = true;
            }

//            free(pathNoPrivateHead); // will crash !!!
//            char* toFreePtr = pathNoPrivateHead - origMallocStrPointerMovePrevLen;
//            iosLogDebug("pathNoPrivateHead=%p, toFreePtr=%p", pathNoPrivateHead, toFreePtr);
//            free(toFreePtr);
            if (NULL != toFreeRemoveHeadPathPrivate){
                free(toFreeRemoveHeadPathPrivate);
                iosLogDebug("has free toFreeRemoveHeadPathPrivate=%p", toFreeRemoveHeadPathPrivate);
            }

            if (NULL != toFreeRemoveHeadPathFilePrivate){
                free(toFreeRemoveHeadPathFilePrivate);
                iosLogDebug("has free toFreeRemoveHeadPathFilePrivate=%p", toFreeRemoveHeadPathFilePrivate);
            }
        } else {
            shouldHook = false;
        }
    } else {
        // not /private/ path
        shouldHook = false;
    }

    free(purePath);

    // for debug
    if (shouldHook) {
        iosLogInfo("path=%{public}s -> shouldHook=%s", path, boolToStr(shouldHook));
        // /private/testWriteToFile.txt
    }

//    // for debug
//    shouldHook = false;

    return shouldHook;
}

bool shouldHookWritePath_NSString(NSString* pathNs){
    const char* pathStr = [pathNs UTF8String];
    BOOL shouldHook = shouldHookWritePath(pathStr);

//    // for debug
//    shouldHook = false;

    iosLogDebug("pathNs=%@ -> shouldHook=%s", pathNs, boolToStr(shouldHook));
    return shouldHook;
}

bool shouldHookWritePath_NSURL(NSURL* url){
    NSString *urlNSStr = [url absoluteString];
    const char* urlStr = [urlNSStr UTF8String];
    BOOL shouldHook = shouldHookWritePath(urlStr);

//    // for debug
//    shouldHook = false;

    iosLogDebug("url=%@ -> shouldHook=%s", url, boolToStr(shouldHook));
    return shouldHook;
}

/*==============================================================================
 Hook: NSString
==============================================================================*/

%hook NSString

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
    BOOL isWriteOk = FALSE;

    if(cfgHookEnable_writeFileiOS){
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(path, useAuxiliaryFile);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(path, useAuxiliaryFile);
        isWriteOk = %orig;
    }

    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
	return isWriteOk;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error{
    iosLogDebug("path=%@, useAuxiliaryFile=%s, enc=%ld, *error=%@", path, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error));
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(path, useAuxiliaryFile, enc, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(path, useAuxiliaryFile, enc, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s, enc=%lu, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, atomically);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, atomically);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, useAuxiliaryFile, enc, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, useAuxiliaryFile, enc, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, useAuxiliaryFile=%s, enc=%lu, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

%end

/*==============================================================================
 Hook: NSData
==============================================================================*/

%hook NSData

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, atomically);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, atomically);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

//- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)writeOptionsMask error:(NSError **)errorPtr{
- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)writeOptionsMask error:(NSError **)error{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(path, writeOptionsMask, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(path, writeOptionsMask, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%spath=%{public}@, writeOptionsMask=0x%lx, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, writeOptionsMask, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

//- (BOOL)writeToURL:(NSURL *)url options:(NSDataWritingOptions)writeOptionsMask error:(NSError **)errorPtr{
- (BOOL)writeToURL:(NSURL *)url options:(NSDataWritingOptions)writeOptionsMask error:(NSError **)error{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, writeOptionsMask, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, writeOptionsMask, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, writeOptionsMask=0x%lx, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, writeOptionsMask, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

%end

/*==============================================================================
 Hook: NSArray
==============================================================================*/

%hook NSArray

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(path, useAuxiliaryFile);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(path, useAuxiliaryFile);
        isWriteOk = %orig;
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, atomically);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, atomically);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url error:(NSError **)error{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, *error=%@ -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

%end

/*==============================================================================
 Hook: NSDictionary
==============================================================================*/

%hook NSDictionary

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(path, useAuxiliaryFile);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(path, useAuxiliaryFile);
        isWriteOk = %orig;
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url error:(NSError **)error{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, error);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, error);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, *error=%@ -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {
//            isWriteOk = %orig(url, atomically);
            isWriteOk = %orig;
        }
    } else {
//        isWriteOk = %orig(url, atomically);
        isWriteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

%end

/*==============================================================================
 Hook: NSFileManager
==============================================================================*/

%hook NSFileManager

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error {
    BOOL isDeleteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isDeleteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isDeleteOk=%s", path, boolToStr(isDeleteOk));
        } else {
//            isDeleteOk = %orig(path, error);
            isDeleteOk = %orig;
        }
    } else {
//        isDeleteOk = %orig(path, error);
        isDeleteOk = %orig;
    }
    iosLogDebug("%spath=%{public}@, *error=%@-> isDeleteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, ERROR_STR(error), boolToStr(isDeleteOk));
    return isDeleteOk;
}

//- (BOOL)removeItemAtURL:(NSURL *)URL error:(NSError **)error {
- (BOOL)removeItemAtURL:(NSURL *)url error:(NSError **)error {
    BOOL isDeleteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isDeleteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isDeleteOk=%s", url, boolToStr(isDeleteOk));
        } else {
//            isDeleteOk = %orig(url, error);
            isDeleteOk = %orig;
        }
    } else {
//        isDeleteOk = %orig(url, error);
        isDeleteOk = %orig;
    }
    iosLogDebug("%surl=%{public}@, *error=%@-> isDeleteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isDeleteOk));
    return isDeleteOk;
}

%end

/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_writeFileiOS=%s", "writeFile_iOS ctor", boolToStr(cfgHookEnable_writeFileiOS));
    }
}

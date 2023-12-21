#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_writeFile_iOS.xm"






#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"

bool shouldHookWritePath(const char* path);
bool shouldHookWritePath_NSString(NSString* pathNs);
bool shouldHookWritePath_NSURL(NSURL* url);







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
        
        char* pathNoPrivateHead = NULL;

        char* toFreeRemoveHeadPathPrivate = NULL;
        char* toFreeRemoveHeadPathFilePrivate = NULL;

        if(isStartWithPrivate){


            pathNoPrivateHead = removeHead(purePath, Path_Private, &toFreeRemoveHeadPathPrivate);
        }

        if(isStartWithFilePrivate){


            pathNoPrivateHead = removeHead(purePath, Path_FilePrivate, &toFreeRemoveHeadPathFilePrivate);
        }

        iosLogDebug("purePath=%s -> pathNoPrivateHead=%s, toFreeRemoveHeadPathPrivate=%p, toFreeRemoveHeadPathFilePrivate=%p", purePath, pathNoPrivateHead, toFreeRemoveHeadPathPrivate, toFreeRemoveHeadPathFilePrivate);

        
        
        if (NULL != pathNoPrivateHead){
            char* foundSlash = strstr(pathNoPrivateHead, "/");
            iosLogDebug("foundSlash=%s", foundSlash);
            if (NULL != foundSlash){
                
                shouldHook = false;
            } else {
                
                shouldHook = true;
            }





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
        
        shouldHook = false;
    }

    free(purePath);

    
    if (shouldHook) {
        iosLogInfo("path=%{public}s -> shouldHook=%s", path, boolToStr(shouldHook));
        
    }




    return shouldHook;
}

bool shouldHookWritePath_NSString(NSString* pathNs){
    const char* pathStr = [pathNs UTF8String];
    BOOL shouldHook = shouldHookWritePath(pathStr);




    iosLogDebug("pathNs=%@ -> shouldHook=%s", pathNs, boolToStr(shouldHook));
    return shouldHook;
}

bool shouldHookWritePath_NSURL(NSURL* url){
    NSString *urlNSStr = [url absoluteString];
    const char* urlStr = [urlNSStr UTF8String];
    BOOL shouldHook = shouldHookWritePath(urlStr);




    iosLogDebug("url=%@ -> shouldHook=%s", url, boolToStr(shouldHook));
    return shouldHook;
}






#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class NSFileManager; @class NSArray; @class NSDictionary; @class NSString; @class NSData; 
static BOOL (*_logos_orig$_ungrouped$NSString$writeToFile$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL _logos_method$_ungrouped$NSString$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSString$writeToFile$atomically$encoding$error$)(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSString *, BOOL, NSStringEncoding, NSError **); static BOOL _logos_method$_ungrouped$NSString$writeToFile$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSString *, BOOL, NSStringEncoding, NSError **); static BOOL (*_logos_orig$_ungrouped$NSString$writeToURL$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$)(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL, NSStringEncoding, NSError **); static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL, NSStringEncoding, NSError **); static BOOL (*_logos_orig$_ungrouped$NSData$writeToURL$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL _logos_method$_ungrouped$NSData$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSData$writeToFile$options$error$)(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSString *, NSDataWritingOptions, NSError **); static BOOL _logos_method$_ungrouped$NSData$writeToFile$options$error$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSString *, NSDataWritingOptions, NSError **); static BOOL (*_logos_orig$_ungrouped$NSData$writeToURL$options$error$)(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, NSDataWritingOptions, NSError **); static BOOL _logos_method$_ungrouped$NSData$writeToURL$options$error$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, NSDataWritingOptions, NSError **); static BOOL (*_logos_orig$_ungrouped$NSArray$writeToFile$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL _logos_method$_ungrouped$NSArray$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSArray$writeToURL$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL _logos_method$_ungrouped$NSArray$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSArray$writeToURL$error$)(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); static BOOL _logos_method$_ungrouped$NSArray$writeToURL$error$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); static BOOL (*_logos_orig$_ungrouped$NSDictionary$writeToFile$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL _logos_method$_ungrouped$NSDictionary$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSString *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSDictionary$writeToURL$error$)(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); static BOOL _logos_method$_ungrouped$NSDictionary$writeToURL$error$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); static BOOL (*_logos_orig$_ungrouped$NSDictionary$writeToURL$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL _logos_method$_ungrouped$NSDictionary$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSFileManager$removeItemAtPath$error$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError **); static BOOL _logos_method$_ungrouped$NSFileManager$removeItemAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError **); static BOOL (*_logos_orig$_ungrouped$NSFileManager$removeItemAtURL$error$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); static BOOL _logos_method$_ungrouped$NSFileManager$removeItemAtURL$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSURL *, NSError **); 

#line 131 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_writeFile_iOS.xm"



static BOOL _logos_method$_ungrouped$NSString$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, BOOL useAuxiliaryFile) {
    BOOL isWriteOk = FALSE;

    if(cfgHookEnable_writeFileiOS){
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSString$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSString$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
    }

    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
	return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSString$writeToFile$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, BOOL useAuxiliaryFile, NSStringEncoding enc, NSError ** error){
    iosLogDebug("path=%@, useAuxiliaryFile=%s, enc=%ld, *error=%@", path, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error));
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSString$writeToFile$atomically$encoding$error$(self, _cmd, path, useAuxiliaryFile, enc, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSString$writeToFile$atomically$encoding$error$(self, _cmd, path, useAuxiliaryFile, enc, error);
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s, enc=%lu, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL atomically){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSString$writeToURL$atomically$(self, _cmd, url, atomically);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSString$writeToURL$atomically$(self, _cmd, url, atomically);
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL useAuxiliaryFile, NSStringEncoding enc, NSError ** error){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$(self, _cmd, url, useAuxiliaryFile, enc, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$(self, _cmd, url, useAuxiliaryFile, enc, error);
    }
    iosLogDebug("%surl=%{public}@, useAuxiliaryFile=%s, enc=%lu, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(useAuxiliaryFile), enc, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}









static BOOL _logos_method$_ungrouped$NSData$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL atomically){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSData$writeToURL$atomically$(self, _cmd, url, atomically);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSData$writeToURL$atomically$(self, _cmd, url, atomically);
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}


static BOOL _logos_method$_ungrouped$NSData$writeToFile$options$error$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, NSDataWritingOptions writeOptionsMask, NSError ** error){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSData$writeToFile$options$error$(self, _cmd, path, writeOptionsMask, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSData$writeToFile$options$error$(self, _cmd, path, writeOptionsMask, error);
    }
    iosLogDebug("%spath=%{public}@, writeOptionsMask=0x%lx, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, writeOptionsMask, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}


static BOOL _logos_method$_ungrouped$NSData$writeToURL$options$error$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSDataWritingOptions writeOptionsMask, NSError ** error){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSData$writeToURL$options$error$(self, _cmd, url, writeOptionsMask, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSData$writeToURL$options$error$(self, _cmd, url, writeOptionsMask, error);
    }
    iosLogDebug("%surl=%{public}@, writeOptionsMask=0x%lx, *error=%@-> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, writeOptionsMask, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}









static BOOL _logos_method$_ungrouped$NSArray$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, BOOL useAuxiliaryFile){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSArray$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSArray$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSArray$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL atomically){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSArray$writeToURL$atomically$(self, _cmd, url, atomically);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSArray$writeToURL$atomically$(self, _cmd, url, atomically);
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSArray$writeToURL$error$(_LOGOS_SELF_TYPE_NORMAL NSArray* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSError ** error){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSArray$writeToURL$error$(self, _cmd, url, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSArray$writeToURL$error$(self, _cmd, url, error);
    }
    iosLogDebug("%surl=%{public}@, *error=%@ -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}









static BOOL _logos_method$_ungrouped$NSDictionary$writeToFile$atomically$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, BOOL useAuxiliaryFile){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isWriteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isWriteOk=%s", path, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToFile$atomically$(self, _cmd, path, useAuxiliaryFile);
    }
    iosLogDebug("%spath=%{public}@, useAuxiliaryFile=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, boolToStr(useAuxiliaryFile), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSDictionary$writeToURL$error$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSError ** error){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToURL$error$(self, _cmd, url, error);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToURL$error$(self, _cmd, url, error);
    }
    iosLogDebug("%surl=%{public}@, *error=%@ -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isWriteOk));
    return isWriteOk;
}

static BOOL _logos_method$_ungrouped$NSDictionary$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSDictionary* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL atomically){
    BOOL isWriteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isWriteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isWriteOk=%s", url, boolToStr(isWriteOk));
        } else {

            isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToURL$atomically$(self, _cmd, url, atomically);
        }
    } else {

        isWriteOk = _logos_orig$_ungrouped$NSDictionary$writeToURL$atomically$(self, _cmd, url, atomically);
    }
    iosLogDebug("%surl=%{public}@, atomically=%s -> isWriteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, boolToStr(atomically), boolToStr(isWriteOk));
    return isWriteOk;
}









static BOOL _logos_method$_ungrouped$NSFileManager$removeItemAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, NSError ** error) {
    BOOL isDeleteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSString(path)){
            isDeleteOk = FALSE;
            iosLogInfo("hooked path=%{public}@ -> isDeleteOk=%s", path, boolToStr(isDeleteOk));
        } else {

            isDeleteOk = _logos_orig$_ungrouped$NSFileManager$removeItemAtPath$error$(self, _cmd, path, error);
        }
    } else {

        isDeleteOk = _logos_orig$_ungrouped$NSFileManager$removeItemAtPath$error$(self, _cmd, path, error);
    }
    iosLogDebug("%spath=%{public}@, *error=%@-> isDeleteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), path, ERROR_STR(error), boolToStr(isDeleteOk));
    return isDeleteOk;
}


static BOOL _logos_method$_ungrouped$NSFileManager$removeItemAtURL$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSError ** error) {
    BOOL isDeleteOk = FALSE;

    if (cfgHookEnable_writeFileiOS) {
        if(shouldHookWritePath_NSURL(url)){
            isDeleteOk = FALSE;
            iosLogInfo("hooked url=%{public}@ -> isDeleteOk=%s", url, boolToStr(isDeleteOk));
        } else {

            isDeleteOk = _logos_orig$_ungrouped$NSFileManager$removeItemAtURL$error$(self, _cmd, url, error);
        }
    } else {

        isDeleteOk = _logos_orig$_ungrouped$NSFileManager$removeItemAtURL$error$(self, _cmd, url, error);
    }
    iosLogDebug("%surl=%{public}@, *error=%@-> isDeleteOk=%s", HOOK_PREFIX(cfgHookEnable_writeFileiOS), url, ERROR_STR(error), boolToStr(isDeleteOk));
    return isDeleteOk;
}







static __attribute__((constructor)) void _logosLocalCtor_0353ab4c(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_writeFileiOS=%s", "writeFile_iOS ctor", boolToStr(cfgHookEnable_writeFileiOS));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSString = objc_getClass("NSString"); { MSHookMessageEx(_logos_class$_ungrouped$NSString, @selector(writeToFile:atomically:), (IMP)&_logos_method$_ungrouped$NSString$writeToFile$atomically$, (IMP*)&_logos_orig$_ungrouped$NSString$writeToFile$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSString, @selector(writeToFile:atomically:encoding:error:), (IMP)&_logos_method$_ungrouped$NSString$writeToFile$atomically$encoding$error$, (IMP*)&_logos_orig$_ungrouped$NSString$writeToFile$atomically$encoding$error$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSString, @selector(writeToURL:atomically:), (IMP)&_logos_method$_ungrouped$NSString$writeToURL$atomically$, (IMP*)&_logos_orig$_ungrouped$NSString$writeToURL$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSString, @selector(writeToURL:atomically:encoding:error:), (IMP)&_logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$, (IMP*)&_logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$);}Class _logos_class$_ungrouped$NSData = objc_getClass("NSData"); { MSHookMessageEx(_logos_class$_ungrouped$NSData, @selector(writeToURL:atomically:), (IMP)&_logos_method$_ungrouped$NSData$writeToURL$atomically$, (IMP*)&_logos_orig$_ungrouped$NSData$writeToURL$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSData, @selector(writeToFile:options:error:), (IMP)&_logos_method$_ungrouped$NSData$writeToFile$options$error$, (IMP*)&_logos_orig$_ungrouped$NSData$writeToFile$options$error$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSData, @selector(writeToURL:options:error:), (IMP)&_logos_method$_ungrouped$NSData$writeToURL$options$error$, (IMP*)&_logos_orig$_ungrouped$NSData$writeToURL$options$error$);}Class _logos_class$_ungrouped$NSArray = objc_getClass("NSArray"); { MSHookMessageEx(_logos_class$_ungrouped$NSArray, @selector(writeToFile:atomically:), (IMP)&_logos_method$_ungrouped$NSArray$writeToFile$atomically$, (IMP*)&_logos_orig$_ungrouped$NSArray$writeToFile$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSArray, @selector(writeToURL:atomically:), (IMP)&_logos_method$_ungrouped$NSArray$writeToURL$atomically$, (IMP*)&_logos_orig$_ungrouped$NSArray$writeToURL$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSArray, @selector(writeToURL:error:), (IMP)&_logos_method$_ungrouped$NSArray$writeToURL$error$, (IMP*)&_logos_orig$_ungrouped$NSArray$writeToURL$error$);}Class _logos_class$_ungrouped$NSDictionary = objc_getClass("NSDictionary"); { MSHookMessageEx(_logos_class$_ungrouped$NSDictionary, @selector(writeToFile:atomically:), (IMP)&_logos_method$_ungrouped$NSDictionary$writeToFile$atomically$, (IMP*)&_logos_orig$_ungrouped$NSDictionary$writeToFile$atomically$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSDictionary, @selector(writeToURL:error:), (IMP)&_logos_method$_ungrouped$NSDictionary$writeToURL$error$, (IMP*)&_logos_orig$_ungrouped$NSDictionary$writeToURL$error$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSDictionary, @selector(writeToURL:atomically:), (IMP)&_logos_method$_ungrouped$NSDictionary$writeToURL$atomically$, (IMP*)&_logos_orig$_ungrouped$NSDictionary$writeToURL$atomically$);}Class _logos_class$_ungrouped$NSFileManager = objc_getClass("NSFileManager"); { MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(removeItemAtPath:error:), (IMP)&_logos_method$_ungrouped$NSFileManager$removeItemAtPath$error$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$removeItemAtPath$error$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(removeItemAtURL:error:), (IMP)&_logos_method$_ungrouped$NSFileManager$removeItemAtURL$error$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$removeItemAtURL$error$);}} }
#line 469 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_writeFile_iOS.xm"

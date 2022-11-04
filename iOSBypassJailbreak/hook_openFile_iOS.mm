#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_iOS.xm"






#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "JailbreakiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"










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

@class NSURL; @class NSFileManager; 
static NSArray<NSString *> * (*_logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError * _Nullable *); static NSArray<NSString *> * _logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError * _Nullable *); static BOOL (*_logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *); static BOOL _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *); static BOOL (*_logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, BOOL *); static BOOL _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, BOOL *); static BOOL (*_logos_orig$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$)(_LOGOS_SELF_TYPE_NORMAL NSURL* _LOGOS_SELF_CONST, SEL, NSError * _Nullable *); static BOOL _logos_method$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$(_LOGOS_SELF_TYPE_NORMAL NSURL* _LOGOS_SELF_CONST, SEL, NSError * _Nullable *); 

#line 23 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_iOS.xm"































static NSArray<NSString *> * _logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, NSError * _Nullable * error) {
    iosLogDebug("path=%{public}@, *error=%@", path, ERROR_STR(error));
    NSArray<NSString *> * retContentList = NULL;
    BOOL isJbPath = FALSE;

    if (cfgHookEnable_openFileiOS) {
        if (NULL != path) {
            isJbPath = [JailbreakiOS isJailbreakPath_iOS: path];
            if (isJbPath){
                retContentList = NULL;
            } else {

                retContentList = _logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(self, _cmd, path, error);
            }
        }
    } else {
        retContentList = _logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(self, _cmd, path, error);
    }

    
   if (isJbPath){
        iosLogInfo("path=%{public}@, *error=%@ -> isJbPath=%{bool}d -> retContentList=%p", path, ERROR_STR(error), isJbPath, retContentList);
   }
    return retContentList;
}


static BOOL _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path) {
    iosLogDebug("path=%{public}@", path);
    bool isExists = FALSE;
    BOOL isJbPath = FALSE;

    if (cfgHookEnable_openFileiOS) {
        if (NULL != path){
            isJbPath = [JailbreakiOS isJailbreakPath_iOS: path];
            if(isJbPath){
                isExists = FALSE;
            } else{

                isExists = _logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$(self, _cmd, path);
            }
        }
    } else {
        isExists = _logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$(self, _cmd, path);
    }

    
   if (isJbPath){
        iosLogInfo("path=%{public}@ -> isJbPath=%s -> isExists=%s", path, boolToStr(isJbPath), boolToStr(isExists));
   }

    return isExists;
}


static BOOL _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, BOOL * isDirectory) {
    iosLogDebug("path=%{public}@, isDirectory=%p", path, isDirectory);
    BOOL isJbPath = FALSE;
    BOOL isExists = FALSE;

    if (cfgHookEnable_openFileiOS) {
        if (NULL != path) {
            isJbPath = [JailbreakiOS isJailbreakPath_iOS: path];
            if(isJbPath){
                isExists = FALSE;
            } else{

                isExists = _logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$(self, _cmd, path, isDirectory);
            }
        }
    } else {
        isExists = _logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$(self, _cmd, path, isDirectory);
    }

    
   if (isJbPath){
        iosLogInfo("path=%{public}@, isDirectory=%p -> isJbPath=%s -> isExists=%s", path, isDirectory, boolToStr(isJbPath), boolToStr(isExists));
   }

	return isExists;
}









static BOOL _logos_method$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$(_LOGOS_SELF_TYPE_NORMAL NSURL* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSError * _Nullable * error){
    NSString* curUrlStr = [self absoluteString];
    iosLogDebug("curUrlStr=%{public}@, error=%p", curUrlStr, error);
    BOOL isJbPath = FALSE;
    BOOL isReachable = FALSE;

    if (cfgHookEnable_openFileiOS) {
        isJbPath = [JailbreakiOS isJailbreakPath_iOS: curUrlStr];
        if(isJbPath){
            isReachable = FALSE;
        } else{

            isReachable = _logos_orig$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$(self, _cmd, error);
        }
    } else {
        isReachable = _logos_orig$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$(self, _cmd, error);
    }

    
   if (isJbPath) {
        iosLogInfo("curUrlStr=%{public}@, error=%p -> isJbPath=%s -> isReachable=%s", curUrlStr, error, boolToStr(isJbPath), boolToStr(isReachable));
   }
    return isReachable;
}







static __attribute__((constructor)) void _logosLocalCtor_bf822969(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_openFileiOS=%s", "openFile_iOS ctor", boolToStr(cfgHookEnable_openFileiOS));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSFileManager = objc_getClass("NSFileManager"); { MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(contentsOfDirectoryAtPath:error:), (IMP)&_logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(fileExistsAtPath:), (IMP)&_logos_method$_ungrouped$NSFileManager$fileExistsAtPath$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(fileExistsAtPath:isDirectory:), (IMP)&_logos_method$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$fileExistsAtPath$isDirectory$);}Class _logos_class$_ungrouped$NSURL = objc_getClass("NSURL"); { MSHookMessageEx(_logos_class$_ungrouped$NSURL, @selector(checkResourceIsReachableAndReturnError:), (IMP)&_logos_method$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$, (IMP*)&_logos_orig$_ungrouped$NSURL$checkResourceIsReachableAndReturnError$);}} }
#line 182 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_iOS.xm"

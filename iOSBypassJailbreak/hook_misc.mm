#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_misc.xm"






#import <os/log.h>

#import <spawn.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
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

@class NSBundle; @class UIApplication; @class FBApplicationInfo; @class NSDictionary; @class LSApplicationProxy; @class LSApplicationWorkspace; 
static BOOL (*_logos_orig$_ungrouped$UIApplication$canOpenURL$)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, NSURL *); static BOOL _logos_method$_ungrouped$UIApplication$canOpenURL$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, NSURL *); static NSString * (*_logos_orig$_ungrouped$NSBundle$pathForResource$ofType$)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); static NSString * _logos_method$_ungrouped$NSBundle$pathForResource$ofType$(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL, NSString *, NSString *); static NSString * (*_logos_orig$_ungrouped$NSBundle$bundlePath)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$NSBundle$bundlePath(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$LSApplicationProxy$itemName)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$LSApplicationProxy$itemName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$LSApplicationProxy$vendorName)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$LSApplicationProxy$vendorName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$LSApplicationProxy$localizedName)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$LSApplicationProxy$localizedName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$LSApplicationProxy$localizedShortName)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$LSApplicationProxy$localizedShortName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id, id); static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id, id); static id (*_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$)(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id, id, BOOL); static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST, SEL, id, id, BOOL); static LSApplicationWorkspace* (*_logos_meta_orig$_ungrouped$LSApplicationWorkspace$defaultWorkspace)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static LSApplicationWorkspace* _logos_meta_method$_ungrouped$LSApplicationWorkspace$defaultWorkspace(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * (*_logos_orig$_ungrouped$LSApplicationWorkspace$allApplications)(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$allApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * (*_logos_orig$_ungrouped$LSApplicationWorkspace$allInstalledApplications)(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$allInstalledApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * (*_logos_orig$_ungrouped$LSApplicationWorkspace$directionsApplications)(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$directionsApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * (*_logos_orig$_ungrouped$LSApplicationWorkspace$unrestrictedApplications)(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$unrestrictedApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <NSString *> * (*_logos_orig$_ungrouped$LSApplicationWorkspace$installedApplications)(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSArray <NSString *> * _logos_method$_ungrouped$LSApplicationWorkspace$installedApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST, SEL); static NSDictionary * (*_logos_orig$_ungrouped$FBApplicationInfo$environmentVariables)(_LOGOS_SELF_TYPE_NORMAL FBApplicationInfo* _LOGOS_SELF_CONST, SEL); static NSDictionary * _logos_method$_ungrouped$FBApplicationInfo$environmentVariables(_LOGOS_SELF_TYPE_NORMAL FBApplicationInfo* _LOGOS_SELF_CONST, SEL); static NSDictionary<NSString *, id> * (*_logos_meta_orig$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, NSError * _Nullable *); static NSDictionary<NSString *, id> * _logos_meta_method$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, NSError * _Nullable *); 

#line 24 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_misc.xm"


const char* CydiaPrefix = "cydia://";


static BOOL _logos_method$_ungrouped$UIApplication$canOpenURL$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url) {
    iosLogDebug("url=%{public}@", url);
    bool couldOpen = false;
    bool isCydia = false;

    if (cfgHookEnable_misc) {
        NSString *urlNSStr = [url absoluteString];
        const char* urlStr = [urlNSStr UTF8String];
        char* urlStrLower = strToLowercase(urlStr);
        iosLogDebug("urlStrLower=%s", urlStrLower);
        isCydia = strStartsWith(urlStrLower, CydiaPrefix);
        free(urlStrLower);
        iosLogDebug("isCydia=%{public}s", boolToStr(isCydia));

        if(isCydia){
            couldOpen = false;
        } else{
    
            couldOpen = _logos_orig$_ungrouped$UIApplication$canOpenURL$(self, _cmd, url);
        }
    } else {
        couldOpen = _logos_orig$_ungrouped$UIApplication$canOpenURL$(self, _cmd, url);
    }

    

        iosLogInfo("url=%{public}@ -> isCydia=%{public}s -> couldOpen=%{public}s", url, boolToStr(isCydia), boolToStr(couldOpen));

    return couldOpen;
}





















char * getenv(const char* name);
const char* DYLD_INSERT_LIBRARIES = "DYLD_INSERT_LIBRARIES";

__unused static char * (*_logos_orig$_ungrouped$getenv)(const char* name); __unused static char * _logos_function$_ungrouped$getenv(const char* name){
    
    char* getenvRetStr = _logos_orig$_ungrouped$getenv(name);

    if (cfgHookEnable_misc) {
        
        

        
        if (strStartsWith(name, "DYLD_")){


            iosLogInfo("DYLD_ name=%s", name);
        }

        if(0 == strcmp(name, DYLD_INSERT_LIBRARIES)){
            iosLogInfo("name=%s -> getenvRetStr=%{public}s", name, getenvRetStr);
            getenvRetStr = NULL;
        } else {
            if (strStartsWith(name, "DYLD_")){
                iosLogInfo("name=%s -> getenvRetStr=%{public}s", name, getenvRetStr);
            }
        }
    }

    return getenvRetStr;
}






pid_t fork(void);

__unused static int (*_logos_orig$_ungrouped$fork)(void); __unused static int _logos_function$_ungrouped$fork(void){
    int retForkValue = FORK_FAILED;
    if (cfgHookEnable_misc) {
        retForkValue = FORK_FAILED;
    } else {
        retForkValue = _logos_orig$_ungrouped$fork();
    }
    iosLogInfo("retForkValue=%d", retForkValue);
    return retForkValue;
}






























Class NSClassFromString(NSString *aClassName);

__unused static Class (*_logos_orig$_ungrouped$NSClassFromString)(NSString *aClassName); __unused static Class _logos_function$_ungrouped$NSClassFromString(NSString *aClassName){
    if (NULL == aClassName) {
        iosLogInfo("%s", "aClassName is NULL");
    }
    
    id origRet = _logos_orig$_ungrouped$NSClassFromString(aClassName);
    
    if (cfgHookEnable_misc) {
        
        bool isKnown = false;

        const char* classNameStr = [aClassName UTF8String];
        const char* startWithList[] = {
            "__NS",
            "_NS",
            "_UI",
            "AC",
            "AF",
            "AWE",
            "AT",
            "BD",
            "BK",
            "BS",
            "CJ",
            "CM",
            "DH",
            "FB",
            "HM",
            "HG",
            "HT",
            "IE",
            "IN", 
            "NS",
            "PT", 
            "QQ",
            "RB",
            "RT",
            "TI", 
            "TK",
            "TT",
            "UI",
            "VE",
            "YY",
        };
        const int startWithListLen = sizeof(startWithList) / StrPointerSize;
        for(int curStrIdx = 0; curStrIdx < startWithListLen; curStrIdx++){
            const char* curStartWithStr = startWithList[curStrIdx];
            if (strStartsWith(classNameStr, curStartWithStr)) {
                isKnown = true;
                break;
            }
        }

        if (!isKnown) {
            iosLogInfo("aClassName=%{public}@ -> origRet=%@", aClassName, origRet);
        }
    }

    return origRet;
}






SEL NSSelectorFromString(NSString *aSelectorName);

__unused static SEL (*_logos_orig$_ungrouped$NSSelectorFromString)(NSString *aSelectorName); __unused static SEL _logos_function$_ungrouped$NSSelectorFromString(NSString *aSelectorName){
    SEL retSel = NULL;

    if (NULL == aSelectorName) {
        iosLogInfo("%s", "aSelectorName is NULL");
    } else {
        retSel = _logos_orig$_ungrouped$NSSelectorFromString(aSelectorName);
    
    
    }
    return retSel;
}


















Protocol* objc_getProtocol(const char *name);

__unused static Protocol * (*_logos_orig$_ungrouped$objc_getProtocol)(const char *name); __unused static Protocol * _logos_function$_ungrouped$objc_getProtocol(const char *name){
    Protocol* origRetProtocol = _logos_orig$_ungrouped$objc_getProtocol(name);
    iosLogInfo("name=%{public}s -> origRetProtocol=%{public}@", name, origRetProtocol);
    return origRetProtocol;
}





Protocol * NSProtocolFromString(NSString *namestr);

__unused static Protocol * (*_logos_orig$_ungrouped$NSProtocolFromString)(NSString *namestr); __unused static Protocol * _logos_function$_ungrouped$NSProtocolFromString(NSString *namestr){
    Protocol* origRetProtocol = _logos_orig$_ungrouped$NSProtocolFromString(namestr);
    iosLogInfo("namestr=%{public}@ -> origRetProtocol=%{public}@", namestr, origRetProtocol);
    return origRetProtocol;
}






const char ** objc_copyImageNames(unsigned int *outCount);

__unused static const char ** (*_logos_orig$_ungrouped$objc_copyImageNames)(unsigned int *outCount); __unused static const char ** _logos_function$_ungrouped$objc_copyImageNames(unsigned int *outCount){
    iosLogInfo("outCount=%p", outCount);
    const char** imageList = _logos_orig$_ungrouped$objc_copyImageNames(outCount);
    iosLogInfo("*outCount=%d, imageList=%p", *outCount, imageList);
    if (cfgHookEnable_aweme) {
        

        if ((*outCount > 0) && (imageList != NULL)) {
            for (int i = 0; i < *outCount; i++) {
                const char* curImagePath = imageList[i];
                bool isJbPath = isJailbreakPath(curImagePath);
                if (isJbPath) {
                    iosLogInfo("[%d] %s -> isJbPath=%s", i, curImagePath, boolToStr(isJbPath));
                }
            }
        }
    }
    return imageList;
}








static NSString * _logos_method$_ungrouped$NSBundle$pathForResource$ofType$(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * name, NSString * ext) {
    NSString* resPath = _logos_orig$_ungrouped$NSBundle$pathForResource$ofType$(self, _cmd, name, ext);

    if (cfgHookEnable_aweme) {
        if ([ext isEqualToString: @"mobileprovision"]){
            iosLogInfo("name=%{public}@, ext=%{public}@ -> resPath=%{public}@", name, ext, resPath);
            if ([name isEqualToString: @"embedded"]){
                resPath = NULL;
            }
        }
    }

    return resPath;
}




static NSString * _logos_method$_ungrouped$NSBundle$bundlePath(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString* origBundlePath = _logos_orig$_ungrouped$NSBundle$bundlePath(self, _cmd);
    BOOL shouldOmit = [origBundlePath containsString: @"Aweme"] || [origBundlePath containsString: @"/System/Library"];
    if (!shouldOmit){
        iosLogInfo("origBundlePath=%{public}@", origBundlePath);
    }
    return origBundlePath;
}
















































static NSString * _logos_method$_ungrouped$LSApplicationProxy$itemName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString* origItemName = _logos_orig$_ungrouped$LSApplicationProxy$itemName(self, _cmd);
    iosLogInfo("origItemName=%{public}@", origItemName);
    return origItemName;
}

static NSString * _logos_method$_ungrouped$LSApplicationProxy$vendorName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString* origVendorName = _logos_orig$_ungrouped$LSApplicationProxy$vendorName(self, _cmd);
    iosLogInfo("origVendorName=%{public}@", origVendorName);
    return origVendorName;
}

static NSString * _logos_method$_ungrouped$LSApplicationProxy$localizedName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString* origLocalizedName = _logos_orig$_ungrouped$LSApplicationProxy$localizedName(self, _cmd);
    iosLogInfo("origLocalizedName=%{public}@", origLocalizedName);
    return origLocalizedName;
}

static NSString * _logos_method$_ungrouped$LSApplicationProxy$localizedShortName(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString* origLocalizedShortName = _logos_orig$_ungrouped$LSApplicationProxy$localizedShortName(self, _cmd);
    iosLogInfo("origLocalizedShortName=%{public}@", origLocalizedShortName);
    return origLocalizedShortName;
}

static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    id origNameForContext = _logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$(self, _cmd, arg1);
    iosLogInfo("arg1=%@ -> origNameForContext=%@", arg1, origNameForContext);
    return origNameForContext;
}

static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    id origNameForContext = _logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$(self, _cmd, arg1, arg2);
    iosLogInfo("arg1=%@,arg2=%@ -> origNameForContext=%@", arg1, arg2, origNameForContext);
    return origNameForContext;
}

static id _logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$(_LOGOS_SELF_TYPE_NORMAL LSApplicationProxy* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, BOOL arg3) {
    id origNameForContext = _logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$(self, _cmd, arg1, arg2, arg3);
    iosLogInfo("arg1=%@,arg2=%@,arg3=%s -> origNameForContext=%@", arg1, arg2, boolToStr(arg3), origNameForContext);
    return origNameForContext;
}









static LSApplicationWorkspace* _logos_meta_method$_ungrouped$LSApplicationWorkspace$defaultWorkspace(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    id defWorkspace = _logos_meta_orig$_ungrouped$LSApplicationWorkspace$defaultWorkspace(self, _cmd);
    iosLogInfo("defWorkspace=%{public}@", defWorkspace);
    return defWorkspace;
}

static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$allApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSArray <LSApplicationProxy *> * allAppList = _logos_orig$_ungrouped$LSApplicationWorkspace$allApplications(self, _cmd);
    iosLogInfo("allAppList=%{public}@", allAppList);
    return allAppList;
}

static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$allInstalledApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSArray <LSApplicationProxy *> * allInstalledAppList = _logos_orig$_ungrouped$LSApplicationWorkspace$allInstalledApplications(self, _cmd);
    iosLogInfo("allInstalledAppList=%{public}@", allInstalledAppList);
    return allInstalledAppList;
}

static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$directionsApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSArray <LSApplicationProxy *> * directionsAppList = _logos_orig$_ungrouped$LSApplicationWorkspace$directionsApplications(self, _cmd);
    iosLogInfo("directionsAppList=%{public}@", directionsAppList);
    return directionsAppList;
}

static NSArray <LSApplicationProxy *> * _logos_method$_ungrouped$LSApplicationWorkspace$unrestrictedApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSArray <LSApplicationProxy *> * unrestrictedAppList = _logos_orig$_ungrouped$LSApplicationWorkspace$unrestrictedApplications(self, _cmd);
    iosLogInfo("unrestrictedAppList=%{public}@", unrestrictedAppList);
    return unrestrictedAppList;
}


static NSArray <NSString *> * _logos_method$_ungrouped$LSApplicationWorkspace$installedApplications(_LOGOS_SELF_TYPE_NORMAL LSApplicationWorkspace* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSArray <NSString *> * allAppStrList = _logos_orig$_ungrouped$LSApplicationWorkspace$installedApplications(self, _cmd);
    iosLogInfo("allAppStrList=%{public}@", allAppStrList);
    return allAppStrList;
}









static NSDictionary * _logos_method$_ungrouped$FBApplicationInfo$environmentVariables(_LOGOS_SELF_TYPE_NORMAL FBApplicationInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSDictionary* allEnvVarList = _logos_orig$_ungrouped$FBApplicationInfo$environmentVariables(self, _cmd);
    iosLogInfo("allEnvVarList=%{public}@", allEnvVarList);
    return allEnvVarList;
}











static NSDictionary<NSString *, id> * _logos_meta_method$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSError * _Nullable * error){
    NSDictionary<NSString *, id>* origDict = _logos_meta_orig$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$(self, _cmd, url, error);
    iosLogInfo("url=%{public}@ -> origDict=%{public}@", url, origDict);
    return origDict;
}


















int posix_spawn(pid_t* pid, const char* path, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t* attrp, char *const argv[], char *const envp[]);

__unused static int (*_logos_orig$_ungrouped$posix_spawn)(pid_t* pid, const char* path, const posix_spawn_file_actions_t* file_actions, const posix_spawnattr_t* attrp, char *const argv[], char *const envp[]); __unused static int _logos_function$_ungrouped$posix_spawn(pid_t* pid, const char* path, const posix_spawn_file_actions_t* file_actions, const posix_spawnattr_t* attrp, char *const argv[], char *const envp[]){
    int spawnRet = _logos_orig$_ungrouped$posix_spawn(pid, path, file_actions, attrp, argv, envp);
    iosLogInfo("pid=%p,path=%{public}s,file_actions=%p,attrp=%p,argv=%p,envp=%p -> spawnRet=%d", pid, path, file_actions, attrp, argv, envp, spawnRet);
    return spawnRet;
}






static __attribute__((constructor)) void _logosLocalCtor_298f95e1(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_misc=%s", "misc ctor", boolToStr(cfgHookEnable_misc));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIApplication = objc_getClass("UIApplication"); { MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(canOpenURL:), (IMP)&_logos_method$_ungrouped$UIApplication$canOpenURL$, (IMP*)&_logos_orig$_ungrouped$UIApplication$canOpenURL$);}Class _logos_class$_ungrouped$NSBundle = objc_getClass("NSBundle"); { MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(pathForResource:ofType:), (IMP)&_logos_method$_ungrouped$NSBundle$pathForResource$ofType$, (IMP*)&_logos_orig$_ungrouped$NSBundle$pathForResource$ofType$);}{ MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(bundlePath), (IMP)&_logos_method$_ungrouped$NSBundle$bundlePath, (IMP*)&_logos_orig$_ungrouped$NSBundle$bundlePath);}Class _logos_class$_ungrouped$LSApplicationProxy = objc_getClass("LSApplicationProxy"); { MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(itemName), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$itemName, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$itemName);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(vendorName), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$vendorName, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$vendorName);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(localizedName), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$localizedName, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$localizedName);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(localizedShortName), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$localizedShortName, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$localizedShortName);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(localizedNameForContext:), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(localizedNameForContext:preferredLocalizations:), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationProxy, @selector(localizedNameForContext:preferredLocalizations:useShortNameOnly:), (IMP)&_logos_method$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$, (IMP*)&_logos_orig$_ungrouped$LSApplicationProxy$localizedNameForContext$preferredLocalizations$useShortNameOnly$);}Class _logos_class$_ungrouped$LSApplicationWorkspace = objc_getClass("LSApplicationWorkspace"); Class _logos_metaclass$_ungrouped$LSApplicationWorkspace = object_getClass(_logos_class$_ungrouped$LSApplicationWorkspace); { MSHookMessageEx(_logos_metaclass$_ungrouped$LSApplicationWorkspace, @selector(defaultWorkspace), (IMP)&_logos_meta_method$_ungrouped$LSApplicationWorkspace$defaultWorkspace, (IMP*)&_logos_meta_orig$_ungrouped$LSApplicationWorkspace$defaultWorkspace);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationWorkspace, @selector(allApplications), (IMP)&_logos_method$_ungrouped$LSApplicationWorkspace$allApplications, (IMP*)&_logos_orig$_ungrouped$LSApplicationWorkspace$allApplications);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationWorkspace, @selector(allInstalledApplications), (IMP)&_logos_method$_ungrouped$LSApplicationWorkspace$allInstalledApplications, (IMP*)&_logos_orig$_ungrouped$LSApplicationWorkspace$allInstalledApplications);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationWorkspace, @selector(directionsApplications), (IMP)&_logos_method$_ungrouped$LSApplicationWorkspace$directionsApplications, (IMP*)&_logos_orig$_ungrouped$LSApplicationWorkspace$directionsApplications);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationWorkspace, @selector(unrestrictedApplications), (IMP)&_logos_method$_ungrouped$LSApplicationWorkspace$unrestrictedApplications, (IMP*)&_logos_orig$_ungrouped$LSApplicationWorkspace$unrestrictedApplications);}{ MSHookMessageEx(_logos_class$_ungrouped$LSApplicationWorkspace, @selector(installedApplications), (IMP)&_logos_method$_ungrouped$LSApplicationWorkspace$installedApplications, (IMP*)&_logos_orig$_ungrouped$LSApplicationWorkspace$installedApplications);}Class _logos_class$_ungrouped$FBApplicationInfo = objc_getClass("FBApplicationInfo"); { MSHookMessageEx(_logos_class$_ungrouped$FBApplicationInfo, @selector(environmentVariables), (IMP)&_logos_method$_ungrouped$FBApplicationInfo$environmentVariables, (IMP*)&_logos_orig$_ungrouped$FBApplicationInfo$environmentVariables);}Class _logos_class$_ungrouped$NSDictionary = objc_getClass("NSDictionary"); Class _logos_metaclass$_ungrouped$NSDictionary = object_getClass(_logos_class$_ungrouped$NSDictionary); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSDictionary, @selector(dictionaryWithContentsOfURL:error:), (IMP)&_logos_meta_method$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSDictionary$dictionaryWithContentsOfURL$error$);}void * _logos_symbol$_ungrouped$getenv = (void *)getenv; MSHookFunction((void *)_logos_symbol$_ungrouped$getenv, (void *)&_logos_function$_ungrouped$getenv, (void **)&_logos_orig$_ungrouped$getenv);void * _logos_symbol$_ungrouped$fork = (void *)fork; MSHookFunction((void *)_logos_symbol$_ungrouped$fork, (void *)&_logos_function$_ungrouped$fork, (void **)&_logos_orig$_ungrouped$fork);void * _logos_symbol$_ungrouped$NSClassFromString = (void *)NSClassFromString; MSHookFunction((void *)_logos_symbol$_ungrouped$NSClassFromString, (void *)&_logos_function$_ungrouped$NSClassFromString, (void **)&_logos_orig$_ungrouped$NSClassFromString);void * _logos_symbol$_ungrouped$NSSelectorFromString = (void *)NSSelectorFromString; MSHookFunction((void *)_logos_symbol$_ungrouped$NSSelectorFromString, (void *)&_logos_function$_ungrouped$NSSelectorFromString, (void **)&_logos_orig$_ungrouped$NSSelectorFromString);void * _logos_symbol$_ungrouped$objc_getProtocol = (void *)objc_getProtocol; MSHookFunction((void *)_logos_symbol$_ungrouped$objc_getProtocol, (void *)&_logos_function$_ungrouped$objc_getProtocol, (void **)&_logos_orig$_ungrouped$objc_getProtocol);void * _logos_symbol$_ungrouped$NSProtocolFromString = (void *)NSProtocolFromString; MSHookFunction((void *)_logos_symbol$_ungrouped$NSProtocolFromString, (void *)&_logos_function$_ungrouped$NSProtocolFromString, (void **)&_logos_orig$_ungrouped$NSProtocolFromString);void * _logos_symbol$_ungrouped$objc_copyImageNames = (void *)objc_copyImageNames; MSHookFunction((void *)_logos_symbol$_ungrouped$objc_copyImageNames, (void *)&_logos_function$_ungrouped$objc_copyImageNames, (void **)&_logos_orig$_ungrouped$objc_copyImageNames);void * _logos_symbol$_ungrouped$posix_spawn = (void *)posix_spawn; MSHookFunction((void *)_logos_symbol$_ungrouped$posix_spawn, (void *)&_logos_function$_ungrouped$posix_spawn, (void **)&_logos_orig$_ungrouped$posix_spawn);} }
#line 540 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_misc.xm"

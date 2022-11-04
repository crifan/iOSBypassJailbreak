/*
 File: hook_misc.xm
 Function: iOS tweak to hook miscellaneous items
 Author: Crifan Li
*/

#import <os/log.h>

#import <spawn.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

/*==============================================================================
 Hook: UIApplication canOpenURL:
==============================================================================*/

/*
 hook url scheme, eg: cydia://
 */

%hook UIApplication

const char* CydiaPrefix = "cydia://";

- (BOOL)canOpenURL:(NSURL *)url
{
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
    //        couldOpen = %orig(url);
            couldOpen = %orig;
        }
    } else {
        couldOpen = %orig;
    }

    // for debug
//    if (isCydia) {
        iosLogInfo("url=%{public}@ -> isCydia=%{public}s -> couldOpen=%{public}s", url, boolToStr(isCydia), boolToStr(couldOpen));
//    }
    return couldOpen;
}

%end


///*==============================================================================
// Hook: system(NULL)
//==============================================================================*/
//
////int system(const char *command);
//
//%hookf(int, system, const char *command){
//    iosLogDebug("command=%s", command);
//    return %orig;
//}



/*==============================================================================
 Hook: getenv(DYLD_INSERT_LIBRARIES)
==============================================================================*/

char * getenv(const char* name);
const char* DYLD_INSERT_LIBRARIES = "DYLD_INSERT_LIBRARIES";

%hookf(char *, getenv, const char* name){
    //    char* getenvRetStr = %orig(name);
    char* getenvRetStr = %orig;

    if (cfgHookEnable_misc) {
        //    iosLogDebug("name=%s", name);
        //    NSLog(@"getenv name");

        // "_CFXNOTIFICATIONREGISTAR2_ENABLED" will cause crash
        if (strStartsWith(name, "DYLD_")){
//        if (!strStartsWith(name, "_")){
//            iosLogInfo("not start with '_', name=%s", name);
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


/*==============================================================================
 Hook: fork()
==============================================================================*/

pid_t fork(void);

%hookf(int, fork, void){
    int retForkValue = FORK_FAILED;
    if (cfgHookEnable_misc) {
        retForkValue = FORK_FAILED;
    } else {
        retForkValue = %orig;
    }
    iosLogInfo("retForkValue=%d", retForkValue);
    return retForkValue;
}


/*==============================================================================
	Anti-Debug: ptrace
==============================================================================*/

//#if !defined(PT_DENY_ATTACH)
//#define PT_DENY_ATTACH          31
//#endif  // !defined(PT_DENY_ATTACH)
//
//// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/ptrace.2.html
////int ptrace(int request, pid_t pid, caddr_t addr, int data);
//
////%hookf(int, ptrace, int request, pid_t pid, caddr_t addr, int data){
//%hookf(int, _ptrace, int request, pid_t pid, caddr_t addr, int data){
//	int ptraceRetValue = PTRACE_FAILED;
//	iosLogInfo("request=%d, pid=%d, addr=%p, data=%d", request, pid, addr, data);
//	if (PT_DENY_ATTACH == request) {
//		ptraceRetValue = PTRACE_OK;
//    } else {
//        ptraceRetValue = %orig(request, pid, addr, data);
//    }
//    iosLogInfo("ptraceRetValue=%d", ptraceRetValue);
//	return ptraceRetValue;
//}

/*==============================================================================
 Hook: NSClassFromString
==============================================================================*/

Class NSClassFromString(NSString *aClassName);

%hookf(Class, NSClassFromString, NSString *aClassName){
    if (NULL == aClassName) {
        iosLogInfo("%s", "aClassName is NULL");
    }
    
    id origRet = %orig;
    
    if (cfgHookEnable_misc) {
        // for debug
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
            "IN", // INCodableAttributeRelationship
            "NS",
            "PT", // PTYFeatureCore
            "QQ",
            "RB",
            "RT",
            "TI", // TIMConversationManager
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


/*==============================================================================
 Hook: NSSelectorFromString
==============================================================================*/

SEL NSSelectorFromString(NSString *aSelectorName);

%hookf(SEL, NSSelectorFromString, NSString *aSelectorName){
    SEL retSel = NULL;

    if (NULL == aSelectorName) {
        iosLogInfo("%s", "aSelectorName is NULL");
    } else {
        retSel = %orig;
    //    iosLogInfo("aSelectorName=%{public}@ -> retSel=%@", aSelectorName, retSel); // will error
    //    iosLogInfo("aSelectorName=%{public}@", aSelectorName); // output too many 3000+ log
    }
    return retSel;
}


/*==============================================================================
 Hook: objc_getClass
==============================================================================*/

//Class objc_getClass ( const char *name );
// // Note: will cause SUBSTITUTE_ERR_FUNC_BAD_INSN_AT_START and other iOS app run failed
//%hookf(Class, objc_getClass, const char *name){
//    id origRetClass = %orig;
//    iosLogInfo("name=%s -> origRetClass=%@", name, origRetClass);
//    return origRetClass;
//}

/*==============================================================================
 Hook: objc_getProtocol
==============================================================================*/

Protocol* objc_getProtocol(const char *name);

%hookf(Protocol *, objc_getProtocol, const char *name){
    Protocol* origRetProtocol = %orig;
    iosLogInfo("name=%{public}s -> origRetProtocol=%{public}@", name, origRetProtocol);
    return origRetProtocol;
}

/*==============================================================================
 Hook: NSProtocolFromString
==============================================================================*/

Protocol * NSProtocolFromString(NSString *namestr);

%hookf(Protocol *, NSProtocolFromString, NSString *namestr){
    Protocol* origRetProtocol = %orig;
    iosLogInfo("namestr=%{public}@ -> origRetProtocol=%{public}@", namestr, origRetProtocol);
    return origRetProtocol;
}

/*==============================================================================
 Hook: objc_copyImageNames
==============================================================================*/

//const char * _Nonnull * objc_copyImageNames(unsigned int *outCount);
const char ** objc_copyImageNames(unsigned int *outCount);

%hookf(const char **, objc_copyImageNames, unsigned int *outCount){
    iosLogInfo("outCount=%p", outCount);
    const char** imageList = %orig(outCount);
    iosLogInfo("*outCount=%d, imageList=%p", *outCount, imageList);
    if (cfgHookEnable_aweme) {
        // TODO: add support

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

/*==============================================================================
 Hook: debugging embedded.mobileprovision
==============================================================================*/

// NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
%hook NSBundle

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext {
    NSString* resPath = %orig(name, ext);

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

// https://developer.apple.com/documentation/foundation/nsbundle/1407973-bundlepath
// @property(readonly, copy) NSString *bundlePath;

- (NSString *)bundlePath {
    NSString* origBundlePath = %orig;
    BOOL shouldOmit = [origBundlePath containsString: @"Aweme"] || [origBundlePath containsString: @"/System/Library"];
    if (!shouldOmit){
        iosLogInfo("origBundlePath=%{public}@", origBundlePath);
    }
    return origBundlePath;
}

%end

///*==============================================================================
// Hook: strcmp
//==============================================================================*/
//
//int strcmp(const char *s1, const char *s2);
//
//// NOTE: !!! will cause app (libsubstitute.dylib`SubHookFunction) crash
//%hookf(int, strcmp, const char *s1, const char *s2){
////    bool isJbLib1 = isJailbreakDylib(s1);
////    if (isJbLib1) {
////        iosLogInfo("isJbPath for s1=%{public}s", s1);
////    }
////
////    bool isJbLib2 = isJailbreakDylib(s2);
////    if (isJbLib2) {
////        iosLogInfo("isJbPath for s2=%{public}s", s2);
////    }
//    int cmpRet = %orig;
//    iosLogInfo("s1=%{public}s,s2=%{public}s -> cmpRet=%d", s1, s2, cmpRet);
//    return cmpRet;
//}


///*==============================================================================
// objc_getClass
//==============================================================================*/
//
////Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//// https://developer.apple.com/documentation/objectivec/1418952-objc_getclass?language=objc
////id objc_getClass(const char *name);
///// Xcode Error: Functions that differ only in their return type cannot be overloaded
///// Run Error: SubstituteLog: SubHookFunction: substitute_hook_functions returned SUBSTITUTE_ERR_FUNC_BAD_INSN_AT_START (0x1921defe0)
//
//%hookf(id, objc_getClass, const char *name){
//    id origClass = %orig;
//    iosLogInfo("name=%s -> origClass=%{public}@", name, origClass);
//    return origClass;
//}

/*==============================================================================
 LSApplicationProxy
==============================================================================*/

%hook LSApplicationProxy

-(NSString *)itemName {
    NSString* origItemName = %orig;
    iosLogInfo("origItemName=%{public}@", origItemName);
    return origItemName;
}

-(NSString *)vendorName {
    NSString* origVendorName = %orig;
    iosLogInfo("origVendorName=%{public}@", origVendorName);
    return origVendorName;
}

-(NSString *)localizedName {
    NSString* origLocalizedName = %orig;
    iosLogInfo("origLocalizedName=%{public}@", origLocalizedName);
    return origLocalizedName;
}

-(NSString *)localizedShortName {
    NSString* origLocalizedShortName = %orig;
    iosLogInfo("origLocalizedShortName=%{public}@", origLocalizedShortName);
    return origLocalizedShortName;
}

-(id)localizedNameForContext:(id)arg1 {
    id origNameForContext = %orig;
    iosLogInfo("arg1=%@ -> origNameForContext=%@", arg1, origNameForContext);
    return origNameForContext;
}

-(id)localizedNameForContext:(id)arg1 preferredLocalizations:(id)arg2{
    id origNameForContext = %orig;
    iosLogInfo("arg1=%@,arg2=%@ -> origNameForContext=%@", arg1, arg2, origNameForContext);
    return origNameForContext;
}

-(id)localizedNameForContext:(id)arg1 preferredLocalizations:(id)arg2 useShortNameOnly:(BOOL)arg3 {
    id origNameForContext = %orig;
    iosLogInfo("arg1=%@,arg2=%@,arg3=%s -> origNameForContext=%@", arg1, arg2, boolToStr(arg3), origNameForContext);
    return origNameForContext;
}

%end

/*==============================================================================
 LSApplicationWorkspace
==============================================================================*/

%hook LSApplicationWorkspace

+(instancetype)defaultWorkspace {
    id defWorkspace = %orig;
    iosLogInfo("defWorkspace=%{public}@", defWorkspace);
    return defWorkspace;
}

-(NSArray <LSApplicationProxy *> *)allApplications{
    NSArray <LSApplicationProxy *> * allAppList = %orig;
    iosLogInfo("allAppList=%{public}@", allAppList);
    return allAppList;
}

-(NSArray <LSApplicationProxy *> *)allInstalledApplications{
    NSArray <LSApplicationProxy *> * allInstalledAppList = %orig;
    iosLogInfo("allInstalledAppList=%{public}@", allInstalledAppList);
    return allInstalledAppList;
}

-(NSArray <LSApplicationProxy *> *)directionsApplications{
    NSArray <LSApplicationProxy *> * directionsAppList = %orig;
    iosLogInfo("directionsAppList=%{public}@", directionsAppList);
    return directionsAppList;
}

-(NSArray <LSApplicationProxy *> *)unrestrictedApplications{
    NSArray <LSApplicationProxy *> * unrestrictedAppList = %orig;
    iosLogInfo("unrestrictedAppList=%{public}@", unrestrictedAppList);
    return unrestrictedAppList;
}


- (NSArray <NSString *> *)installedApplications{
    NSArray <NSString *> * allAppStrList = %orig;
    iosLogInfo("allAppStrList=%{public}@", allAppStrList);
    return allAppStrList;
}

%end

/*==============================================================================
 FBApplicationInfo
==============================================================================*/

%hook FBApplicationInfo

-(NSDictionary *)environmentVariables{
    NSDictionary* allEnvVarList = %orig;
    iosLogInfo("allEnvVarList=%{public}@", allEnvVarList);
    return allEnvVarList;
}

%end

/*==============================================================================
 NSDictionary
==============================================================================*/

%hook NSDictionary

//+ (NSDictionary<NSString *,ObjectType> *)dictionaryWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable *)error{
//    NSDictionary<NSString *,ObjectType>* origDict = %orig;
+ (NSDictionary<NSString *, id> *)dictionaryWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable *)error{
    NSDictionary<NSString *, id>* origDict = %orig;
    iosLogInfo("url=%{public}@ -> origDict=%{public}@", url, origDict);
    return origDict;
}

%end


/*==============================================================================
 posix_spawn
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/posix_spawn.2.html
//int posix_spawn(pid_t *restrict pid, const char *restrict path,
//    const posix_spawn_file_actions_t *file_actions,
//    const posix_spawnattr_t *restrict attrp, char *const argv[restrict],
//    char *const envp[restrict]);
//
//%hookf(int, posix_spawn, pid_t *restrict pid, const char *restrict path,
//       const posix_spawn_file_actions_t *file_actions,
//       const posix_spawnattr_t *restrict attrp, char *const argv[restrict],
//       char *const envp[restrict]){
int posix_spawn(pid_t* pid, const char* path, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t* attrp, char *const argv[], char *const envp[]);

%hookf(int, posix_spawn, pid_t* pid, const char* path, const posix_spawn_file_actions_t* file_actions, const posix_spawnattr_t* attrp, char *const argv[], char *const envp[]){
    int spawnRet = %orig;
    iosLogInfo("pid=%p,path=%{public}s,file_actions=%p,attrp=%p,argv=%p,envp=%p -> spawnRet=%d", pid, path, file_actions, attrp, argv, envp, spawnRet);
    return spawnRet;
}


/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_misc=%s", "misc ctor", boolToStr(cfgHookEnable_misc));
    }
}

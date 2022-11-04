#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_dylib.xm"






#import <os/log.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <stdlib.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"











void* generateHookedDladdrAddress(void *origAddr);

const long DLADDR_HOOKED_ADDRESS_BASE = 0xF00000000000;


void* generateHookedDladdrAddress(void *origAddr) {

    void* hookedAddr = origAddr;
    if ((long)origAddr > (long)DLADDR_HOOKED_ADDRESS_BASE) {
        hookedAddr = origAddr;
    } else {
        hookedAddr = (void*)((long)origAddr + DLADDR_HOOKED_ADDRESS_BASE);
    }
    return hookedAddr;
}

static bool isHookedDladdrAddress(const void *addr){
    bool isHookedAddr = false;
    long addrLong = (long) addr;

    if (addrLong > DLADDR_HOOKED_ADDRESS_BASE) {
        isHookedAddr = true;
    }

    return isHookedAddr;
}

static void* hookedToOrigDladdrAddr(const void *hookedAddr){
    return (void*) ( (long)hookedAddr - DLADDR_HOOKED_ADDRESS_BASE );
}

int dladdr(const void *, Dl_info *);





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




#line 63 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_dylib.xm"
__unused static int (*_logos_orig$_ungrouped$dladdr)(const void *addr, Dl_info *info); __unused static int _logos_function$_ungrouped$dladdr(const void *addr, Dl_info *info){
    iosLogDebug("addr=%p,info=%p", addr, info);
    int finalRet = DLADDR_FAILED;

    if (NULL == addr) {
        iosLogInfo("addr is %s", "NULL");
    } else {
        void* origAddr = (void*)addr;

        bool isHookedAddr = isHookedDladdrAddress(addr);
        if (isHookedAddr) {
            origAddr = hookedToOrigDladdrAddr(addr);

            iosLogDebug("addr=%p -> isHookedAddr=%s -> origAddr=%p", addr, boolToStr(isHookedAddr), origAddr);
            
            if (NULL == origAddr) {
                iosLogInfo("addr=%p -> isHookedAddr=%s -> origAddr=%p", addr, boolToStr(isHookedAddr), origAddr);
            }
        }
        
    

        






        int origRet = _logos_orig$_ungrouped$dladdr(origAddr, info);
        finalRet = origRet;

        bool isNotHookedAddr = !isHookedAddr;
        bool isNeedHook = cfgHookEnable_dylib_dladdr && isNotHookedAddr;
        if (isNeedHook) {
            
            if (DLADDR_FAILED != origRet) {
                if (NULL != info) {
                    const char* curImageName = info->dli_fname;
                    bool isJbDyib = isJailbreakDylib(curImageName);
                    if (isJbDyib) {
                        finalRet = DLADDR_FAILED;

                        iosLogInfo("addr=%p -> origRet=%d -> dli_fname=%{public}s, dli_fbase=%p, dli_sname=%{public}s, dli_saddr=%p -> isJbDyib=%s -> finalRet=%d", addr, origRet, info->dli_fname, info->dli_fbase, info->dli_sname, info->dli_saddr, boolToStr(isJbDyib), finalRet);
    
    
    
    

                        size_t dlInfoSize = sizeof(Dl_info);
                        memset(info, 0, dlInfoSize);
                    }
                }
            }
        }
    }

    return finalRet;
}














void* dlsym(void* handle, const char* symbol);

__unused static void* (*_logos_orig$_ungrouped$dlsym)(void* handle, const char* symbol); __unused static void* _logos_function$_ungrouped$dlsym(void* handle, const char* symbol) {
    iosLogDebug("handle=%p, symbol=%{public}s", handle, symbol);
    void* dlsymRetPtr = NULL;

    if (cfgHookEnable_dylib) {
        bool shouldHook = false;
        bool isJbFuncName = isJailbreakDylibFunctionName(symbol);
        bool isPtrace = 0 == strcmp(symbol, "ptrace");
        shouldHook = isJbFuncName || isPtrace;
        iosLogDebug("isPtrace=%s, shouldHook=%s", boolToStr(isPtrace), boolToStr(shouldHook));
    
        if (shouldHook) {
            dlsymRetPtr = NULL;
        } else {

            dlsymRetPtr = _logos_orig$_ungrouped$dlsym(handle, symbol);
        }

    
        if (shouldHook) {
    
            iosLogInfo("handle=%p, symbol=%{public}s -> isJbFuncName=%s, isPtrace=%s -> shouldHook=%s -> dlsymRetPtr=%p", handle, symbol, boolToStr(isJbFuncName), boolToStr(isPtrace), boolToStr(shouldHook), dlsymRetPtr);
        }
    } else {

        dlsymRetPtr = _logos_orig$_ungrouped$dlsym(handle, symbol);
    }

    return dlsymRetPtr;
}





void* dlopen(const char* path, int mode);

__unused static void* (*_logos_orig$_ungrouped$dlopen)(const char* path, int mode); __unused static void* _logos_function$_ungrouped$dlopen(const char* path, int mode){
    iosLogDebug("path=%{public}s, mode=0x%x", path, mode);
    void* dlopenRetPtr = NULL;

    if (cfgHookEnable_dylib) {
        bool isJbDylib = isJailbreakDylib(path);
        if (isJbDylib) {
            dlopenRetPtr = NULL;
        } else {

            dlopenRetPtr = _logos_orig$_ungrouped$dlopen(path, mode);
        }

        if (isJbDylib) {
            iosLogInfo("path=%{public}s, mode=0x%x -> isJbDylib=%s -> dlopenRetPtr=%p", path, mode, boolToStr(isJbDylib), dlopenRetPtr);
        }
    } else {

        dlopenRetPtr = _logos_orig$_ungrouped$dlopen(path, mode);
    }

    return dlopenRetPtr;
}

















bool dlopen_preflight(const char* path);

__unused static bool (*_logos_orig$_ungrouped$dlopen_preflight)(const char* path); __unused static bool _logos_function$_ungrouped$dlopen_preflight(const char* path){
    bool isPreLoadOk = _logos_orig$_ungrouped$dlopen_preflight(path);
    iosLogInfo("path=%{public}s -> isPreLoadOk=%s", path, boolToStr(isPreLoadOk));
    return isPreLoadOk;
}





int dlclose(void* handle);

__unused static int (*_logos_orig$_ungrouped$dlclose)(void* handle); __unused static int _logos_function$_ungrouped$dlclose(void* handle){
    bool isJbLib = false;

    Dl_info info;
    size_t dlInfoSize = sizeof(Dl_info);
    memset(&info, 0, dlInfoSize);


    void* hookedAddr = generateHookedDladdrAddress(handle);
    dladdr(hookedAddr, &info);

    const char* curImgName = info.dli_fname;
    if(curImgName != NULL) {
        isJbLib = isJailbreakDylib(curImgName);
    }

    if (isJbLib) {
        iosLogInfo("handle=%p -> is jb lib: %s", handle, curImgName);
    }

    int closeRet = _logos_orig$_ungrouped$dlclose(handle);
    iosLogInfo("handle=%p -> closeRet=%d", handle, closeRet);
    return closeRet;
}


































































static __attribute__((constructor)) void _logosLocalCtor_432aca3a(int __unused argc, char __unused **argv, char __unused **envp)
{
	@autoreleasepool
	{
		iosLogInfo("%s, cfgHookEnable_dylib=%s, cfgHookEnable_dylib_dladdr=%s", "dylib ctor", boolToStr(cfgHookEnable_dylib), boolToStr(cfgHookEnable_dylib_dladdr));

        
        














	}
}
static __attribute__((constructor)) void _logosLocalInit() {
{void * _logos_symbol$_ungrouped$dladdr = (void *)dladdr; MSHookFunction((void *)_logos_symbol$_ungrouped$dladdr, (void *)&_logos_function$_ungrouped$dladdr, (void **)&_logos_orig$_ungrouped$dladdr);void * _logos_symbol$_ungrouped$dlsym = (void *)dlsym; MSHookFunction((void *)_logos_symbol$_ungrouped$dlsym, (void *)&_logos_function$_ungrouped$dlsym, (void **)&_logos_orig$_ungrouped$dlsym);void * _logos_symbol$_ungrouped$dlopen = (void *)dlopen; MSHookFunction((void *)_logos_symbol$_ungrouped$dlopen, (void *)&_logos_function$_ungrouped$dlopen, (void **)&_logos_orig$_ungrouped$dlopen);void * _logos_symbol$_ungrouped$dlopen_preflight = (void *)dlopen_preflight; MSHookFunction((void *)_logos_symbol$_ungrouped$dlopen_preflight, (void *)&_logos_function$_ungrouped$dlopen_preflight, (void **)&_logos_orig$_ungrouped$dlopen_preflight);void * _logos_symbol$_ungrouped$dlclose = (void *)dlclose; MSHookFunction((void *)_logos_symbol$_ungrouped$dlclose, (void *)&_logos_function$_ungrouped$dlclose, (void **)&_logos_orig$_ungrouped$dlclose);} }
#line 343 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_dylib.xm"

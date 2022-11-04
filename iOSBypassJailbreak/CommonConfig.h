//
//  CommonConfig.h
//  iOSBypassJailbreak
//
//  Created by crifan on 2022/11/04.
//

#ifndef CommonConfig_h
#define CommonConfig_h

/*==============================================================================
    Global Config
==============================================================================*/

// TODO: NOTE: when release == NOT use XCode debug, should disable this macro !!!
// UPDATE: 20220328 when debug Aweme NOT crash, seem not need this macro !
// when XCode+MonkeyDev debugging Aweme, some hook will crash, so need disable these hook
//#define XCODE_DEBUG

// release to other for test
// when release to other: disable all log, (tmp) disable all dylib function
//#define FOR_RELEASE

/*==============================================================================
    Define
==============================================================================*/

#ifdef FOR_RELEASE
#define EXPIRED_TIME_STR "2022-11-04 12:00:00"

#define DISABLE_ALL_IOS_LOG     1

#endif

/*==============================================================================
    Exported Gobal Variable
==============================================================================*/

// Note: all following variable are init inside hook_init.xm

// global
extern bool cfgHookEnable;

/* ---------- Bypass Jailbreak Detection related ---------- */

// modules
extern bool cfgHookEnable_aweme;
extern bool cfgHookEnable_dyld;
extern bool cfgHookEnable_dylib;
extern bool cfgHookEnable_misc;
extern bool cfgHookEnable_macho;
extern bool cfgHookEnable_openFileC;
extern bool cfgHookEnable_openFileiOS;
extern bool cfgHookEnable_syscall;
extern bool cfgHookEnable_writeFileiOS;

// dylib sub functions
extern bool cfgHookEnable_dylib_dladdr;

// openFileC sub functions
extern bool cfgHookEnable_openFileC_open;
extern bool cfgHookEnable_openFileC_fopen;
extern bool cfgHookEnable_openFileC_faccessat;
extern bool cfgHookEnable_openFileC___opendir2;

/* ---------- Common Part related ---------- */

extern bool cfgHookEnable_sysctl;

// sysctl sub functions
extern bool cfgHookEnable_sysctl_sysctl;

/*=======================================
    hook_dyld.xm
=======================================

==============================================================================*/

// use simple hook
//const bool cfgDyldUseSimpleHook = false;
//const bool cfgDyldUseSimpleHook = true;

enum DyldHookType {
    DYLD_HOOK_COMPLEX,
    DYLD_HOOK_SIMPLE_NULL, // return NULL
    DYLD_HOOK_SIMPLE_FIRST, // return first one, normally is app self
    DYLD_HOOK_SIMPLE_RANDOM_NAME, // return randome dylib name
};

//const enum DyldHookType cfgCurDyldHookType = DYLD_HOOK_SIMPLE_FIRST;
//const enum DyldHookType cfgCurDyldHookType = DYLD_HOOK_SIMPLE_RANDOM_NAME;
const enum DyldHookType cfgCurDyldHookType = DYLD_HOOK_COMPLEX;

// for normal iPhone, valid image index should be around 100~300, so here 1000 is enought
const int IMAGE_INDEX_MAX_VALID_NUMBER = 1000;
// just a little large is ok
//const int IMAGE_INDEX_FAKE_START = 10000;
// just change to another large value -> not be easy gussed out
// const int IMAGE_INDEX_FAKE_START = 20000;
// such as < 32768, use 30000, or more trick one: 29000
// const int IMAGE_INDEX_FAKE_START = 30000;
const int IMAGE_INDEX_FAKE_START = 28000;

 // const int IMAGE_INDEX_MAX_JAILBREAK = 100;
const int IMAGE_INDEX_MAX_JAILBREAK = 50;

#endif /* CommonConfig_h */

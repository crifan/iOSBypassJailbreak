/*
 File: hook_init.xm
 Function: iOS tweak global init
 Author: Crifan Li
*/

#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"

/*==============================================================================
    Const
==============================================================================*/

/*==============================================================================
    Gobal Variable
==============================================================================*/

// all module
bool cfgHookEnable = true;

/* ---------- Bypass Jailbreak Detection related ---------- */

// sub module: aweme
bool cfgHookEnable_aweme = true;

// sub module: dyld
bool cfgHookEnable_dyld = true;

// sub module: dylib
bool cfgHookEnable_dylib = true;

// sub module dylib sub functions
bool cfgHookEnable_dylib_dladdr = true;
//for debug
//bool cfgHookEnable_dylib_dladdr = false;

// sub module: misc
bool cfgHookEnable_misc = true;

// sub module: mach-o
bool cfgHookEnable_macho = true;
//// for debug
//bool cfgHookEnable_macho = false;

// sub module: openFile_C
bool cfgHookEnable_openFileC = true;
// sub module openFile_C sub functions

bool cfgHookEnable_openFileC_open = true;
//// for debug
//bool cfgHookEnable_openFileC_open = false;

bool cfgHookEnable_openFileC_fopen = true;
bool cfgHookEnable_openFileC_faccessat = true;
bool cfgHookEnable_openFileC___opendir2 = true;

// sub module: openFile_iOS
bool cfgHookEnable_openFileiOS = true;

// sub module: syscall
bool cfgHookEnable_syscall = true;

// SPECIAL:

// enable hook module: writeFile_iOS
//bool cfgHookEnable_writeFileiOS = true;

// Note: actually jailbreak and non-jailbreak iOS, both can NOT write, so no need hook here
// is enbable hook, should: add return related (like 513) error NSError
// otherwise jailbreak check returned error, will find iOS is jailbreaked
bool cfgHookEnable_writeFileiOS = false;

/* ---------- Common Part related ---------- */

// sub module: sysctl
bool cfgHookEnable_sysctl = true;
// sub module sysctl sub functions
bool cfgHookEnable_sysctl_sysctl = true;

/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
	@autoreleasepool
	{
		iosLogInfo("%s", "Init ctor");
        
#ifdef FOR_RELEASE
        bool isExpired = isTimeExpired(EXPIRED_TIME_STR);
        iosLogInfo("EXPIRED_TIME_STR=%s -> isExpired=%s", EXPIRED_TIME_STR, boolToStr(isExpired)); // isExpired=True
        if (isExpired) {
            cfgHookEnable = false;
        }
#endif
        iosLogInfo("cfgHookEnable=%s", boolToStr(cfgHookEnable));

        if (cfgHookEnable) {
            // init random for later call randomStr
            initRandomChar();
            iosLogInfo("%s", "inited random char");
            
            // SPECIAL
            cfgHookEnable_writeFileiOS = false;
        } else {
            // Bypass Jailbreak Detection related
            cfgHookEnable_aweme = false;
            cfgHookEnable_dyld = false;
            cfgHookEnable_dylib = false;
            cfgHookEnable_misc = false;
            cfgHookEnable_macho = false;
            cfgHookEnable_openFileC = false;
            cfgHookEnable_openFileiOS = false;
            cfgHookEnable_syscall = false;

            // SPECIAL
            cfgHookEnable_writeFileiOS = false;
            
            // Common Part related
        }
        
        if (false == cfgHookEnable_openFileC) {
            cfgHookEnable_openFileC_open = false;
            cfgHookEnable_openFileC_fopen = false;
            cfgHookEnable_openFileC_faccessat = false;
            cfgHookEnable_openFileC___opendir2 = false;
        }

        if (false == cfgHookEnable_dylib) {
            cfgHookEnable_dylib_dladdr = false;
        }

        if (false == cfgHookEnable_sysctl) {
            cfgHookEnable_sysctl_sysctl = false;
        }

	}
}

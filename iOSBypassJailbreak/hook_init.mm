#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_init.xm"






#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"










bool cfgHookEnable = true;




bool cfgHookEnable_aweme = true;


bool cfgHookEnable_dyld = true;


bool cfgHookEnable_dylib = true;


bool cfgHookEnable_dylib_dladdr = true;




bool cfgHookEnable_misc = true;


bool cfgHookEnable_macho = true;




bool cfgHookEnable_openFileC = true;


bool cfgHookEnable_openFileC_open = true;



bool cfgHookEnable_openFileC_fopen = true;
bool cfgHookEnable_openFileC_faccessat = true;
bool cfgHookEnable_openFileC___opendir2 = true;


bool cfgHookEnable_openFileiOS = true;


bool cfgHookEnable_syscall = true;









bool cfgHookEnable_writeFileiOS = false;




bool cfgHookEnable_sysctl = true;

bool cfgHookEnable_sysctl_sysctl = true;





static __attribute__((constructor)) void _logosLocalCtor_93db85ed(int __unused argc, char __unused **argv, char __unused **envp)
{
	@autoreleasepool
	{
		iosLogInfo("%s", "Init ctor");
        
#ifdef FOR_RELEASE
        bool isExpired = isTimeExpired(EXPIRED_TIME_STR);
        iosLogInfo("EXPIRED_TIME_STR=%s -> isExpired=%s", EXPIRED_TIME_STR, boolToStr(isExpired)); 
        if (isExpired) {
            cfgHookEnable = false;
        }
#endif
        iosLogInfo("cfgHookEnable=%s", boolToStr(cfgHookEnable));

        if (cfgHookEnable) {
            
            initRandomChar();
            iosLogInfo("%s", "inited random char");
            
            
            cfgHookEnable_writeFileiOS = false;
        } else {
            
            cfgHookEnable_aweme = false;
            cfgHookEnable_dyld = false;
            cfgHookEnable_dylib = false;
            cfgHookEnable_misc = false;
            cfgHookEnable_macho = false;
            cfgHookEnable_openFileC = false;
            cfgHookEnable_openFileiOS = false;
            cfgHookEnable_syscall = false;

            
            cfgHookEnable_writeFileiOS = false;
            
            
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

#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_sysctl.xm"






#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/errno.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"





int sysctl(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen);


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




#line 21 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_sysctl.xm"
__unused static int (*_logos_orig$_ungrouped$sysctl)(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen); __unused static int _logos_function$_ungrouped$sysctl(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen){
    iosLogDebug("name=%p, namelen=%d, oldp=%p, oldlenp=%p, newp=%p, newlen=%ld", name, namelen, oldp, oldlenp, newp, newlen);



	int sysctlRet = _logos_orig$_ungrouped$sysctl(name, namelen, oldp, oldlenp, newp, newlen);

	if (cfgHookEnable_sysctl_sysctl) {
		
		bool isGetpid = (name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID);
		if (isGetpid) {
			struct kinfo_proc *info = NULL;
			info = (struct kinfo_proc *)oldp;
			int oldPFlag = info->kp_proc.p_flag;
			info->kp_proc.p_flag &= ~(P_TRACED);
			int newPFlag = info->kp_proc.p_flag;

			iosLogInfo("name=%p, namelen=%d, oldp=%p, oldlenp=%p, newp=%p, newlen=%ld -> isGetpid=%s -> oldPFlag=0x%x, newPFlag=0x%x -> sysctlRet=%d", name, namelen, oldp, oldlenp, newp, newlen, boolToStr(isGetpid), oldPFlag, newPFlag, sysctlRet);
		}
	}

	return sysctlRet;
}






int sysctlnametomib(const char *name, int *mibp, size_t *sizep);

__unused static int (*_logos_orig$_ungrouped$sysctlnametomib)(const char *name, int *mibp, size_t *sizep); __unused static int _logos_function$_ungrouped$sysctlnametomib(const char *name, int *mibp, size_t *sizep){

    int retInt = SYSCTL_FAIL;
    retInt = _logos_orig$_ungrouped$sysctlnametomib(name, mibp, sizep);
    iosLogInfo("name=%{public}s, mibp=%p, sizep=%p -> retInt=%d", name, mibp, sizep, retInt);
    return retInt;
}





static __attribute__((constructor)) void _logosLocalCtor_03afdbd6(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_sysctl=%s, cfgHookEnable_sysctl_sysctl=%s", "sysctl ctor", boolToStr(cfgHookEnable_sysctl), boolToStr(cfgHookEnable_sysctl_sysctl));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{void * _logos_symbol$_ungrouped$sysctl = (void *)sysctl; MSHookFunction((void *)_logos_symbol$_ungrouped$sysctl, (void *)&_logos_function$_ungrouped$sysctl, (void **)&_logos_orig$_ungrouped$sysctl);void * _logos_symbol$_ungrouped$sysctlnametomib = (void *)sysctlnametomib; MSHookFunction((void *)_logos_symbol$_ungrouped$sysctlnametomib, (void *)&_logos_function$_ungrouped$sysctlnametomib, (void **)&_logos_orig$_ungrouped$sysctlnametomib);} }
#line 71 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_sysctl.xm"

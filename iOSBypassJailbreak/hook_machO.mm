#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_machO.xm"






#import "mach-o/getsect.h"
#import <dlfcn.h>
#import <mach-o/dyld.h>

#import "objc/runtime.h"

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

extern void* generateHookedDladdrAddress(void *origAddr);









uint8_t* getsegmentdata(const struct mach_header_64 *mhp, const char *segname, unsigned long *size);


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




#line 30 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_machO.xm"
__unused static uint8_t* (*_logos_orig$_ungrouped$getsegmentdata)(const struct mach_header_64 *mhp, const char *segname, unsigned long *size); __unused static uint8_t* _logos_function$_ungrouped$getsegmentdata(const struct mach_header_64 *mhp, const char *segname, unsigned long *size){

    uint8_t* retSegData = _logos_orig$_ungrouped$getsegmentdata(mhp, segname, size);

    return retSegData;
}





const struct section_64* getsectbyname(const char *segname, const char *sectname);

__unused static const struct section_64* (*_logos_orig$_ungrouped$getsectbyname)(const char *segname, const char *sectname); __unused static const struct section_64* _logos_function$_ungrouped$getsectbyname(const char *segname, const char *sectname){
	const struct section_64* retSection = _logos_orig$_ungrouped$getsectbyname(segname, sectname);
	iosLogInfo("segname=%{public}s,sectname=%{public}s -> retSection=%p", segname, sectname, retSection);
	return retSection;
}





const struct segment_command_64* getsegbyname(const char *segname);

__unused static const struct segment_command_64* (*_logos_orig$_ungrouped$getsegbyname)(const char *segname); __unused static const struct segment_command_64* _logos_function$_ungrouped$getsegbyname(const char *segname){
	const struct segment_command_64* retSegCmd = _logos_orig$_ungrouped$getsegbyname(segname);
	iosLogInfo("segname=%{public}s -> retSegCmd=%p", segname, retSegCmd);
	return retSegCmd;
}





const struct section* getsectbynamefromheaderwithswap_64(struct mach_header_64 *mhp, const char *segname, const char *sectname, int fSwap);

__unused static const struct section* (*_logos_orig$_ungrouped$getsectbynamefromheaderwithswap_64)(struct mach_header_64 *mhp, const char *segname, const char *sectname, int fSwap); __unused static const struct section* _logos_function$_ungrouped$getsectbynamefromheaderwithswap_64(struct mach_header_64 *mhp, const char *segname, const char *sectname, int fSwap){
    const struct section* retSection = _logos_orig$_ungrouped$getsectbynamefromheaderwithswap_64(mhp, segname, sectname, fSwap);
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,fSwap=%d -> retSection=%p", mhp, segname, sectname, fSwap, retSection);
    return retSection;
}





extern char* getsectdata(const char *segname, const char *sectname, unsigned long *size);

__unused static char* (*_logos_orig$_ungrouped$getsectdata)(const char *segname, const char *sectname, unsigned long *size); __unused static char* _logos_function$_ungrouped$getsectdata(const char *segname, const char *sectname, unsigned long *size){
    char* sectDataStr = _logos_orig$_ungrouped$getsectdata(segname, sectname, size);
    iosLogInfo("segname=%{public}s,sectname=%{public}s,*size=%lu -> sectDataStr=%s", segname, sectname, *size, sectDataStr);
    return sectDataStr;
}





char* getsectdatafromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname, uint64_t *size);

__unused static char* (*_logos_orig$_ungrouped$getsectdatafromheader_64)(const struct mach_header_64 *mhp, const char *segname, const char *sectname, uint64_t *size); __unused static char* _logos_function$_ungrouped$getsectdatafromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname, uint64_t *size){
    char* retSectDataStr = _logos_orig$_ungrouped$getsectdatafromheader_64(mhp, segname, sectname, size);
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,*size=%llu -> retSectData=%{public}s", mhp, segname, sectname, *size, retSectDataStr);
    return retSectDataStr;
}





char* getsectdatafromFramework(const char *FrameworkName, const char *segname, const char *sectname, unsigned long *size);

__unused static char * (*_logos_orig$_ungrouped$getsectdatafromFramework)(const char *FrameworkName, const char *segname, const char *sectname, unsigned long *size); __unused static char * _logos_function$_ungrouped$getsectdatafromFramework(const char *FrameworkName, const char *segname, const char *sectname, unsigned long *size){
    char* sectDataFrameworkStr = _logos_orig$_ungrouped$getsectdatafromFramework(FrameworkName, segname, sectname, size);
    iosLogInfo("FrameworkName=%{public}s,segname=%{public}s,sectname=%{public}s,*size=%lu -> sectDataFrameworkStr=%s", FrameworkName, segname, sectname, *size, sectDataFrameworkStr);
    return sectDataFrameworkStr;
}






const struct section* getsectbynamefromheader(const struct mach_header *mhp, const char *segname, const char *sectname);

__unused static const struct section* (*_logos_orig$_ungrouped$getsectbynamefromheader)(const struct mach_header *mhp, const char *segname, const char *sectname); __unused static const struct section* _logos_function$_ungrouped$getsectbynamefromheader(const struct mach_header *mhp, const char *segname, const char *sectname){
    const struct section* retSection = _logos_orig$_ungrouped$getsectbynamefromheader(mhp, segname, sectname);
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s -> retSection=%p", mhp, segname, sectname, retSection);
    return retSection;
}

const struct section_64* getsectbynamefromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname);

__unused static const struct section_64 * (*_logos_orig$_ungrouped$getsectbynamefromheader_64)(const struct mach_header_64 *mhp, const char *segname, const char *sectname); __unused static const struct section_64 * _logos_function$_ungrouped$getsectbynamefromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname){
	const struct section_64* retSection64 = _logos_orig$_ungrouped$getsectbynamefromheader_64(mhp, segname, sectname);
    
	bool isJbLib = false;

	Dl_info info;
	size_t dlInfoSize = sizeof(Dl_info);
	memset(&info, 0, dlInfoSize);
	

	void* hookedAddr = generateHookedDladdrAddress((void*)mhp);
	dladdr(hookedAddr, &info);

	const char* curImgName = info.dli_fname;
	if(curImgName != NULL) {
		isJbLib = isJailbreakDylib(curImgName);
	}

	if (isJbLib) {
		iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s -> retSection64=%p -> isJbLib=%s", mhp, segname, sectname, retSection64, boolToStr(isJbLib));
		retSection64 = NULL;
    } else {
        iosLogDebug("mhp=%p,segname=%{public}s,sectname=%{public}s -> retSection64=%p", mhp, segname, sectname, retSection64);
    }

	return retSection64;
}





extern uint8_t *getsectiondata(
	const struct mach_header_64 *mhp,
	const char *segname,
	const char *sectname,
	unsigned long *size);







__unused static uint8_t* (*_logos_orig$_ungrouped$getsectiondata)(const struct mach_header_64 *mhp, const char *segname, const char *sectname, unsigned long *size); __unused static uint8_t* _logos_function$_ungrouped$getsectiondata(const struct mach_header_64 *mhp, const char *segname, const char *sectname, unsigned long *size){
	iosLogDebug("mhp=%p,segname=%{public}s,sectname=%{public}s,size=%p", mhp, segname, sectname, size);

	uint8_t* origRetIntP = _logos_orig$_ungrouped$getsectiondata(mhp, segname, sectname, size);
	
	if (cfgHookEnable_macho) {
		bool isJbLib = false;
		bool isShowLog = false;

		Dl_info info;
		size_t dlInfoSize = sizeof(Dl_info);
		memset(&info, 0, dlInfoSize);
		

		void* hookedAddr = generateHookedDladdrAddress((void*)mhp);
		dladdr(hookedAddr, &info);

		const char* curImgName = info.dli_fname;
		if(curImgName != NULL) {
			isJbLib = isJailbreakDylib(curImgName);
		}

		if (isJbLib) {
	
			if( size && (*size > 0) ) {
				isShowLog = true;


				


				if (
					strstr(curImgName, "AppSyncUnified") && \
					(0==strcmp(segname, "__TEXT"))

				) {
					isShowLog = false;
				}

				
				if (strstr(curImgName, "Choicy")) {
					isShowLog = false;
				}

				
				if (strstr(curImgName, "librocketbootstrap")) {
					isShowLog = false;
				}


				if (isShowLog) {
					iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,size=%p ===> *size=%lu, curImgName=%{public}s, isJbLib=%s", mhp, segname, sectname, size, size ? *size : 0, curImgName, boolToStr(isJbLib));
				}
			}
		}

		if (isJbLib) {
			origRetIntP = NULL;
			if (NULL != size) {
				*size = 0;
			}
		}

	
	
	
	
	

	
	
	
	}






	return origRetIntP;
}





static __attribute__((constructor)) void _logosLocalCtor_c24cd76e(int __unused argc, char __unused **argv, char __unused **envp)
{
	@autoreleasepool
	{
		iosLogInfo("%s, cfgHookEnable_macho=%s", "Mach-O ctor", boolToStr(cfgHookEnable_macho));
	}
}
static __attribute__((constructor)) void _logosLocalInit() {
{void * _logos_symbol$_ungrouped$getsegmentdata = (void *)getsegmentdata; MSHookFunction((void *)_logos_symbol$_ungrouped$getsegmentdata, (void *)&_logos_function$_ungrouped$getsegmentdata, (void **)&_logos_orig$_ungrouped$getsegmentdata);void * _logos_symbol$_ungrouped$getsectbyname = (void *)getsectbyname; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectbyname, (void *)&_logos_function$_ungrouped$getsectbyname, (void **)&_logos_orig$_ungrouped$getsectbyname);void * _logos_symbol$_ungrouped$getsegbyname = (void *)getsegbyname; MSHookFunction((void *)_logos_symbol$_ungrouped$getsegbyname, (void *)&_logos_function$_ungrouped$getsegbyname, (void **)&_logos_orig$_ungrouped$getsegbyname);void * _logos_symbol$_ungrouped$getsectbynamefromheaderwithswap_64 = (void *)getsectbynamefromheaderwithswap_64; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectbynamefromheaderwithswap_64, (void *)&_logos_function$_ungrouped$getsectbynamefromheaderwithswap_64, (void **)&_logos_orig$_ungrouped$getsectbynamefromheaderwithswap_64);void * _logos_symbol$_ungrouped$getsectdata = (void *)getsectdata; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectdata, (void *)&_logos_function$_ungrouped$getsectdata, (void **)&_logos_orig$_ungrouped$getsectdata);void * _logos_symbol$_ungrouped$getsectdatafromheader_64 = (void *)getsectdatafromheader_64; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectdatafromheader_64, (void *)&_logos_function$_ungrouped$getsectdatafromheader_64, (void **)&_logos_orig$_ungrouped$getsectdatafromheader_64);void * _logos_symbol$_ungrouped$getsectdatafromFramework = (void *)getsectdatafromFramework; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectdatafromFramework, (void *)&_logos_function$_ungrouped$getsectdatafromFramework, (void **)&_logos_orig$_ungrouped$getsectdatafromFramework);void * _logos_symbol$_ungrouped$getsectbynamefromheader = (void *)getsectbynamefromheader; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectbynamefromheader, (void *)&_logos_function$_ungrouped$getsectbynamefromheader, (void **)&_logos_orig$_ungrouped$getsectbynamefromheader);void * _logos_symbol$_ungrouped$getsectbynamefromheader_64 = (void *)getsectbynamefromheader_64; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectbynamefromheader_64, (void *)&_logos_function$_ungrouped$getsectbynamefromheader_64, (void **)&_logos_orig$_ungrouped$getsectbynamefromheader_64);void * _logos_symbol$_ungrouped$getsectiondata = (void *)getsectiondata; MSHookFunction((void *)_logos_symbol$_ungrouped$getsectiondata, (void *)&_logos_function$_ungrouped$getsectiondata, (void **)&_logos_orig$_ungrouped$getsectiondata);} }
#line 261 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_machO.xm"

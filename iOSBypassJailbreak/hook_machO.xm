/*
 File: hook_machO.xm
 Function: iOS tweak to hook Mach-O items
 Author: Crifan Li
*/

#import "mach-o/getsect.h"
#import <dlfcn.h>
#import <mach-o/dyld.h>

#import "objc/runtime.h"

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

extern void* generateHookedDladdrAddress(void *origAddr);

// https://opensource.apple.com/source/cctools/cctools-895/include/mach-o/getsect.h.auto.html

/*==============================================================================
 Hook: getsegbyname
==============================================================================*/

// Note: if add log, Aweme will crash

uint8_t* getsegmentdata(const struct mach_header_64 *mhp, const char *segname, unsigned long *size);

%hookf(uint8_t*, getsegmentdata, const struct mach_header_64 *mhp, const char *segname, unsigned long *size){
//    iosLogInfo("mhp=%p,segname=%{public}s,size=%p", mhp, segname, size);
    uint8_t* retSegData = %orig;
//    iosLogInfo("mhp=%p,segname=%{public}s,*size=%lu -> retSegCmd=%p", mhp, segname, *size, retSegData);
    return retSegData;
}

/*==============================================================================
 Hook: getsectdatafromFramework
==============================================================================*/

const struct section_64* getsectbyname(const char *segname, const char *sectname);

%hookf(const struct section_64*, getsectbyname, const char *segname, const char *sectname){
	const struct section_64* retSection = %orig;
	iosLogInfo("segname=%{public}s,sectname=%{public}s -> retSection=%p", segname, sectname, retSection);
	return retSection;
}

/*==============================================================================
 Hook: getsegbyname
==============================================================================*/

const struct segment_command_64* getsegbyname(const char *segname);

%hookf(const struct segment_command_64*, getsegbyname, const char *segname){
	const struct segment_command_64* retSegCmd = %orig;
	iosLogInfo("segname=%{public}s -> retSegCmd=%p", segname, retSegCmd);
	return retSegCmd;
}

/*==============================================================================
 Hook: getsectbynamefromheaderwithswap_64
==============================================================================*/

const struct section* getsectbynamefromheaderwithswap_64(struct mach_header_64 *mhp, const char *segname, const char *sectname, int fSwap);

%hookf(const struct section*, getsectbynamefromheaderwithswap_64, struct mach_header_64 *mhp, const char *segname, const char *sectname, int fSwap){
    const struct section* retSection = %orig;
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,fSwap=%d -> retSection=%p", mhp, segname, sectname, fSwap, retSection);
    return retSection;
}

/*==============================================================================
 Hook: getsectdata
==============================================================================*/

extern char* getsectdata(const char *segname, const char *sectname, unsigned long *size);

%hookf(char*, getsectdata, const char *segname, const char *sectname, unsigned long *size){
    char* sectDataStr = %orig;
    iosLogInfo("segname=%{public}s,sectname=%{public}s,*size=%lu -> sectDataStr=%s", segname, sectname, *size, sectDataStr);
    return sectDataStr;
}

/*==============================================================================
 Hook: getsectdatafromheader_64
==============================================================================*/

char* getsectdatafromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname, uint64_t *size);

%hookf(char*, getsectdatafromheader_64, const struct mach_header_64 *mhp, const char *segname, const char *sectname, uint64_t *size){
    char* retSectDataStr = %orig;
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,*size=%llu -> retSectData=%{public}s", mhp, segname, sectname, *size, retSectDataStr);
    return retSectDataStr;
}

/*==============================================================================
 Hook: getsectdatafromFramework
==============================================================================*/

char* getsectdatafromFramework(const char *FrameworkName, const char *segname, const char *sectname, unsigned long *size);

%hookf(char *, getsectdatafromFramework, const char *FrameworkName, const char *segname, const char *sectname, unsigned long *size){
    char* sectDataFrameworkStr = %orig;
    iosLogInfo("FrameworkName=%{public}s,segname=%{public}s,sectname=%{public}s,*size=%lu -> sectDataFrameworkStr=%s", FrameworkName, segname, sectname, *size, sectDataFrameworkStr);
    return sectDataFrameworkStr;
}

/*==============================================================================
 Hook: getsectbynamefromheader getsectbynamefromheader_64
==============================================================================*/

// Not found: Aweme call getsectbynamefromheader
const struct section* getsectbynamefromheader(const struct mach_header *mhp, const char *segname, const char *sectname);

%hookf(const struct section*, getsectbynamefromheader, const struct mach_header *mhp, const char *segname, const char *sectname){
    const struct section* retSection = %orig;
    iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s -> retSection=%p", mhp, segname, sectname, retSection);
    return retSection;
}

const struct section_64* getsectbynamefromheader_64(const struct mach_header_64 *mhp, const char *segname, const char *sectname);

%hookf(const struct section_64 *, getsectbynamefromheader_64, const struct mach_header_64 *mhp, const char *segname, const char *sectname){
	const struct section_64* retSection64 = %orig;
    
	bool isJbLib = false;

	Dl_info info;
	size_t dlInfoSize = sizeof(Dl_info);
	memset(&info, 0, dlInfoSize);
	
//        dladdr(mhp, &info);
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

/*==============================================================================
 Hook: getsectiondata
==============================================================================*/

extern uint8_t *getsectiondata(
	const struct mach_header_64 *mhp,
	const char *segname,
	const char *sectname,
	unsigned long *size);

//extern uint8_t *getsectiondata(
//    const struct mach_header *mhp,
//    const char *segname,
//    const char *sectname,
//    unsigned long *size);

%hookf(uint8_t*, getsectiondata, const struct mach_header_64 *mhp, const char *segname, const char *sectname, unsigned long *size){
	iosLogDebug("mhp=%p,segname=%{public}s,sectname=%{public}s,size=%p", mhp, segname, sectname, size);

	uint8_t* origRetIntP = %orig;
	
	if (cfgHookEnable_macho) {
		bool isJbLib = false;
		bool isShowLog = false;

		Dl_info info;
		size_t dlInfoSize = sizeof(Dl_info);
		memset(&info, 0, dlInfoSize);
		
//        dladdr(mhp, &info);
		void* hookedAddr = generateHookedDladdrAddress((void*)mhp);
		dladdr(hookedAddr, &info);

		const char* curImgName = info.dli_fname;
		if(curImgName != NULL) {
			isJbLib = isJailbreakDylib(curImgName);
		}

		if (isJbLib) {
	//        isShowLog = true;
			if( size && (*size > 0) ) {
				isShowLog = true;

//#ifdef XCODE_DEBUG
				// Note: MUST filter out following log, otherwise Aweme will crash

//                // getsectiondata: mhp=0x114af0000,segname=__TEXT,sectname=__swift5_replace,size=0x16fbf7df8 ===> *size=6169788088, curImgName=/Library/MobileSubstrate/DynamicLibraries/AppSyncUnified-FrontBoard.dylib, isJbLib=True
				if (
					strstr(curImgName, "AppSyncUnified") && \
					(0==strcmp(segname, "__TEXT"))
//                     ( (0==strcmp(sectname, "__swift5_replace")) || (0==strcmp(sectname, "__swift5_types")) ) \
				) {
					isShowLog = false;
				}

				// "/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib"
				if (strstr(curImgName, "Choicy")) {
					isShowLog = false;
				}

				// /usr/lib/librocketbootstrap.dylib
				if (strstr(curImgName, "librocketbootstrap")) {
					isShowLog = false;
				}
//#endif

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

	//    if (NULL != size) {
	//        if (*size > 0) {
	//            isShowLog = true;
	//        }
	//    }

	//    if (isShowLog) {
	//        iosLogInfo("mhp=%p,segname=%{public}s,sectname=%{public}s,size=%p ===> *size=%lu, curImgName=%{public}s, isJbLib=%s", mhp, segname, sectname, size, size ? *size : 0, curImgName, boolToStr(isJbLib));
	//    }
	}

//    // for debug
//    if (origRetIntP != NULL) {
//        printf("origRetIntP=%p", origRetIntP);
//    }

	return origRetIntP;
}

/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
	@autoreleasepool
	{
		iosLogInfo("%s, cfgHookEnable_macho=%s", "Mach-O ctor", boolToStr(cfgHookEnable_macho));
	}
}

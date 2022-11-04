/*
File: hook_dyld.xm
Function: iOS tweak to hook dyld related
Author: Crifan Li
*/

#import <os/log.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <stdlib.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

/*==============================================================================
Hook: _dyld_image_count(), _dyld_get_image_name(), _dyld_get_image_header(), _dyld_get_image_vmaddr_slide()
==============================================================================*/

/*
https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/dyld.3.html
   _dyld_image_count,
   _dyld_get_image_header,
   _dyld_get_image_vmaddr_slide,
   _dyld_get_image_name,
   _dyld_register_func_for_add_image,
   _dyld_register_func_for_remove_image,
   NSVersionOfRunTimeLibrary,
   NSVersionOfLinkTimeLibrary,
   _NSGetExecutablePath
*/

uint32_t _dyld_image_count(void);
//uint32_t orig__dyld_image_count(void);
//uint32_t _logos_orig$_ungrouped$_dyld_image_count(void);
//uint32_t (*_logos_orig$_ungrouped$_dyld_image_count)(void);
//static uint32_t (*_logos_orig$_ungrouped$_dyld_image_count)(void);

const struct mach_header* _dyld_get_image_header(uint32_t image_index);
const char* _dyld_get_image_name(uint32_t image_index);
intptr_t _dyld_get_image_vmaddr_slide(uint32_t image_index);

void _dyld_register_func_for_add_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide));
void _dyld_register_func_for_remove_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide));

int32_t NSVersionOfRunTimeLibrary(const char* libraryName);

int32_t NSVersionOfLinkTimeLibrary(const char* libraryName);

int _NSGetExecutablePath(char* buf, uint32_t* bufsize);

const int IMAGE_INDEX_FAKE_END = IMAGE_INDEX_FAKE_START + IMAGE_INDEX_MAX_VALID_NUMBER;

// Global Variable
int gOrigImageCount = -1;
int gHookedImageCount = -1;
int gRealOrigImageCount = -1; // after hooked, image name/header/slide got hooked image count -> so need find real original image count

int* gJbDylibIdxList = NULL;
int gJbDylibIdxListLen = -1;

int* gHookedImgIdxList = NULL;
int gHookedImgIdxListLen = -1;

static int generateFakeImageIndex(int origImageIndex){
   int fakeImgIdx = origImageIndex + IMAGE_INDEX_FAKE_START;
   iosLogDebug("generateFakeImageIndex: origImageIndex=%d -> fakeImgIdx=%d", origImageIndex, fakeImgIdx);
   return fakeImgIdx;
}

static bool isFakeImageIndex(int curImageIndex){
   bool isFakeIdx = (curImageIndex >= IMAGE_INDEX_FAKE_START) && (curImageIndex < IMAGE_INDEX_FAKE_END);
   iosLogDebug("curImageIndex=%d -> isFakeIdx=%s", curImageIndex, boolToStr(isFakeIdx));
   return isFakeIdx;
}

static int fakeToRealImageIndex(int fakeImgageIndex){
   int realImageIndex = fakeImgageIndex - IMAGE_INDEX_FAKE_START;
   iosLogDebug("fakeImgageIndex=%d -> realImageIndex=%d", fakeImgageIndex, realImageIndex);
   return realImageIndex;
}

static void dbgPrintImgIdxList(int* imgIdxList){
   iosLogDebug("imgIdxList=%p", imgIdxList);

   if (NULL != imgIdxList){
	   int curListIdx = 0;
	   int curIdxValue = DYLD_IMAGE_INDEX_INVALID;
	   curIdxValue = imgIdxList[curListIdx];
	   if (DYLD_IMAGE_INDEX_INVALID == curIdxValue) {
		   iosLogDebug("[%d] %d", curListIdx, curIdxValue);
	   }

	   while(DYLD_IMAGE_INDEX_INVALID != curIdxValue){
		   iosLogDebug("[%d] %d", curListIdx, curIdxValue);

		   ++curListIdx;
		   curIdxValue = imgIdxList[curListIdx];
	   }

	   int listCount = curListIdx;
	   iosLogDebug("end listCount=%d", listCount);
   }
}

static void getJbDylibImgIdxList(int origImageCount, int** outJbDylibIdxList,  int* jbDylibIdxListLen){
   iosLogDebug("origImageCount=%d", origImageCount);

   int intSize = sizeof(int);
   int mallocCount = IMAGE_INDEX_MAX_JAILBREAK + 1;
   int mallocSize = intSize * mallocCount;
   iosLogDebug("intSize=%d, mallocCount=%d, mallocSize=%d", intSize, mallocCount, mallocSize);

   int curListIdx = 0;

   int* jbDylibIdxList = (int *)malloc(mallocSize);
   iosLogDebug("jbDylibIdxList=%p", jbDylibIdxList);

   if (NULL != jbDylibIdxList) {
	   for (int origImgIdx = 0 ; origImgIdx < origImageCount; ++origImgIdx) {
		   int fakeImgIdx = generateFakeImageIndex(origImgIdx);
		   iosLogDebug("origImgIdx=%d, fakeImgIdx=%d", origImgIdx, fakeImgIdx);
		   const char* curImageName = _dyld_get_image_name(fakeImgIdx);
		   iosLogDebug("curImageName=%{public}s", curImageName);

		   bool isJbDylib = isJailbreakDylib(curImageName);
		   iosLogDebug("isJbDylib=%s", boolToStr(isJbDylib));

		   if(isJbDylib){
			   jbDylibIdxList[curListIdx] = origImgIdx;
			   iosLogInfo("curImageName=%{public}s -> origImgIdx=%d, jbDylibIdxList[%d]=%d", curImageName, origImgIdx, curListIdx, jbDylibIdxList[curListIdx]);
			   ++curListIdx;
		   }
	   }

	   int curListCount = curListIdx;

	   if (jbDylibIdxListLen) {
		   *jbDylibIdxListLen = curListCount;
		   iosLogDebug("*jbDylibIdxListLen=%d", *jbDylibIdxListLen);
	   }

	   int curListEndIdx = curListCount;
	   jbDylibIdxList[curListEndIdx] = DYLD_IMAGE_INDEX_INVALID;
	   iosLogDebug("list end, jbDylibIdxList[%d]=%d", curListEndIdx, jbDylibIdxList[curListEndIdx]);

	   dbgPrintImgIdxList(jbDylibIdxList);

	   if (outJbDylibIdxList) {
		   // Note: here for 0 jailbreak dylib, also means get OK
		   *outJbDylibIdxList = jbDylibIdxList;
	   }
   }

   iosLogInfo("origImageCount=%d -> outJbDylibIdxList=%p, *outJbDylibIdxList=%p, jbDylibIdxList=%p, *jbDylibIdxListLen=%d", origImageCount, outJbDylibIdxList, outJbDylibIdxList ? *outJbDylibIdxList : NULL, jbDylibIdxList, jbDylibIdxListLen ? *jbDylibIdxListLen : 0);
}

static void initDylibImageIdxList(void) {
   // init for _dyld_image_count and related
   if (cfgCurDyldHookType == DYLD_HOOK_COMPLEX){
	   getJbDylibImgIdxList(gOrigImageCount, &gJbDylibIdxList, &gJbDylibIdxListLen);
	   gHookedImageCount = gOrigImageCount - gJbDylibIdxListLen;
	   iosLogInfo("gOrigImageCount=%d, gJbDylibIdxList=%p, gJbDylibIdxListLen=%d -> gHookedImageCount=%d", gOrigImageCount, gJbDylibIdxList, gJbDylibIdxListLen, gHookedImageCount);
   }
}

static void generateHookedImageIndexList(int* jbDylibIdxList, int jbDylibIdxListLen, int origImgageCount, int** outHookedImgIdxList, int* outHookedImgIdxListLen){
   int* hookedImgIdxList = (int*)malloc(sizeof(int) * (origImgageCount + 1));
   int curListIdx = 0;
   for(int curImgIdx = 0; curImgIdx < origImgageCount; curImgIdx++){
	   bool isJbDylibIdx = false;
	   if (jbDylibIdxListLen > 0){
		   isJbDylibIdx = isIntInList(curImgIdx, jbDylibIdxList, jbDylibIdxListLen);
	   }

	   iosLogDebug("curImgIdx=%d, isJbDylibIdx=%s", curImgIdx, boolToStr(isJbDylibIdx));

	   if(!isJbDylibIdx){
		   hookedImgIdxList[curListIdx] = curImgIdx;
		   ++curListIdx;
	   }
   }

   int hookedImgIdxListLen = curListIdx;
   // set end
   int hookedImgIdxListEndIdx = hookedImgIdxListLen;
   hookedImgIdxList[hookedImgIdxListEndIdx] = DYLD_IMAGE_INDEX_INVALID;

   dbgPrintImgIdxList(hookedImgIdxList);

   // return result
   *outHookedImgIdxList = hookedImgIdxList;
   *outHookedImgIdxListLen = hookedImgIdxListLen;

   iosLogInfo("-> outHookedImgIdxList=%p, *outHookedImgIdxList=%p, *outHookedImgIdxListLen=%d", outHookedImgIdxList, *outHookedImgIdxList, *outHookedImgIdxListLen);
}

static void reInitImgCountIfNeed(int curOrigCount) {
   if (curOrigCount != gOrigImageCount) {
	   iosLogInfo("curOrigCount=%d != gOrigImageCount=%d, need init", curOrigCount, gOrigImageCount);
	   gOrigImageCount = curOrigCount;
	   initDylibImageIdxList();

	   bool foundJbLib = (NULL != gJbDylibIdxList) && (gJbDylibIdxListLen > 0);
	   if (foundJbLib) {
		   generateHookedImageIndexList(gJbDylibIdxList, gJbDylibIdxListLen, gOrigImageCount, &gHookedImgIdxList, &gHookedImgIdxListLen);
	   }
   }
}

// static int hookedToOrigImageIndex(int hookedImageIndex, int* jbDylibIdxList, int jbDylibIdxListLen, int origImgageCount){
static int hookedToOrigImageIndex(int hookedImageIndex){
   int origImgIdx = DYLD_IMAGE_INDEX_INVALID;

   // int* hookedImgIdxList = NULL;
   // int hookedImgIdxListLen = 0;
   // generateHookedImageIndexList(jbDylibIdxList, jbDylibIdxListLen, origImgageCount, &hookedImgIdxList, &hookedImgIdxListLen);

   // int hookedImgIdxListMaxIdx = hookedImgIdxListLen - 1;
   int hookedImgIdxListMaxIdx = gHookedImgIdxListLen - 1;
   iosLogDebug("hookedImgIdxListMaxIdx=%d", hookedImgIdxListMaxIdx);

   if (hookedImageIndex <= hookedImgIdxListMaxIdx){
	   // origImgIdx = hookedImgIdxList[hookedImageIndex];
	   origImgIdx = gHookedImgIdxList[hookedImageIndex];
	   iosLogDebug("hookedImageIndex=%d <= hookedImgIdxListMaxIdx=%d -> origImgIdx=%d", hookedImageIndex, hookedImgIdxListMaxIdx, origImgIdx);
   } else {
	   origImgIdx = DYLD_IMAGE_INDEX_INVALID;
	   iosLogDebug("hookedImageIndex=%d > hookedImgIdxListMaxIdx=%d -> origImgIdx=%d", hookedImageIndex, hookedImgIdxListMaxIdx, origImgIdx);
   }

   // if (NULL != hookedImgIdxList){
   //     free(hookedImgIdxList);
   // }

   return origImgIdx;
}

static int findRealImageCount(void){
   iosLogDebug("%s", "");

   int realImageCount = 0;
   int hookedImageCount = _dyld_image_count();
//        int origImageCount = orig__dyld_image_count();
   iosLogDebug("hookedImageCount=%d", hookedImageCount);

   // find real count
   int curImgIdx = hookedImageCount;

   // use: _dyld_get_image_vmaddr_slide

   long retSlide = _dyld_get_image_vmaddr_slide(generateFakeImageIndex(curImgIdx));
   iosLogDebug("[%d] -> retSlide=%ld", curImgIdx, retSlide);
   while(DYLD_IMAGE_SLIDE_INVALID != retSlide){
	   ++curImgIdx;
	   retSlide = _dyld_get_image_vmaddr_slide(generateFakeImageIndex(curImgIdx));
	   iosLogDebug("[%d] -> retSlide=%ld", curImgIdx, retSlide);
   }

   // // use: _dyld_get_image_name
   // const char* retImgName = _dyld_get_image_name(generateFakeImageIndex(curImgIdx));
   // iosLogDebug("[%d] -> retImgName=%s", curImgIdx, retImgName);
   // while(NULL != retImgName){
   //     ++curImgIdx;
   //     retImgName = _dyld_get_image_name(generateFakeImageIndex(curImgIdx));
   //     iosLogDebug("[%d] -> retImgName=%s", curImgIdx, retImgName);
   // }

   // // use: _dyld_get_image_header
   // const struct mach_header* retImgHeader = _dyld_get_image_header(generateFakeImageIndex(curImgIdx));
   // iosLogDebug("[%d] -> retImgHeader=%p", curImgIdx, retImgHeader);
   // while(NULL != retImgHeader){
   //     ++curImgIdx;
   //     retImgHeader = _dyld_get_image_header(generateFakeImageIndex(curImgIdx));
   //     iosLogDebug("[%d] -> retImgHeader=%p", curImgIdx, retImgHeader);
   // }

   realImageCount = curImgIdx;
   iosLogDebug("realImageCount=%d", realImageCount);
   return realImageCount;
}

static void reInitAllRelated(void) {
   // if (gRealOrigImageCount <= 0) {
   //     // invalid, need reinit
   //     gRealOrigImageCount = findRealImageCount();
   //     iosLogInfo("gRealOrigImageCount=%d", gRealOrigImageCount);
   // }

   int curOrigCount = -1;

   int curHookedImageCount = _dyld_image_count();
   if (gJbDylibIdxListLen > 0) {
	   curOrigCount = curHookedImageCount + gJbDylibIdxListLen;
   } else {
	   curOrigCount = findRealImageCount();
   }
   iosLogDebug("curHookedImageCount=%d, gJbDylibIdxListLen=%d -> curOrigCount=%d", curHookedImageCount, gJbDylibIdxListLen, curOrigCount);

   if (curOrigCount != gOrigImageCount) {
	   iosLogInfo("curOrigCount=%d != gOrigImageCount=%d -> reinit image index list", curOrigCount, gOrigImageCount);

	   reInitImgCountIfNeed(curOrigCount);
	   iosLogInfo("after reinit, gOrigImageCount=%d, gHookedImgIdxList=%p, gHookedImgIdxListLen=%d", gOrigImageCount, gHookedImgIdxList, gHookedImgIdxListLen);
   } else {
	   iosLogDebug("gJbDylibIdxList=%p, gJbDylibIdxListLen=%d, gHookedImgIdxList=%p, gHookedImgIdxListLen=%d", gJbDylibIdxList, gJbDylibIdxListLen, gHookedImgIdxList, gHookedImgIdxListLen);

	   if ((NULL == gJbDylibIdxList) || (gJbDylibIdxListLen <= 0)) {
		   reInitImgCountIfNeed(curOrigCount);
	   }

	   if ((NULL == gHookedImgIdxList) || (gHookedImgIdxListLen <= 0)) {
		   generateHookedImageIndexList(gJbDylibIdxList, gJbDylibIdxListLen, curOrigCount, &gHookedImgIdxList, &gHookedImgIdxListLen);
	   }
   }
}

static int getOrigImageIndex(int hookedImageIndex){
   iosLogDebug("hookedImageIndex=%d", hookedImageIndex);

   int origImgIdx = DYLD_IMAGE_INDEX_INVALID;

   // uint32_t origImageCount_byLogos = (*_logos_orig$_ungrouped$_dyld_image_count)();
   // os_log(OS_LOG_DEFAULT, "hook_dyld getOrigImageIndex: origImageCount_byLogos=%d", origImageCount_byLogos);

//     uint32_t origImageCount = findRealImageCount();
//     iosLogDebug("origImageCount=%d", origImageCount);
//
//    int* jbDylibImgIdxList = NULL;
//    int jbDylibImgIdxListLen = -1;
//    getJbDylibImgIdxList(origImageCount, &jbDylibImgIdxList, &jbDylibImgIdxListLen);
//    iosLogDebug("jbDylibImgIdxList=%p,jbDylibImgIdxListLen=%d", jbDylibImgIdxList, jbDylibImgIdxListLen);

   reInitAllRelated();

   // if (jbDylibImgIdxListLen > 0){
   if (gJbDylibIdxListLen > 0){
	   // check input image index validation
	   // int origImgMaxIdx = origImageCount - 1;
	   // int origImgMaxIdx = gRealOrigImageCount - 1;
	   int origImgMaxIdx = gOrigImageCount - 1;
	   // int hookedImgMaxIdx = origImgMaxIdx - jbDylibImgIdxListLen;
	   int hookedImgMaxIdx = origImgMaxIdx - gJbDylibIdxListLen;
	   iosLogDebug("origImgMaxIdx=%d, hookedImgMaxIdx=%d, hookedImageIndex=%d", origImgMaxIdx, hookedImgMaxIdx, hookedImageIndex);

	   if(hookedImageIndex > hookedImgMaxIdx){
		   // invalid
		   iosLogError("input image index invalid, hookedImageIndex=%d > hookedImgMaxIdx=%d", hookedImageIndex, hookedImgMaxIdx);
		   origImgIdx = DYLD_IMAGE_INDEX_INVALID;
	   } else {
		   // valid
		   // origImgIdx = hookedToOrigImageIndex(hookedImageIndex, jbDylibImgIdxList, jbDylibImgIdxListLen,  origImageCount);
		   origImgIdx = hookedToOrigImageIndex(hookedImageIndex);
	   }
   } else {
	   // no jailbreak dylib image index list
	   origImgIdx = hookedImageIndex;
   }

   iosLogDebug("hookedImageIndex=%d -> origImgIdx=%d", hookedImageIndex, origImgIdx);

   // if (NULL != jbDylibImgIdxList){
   //     free(jbDylibImgIdxList);
   // }

   return origImgIdx;
}

static int getRealOrOrigImageIndex(int inputImageIndex){
   iosLogDebug("inputImageIndex=%d", inputImageIndex);

   int realOrOrigImgIdx = DYLD_IMAGE_INDEX_INVALID;

   bool isFakeImgIdx = isFakeImageIndex(inputImageIndex);
   iosLogDebug("isFakeImgIdx=%s", boolToStr(isFakeImgIdx));

   if (isFakeImgIdx){
	   realOrOrigImgIdx = fakeToRealImageIndex(inputImageIndex);
   } else {
	   realOrOrigImgIdx = getOrigImageIndex(inputImageIndex);
   }

   iosLogDebug("inputImageIndex=%d -> realOrOrigImgIdx=%d", inputImageIndex, realOrOrigImgIdx);

   return realOrOrigImgIdx;
}

%hookf(uint32_t, _dyld_image_count, void){
//    iosLogDebug();
   iosLogDebug("%s", "");

   uint32_t origCount = 0;
   int retImageCount = 0;

   if (cfgHookEnable_dyld){
	   origCount = %orig();
	   iosLogDebug("origCount=%d", origCount);
	   retImageCount = origCount;

	   if (cfgCurDyldHookType == DYLD_HOOK_COMPLEX){
//            int* jbDylibIdxList = NULL;
//            int jbDylibIdxListLen = -1;
//            getJbDylibImgIdxList(origCount, &jbDylibIdxList, &jbDylibIdxListLen);
//            iosLogDebug("jbDylibIdxList=%p, jbDylibIdxListLen=%d", jbDylibIdxList, jbDylibIdxListLen);
//            retImageCount = origCount - jbDylibIdxListLen;
//
//            if(NULL != jbDylibIdxList){
//                free(jbDylibIdxList);
//            }

		   reInitImgCountIfNeed(origCount);

		   // if ((NULL == gHookedImgIdxList) || (gHookedImgIdxListLen <= 0)) {
		   //     generateHookedImageIndexList(gJbDylibIdxList, gJbDylibIdxListLen, origCount, &gHookedImgIdxList, &gHookedImgIdxListLen);
		   // }

		   retImageCount = gHookedImageCount;
		   // retImageCount = gOrigImageCount;
	   }
   } else {
	   origCount = %orig();
	   retImageCount = origCount;
   }

   iosLogDebug("%sorigCount=%d -> retImageCount=%d", HOOK_PREFIX(cfgHookEnable_dyld), origCount, retImageCount);
   return retImageCount;
}

%hookf(const char*, _dyld_get_image_name, uint32_t image_index){
   iosLogDebug("image_index=%d", image_index);
   const char* retImgName = NULL;

   if (cfgHookEnable_dyld){
	   if (cfgCurDyldHookType == DYLD_HOOK_COMPLEX){
		   int realOrOrigImgIdx = getRealOrOrigImageIndex(image_index);
		   bool isValidImgIdx = (realOrOrigImgIdx >= 0);
		   if (isValidImgIdx){
			   const char* imgName = %orig(realOrOrigImgIdx);
			   iosLogDebug("image_index=%d -> realOrOrigImgIdx=%d -> isValidImgIdx=%s -> imgName=%{public}s", image_index, realOrOrigImgIdx, boolToStr(isValidImgIdx), imgName);
			   retImgName = imgName;
		   } else {
			   iosLogError("fail to get real or origin image index for image_index=%d", image_index);
			   retImgName = NULL;
		   }
	   } else {
		   const char * firstImgName = NULL;
		   char* randomDylibName = NULL;
		   const char* imgName = %orig(image_index);
		   bool isJbDylib = isJailbreakDylib(imgName);
		   if (isJbDylib){
			   if (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_NULL) {
				   retImgName = NULL;
			   } else if (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_FIRST) {
				   firstImgName = _dyld_get_image_name(0);
				   // normally is app self
				   // eg: /private/var/containers/Bundle/Application/B6327617-9ED7-4DED-AFAC-4D9C92D82377/Aweme.app/Aweme
				   retImgName = firstImgName;
			   } else if (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_RANDOM_NAME) {
				   char* randomName = randomStr(10, NULL);
				   asprintf(&randomDylibName, "/usr/lib/%s.dylib", randomName);
				   retImgName = randomDylibName;
			   }
		   } else {
			   retImgName = imgName;
		   }

		   // for debug
		   if (isJbDylib) {
			   iosLogInfo("image_index=%d -> imgName=%{public}s -> isJbDylib=%s -> firstImgName=%{public}s, randomDylibName=%{public}s -> retImgName=%{public}s", image_index, imgName, boolToStr(isJbDylib), firstImgName, randomDylibName, retImgName);
		   }
	   }
   } else {
	   retImgName = %orig(image_index);
   }

   iosLogDebug("%simage_index=%d -> retImgName=%{public}s", HOOK_PREFIX(cfgHookEnable_dyld), image_index, retImgName);
   return retImgName;
}

%hookf(const struct mach_header*, _dyld_get_image_header, uint32_t image_index){
   iosLogDebug("image_index=%d", image_index);
//    return %orig;
   const struct mach_header* retMachHeader = NULL;

   if (cfgHookEnable_dyld){
	   if (cfgCurDyldHookType == DYLD_HOOK_COMPLEX){
		   int realOrOrigImgIdx = getRealOrOrigImageIndex(image_index);
		   bool isValidImgIdx = (realOrOrigImgIdx >= 0);
		   if (isValidImgIdx){
			   retMachHeader = %orig(realOrOrigImgIdx);
		   } else {
			   iosLogError("fail to get real or origin image index for image_index=%d", image_index);
			   retMachHeader = NULL;
		   }
		   iosLogDebug("image_index=%d -> realOrOrigImgIdx=%d -> isValidImgIdx=%s -> retMachHeader=%p", image_index, realOrOrigImgIdx, boolToStr(isValidImgIdx), retMachHeader);
	   } else {
		   bool isJbDylib = false;
		   const struct mach_header* firstImgHeader = NULL;
		   const char* imageName = _dyld_get_image_name(image_index);
		   if (NULL == imageName){
			   retMachHeader = NULL;
		   } else {
			   isJbDylib = isJailbreakDylib(imageName);
			   if (isJbDylib){
				   if (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_NULL) {
					   retMachHeader = NULL;
				   } else if ( (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_FIRST) || (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_RANDOM_NAME) ) {
					   firstImgHeader = _dyld_get_image_header(0);
					   // normally is app self
					   retMachHeader = firstImgHeader;
				   }
			   } else {
				   retMachHeader = %orig(image_index);
			   }
		   }

		   // for debug
		   if (isJbDylib) {
			   iosLogInfo("image_index=%d -> imageName=%{public}s -> isJbDylib=%s -> firstImgHeader=%p -> retMachHeader=%p", image_index, imageName, boolToStr(isJbDylib), firstImgHeader, retMachHeader);
		   }
	   }
   } else {
	   retMachHeader = %orig(image_index);
//        iosLogDebug("%simage_index=%d -> retMachHeader=%p", HOOK_PREFIX(cfgHookEnable_dyld), image_index, retMachHeader);
   }

   iosLogDebug("%simage_index=%d -> retMachHeader=%p", HOOK_PREFIX(cfgHookEnable_dyld), image_index, retMachHeader);
   return retMachHeader;
}

%hookf(intptr_t, _dyld_get_image_vmaddr_slide, uint32_t image_index){
   iosLogDebug("image_index=%d", image_index);
//    return %orig;
   long retSlide = DYLD_IMAGE_SLIDE_INVALID;

   if (cfgHookEnable_dyld){
	   if (cfgCurDyldHookType == DYLD_HOOK_COMPLEX){
		   int realOrOrigImgIdx = getRealOrOrigImageIndex(image_index);
		   bool isValidImgIdx = (realOrOrigImgIdx >= 0);
		   if (isValidImgIdx){
			   retSlide = %orig(realOrOrigImgIdx);
		   } else {
			   iosLogError("fail to get real or origin image index for image_index=%d", image_index);
			   retSlide = DYLD_IMAGE_SLIDE_INVALID;
		   }
		   iosLogDebug("image_index=%d -> realOrOrigImgIdx=%d -> isValidImgIdx=%s -> retSlide=0x%lx", image_index, realOrOrigImgIdx, boolToStr(isValidImgIdx), retSlide);
	   } else {
		   bool isJbDylib = false;
		   long firtImgSlide = DYLD_IMAGE_SLIDE_INVALID;
		   const char* imageName = _dyld_get_image_name(image_index);
		   if (NULL == imageName){
			   retSlide = DYLD_IMAGE_SLIDE_INVALID;
		   } else {
			   isJbDylib = isJailbreakDylib(imageName);
			   if (isJbDylib){
				   if (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_NULL) {
					   retSlide = DYLD_IMAGE_SLIDE_INVALID;
				   } else if ( (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_FIRST) || (cfgCurDyldHookType == DYLD_HOOK_SIMPLE_RANDOM_NAME) ) {
					   firtImgSlide = _dyld_get_image_vmaddr_slide(0);
					   // normally is app self
					   retSlide = firtImgSlide;
				   }
			   } else {
				   retSlide = %orig(image_index);
			   }
		   }

		   // for debug
		   if (isJbDylib) {
			   iosLogInfo("image_index=%d -> imageName=%{public}s -> isJbDylib=%s -> firtImgSlide=0x%lx -> retSlide=0x%lx", image_index, imageName, boolToStr(isJbDylib), firtImgSlide, retSlide);
		   }
	   }
   } else {
	   retSlide = %orig(image_index);
//        iosLogDebug("%simage_index=%d -> retSlide=0x%lx", HOOK_PREFIX(cfgHookEnable_dyld), image_index, retSlide);
   }

   iosLogDebug("%simage_index=%d -> retSlide=0x%lx", HOOK_PREFIX(cfgHookEnable_dyld), image_index, retSlide);
   return retSlide;
}

%hookf(void, _dyld_register_func_for_add_image, void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide)){
//    iosLogInfo("%sfunc=%p -> Omitted", HOOK_PREFIX(cfgHookEnable_dyld), func);
   iosLogInfo("%sfunc=%p", HOOK_PREFIX(cfgHookEnable_dyld), func);

//#ifndef XCODE_DEBUG
   %orig;
//    %orig(func);
//#endif
}

%hookf(void, _dyld_register_func_for_remove_image, void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide)){
//    iosLogInfo("%sfunc=%p -> Omitted", HOOK_PREFIX(cfgHookEnable_dyld), func);
   iosLogInfo("%sfunc=%p", HOOK_PREFIX(cfgHookEnable_dyld), func);
   %orig;
}


%hookf(int32_t, NSVersionOfRunTimeLibrary, const char* libraryName){
   int32_t rtLibVer = %orig;
   iosLogInfo("libraryName=%s -> rtLibVer=%d", libraryName, rtLibVer);
   return rtLibVer;
}

%hookf(int32_t, NSVersionOfLinkTimeLibrary, const char* libraryName){
   int32_t rtLtLibVer = %orig;
   iosLogInfo("libraryName=%s -> rtLtLibVer=%d", libraryName, rtLtLibVer);
   return rtLtLibVer;
}

%hookf(int, _NSGetExecutablePath, char* buf, uint32_t* bufsize){
   int extPathCpSize = %orig;
   iosLogInfo("buf=%{public}s,*bufsize=%d -> extPathCpSize=%d", buf, *bufsize, extPathCpSize);
   return extPathCpSize;
}

/*==============================================================================
Ctor
==============================================================================*/

%ctor
{
   @autoreleasepool
   {
	   iosLogInfo("%s, cfgHookEnable_dyld=%s", "dylib ctor", boolToStr(cfgHookEnable_dyld));

	   gOrigImageCount = _dyld_image_count();
	   initDylibImageIdxList();
   }
}

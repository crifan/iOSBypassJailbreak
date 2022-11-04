/*
    File: CrifanLibiOS.h
    Function: crifan's common iOS function
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/iOS/CrifanLibiOS.h
    Updated: 20220316_1717
*/

#import <Foundation/Foundation.h>
#import <os/log.h>
#import <dlfcn.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <fcntl.h>
#import <sys/param.h>
#import <sys/mount.h>

#import "CrifanLib.h"

/*==============================================================================
 Common Define
==============================================================================*/

// String
#define STR_EMPTY ""
#define IS_EMPTY_STR(curStr) (0 == strcmp(curStr, STR_EMPTY))

// Log

#define ERROR_STR(curErr) ((error != NULL) ? *error: @"")

#define HOOK_PREFIX(isEnable) (isEnable ? "":"no_hook ")

//#ifdef FOR_RELEASE
#ifdef DISABLE_ALL_IOS_LOG

//// for debug
//#define IOS_LOG_INFO_ENABLE     1
#define IOS_LOG_INFO_ENABLE     0

#define IOS_LOG_DEBUG_ENABLE    0
#define IOS_LOG_ERROR_ENABLE    0

#else

#define IOS_LOG_INFO_ENABLE     1
#define IOS_LOG_DEBUG_ENABLE    0
#define IOS_LOG_ERROR_ENABLE    1

#endif

//// hook_openFile.xm -> hook_openFile
//#define FILENAME_NO_SUFFIX (strrchr(__FILE_NAME__, '.') ? strrchr(__FILE_NAME__, '.') + 1 : __FILE_NAME__)

// // _logos_function$_ungrouped$open -> open
// #define PURE_FUNC (strrchr(__func__, '$') ? strrchr(__func__, '$') + 1 : __func__)

// // _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$ -> fileExistsAtPath$


#define UNGROUP_STR "_ungrouped$"
#define UNGROUP_LEN strlen(UNGROUP_STR)
#define HOOK_ "hook_"
//#define HOOK_SPACE "hook_ "

// Method 1:
// // _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$ -> NSFileManager$fileExistsAtPath$
// //#define FUNC_UNGROUPED_NEXT (0 == strcmp(PURE_FUNC, "")) ? (strstr(__func__, UNGROUP_STR) + UNGROUP_LEN) : (PURE_FUNC)
// #define FUNC_UNGROUPED_NEXT IS_EMPTY_STR(PURE_FUNC) ? (strstr(__func__, UNGROUP_STR) + UNGROUP_LEN) : (PURE_FUNC)

// // NSFileManager$fileExistsAtPath$ -> fileExistsAtPath$
// // #define FUNC_ONLY_METHOD strchr(FUNC_UNGROUPED_NEXT, '$') ? (strchr(FUNC_UNGROUPED_NEXT, '$') + 1) : __func__
// // #define FUNC_ONLY_METHOD (NULL != strchr(FUNC_UNGROUPED_NEXT, '$')) ? (strchr(FUNC_UNGROUPED_NEXT, '$') + 1) : __func__
// #define FUNC_ONLY_METHOD strchr(FUNC_UNGROUPED_NEXT, '$') ? (strchr(FUNC_UNGROUPED_NEXT, '$') + 1) : FUNC_UNGROUPED_NEXT


// Method 2:
#define FUNC_NAME_AFTER_UNGROUP strstr(__func__, UNGROUP_STR) ? (strstr(__func__, UNGROUP_STR) + UNGROUP_LEN) : __func__
// =>
// _logos_function$_ungrouped$open -> open
// _logos_method$_ungrouped$NSFileManager$fileExistsAtPath$ -> NSFileManager$fileExistsAtPath$
// normal_function -> normal_function

//#define FUNC_NAME strchr(FUNC_NAME_AFTER_UNGROUP, '$') ? (strchr(FUNC_NAME_AFTER_UNGROUP, '$') + 1) : FUNC_NAME_AFTER_UNGROUP
//#define FUNC_NAME_NO_CLASS strchr(FUNC_NAME_AFTER_UNGROUP, '$') ? (strchr(FUNC_NAME_AFTER_UNGROUP, '$') + 1) : FUNC_NAME_AFTER_UNGROUP
// =>
// open -> open
// NSFileManager$fileExistsAtPath$ -> fileExistsAtPath$
// normal_function -> normal_function

// Updated: add support for `_logos_meta_method` inside hook_aweme.mm
// static BOOL _logos_meta_method$_ungrouped$TTInstallUtil$isJailBroken(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL);
#define FUNC_NAME_NO_CLASS FUNC_NAME_AFTER_UNGROUP

#define FUNC_NAME strchr(FUNC_NAME_NO_CLASS, ' ') ? (strchr(FUNC_NAME_NO_CLASS, ' ') + 1) : FUNC_NAME_NO_CLASS
// =>
// +[CrifanLibHookiOS nsStrListToStr:isSortList:isAddIndexPrefix:] -> nsStrListToStr:isSortList:isAddIndexPrefix:]

#define HOOK_FILE_NAME strstr(__FILE_NAME__, HOOK_) ? __FILE_NAME__ : (HOOK_ " " __FILE_NAME__)
// =>
// hook_aweme.xm -> hook_aweme.xm
// CrifanLibHookiOS.m -> hook_ CrifanLibHookiOS.m

#define iosLogInfo(format, ...) \
    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, HOOK_FILE_NAME, FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, FUNC_ONLY_METHOD, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, FUNC_UNGROUPED_NEXT, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, PURE_FUNC, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, FILENAME_NO_SUFFIX, PURE_FUNC, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_INFO_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, __func__, __VA_ARGS__); } while(0)

#define iosLogDebug(format, ...) \
do { if (IOS_LOG_DEBUG_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, HOOK_FILE_NAME,  FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_DEBUG_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__,  FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_DEBUG_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__,  PURE_FUNC, __VA_ARGS__); } while(0)

#define iosLogError(format, ...) \
do { if (IOS_LOG_ERROR_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, HOOK_FILE_NAME, FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_ERROR_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, FUNC_NAME, __VA_ARGS__); } while(0)
//    do { if (IOS_LOG_ERROR_ENABLE) os_log(OS_LOG_DEFAULT, "%s %s: " format, __FILE_NAME__, PURE_FUNC, __VA_ARGS__); } while(0)

/*==============================================================================
 Exported Global Variable
==============================================================================*/

extern const int OPEN_OK;
extern const int OPEN_FAILED;

extern const int OPEN_FD_INVALID;

extern const int ACCESS_OK;
extern const int ACCESS_FAILED;

extern const int STAT_OK;
extern const int STAT_FAILED;

extern const int STATFS_OK;
extern const int STATFS_FAILED;

extern const int FORK_FAILED;

extern const int PTRACE_OK;
extern const int PTRACE_FAILED;

extern const int FOPEN_OPEN_FAILED;

extern const int FCNTL_FAILED;

//extern const char* REALPATH_FAILED;
extern char* REALPATH_FAILED;

//extern const char* OPENDIR_FAILED;
//extern char* OPENDIR_FAILED;
//extern const int OPENDIR_FAILED;
//extern int OPENDIR_FAILED;
extern DIR* OPENDIR_FAILED;

extern const int StrPointerSize;

extern const int DLADDR_FAILED;

extern const int DYLD_IMAGE_INDEX_INVALID;
extern const long DYLD_IMAGE_SLIDE_INVALID;

extern const int SYSCTL_OK;
extern const int SYSCTL_FAIL;


/*==============================================================================
 Global Type
==============================================================================*/

typedef NS_ENUM(NSInteger, OpenFileFunctionType) {
    FUNC_UNKNOWN,
    FUNC_STAT,
    FUNC_STAT64,
    FUNC_SYSCALL_STAT,
    FUNC_SYSCALL_STAT64,
    FUNC_SVC_0X80_STAT,
    FUNC_SVC_0X80_STAT64,
    FUNC_OPEN,
    FUNC_SYSCALL_OPEN,
    FUNC_SVC_0X80_OPEN,
    FUNC_FOPEN,
    FUNC_NSFILEMANAGER,
    FUNC_ACCESS,
    FUNC_FACCESSAT,
    FUNC_LSTAT,
    FUNC_REALPATH,
    FUNC_OPENDIR,
    FUNC___OPENDIR2,
    FUNC_NSURL,
    FUNC_STATFS,
    FUNC_STATFS64,
    FUNC_FSTATFS,
    FUNC_FSTATAT,
    FUNC_FSTAT,
    FUNC_SYSCALL_LSTAT,
    FUNC_SYSCALL_FSTAT,
    FUNC_SYSCALL_FSTATAT,
    FUNC_SYSCALL_STATFS,
    FUNC_SYSCALL_FSTATFS,
    FUNC_SYSCALL_FOPEN,
    FUNC_SYSCALL_ACCESS,
    FUNC_SYSCALL_FACCESSAT,
};

typedef NS_ENUM(NSInteger, ButtonId) {
    BTN_STAT=1,
    BTN_STAT64=2,
    BTN_SYSCALL_STAT=3,
    BTN_SYSCALL_STAT64=4,
    BTN_SVC_0X80_STAT=5,
    BTN_SVC_0X80_STAT64=6,
    BTN_OPEN=7,
    BTN_SYSCALL_OPEN=8,
    BTN_SVC_0X80_OPEN=9,
    BTN_FOPEN=10,
    BTN_NSFILEMANAGER=11,
    BTN_ACCESS=12,
    BTN_FACCESSAT=13,
    BTN_LSTAT=14,
    BTN_REALPATH=15,
    BTN_OPENDIR=16,
    BTN___OPENDIR2=17,
    BTN_NSURL=18,
    BTN_STATFS=19,
    BTN_STATFS64=20,
    BTN_FSTATFS=21,
    BTN_FSTATAT=22,
    BTN_FSTAT=23,
    BTN_SYSCALL_LSTAT=24,
    BTN_SYSCALL_FSTAT=25,
    BTN_SYSCALL_FSTATAT=26,
    BTN_SYSCALL_STATFS=27,
    BTN_SYSCALL_FSTATFS=28,
    BTN_SYSCALL_FOPEN=29,
    BTN_SYSCALL_ACCESS=30,
    BTN_SYSCALL_FACCESSAT=31,
};


/*==============================================================================
 iOS Related
==============================================================================*/

NS_ASSUME_NONNULL_BEGIN

@interface CrifanLibiOS : NSObject

/*==============================================================================
 String List
==============================================================================*/

//+ (NSArray *) strListToNSArray: (char*_Nullable*_Nullable)strList listCount:(int)listCount;
+ (NSArray *) strListToNSArray: (char**)strList listCount:(int)listCount;

/*==============================================================================
 NSArray
==============================================================================*/

+ (NSString*) nsStrListToStr: (NSArray*)curList;
+ (NSString*) nsStrListToStr: (NSArray*)curList isSortList:(BOOL)isSortList isAddIndexPrefix:(BOOL)isAddIndexPrefix;

/*==============================================================================
 Open File
==============================================================================*/

+ (BOOL) openFile:(NSString *)filePath funcType:(OpenFileFunctionType) funcType;

/*==============================================================================
 Codesign
==============================================================================*/

+ (BOOL) isCodeSignExist;
+ (NSString*) getEmbeddedCodesign;
+ (NSString*) getAppId;
+ (BOOL) isSelfAppId: (NSString*) selfAppId;

/*==============================================================================
 Process
==============================================================================*/

+ (NSArray *)runningProcesses;

@end

NS_ASSUME_NONNULL_END

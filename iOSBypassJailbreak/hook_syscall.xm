/*
 File: hook_syscall.xm
 Function: iOS tweak to hook syscall
 Author: Crifan Li
*/

#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

/*==============================================================================
 Define
==============================================================================*/

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH          31
#endif  // !defined(PT_DENY_ATTACH)

/*==============================================================================
 Const
==============================================================================*/

/*==============================================================================
 Hook: syscall()
==============================================================================*/

/*
    https://www.theiphonewiki.com/wiki/Kernel_Syscalls
    TODO: support syscall(access_extended)
 */


int syscall(int, ...);

// normally max number of syscall parameter is not exceed 8
// refer: https://opensource.apple.com/source/xnu/xnu-4570.1.46/bsd/kern/syscalls.master
int MaxSupportArgNum_syscall = 16;

%hookf(int, syscall, int number, ...){
	iosLogDebug("number=%d", number);

	int syscallRetValue = -1;

	// Setting up some variables to get all the parameters from syscall
	void *paraPtr, *paraList[MaxSupportArgNum_syscall];
//    char *paraPtr, *paraList[MaxSupportArgNum_syscall];
	va_list argList;
	int curParaNum = 0;
    
    if (cfgHookEnable_syscall) {
        // #define    SYS_fork           2
        bool isFork = (SYS_fork == number);
        if (isFork){
            iosLogInfo("number=%d -> return %d", number, FORK_FAILED);
            return FORK_FAILED;
        }

        // #define    SYS_open           5
        bool isOpen = (SYS_open == number);
        if (isOpen){
            //int open(const char *path, int oflag, ...);
            // ->
    //        int open(const char *pathname, int flags);
    //        int open(const char *pathname, int flags, mode_t mode);

            //5    AUE_OPEN_RWTC   ALL     { int open(user_addr_t path, int flags, int mode) NO_SYSCALL_STUB; }
            va_start(argList, number);
            const char * fisrtPath = va_arg(argList, const char *);
            int secondFlags = va_arg(argList, int);
    //        mode_t thirdMode = va_arg(argList, mode_t);
            mode_t thirdMode = (mode_t)va_arg(argList, unsigned int);
            va_end(argList);
            iosLogDebug("fisrtPath=%{public}s, secondFlags=%d, thirdMode=%d", fisrtPath, secondFlags, thirdMode);

            bool isJbPath = isJailbreakPath(fisrtPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);
            if (isJbPath){
                errno = ENOENT;
                iosLogDebug("set errno=%d", errno);
                syscallRetValue = OPEN_FAILED;
            } else {
                syscallRetValue = %orig(number, fisrtPath, secondFlags, thirdMode);
            }
            iosLogInfo("SYS_open: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }
        
        // #define    SYS_ptrace         26
        bool isPtrace = (SYS_ptrace == number);
        if (isPtrace){
            // https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/ptrace.2.html
            // int ptrace(int request, pid_t pid, caddr_t addr, int data);
            va_start(argList, number);
            int request = va_arg(argList, int);
            int pid = va_arg(argList, int);
            char* addr = va_arg(argList, char*);
            int data = va_arg(argList, int);
            va_end(argList);

            iosLogInfo("request=%d, pid=%d, addr=%p, data=%d", request, pid, addr, data);

            if (PT_DENY_ATTACH == request){
                syscallRetValue = PTRACE_FAILED;
            } else {
                syscallRetValue = %orig(request, pid, addr, data);
            }

            iosLogInfo("SYS_ptrace: request=%d, pid=%d, addr=%p, data=%d -> syscallRetValue=%d", request, pid, addr, data, syscallRetValue);
            return syscallRetValue;
        }

        // #define    SYS_access         33
        bool isAccess = (SYS_access == number);
        if (isAccess) {
            // int access(const char *path, int amode);
            va_start(argList, number);
            const char* path = va_arg(argList, const char *);
            int amode = va_arg(argList, int);
            va_end(argList);

            iosLogDebug("isAccess=%{bool}d, path=%{public}s, amode=0x%x", isAccess, path, amode);

            bool isJbPath = isJailbreakPath(path);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);
            if (isJbPath){
                syscallRetValue = ACCESS_FAILED;
            } else {
                syscallRetValue = %orig(number, path, amode);
            }
            iosLogInfo("SYS_access: number=%d -> path=%{public}s, amode=0x%x -> isJbPath=%{bool}d -> syscallRetValue=%d", number, path, amode, isJbPath, syscallRetValue);
            return syscallRetValue;
        }

        // #define    SYS_statfs         157
        bool isStatfs = (SYS_statfs == number);
        if (isStatfs) {
            // int statfs(const char *path, struct statfs *buf);
            va_start(argList, number);
            const char* path = va_arg(argList, const char *);
            struct stat* buf = va_arg(argList, struct stat*);
            va_end(argList);

            iosLogDebug("isStatfs=%{bool}d, path=%{public}s, buf=%p", isStatfs, path, buf);

            bool isJbPath = isJailbreakPath(path);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);
            if (isJbPath){
                syscallRetValue = STATFS_FAILED;
            } else {
                syscallRetValue = %orig(number, path, buf);
            }
            iosLogInfo("SYS_statfs: number=%d -> path=%{public}s, buf=%p -> isJbPath=%{bool}d -> syscallRetValue=%d", number, path, buf, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
        // #define    SYS_fstatfs        158
        bool isFstatfs = (SYS_fstatfs == number);
        if (isFstatfs) {
            bool isGetPathOk = false;
            bool isJbPath = false;
            char parsedPath[PATH_MAX];
            memset(parsedPath, 0, PATH_MAX);

            // int fstatfs(int fd, struct statfs *buf);
            va_start(argList, number);
            int fd = va_arg(argList, int);
            struct stat* buf = va_arg(argList, struct stat*);
            va_end(argList);

            iosLogDebug("isFstatfs=%{bool}d, fd=%d, buf=%p", isFstatfs, fd, buf);

            isGetPathOk = getFilePath(fd, parsedPath);
            iosLogDebug("isGetPathOk=%s, parsedPath=%s", boolToStr(isGetPathOk), parsedPath);
            if (isGetPathOk) {
                isJbPath = isJailbreakPath(parsedPath);
                iosLogDebug("isJbPath=%{bool}d", isJbPath);

                if (isJbPath){
                    syscallRetValue = STATFS_FAILED;
                } else {
                    syscallRetValue = %orig(number, fd, buf);
                }
            } else {
                // can not get path -> can not check is jailbreak or not -> not hook
                syscallRetValue = %orig(number, fd, buf);
            }

            iosLogInfo("SYS_fstatfs: number=%d -> fd=%d, buf=%p -> isJbPath=%{bool}d -> syscallRetValue=%d", number, fd, buf, isJbPath, syscallRetValue);
            return syscallRetValue;
        }

        // #define    SYS_stat           188
        // #define    SYS_stat64         338
        bool isStat = (SYS_stat == number);
        bool isStat64 = (SYS_stat64 == number);
        if (isStat || isStat64){
            //int     stat(const char *, struct stat *) __DARWIN_INODE64(stat);
            //int     stat64(const char *, struct stat64 *) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5, __MAC_10_6, __IPHONE_NA, __IPHONE_NA);
            va_start(argList, number);
            const char * fisrtPath = va_arg(argList, const char *);
            void *secondStat = va_arg(argList, void *);
            va_end(argList);

            iosLogDebug("isStat=%{bool}d, isStat64=%{BOOL}d, fisrtPath=%{public}s, secondStat=%p", isStat, isStat64, fisrtPath, secondStat);

            bool isJbPath = isJailbreakPath(fisrtPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);
            if (isJbPath){
                syscallRetValue =  OPEN_FAILED;
            } else {
                //        if (isStat){
        //            struct stat *statInfo = (struct stat *)secondStat;
        //            syscallRetValue = %orig(number, fisrtPath, statInfo);
        //        } else if(isStat64){
        //            struct stat64 *stat64Info = (struct stat64 *)secondStat;
        //            syscallRetValue = %orig(number, fisrtPath, stat64Info);
        //        }
                syscallRetValue = %orig(number, fisrtPath, secondStat);
            }
            iosLogInfo("SYS_stat/SYS_stat64: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }

        // #define    SYS_fstat          189
        bool isFstat = (SYS_fstat == number);
        if (isFstat) {
            bool isGetPathOk = false;
            bool isJbPath = false;
            char parsedPath[PATH_MAX];
            memset(parsedPath, 0, PATH_MAX);

            // int fstat(int fd, struct stat *buf);
            va_start(argList, number);
            int fd = va_arg(argList, int);
            struct stat* buf = (struct stat*)va_arg(argList, void *);
            va_end(argList);

            iosLogDebug("isFstat=%{bool}d, fd=%d, buf=%p", isFstat, fd, buf);

            isGetPathOk = getFilePath(fd, parsedPath);
            iosLogDebug("isGetPathOk=%{bool}d, parsedPath=%s", isGetPathOk, parsedPath);
            if (isGetPathOk) {
                isJbPath = isJailbreakPath(parsedPath);
                iosLogDebug("isJbPath=%{bool}d", isJbPath);

                if (isJbPath){
                    syscallRetValue =  STAT_FAILED;
                } else {
                    syscallRetValue = %orig(number, fd, buf);
                }
            } else {
                syscallRetValue = %orig(number, fd, buf);
            }

            iosLogInfo("SYS_fstat: number=%d -> fd=%d -> isGetPathOk=%{bool}d, parsedPath=%{public}s -> isJbPath=%{bool}d -> syscallRetValue=%d", number, fd, isGetPathOk, parsedPath, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
        // #define    SYS_lstat          190
        bool isLstat = (SYS_lstat == number);
        if (isLstat) {
            // int lstat(const char* path, struct stat* buf);
            va_start(argList, number);
            const char* fisrtPath = va_arg(argList, const char *);
            struct stat* secondBuf = (struct stat*)va_arg(argList, void *);
            va_end(argList);

            iosLogDebug("isLstat=%{bool}d, fisrtPath=%{public}s, secondBuf=%p", isLstat, fisrtPath, secondBuf);

            bool isJbPath = isJailbreakPath(fisrtPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);
            if (isJbPath){
                syscallRetValue =  STAT_FAILED;
            } else {
                syscallRetValue = %orig(number, fisrtPath, secondBuf);
            }
            iosLogInfo("SYS_lstat: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }
        
        // #define    SYS_fstatat        469
        bool isFstatat = (SYS_fstatat == number);
        if (isFstatat) {
            bool isJbPath = false;

            // int fstatat(int dirfd, const char *pathname, struct stat *buf, int flags);
            va_start(argList, number);
            int dirfd = va_arg(argList, int);
            const char *pathname = (const char *)va_arg(argList, void *);
            struct stat *buf = (struct stat*)va_arg(argList, void *);
            int flags = va_arg(argList, int);
            va_end(argList);

            iosLogDebug("isFstatat=%{bool}d, dirfd=%d, pathname=%{public}s, buf=%p, flags=%d", isFstatat, dirfd, pathname, buf, flags);

            const char* absPath = NULL;
            bool isAbsPath = strStartsWith(pathname, "/");
            iosLogDebug("isAbsPath=%{bool}d", isAbsPath);
            if (isAbsPath) {
                absPath = pathname;
            } else {
                // is relative path
                if (dirfd == AT_FDCWD){
                    iosLogDebug("dirfd is AT_FDCWD=%d", AT_FDCWD);

                    // pathname is interpreted relative to the current working directory of the calling process (like access())
                    // TODO: try get current working directory -> avoid caller pass the special path, finnaly is jailbreak path
                    // eg: current working directory is "/usr/xxx/yyy/", then pass in "../../libexec/cydia/zzz"
                    // finnal path is "/usr/libexec/cydia/zzz", match jailbreak path: "/usr/libexec/cydia/", is jaibreak path
                    // but use "../../libexec/cydia/zzz" can not check whether is jailbreak path
                } else {
                    // get file path from dir fd
                    char filePath[PATH_MAX];
                    bool isGetPathOk = getFilePath(dirfd, filePath);
                    iosLogDebug("isGetPathOk=%s", boolToStr(isGetPathOk));
                    if (isGetPathOk) {
                        char* fullPath = strPathJoin(filePath, pathname)
                        iosLogDebug("fullPath=%{public}s", fullPath);
                        absPath = fullPath;
                    }
                }
            }

            if (NULL != absPath){
                isJbPath = isJailbreakPath(absPath);
                iosLogDebug("absPath=%{public}s -> isJbPath=%{bool}d", absPath, isJbPath);
                if (isJbPath) {
                    iosLogDebug("hook jailbreak path: %s", absPath);
                    syscallRetValue = STATFS_FAILED;
                } else {
                    syscallRetValue = %orig(number, dirfd, pathname, buf, flags);
                }
            } else {
                syscallRetValue = %orig(number, dirfd, pathname, buf, flags);
            }

            iosLogInfo("SYS_fstatat: number=%d -> dirfd=%d, pathname=%{public}s, buf=%p, flags=0x%x -> isJbPath=%{bool}d -> syscallRetValue=%d", number, dirfd, pathname, buf, flags, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
    }

	va_start(argList, number);
	while ((paraPtr = (void *) va_arg(argList, void *))) {
	//    while ((paraPtr = (char *) va_arg(argList, char *))) {
		paraList[curParaNum] = paraPtr;
		curParaNum += 1;
		iosLogDebug("[%d] paraPtr=%p", curParaNum, paraPtr);
	}
	va_end(argList);

//    iosLogDebug("argList=%{public}s", argList);
	iosLogDebug("curParaNum=%d", curParaNum);

//    return %orig;
//    return %orig(number, ...);
//    int retValue = %orig();

//    int retValue = callOriginSyscall(number, curParaNum, paraList);
////    int retValue = callOriginSyscall(number, curParaNum, (void *)paraList);
//    iosLogDebug("retValue=%d", retValue);
//    return retValue;

	int paraNum = curParaNum;

	if (0 == paraNum){
		syscallRetValue = %orig(number);
	} else if (1 == paraNum){
		void* para1 = paraList[0];
		iosLogDebug("para1=%p", para1);
		syscallRetValue = %orig(number, para1);
	} else if (2 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		iosLogDebug("para1=%p,para2=%p", para1, para2);
		syscallRetValue = %orig(number, para1, para2);
	} else if (3 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		iosLogDebug("para1=%p,para2=%p,para3=%p", para1, para2, para3);
		syscallRetValue = %orig(number, para1, para2, para3);
	} else if (4 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p", para1, para2, para3, para4);
		syscallRetValue = %orig(number, para1, para2, para3, para4);
	} else if (5 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p", para1, para2, para3, para4, para5);
		syscallRetValue = %orig(number, para1, para2, para3, para4, para5);
	} else if (6 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p", para1, para2, para3, para4, para5, para6);
		syscallRetValue = %orig(number, para1, para2, para3, para4, para5, para6);
	} else if (7 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		void* para7 = paraList[6];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p,para7=%p", para1, para2, para3, para4, para5, para6, para7);
		syscallRetValue = %orig(number, para1, para2, para3, para4, para5, para6, para7);
	} else if (8 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		void* para7 = paraList[6];
		void* para8 = paraList[7];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p,para7=%p,para8=%p", para1, para2, para3, para4, para5, para6, para7, para8);
		syscallRetValue = %orig(number, para1, para2, para3, para4, para5, para6, para7, para8);
	} else if (9 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		void* para7 = paraList[6];
		void* para8 = paraList[7];
		void* para9 = paraList[8];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p,para7=%p,para8=%p,para9=%p", para1, para2, para3, para4, para5, para6, para7, para8, para9);
		syscallRetValue = %orig(number, para1, para2, para3, para4, para5, para6, para7, para8, para9);
	}

	iosLogInfo("number=%d -> syscallRetValue=%d", number, syscallRetValue);
	return syscallRetValue;
}

/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_syscall=%s", "syscall ctor", boolToStr(cfgHookEnable_syscall));
    }
}

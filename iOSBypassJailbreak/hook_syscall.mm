#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_syscall.xm"






#import <os/log.h>

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"





#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH          31
#endif  















int syscall(int, ...);



int MaxSupportArgNum_syscall = 16;


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




#line 42 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_syscall.xm"
__unused static int (*_logos_orig$_ungrouped$syscall)(int number, ...); __unused static int _logos_function$_ungrouped$syscall(int number, ...){
	iosLogDebug("number=%d", number);

	int syscallRetValue = -1;

	
	void *paraPtr, *paraList[MaxSupportArgNum_syscall];

	va_list argList;
	int curParaNum = 0;
    
    if (cfgHookEnable_syscall) {
        
        bool isFork = (SYS_fork == number);
        if (isFork){
            iosLogInfo("number=%d -> return %d", number, FORK_FAILED);
            return FORK_FAILED;
        }

        
        bool isOpen = (SYS_open == number);
        if (isOpen){
            
            
    
    

            
            va_start(argList, number);
            const char * fisrtPath = va_arg(argList, const char *);
            int secondFlags = va_arg(argList, int);
    
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
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, fisrtPath, secondFlags, thirdMode);
            }
            iosLogInfo("SYS_open: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }
        
        
        bool isPtrace = (SYS_ptrace == number);
        if (isPtrace){
            
            
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
                syscallRetValue = _logos_orig$_ungrouped$syscall(request, pid, addr, data);
            }

            iosLogInfo("SYS_ptrace: request=%d, pid=%d, addr=%p, data=%d -> syscallRetValue=%d", request, pid, addr, data, syscallRetValue);
            return syscallRetValue;
        }

        
        bool isAccess = (SYS_access == number);
        if (isAccess) {
            
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
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, path, amode);
            }
            iosLogInfo("SYS_access: number=%d -> path=%{public}s, amode=0x%x -> isJbPath=%{bool}d -> syscallRetValue=%d", number, path, amode, isJbPath, syscallRetValue);
            return syscallRetValue;
        }

        
        bool isStatfs = (SYS_statfs == number);
        if (isStatfs) {
            
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
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, path, buf);
            }
            iosLogInfo("SYS_statfs: number=%d -> path=%{public}s, buf=%p -> isJbPath=%{bool}d -> syscallRetValue=%d", number, path, buf, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
        
        bool isFstatfs = (SYS_fstatfs == number);
        if (isFstatfs) {
            bool isGetPathOk = false;
            bool isJbPath = false;
            char parsedPath[PATH_MAX];
            memset(parsedPath, 0, PATH_MAX);

            
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
                    syscallRetValue = _logos_orig$_ungrouped$syscall(number, fd, buf);
                }
            } else {
                
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, fd, buf);
            }

            iosLogInfo("SYS_fstatfs: number=%d -> fd=%d, buf=%p -> isJbPath=%{bool}d -> syscallRetValue=%d", number, fd, buf, isJbPath, syscallRetValue);
            return syscallRetValue;
        }

        
        
        bool isStat = (SYS_stat == number);
        bool isStat64 = (SYS_stat64 == number);
        if (isStat || isStat64){
            
            
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
                
        
        
        
        
        
        
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, fisrtPath, secondStat);
            }
            iosLogInfo("SYS_stat/SYS_stat64: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }

        
        bool isFstat = (SYS_fstat == number);
        if (isFstat) {
            bool isGetPathOk = false;
            bool isJbPath = false;
            char parsedPath[PATH_MAX];
            memset(parsedPath, 0, PATH_MAX);

            
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
                    syscallRetValue = _logos_orig$_ungrouped$syscall(number, fd, buf);
                }
            } else {
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, fd, buf);
            }

            iosLogInfo("SYS_fstat: number=%d -> fd=%d -> isGetPathOk=%{bool}d, parsedPath=%{public}s -> isJbPath=%{bool}d -> syscallRetValue=%d", number, fd, isGetPathOk, parsedPath, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
        
        bool isLstat = (SYS_lstat == number);
        if (isLstat) {
            
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
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, fisrtPath, secondBuf);
            }
            iosLogInfo("SYS_lstat: number=%d -> isJbPath=%{bool}d, fisrtPath=%{public}s -> syscallRetValue=%d", number, isJbPath, fisrtPath, syscallRetValue);
            return syscallRetValue;
        }
        
        
        bool isFstatat = (SYS_fstatat == number);
        if (isFstatat) {
            bool isJbPath = false;

            
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
                
                if (dirfd == AT_FDCWD){
                    iosLogDebug("dirfd is AT_FDCWD=%d", AT_FDCWD);

                    
                    
                    
                    
                    
                } else {
                    
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
                    syscallRetValue = _logos_orig$_ungrouped$syscall(number, dirfd, pathname, buf, flags);
                }
            } else {
                syscallRetValue = _logos_orig$_ungrouped$syscall(number, dirfd, pathname, buf, flags);
            }

            iosLogInfo("SYS_fstatat: number=%d -> dirfd=%d, pathname=%{public}s, buf=%p, flags=0x%x -> isJbPath=%{bool}d -> syscallRetValue=%d", number, dirfd, pathname, buf, flags, isJbPath, syscallRetValue);
            return syscallRetValue;
        }
        
    }

	va_start(argList, number);
	while ((paraPtr = (void *) va_arg(argList, void *))) {
	
		paraList[curParaNum] = paraPtr;
		curParaNum += 1;
		iosLogDebug("[%d] paraPtr=%p", curParaNum, paraPtr);
	}
	va_end(argList);


	iosLogDebug("curParaNum=%d", curParaNum);










	int paraNum = curParaNum;

	if (0 == paraNum){
		syscallRetValue = _logos_orig$_ungrouped$syscall(number);
	} else if (1 == paraNum){
		void* para1 = paraList[0];
		iosLogDebug("para1=%p", para1);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1);
	} else if (2 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		iosLogDebug("para1=%p,para2=%p", para1, para2);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2);
	} else if (3 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		iosLogDebug("para1=%p,para2=%p,para3=%p", para1, para2, para3);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3);
	} else if (4 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p", para1, para2, para3, para4);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4);
	} else if (5 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p", para1, para2, para3, para4, para5);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4, para5);
	} else if (6 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p", para1, para2, para3, para4, para5, para6);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4, para5, para6);
	} else if (7 == paraNum){
		void* para1 = paraList[0];
		void* para2 = paraList[1];
		void* para3 = paraList[2];
		void* para4 = paraList[3];
		void* para5 = paraList[4];
		void* para6 = paraList[5];
		void* para7 = paraList[6];
		iosLogDebug("para1=%p,para2=%p,para3=%p,para4=%p,para5=%p,para6=%p,para7=%p", para1, para2, para3, para4, para5, para6, para7);
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4, para5, para6, para7);
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
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4, para5, para6, para7, para8);
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
		syscallRetValue = _logos_orig$_ungrouped$syscall(number, para1, para2, para3, para4, para5, para6, para7, para8, para9);
	}

	iosLogInfo("number=%d -> syscallRetValue=%d", number, syscallRetValue);
	return syscallRetValue;
}





static __attribute__((constructor)) void _logosLocalCtor_9431c87f(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_syscall=%s", "syscall ctor", boolToStr(cfgHookEnable_syscall));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{void * _logos_symbol$_ungrouped$syscall = (void *)syscall; MSHookFunction((void *)_logos_symbol$_ungrouped$syscall, (void *)&_logos_function$_ungrouped$syscall, (void **)&_logos_orig$_ungrouped$syscall);} }
#line 460 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_syscall.xm"

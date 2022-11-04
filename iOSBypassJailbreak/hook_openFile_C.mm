#line 1 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_C.xm"






#import <os/log.h>
#import <string.h>
#import <stdlib.h>
#import <sys/syscall.h>
#import <unistd.h>
#import <stdarg.h>
#import <stdio.h>

#import <sys/param.h>
#import <sys/mount.h>



#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"









int stat(const char *pathname, struct stat *buf);


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




#line 35 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_C.xm"
__unused static int (*_logos_orig$_ungrouped$stat)(const char *pathname, struct stat *buf); __unused static int _logos_function$_ungrouped$stat(const char *pathname, struct stat *buf){
    int statRet = STAT_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(pathname);
        iosLogDebug("pathname=%{public}s -> isJbPath=%s", pathname, boolToStr(isJbPath));

        if (isJbPath){
            statRet = STAT_FAILED;
        } else {
            statRet = _logos_orig$_ungrouped$stat(pathname, buf);
        }
    } else {
        statRet = _logos_orig$_ungrouped$stat(pathname, buf);
    }

    
    if(isJbPath){
        iosLogInfo("pathname=%{public}s -> isJbPath=%s -> statRet=%d", pathname, boolToStr(isJbPath), statRet);
    }

    return statRet;
}






int lstat(const char* path, struct stat* buf);

__unused static int (*_logos_orig$_ungrouped$lstat)(const char* path, struct stat* buf); __unused static int _logos_function$_ungrouped$lstat(const char* path, struct stat* buf){
    iosLogDebug("path=%{public}s, buf=%p", path, buf);
    int lstatRet = STAT_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

        if (isJbPath){
            lstatRet = STAT_FAILED;
        } else {
            lstatRet = _logos_orig$_ungrouped$lstat(path, buf);
        }
    } else {
        lstatRet = _logos_orig$_ungrouped$lstat(path, buf);
    }

    
    if(isJbPath){
        iosLogInfo("path=%{public}s -> isJbPath=%s -> lstatRet=%d", path, boolToStr(isJbPath), lstatRet);
    }

    return lstatRet;
}







int fstat(int fd, struct stat *buf);

__unused static int (*_logos_orig$_ungrouped$fstat)(int fd, struct stat *buf); __unused static int _logos_function$_ungrouped$fstat(int fd, struct stat *buf){
    iosLogDebug("fd=%d, buf=%p", fd, buf);
    int retInt = STAT_FAILED;
    bool isJbPath = false;

    char parsedPath[PATH_MAX];
    memset(parsedPath, 0, PATH_MAX);

    if (cfgHookEnable_openFileC) {
        
        bool isGetPathOk = getFilePath(fd, parsedPath);
        iosLogDebug("isGetPathOk=%s, parsedPath=%s", boolToStr(isGetPathOk), parsedPath);
        if (isGetPathOk) {
            isJbPath = isJailbreakPath(parsedPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);

            if (isJbPath){
                retInt = STAT_FAILED;
            } else {
                retInt = _logos_orig$_ungrouped$fstat(fd, buf);
            }
        } else {
            
            retInt = _logos_orig$_ungrouped$fstat(fd, buf);
        }
    } else {
        retInt = _logos_orig$_ungrouped$fstat(fd, buf);
    }

    
    if(isJbPath){
        iosLogInfo("fd=%d,buf=%p -> parsedPath=%{public}s -> isJbPath=%s -> retInt=%d", fd, buf, parsedPath, boolToStr(isJbPath), retInt);
    }

    return retInt;
}










int fstatat(int fd, const char* pathname, struct stat* buf, int flags);

__unused static int (*_logos_orig$_ungrouped$fstatat)(int fd, const char* pathname, struct stat* buf, int flags); __unused static int _logos_function$_ungrouped$fstatat(int fd, const char* pathname, struct stat* buf, int flags){
    iosLogDebug("fd=%d, pathname=%{public}s, buf=%p, flags=0x%x", fd, pathname, buf, flags);
    int fstatatRet = STATFS_FAILED;
    bool isJbPath = false;

    if(cfgHookEnable_openFileC){
        const char* absPath = NULL;
        bool isAbsPath = strStartsWith(pathname, "/");
        iosLogDebug("isAbsPath=%{bool}d", isAbsPath);
        if (isAbsPath) {
            absPath = pathname;
        } else {
            
            if (fd == AT_FDCWD){
                iosLogDebug("fd is AT_FDCWD=%d", AT_FDCWD);

                
                
                
                
                
            } else {
                
                char filePath[PATH_MAX];
                bool isGetPathOk = getFilePath(fd, filePath);
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
                fstatatRet = STATFS_FAILED;
            } else {
                fstatatRet = _logos_orig$_ungrouped$fstatat(fd, pathname, buf, flags);
            }
        } else {
            fstatatRet = _logos_orig$_ungrouped$fstatat(fd, pathname, buf, flags);
        }
    } else {
        fstatatRet = _logos_orig$_ungrouped$fstatat(fd, pathname, buf, flags);
    }

    
    if (isJbPath) {
        iosLogInfo("fd=%d, pathname=%{public}s, buf=%p, flags=0x%x -> isJbPath=%{bool}d -> fstatatRet=%d", fd, pathname, buf, flags, isJbPath, fstatatRet);
    }

    return fstatatRet;
}








int statfs(const char *path, struct statfs *buf);

__unused static int (*_logos_orig$_ungrouped$statfs)(const char *path, struct statfs *buf); __unused static int _logos_function$_ungrouped$statfs(const char *path, struct statfs *buf){
    iosLogDebug("path=%{public}s, buf=%p", path, buf);
    int statfsRet = STATFS_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

        if (isJbPath){
            statfsRet = STATFS_FAILED;
        } else {
            statfsRet = _logos_orig$_ungrouped$statfs(path, buf);
        }
    } else {
        statfsRet = _logos_orig$_ungrouped$statfs(path, buf);
    }

    
    if(isJbPath){
        iosLogInfo("found jailbreak path: path=%{public}s -> isJbPath=%s -> statfsRet=%d", path, boolToStr(isJbPath), statfsRet);
    }

    return statfsRet;
}







int fstatfs(int fd, struct statfs *buf);

__unused static int (*_logos_orig$_ungrouped$fstatfs)(int fd, struct statfs *buf); __unused static int _logos_function$_ungrouped$fstatfs(int fd, struct statfs *buf){
    iosLogDebug("fd=%d, buf=%p", fd, buf);
    int fstatfsRet = STATFS_FAILED;
    bool isJbPath = false;

    char parsedPath[PATH_MAX];
    memset(parsedPath, 0, PATH_MAX);

    if (cfgHookEnable_openFileC) {
        
        bool isGetPathOk = getFilePath(fd, parsedPath);
        iosLogDebug("isGetPathOk=%s, parsedPath=%s", boolToStr(isGetPathOk), parsedPath);
        if (isGetPathOk) {
            isJbPath = isJailbreakPath(parsedPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);

            if (isJbPath){
                fstatfsRet = STATFS_FAILED;
            } else {
                fstatfsRet = _logos_orig$_ungrouped$fstatfs(fd, buf);
            }
        } else {
            
            fstatfsRet = _logos_orig$_ungrouped$fstatfs(fd, buf);
        }
    } else {
        fstatfsRet = _logos_orig$_ungrouped$fstatfs(fd, buf);
    }

    
    if(isJbPath){
        iosLogInfo("fd=%d,buf=%p -> parsedPath=%{public}s -> isJbPath=%s -> fstatfsRet=%d", fd, buf, parsedPath, boolToStr(isJbPath), fstatfsRet);
    }

    return fstatfsRet;
}

















int MaxSupportArgNum_open = 2;
int open(const char *path, int oflag, ...);

__unused static int (*_logos_orig$_ungrouped$open)(const char *path, int oflag, ...); __unused static int _logos_function$_ungrouped$open(const char *path, int oflag, ...){
    iosLogDebug("path=%{public}s, oflag=%d", path, oflag);
    bool isJbPath = false;

    if(cfgHookEnable_openFileC_open){
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

    
    
    
    
    

        if (isJbPath){
            iosLogInfo("path=%{public}s -> isJbPath=%{bool}d", path, isJbPath);
            errno = ENOENT;
            iosLogDebug("set errno=%d", errno);
            return OPEN_FAILED;
        }
    }

    
    mode_t curPara, paraList[MaxSupportArgNum_open];
    va_list argList;
    int curParaNum = 0;

    va_start(argList, oflag);







    curPara = (mode_t) va_arg(argList, unsigned int);
    
    if (0 != (int)curPara) {
        paraList[curParaNum] = curPara;
        curParaNum += 1;
        iosLogDebug("[%d] para=%d", curParaNum, curPara);
    }
    va_end(argList);

    iosLogDebug("curParaNum=%d, argList=%{public}s", curParaNum, argList);


    int openRetValue = OPEN_FAILED;
    if (0 == curParaNum){
        openRetValue = _logos_orig$_ungrouped$open(path, oflag);
        if (isJbPath) {
            iosLogInfo("%spath=%{public}s, oflag=0x%x -> isJbPath=%{bool}d -> openRetValue=%d", HOOK_PREFIX(cfgHookEnable_openFileC_open), path, oflag, isJbPath, openRetValue);
        }
    } else if (1 == curParaNum){
        mode_t mode = paraList[0];

        openRetValue = _logos_orig$_ungrouped$open(path, oflag, mode);
        if (isJbPath) {
            iosLogInfo("%spath=%{public}s, oflag=0x%x, mode=0x%x -> isJbPath=%{bool}d -> openRetValue=%d", HOOK_PREFIX(cfgHookEnable_openFileC_open), path, oflag, mode, isJbPath, openRetValue);
        }
    }
    return openRetValue;
}






FILE* fopen(const char *filename, const char *mode);

__unused static int (*_logos_orig$_ungrouped$fopen)(const char *filename, const char *mode); __unused static int _logos_function$_ungrouped$fopen(const char *filename, const char *mode){
    iosLogDebug("filename=%{public}s, mode=%{public}s", filename, mode);
    int retValue = FOPEN_OPEN_FAILED;
    bool isJbPath = false;

    if(cfgHookEnable_openFileC_fopen){
        isJbPath = isJailbreakPath(filename);
        if (isJbPath){
            retValue = FOPEN_OPEN_FAILED;
        } else {
            retValue = _logos_orig$_ungrouped$fopen(filename, mode);
        }
    } else {
        retValue = _logos_orig$_ungrouped$fopen(filename, mode);
    }

    
    if (isJbPath) {
        iosLogInfo("filename=%{public}s, mode=%{public}s -> isJbPath=%s -> retValue=%d", filename, mode, boolToStr(isJbPath), retValue);
    }
    return retValue;
}






int access(const char *path, int amode);

__unused static int (*_logos_orig$_ungrouped$access)(const char *path, int amode); __unused static int _logos_function$_ungrouped$access(const char *path, int amode){
    iosLogDebug("path=%{public}s, amode=0x%x", path, amode);
    int retValue = ACCESS_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);
        if (isJbPath){
            iosLogDebug("isJbPath=%{bool}d, %{public}s", isJbPath, path);
            errno = ENOENT;
            iosLogDebug("set errno=%d", errno);
            retValue = ACCESS_FAILED;
        } else {
            retValue = _logos_orig$_ungrouped$access(path, amode);
        }
    } else {
        retValue = _logos_orig$_ungrouped$access(path, amode);
    }

    
    if(isJbPath){
        iosLogInfo("path=%{public}s, amode=0x%x -> isJbPath=%{bool}d, retValue=%d", path, amode, isJbPath, retValue);
    }
    return retValue;
}







int faccessat(int dirfd, const char *pathname, int mode, int flags);

__unused static int (*_logos_orig$_ungrouped$faccessat)(int dirfd, const char *pathname, int mode, int flags); __unused static int _logos_function$_ungrouped$faccessat(int dirfd, const char *pathname, int mode, int flags){
    iosLogDebug("dirfd=%d, pathname=%{public}s, mode=0x%x, flags=0x%x", dirfd, pathname, mode, flags);
    int retInt = ACCESS_FAILED;
    bool isJbPath = false;

    if(cfgHookEnable_openFileC_faccessat){
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
                retInt = ACCESS_FAILED;
            } else {
                retInt = _logos_orig$_ungrouped$faccessat(dirfd, pathname, mode, flags);
            }
        } else {
            retInt = _logos_orig$_ungrouped$faccessat(dirfd, pathname, mode, flags);
        }
    } else {
        retInt = _logos_orig$_ungrouped$faccessat(dirfd, pathname, mode, flags);
    }

    
    if (isJbPath) {
        iosLogInfo("%sdirfd=%d, pathname=%{public}s, mode=0x%x, flags=0x%x -> isJbPath=%{bool}d, retInt=%d",
                   HOOK_PREFIX(cfgHookEnable_openFileC_faccessat), dirfd, pathname, mode, flags, isJbPath, retInt);
    }

    return retInt;
}






char* realpath(const char* file_name, char* resolved_name);

__unused static char* (*_logos_orig$_ungrouped$realpath)(const char* file_name, char* resolved_name); __unused static char* _logos_function$_ungrouped$realpath(const char* file_name, char* resolved_name){
    iosLogDebug("file_name=%{public}s, resolved_name=%p", file_name, resolved_name);
    char* resolvedPath = REALPATH_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(file_name);
        if (isJbPath) {
            resolvedPath = REALPATH_FAILED;
        } else {

            resolvedPath = _logos_orig$_ungrouped$realpath(file_name, resolved_name);
        }
    } else {
        resolvedPath = _logos_orig$_ungrouped$realpath(file_name, resolved_name);
    }

    
    if (isJbPath) {
        iosLogInfo("file_name=%{public}s, resolved_name=%{public}s -> isJbPath=%{bool}d -> resolvedPath=%{public}s", file_name, resolved_name, isJbPath, resolvedPath);
    }

    return resolvedPath;
}























DIR *__opendir2(const char *name, int flags);

__unused static DIR* (*_logos_orig$_ungrouped$__opendir2)(const char *name, int flags); __unused static DIR* _logos_function$_ungrouped$__opendir2(const char *name, int flags){
    iosLogDebug("name=%{public}s, flags=0x%x", name, flags);
    DIR* openedDir = OPENDIR_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC___opendir2){
        isJbPath = isJailbreakPath(name);
        if (isJbPath) {
            openedDir = OPENDIR_FAILED;
        } else {

            openedDir = _logos_orig$_ungrouped$__opendir2(name, flags);
        }
    } else {

        openedDir = _logos_orig$_ungrouped$__opendir2(name, flags);
    }

    
    if (isJbPath) {
        iosLogInfo("name=%{public}s, flags=0x%x -> isJbPath=%{bool}d -> openedDir=%p", name, flags, isJbPath, openedDir);
    }

    return openedDir;
}





static __attribute__((constructor)) void _logosLocalCtor_605ff764(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_openFileC=%s", "openFile_C ctor", boolToStr(cfgHookEnable_openFileC));
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{void * _logos_symbol$_ungrouped$stat = (void *)stat; MSHookFunction((void *)_logos_symbol$_ungrouped$stat, (void *)&_logos_function$_ungrouped$stat, (void **)&_logos_orig$_ungrouped$stat);void * _logos_symbol$_ungrouped$lstat = (void *)lstat; MSHookFunction((void *)_logos_symbol$_ungrouped$lstat, (void *)&_logos_function$_ungrouped$lstat, (void **)&_logos_orig$_ungrouped$lstat);void * _logos_symbol$_ungrouped$fstat = (void *)fstat; MSHookFunction((void *)_logos_symbol$_ungrouped$fstat, (void *)&_logos_function$_ungrouped$fstat, (void **)&_logos_orig$_ungrouped$fstat);void * _logos_symbol$_ungrouped$fstatat = (void *)fstatat; MSHookFunction((void *)_logos_symbol$_ungrouped$fstatat, (void *)&_logos_function$_ungrouped$fstatat, (void **)&_logos_orig$_ungrouped$fstatat);void * _logos_symbol$_ungrouped$statfs = (void *)statfs; MSHookFunction((void *)_logos_symbol$_ungrouped$statfs, (void *)&_logos_function$_ungrouped$statfs, (void **)&_logos_orig$_ungrouped$statfs);void * _logos_symbol$_ungrouped$fstatfs = (void *)fstatfs; MSHookFunction((void *)_logos_symbol$_ungrouped$fstatfs, (void *)&_logos_function$_ungrouped$fstatfs, (void **)&_logos_orig$_ungrouped$fstatfs);void * _logos_symbol$_ungrouped$open = (void *)open; MSHookFunction((void *)_logos_symbol$_ungrouped$open, (void *)&_logos_function$_ungrouped$open, (void **)&_logos_orig$_ungrouped$open);void * _logos_symbol$_ungrouped$fopen = (void *)fopen; MSHookFunction((void *)_logos_symbol$_ungrouped$fopen, (void *)&_logos_function$_ungrouped$fopen, (void **)&_logos_orig$_ungrouped$fopen);void * _logos_symbol$_ungrouped$access = (void *)access; MSHookFunction((void *)_logos_symbol$_ungrouped$access, (void *)&_logos_function$_ungrouped$access, (void **)&_logos_orig$_ungrouped$access);void * _logos_symbol$_ungrouped$faccessat = (void *)faccessat; MSHookFunction((void *)_logos_symbol$_ungrouped$faccessat, (void *)&_logos_function$_ungrouped$faccessat, (void **)&_logos_orig$_ungrouped$faccessat);void * _logos_symbol$_ungrouped$realpath = (void *)realpath; MSHookFunction((void *)_logos_symbol$_ungrouped$realpath, (void *)&_logos_function$_ungrouped$realpath, (void **)&_logos_orig$_ungrouped$realpath);void * _logos_symbol$_ungrouped$__opendir2 = (void *)__opendir2; MSHookFunction((void *)_logos_symbol$_ungrouped$__opendir2, (void *)&_logos_function$_ungrouped$__opendir2, (void **)&_logos_orig$_ungrouped$__opendir2);} }
#line 594 "/Users/crifan/dev/dev_root/crifan/iOSBypassJailbreak/iOSBypassJailbreak/hook_openFile_C.xm"

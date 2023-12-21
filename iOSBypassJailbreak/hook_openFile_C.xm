/*
 File: hook_openFile_C.xm
 Function: iOS tweak to hook open file of C language related function
 Author: Crifan Li
*/

#import <os/log.h>
#import <string.h>
#import <stdlib.h>
#import <sys/syscall.h>
#import <unistd.h>
#import <stdarg.h>
#import <stdio.h>
//#import <dirent.h>
#import <sys/param.h>
#import <sys/mount.h>
//#import <fcntl.h>
//#import <sys/syslimits.h> // use #include <limits.h> from CrifanLib.h

#import "CommonConfig.h"
#import "CrifanLibiOS.h"
#import "CrifanLib.h"
#import "JailbreakPathList.h"

/*==============================================================================
 Const
==============================================================================*/

/*==============================================================================
 Hook: stat()
==============================================================================*/

int stat(const char *pathname, struct stat *buf);

%hookf(int, stat, const char *pathname, struct stat *buf){
    int statRet = STAT_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(pathname);
        iosLogDebug("pathname=%{public}s -> isJbPath=%s", pathname, boolToStr(isJbPath));

        if (isJbPath){
            statRet = STAT_FAILED;
        } else {
            statRet = %orig;
        }
    } else {
        statRet = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("pathname=%{public}s -> isJbPath=%s -> statRet=%d", pathname, boolToStr(isJbPath), statRet);
    }

    return statRet;
}

/*==============================================================================
 Hook: lstat()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/lstat.2.html
int lstat(const char* path, struct stat* buf);

%hookf(int, lstat, const char* path, struct stat* buf){
    iosLogDebug("path=%{public}s, buf=%p", path, buf);
    int lstatRet = STAT_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

        if (isJbPath){
            lstatRet = STAT_FAILED;
        } else {
            lstatRet = %orig;
        }
    } else {
        lstatRet = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("path=%{public}s -> isJbPath=%s -> lstatRet=%d", path, boolToStr(isJbPath), lstatRet);
    }

    return lstatRet;
}

/*==============================================================================
 Hook: fstat()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/fstat.2.html

int fstat(int fd, struct stat *buf);

%hookf(int, fstat, int fd, struct stat *buf){
    iosLogDebug("fd=%d, buf=%p", fd, buf);
    int retInt = STAT_FAILED;
    bool isJbPath = false;

    char parsedPath[PATH_MAX];
    memset(parsedPath, 0, PATH_MAX);

    if (cfgHookEnable_openFileC) {
        // get file path from fd
        bool isGetPathOk = getFilePath(fd, parsedPath);
        iosLogDebug("isGetPathOk=%s, parsedPath=%s", boolToStr(isGetPathOk), parsedPath);
        if (isGetPathOk) {
            isJbPath = isJailbreakPath(parsedPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);

            if (isJbPath){
                retInt = STAT_FAILED;
            } else {
                retInt = %orig;
            }
        } else {
            // can not get path -> can not check is jailbreak or not -> not hook
            retInt = %orig;
        }
    } else {
        retInt = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("fd=%d,buf=%p -> parsedPath=%{public}s -> isJbPath=%s -> retInt=%d", fd, buf, parsedPath, boolToStr(isJbPath), retInt);
    }

    return retInt;
}

/*==============================================================================
 Hook: fstatat()
==============================================================================*/

// https://man7.org/linux/man-pages/man3/fstatat.3p.html
// https://linux.die.net/man/2/fstatat

//int fstatat(int dirfd, const char *pathname, struct stat *buf, int flags);
//int fstatat(int fd, const char *restrict path, struct stat *restrict buf, int flag);
int fstatat(int fd, const char* pathname, struct stat* buf, int flags);

%hookf(int, fstatat, int fd, const char* pathname, struct stat* buf, int flags){
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
            // is relative path
            if (fd == AT_FDCWD){
                iosLogDebug("fd is AT_FDCWD=%d", AT_FDCWD);

                // pathname is interpreted relative to the current working directory of the calling process (like access())
                // TODO: try get current working directory -> avoid caller pass the special path, finnaly is jailbreak path
                // eg: current working directory is "/usr/xxx/yyy/", then pass in "../../libexec/cydia/zzz"
                // finnal path is "/usr/libexec/cydia/zzz", match jailbreak path: "/usr/libexec/cydia/", is jaibreak path
                // but use "../../libexec/cydia/zzz" can not check whether is jailbreak path
            } else {
                // get file path from dir fd
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
                fstatatRet = %orig;
            }
        } else {
            fstatatRet = %orig;
        }
    } else {
        fstatatRet = %orig;
    }

    // for debug
    if (isJbPath) {
        iosLogInfo("fd=%d, pathname=%{public}s, buf=%p, flags=0x%x -> isJbPath=%{bool}d -> fstatatRet=%d", fd, pathname, buf, flags, isJbPath, fstatatRet);
    }

    return fstatatRet;
}


/*==============================================================================
 Hook: statfs()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/statfs.2.html

int statfs(const char *path, struct statfs *buf);

%hookf(int, statfs, const char *path, struct statfs *buf){
    iosLogDebug("path=%{public}s, buf=%p", path, buf);
    int statfsRet = STATFS_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

        if (isJbPath){
            statfsRet = STATFS_FAILED;
        } else {
            statfsRet = %orig;
        }
    } else {
        statfsRet = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("found jailbreak path: path=%{public}s -> isJbPath=%s -> statfsRet=%d", path, boolToStr(isJbPath), statfsRet);
    }

    return statfsRet;
}

/*==============================================================================
 Hook: fstatfs()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/statfs64.2.html

int fstatfs(int fd, struct statfs *buf);

%hookf(int, fstatfs, int fd, struct statfs *buf){
    iosLogDebug("fd=%d, buf=%p", fd, buf);
    int fstatfsRet = STATFS_FAILED;
    bool isJbPath = false;

    char parsedPath[PATH_MAX];
    memset(parsedPath, 0, PATH_MAX);

    if (cfgHookEnable_openFileC) {
        // get file path from fd
        bool isGetPathOk = getFilePath(fd, parsedPath);
        iosLogDebug("isGetPathOk=%s, parsedPath=%s", boolToStr(isGetPathOk), parsedPath);
        if (isGetPathOk) {
            isJbPath = isJailbreakPath(parsedPath);
            iosLogDebug("isJbPath=%{bool}d", isJbPath);

            if (isJbPath){
                fstatfsRet = STATFS_FAILED;
            } else {
                fstatfsRet = %orig;
            }
        } else {
            // can not get path -> can not check is jailbreak or not -> not hook
            fstatfsRet = %orig;
        }
    } else {
        fstatfsRet = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("fd=%d,buf=%p -> parsedPath=%{public}s -> isJbPath=%s -> fstatfsRet=%d", fd, buf, parsedPath, boolToStr(isJbPath), fstatfsRet);
    }

    return fstatfsRet;
}

/*==============================================================================
 Hook: open()
==============================================================================*/

/*
 TODO: maybe need support more version:
        int creat(const char *pathname, mode_t mode);
        int openat(int dirfd, const char *pathname, int flags);
        int openat(int dirfd, const char *pathname, int flags, mode_t mode);
        int openat2(int dirfd, const char *pathname, const struct open_how *how, size_t size);
 refer:
    https://man7.org/linux/man-pages/man2/open.2.html
 */

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/open.2.html
// normally max number of open parameter is 1
int MaxSupportArgNum_open = 2;
int open(const char *path, int oflag, ...);

%hookf(int, open, const char *path, int oflag, ...){
    iosLogDebug("path=%{public}s, oflag=%d", path, oflag);
    bool isJbPath = false;

    if(cfgHookEnable_openFileC_open){
        isJbPath = isJailbreakPath(path);
        iosLogDebug("isJbPath=%{bool}d", isJbPath);

    //    // for debug: for system() call, temp allow /bin/sh
    //    if (0 == strcmp(path, "/bin/sh")){
    //        os_log(OS_LOG_DEFAULT, "hook_open_system: temp allow /bin/sh");
    //        isJbPath = false;
    //    }

        if (isJbPath){
            iosLogInfo("path=%{public}s -> isJbPath=%{bool}d", path, isJbPath);
            errno = ENOENT;
            iosLogDebug("set errno=%d", errno);
            return OPEN_FAILED;
        }
    }

    // Setting up some variables to get all the parameters from open
    mode_t curPara, paraList[MaxSupportArgNum_open];
    va_list argList;
    int curParaNum = 0;

    va_start(argList, oflag);
//    while ((curPara = (mode_t) va_arg(argList, mode_t))) {
//        paraList[curParaNum] = curPara;
//        curParaNum += 1;
//        os_log(OS_LOG_DEFAULT, "hook_open: [%d] curPara=%d", curParaNum, curPara);
//    }
//    unsigned int firstArg = va_arg(argList, mode_t)
//    curPara = (mode_t) va_arg(argList, mode_t);
    curPara = (mode_t) va_arg(argList, unsigned int);
    // maxium is only extra 1 para, so no need while
    if (0 != (int)curPara) {
        paraList[curParaNum] = curPara;
        curParaNum += 1;
        iosLogDebug("[%d] para=%d", curParaNum, curPara);
    }
    va_end(argList);

    iosLogDebug("curParaNum=%d, argList=%{public}s", curParaNum, argList);

//    return %orig;
    int openRetValue = OPEN_FAILED;
    if (0 == curParaNum){
        openRetValue = %orig(path, oflag);
        if (isJbPath) {
            iosLogInfo("%spath=%{public}s, oflag=0x%x -> isJbPath=%{bool}d -> openRetValue=%d", HOOK_PREFIX(cfgHookEnable_openFileC_open), path, oflag, isJbPath, openRetValue);
        }
    } else if (1 == curParaNum){
        mode_t mode = paraList[0];
//        os_log(OS_LOG_DEFAULT, "hook_open: mode=0x%x", mode);
        openRetValue = %orig(path, oflag, mode);
        if (isJbPath) {
            iosLogInfo("%spath=%{public}s, oflag=0x%x, mode=0x%x -> isJbPath=%{bool}d -> openRetValue=%d", HOOK_PREFIX(cfgHookEnable_openFileC_open), path, oflag, mode, isJbPath, openRetValue);
        }
    }
    return openRetValue;
}

/*==============================================================================
 Hook: fopen()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/fopen.3.html
FILE* fopen(const char *filename, const char *mode);

%hookf(FILE*, fopen, const char *filename, const char *mode){
    iosLogDebug("filename=%{public}s, mode=%{public}s", filename, mode);
    FILE* retFp = FOPEN_OPEN_FAILED;
    bool isJbPath = false;

    if(cfgHookEnable_openFileC_fopen){
        isJbPath = isJailbreakPath(filename);
        if (isJbPath){
            retFp = FOPEN_OPEN_FAILED;
        } else {
            retFp = %orig;
        }
    } else {
        retFp = %orig;
    }

    // for debug
    if (isJbPath) {
        iosLogInfo("filename=%{public}s, mode=%{public}s -> isJbPath=%s -> retFp=%d", filename, mode, boolToStr(isJbPath), retFp);
    }
    return retFp;
}

/*==============================================================================
 Hook: access()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/access.2.html
int access(const char *path, int amode);

%hookf(int, access, const char *path, int amode){
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
            retValue = %orig;
        }
    } else {
        retValue = %orig;
    }

    // for debug
    if(isJbPath){
        iosLogInfo("path=%{public}s, amode=0x%x -> isJbPath=%{bool}d, retValue=%d", path, amode, isJbPath, retValue);
    }
    return retValue;
}

/*==============================================================================
 Hook: faccessat()
==============================================================================*/

// https://man7.org/linux/man-pages/man2/access.2.html
// https://linux.die.net/man/2/faccessat
int faccessat(int dirfd, const char *pathname, int mode, int flags);

%hookf(int, faccessat, int dirfd, const char *pathname, int mode, int flags){
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
                retInt = ACCESS_FAILED;
            } else {
                retInt = %orig;
            }
        } else {
            retInt = %orig;
        }
    } else {
        retInt = %orig;
    }

    // for debug
    if (isJbPath) {
        iosLogInfo("%sdirfd=%d, pathname=%{public}s, mode=0x%x, flags=0x%x -> isJbPath=%{bool}d, retInt=%d",
                   HOOK_PREFIX(cfgHookEnable_openFileC_faccessat), dirfd, pathname, mode, flags, isJbPath, retInt);
    }

    return retInt;
}

/*==============================================================================
 Hook: realpath()
==============================================================================*/

// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/realpath.3.html
char* realpath(const char* file_name, char* resolved_name);

%hookf(char*, realpath, const char* file_name, char* resolved_name){
    iosLogDebug("file_name=%{public}s, resolved_name=%p", file_name, resolved_name);
    char* resolvedPath = REALPATH_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC) {
        isJbPath = isJailbreakPath(file_name);
        if (isJbPath) {
            resolvedPath = REALPATH_FAILED;
        } else {
//            resolvedPath = %orig(file_name, resolved_name);
            resolvedPath = %orig;
        }
    } else {
        resolvedPath = %orig;
    }

    // for debug
    if (isJbPath) {
        iosLogInfo("file_name=%{public}s, resolved_name=%{public}s -> isJbPath=%{bool}d -> resolvedPath=%{public}s", file_name, resolved_name, isJbPath, resolvedPath);
    }

    return resolvedPath;
}

/*==============================================================================
 Hook: opendir()
==============================================================================*/

// NOTES: !!! hook opendir will cause app crash.
//  detail log: SubstituteLog: SubHookFunction: substitute_hook_functions returned SUBSTITUTE_ERR_FUNC_BAD_INSN_AT_START

//// https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/opendir.3.html
//DIR* opendir(const char *dirname);
//
//%hookf(DIR*, opendir, const char *dirname){
//    iosLogInfo("dirname=%s", dirname);
////    return %orig;
//    return %orig(dirname);
//}

/*==============================================================================
 Hook: __opendir2()
==============================================================================*/

// https://opensource.apple.com/source/Libc/Libc-186/gen.subproj/opendir.c.auto.html
// https://opensource.apple.com/source/Libc/Libc-320/include/dirent.h.auto.html
DIR *__opendir2(const char *name, int flags);

%hookf(DIR*, __opendir2, const char *name, int flags){
    iosLogDebug("name=%{public}s, flags=0x%x", name, flags);
    DIR* openedDir = OPENDIR_FAILED;
    bool isJbPath = false;

    if (cfgHookEnable_openFileC___opendir2){
        isJbPath = isJailbreakPath(name);
        if (isJbPath) {
            openedDir = OPENDIR_FAILED;
        } else {
//            openedDir = %orig(name, flags);
            openedDir = %orig;
        }
    } else {
//        openedDir = %orig(name, flags);
        openedDir = %orig;
    }

    // for debug
    if (isJbPath) {
        iosLogInfo("name=%{public}s, flags=0x%x -> isJbPath=%{bool}d -> openedDir=%p", name, flags, isJbPath, openedDir);
    }

    return openedDir;
}

/*==============================================================================
 Ctor
==============================================================================*/

%ctor
{
    @autoreleasepool
    {
        iosLogInfo("%s, cfgHookEnable_openFileC=%s", "openFile_C ctor", boolToStr(cfgHookEnable_openFileC));
    }
}

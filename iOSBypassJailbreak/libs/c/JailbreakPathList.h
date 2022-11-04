/*
    File: JailbreakPathList.h
    Function: crifan's common jailbreak file path list header file
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/c/JailbreakPathList.h
    Updated: 20211230_1049
*/

// This will not work with all C++ compilers, but it works with clang and gcc
#ifdef __cplusplus
extern "C" {
#endif

#ifndef JailbreakPathList_h
#define JailbreakPathList_h

#include <stdbool.h>

#include "CrifanLib.h"

extern const int jailbreakPathListLen;
extern const char* jailbreakPathList_Dylib[];
extern const char* jailbreakPathList_Other[];
//extern char* jailbreakPathList_Dylib[];
//extern char* jailbreakPathList_Other[];
extern const int jailbreakPathListLen_Dylib;
extern const int jailbreakPathListLen_Other;

//extern const char* jailbreakPathList[];
const char** getJailbreakPathList(void);
//char** getJailbreakPathList(void);

bool isPathInJailbreakPathList(const char *curPath);
bool isJailbreakPath_pureC(const char *curPath);
bool isJailbreakPath_realpath(const char *pathname);
bool isJailbreakPath(const char *pathname);
bool isJailbreakDylib(const char *pathname);
bool isJailbreakDylibFunctionName(const char *libFuncName);

bool isPathInList(
      const char* inputPath,
//      char* inputPath,
      const char** pathList,
//      char** pathList,
      int pathListLen,
      bool isConvertToPurePath, // is convert to pure path or not
      bool isCmpSubFolder // is compare sub foder or not
);

#endif /* JailbreakPathList_h */

#ifdef __cplusplus
}
#endif

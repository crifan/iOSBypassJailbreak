/*
    File: JailbreakPathList.c
    Function: crifan's common jailbreak file path list
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/c/JailbreakPathList.c
    Updated: 20221104_1730
*/

#include "JailbreakPathList.h"

/*==============================================================================
 Jailbreak Path List
==============================================================================*/

// when use isJailbreakPath_realpath, should/could disable KEEP_SOFT_LINK -> internally will convert soft link to real link, so no need soft link
// when use isJailbreakPath_pureC, shold enable KEEP_SOFT_LINK -> to include other soft link jailbreak path for later compare
#define KEEP_SOFT_LINK

const char* jailbreakDylibFuncNameList[] = {
    "MSGetImageByName",
    "MSFindSymbol",
    "MSHookFunction",
    "MSHookMessageEx",

    "SubGetImageByName",
    "SubFindSymbol",
    "SubHookFunction",
    "SubHookMessageEx",
};

const char* jailbreakPathList_Dylib[] = {
//char* jailbreakPathList_Dylib[] = {
    // common: tweak plugin libs
    "/Library/Frameworks/Cephei.framework/Cephei", // -> /usr/lib/CepheiUI.framework/CepheiUI ?

#ifdef KEEP_SOFT_LINK
    "/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", // -> /usr/lib/libsubstrate.dylib
#endif

    "/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/0Shadow.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/afc2dService.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/afc2dSupport.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/AppSyncUnified-FrontBoard.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/AppSyncUnified-installd.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/ChoicySB.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/dygz.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/LiveClock.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/MobileSafety.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/RocketBootstrap.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/Veency.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/xCon.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/zorro.dylib",
    "/Library/MobileSubstrate/DynamicLibraries/zzzzHeiBaoLib.dylib",

    "/usr/lib/libsubstrate.dylib",

    // Cydia Substrate libs
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/usr/lib/CepheiUI.framework/CepheiUI",
    "/usr/lib/substrate/SubstrateInserter.dylib",
    "/usr/lib/substrate/SubstrateLoader.dylib",
    "/usr/lib/substrate/SubstrateBootstrap.dylib",

    // Substitute libs
    "/usr/lib/libsubstitute.dylib",
#ifdef KEEP_SOFT_LINK
    "/usr/lib/libsubstitute.0.dylib", // -> /usr/lib/libsubstitute.dylib
#endif
    "/usr/lib/substitute-inserter.dylib",
    "/usr/lib/substitute-loader.dylib",
#ifdef KEEP_SOFT_LINK
    "/Library/Frameworks/CydiaSubstrate.framework/SubstrateLoader.dylib", // -> /usr/lib/substitute-loader.dylib
#endif

    // Other libs
    "/private/var/lib/clutch/overdrive.dylib",
    "/usr/lib/frida/frida-agent.dylib",

#ifdef KEEP_SOFT_LINK
    "/usr/lib/libapt-inst.2.0.dylib",
    "/usr/lib/libapt-pkg.5.0.dylib",
    "/usr/lib/libapt-private.0.0.dylib",
#endif
    "/usr/lib/libapt-inst.2.0.0.dylib",
    "/usr/lib/libapt-pkg.5.0.2.dylib",
    "/usr/lib/libapt-private.0.0.0.dylib",

    "/usr/lib/libcycript.dylib",
    "/usr/lib/librocketbootstrap.dylib",
    "/usr/lib/tweakloader.dylib",
};

const char* jailbreakPathList_Other[] = {
//char* jailbreakPathList_Other[] = {
    "/Applications/Activator.app",
    "/Applications/ALS.app",
    "/Applications/blackra1n.app",
    "/Applications/Cydia.app",
    "/Applications/FakeCarrier.app",
    "/Applications/Filza.app",
    "/Applications/FlyJB.app",
    "/Applications/Icy.app",
    "/Applications/iFile.app",
    "/Applications/Iny.app",
    "/Applications/IntelliScreen.app",
    "/Applications/MTerminal.app",
    "/Applications/MxTube.app",
    "/Applications/RockApp.app",
    "/Applications/SBSettings.app",
    "/Applications/SubstituteSettings.app"
    "/Applications/SubstituteSettings.app/Info.plist",
    "/Applications/SubstituteSettings.app/SubstituteSettings",
    "/Applications/Snoop-itConfig.app",
    "/Applications/WinterBoard.app",

#ifdef KEEP_SOFT_LINK
    "/bin/sh",
#endif
    "/bin/bash",

#ifdef KEEP_SOFT_LINK
    // Note: etc -> private/etc/ !!!
    "/etc/alternatives/sh",
    "/etc/apt",
    "/etc/apt/preferences.d/checkra1n",
    "/etc/apt/preferences.d/cydia",
    "/etc/clutch.conf",
    "/etc/clutch_cracked.plist",
    "/etc/dpkg/origins/debian",
    "/etc/rc.d/substitute-launcher",
    "/etc/ssh/sshd_config",
#endif

    "/Library/Activator",
    "/Library/Flipswitch",
    "/Library/dpkg/",

    "/Library/Frameworks/CydiaSubstrate.framework/",
    "/Library/Frameworks/CydiaSubstrate.framework/Headers/"
    "/Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h",
    "/Library/Frameworks/CydiaSubstrate.framework/Info.plist",

    "/Library/LaunchDaemons/ai.akemi.asu_inject.plist",
    "/Library/LaunchDaemons/com.openssh.sshd.plist",
    "/Library/LaunchDaemons/com.rpetrich.rocketbootstrapd.plist",
    "/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
    "/Library/LaunchDaemons/com.tigisoftware.filza.helper.plist",
    "/Library/LaunchDaemons/dhpdaemon.plist",
    "/Library/LaunchDaemons/re.frida.server.plist",

    // for debug: try avoid 抖音(Aweme) crash
    "/Library/MobileSubstrate/",
    "/Library/MobileSubstrate/DynamicLibraries/",

    "/Library/MobileSubstrate/DynamicLibraries/   Choicy.plist",
    "/Library/MobileSubstrate/DynamicLibraries/afc2dService.plist",
    "/Library/MobileSubstrate/DynamicLibraries/afc2dSupport.plist",
    "/Library/MobileSubstrate/DynamicLibraries/AppSyncUnified-FrontBoard.plist",
    "/Library/MobileSubstrate/DynamicLibraries/AppSyncUnified-installd.plist",
    "/Library/MobileSubstrate/DynamicLibraries/ChoicySB.plist",
    "/Library/MobileSubstrate/DynamicLibraries/dygz.plist",
    "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
    "/Library/MobileSubstrate/DynamicLibraries/MobileSafety.plist",
    "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.plist",
    "/Library/MobileSubstrate/DynamicLibraries/RocketBootstrap.plist",
    "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
    "/Library/MobileSubstrate/DynamicLibraries/xCon.plist",
    "/Library/MobileSubstrate/DynamicLibraries/zorro.plist",
    "/Library/MobileSubstrate/DynamicLibraries/zzzzHeiBaoLib.plist",
    
    "/Library/PreferenceBundles/SubstitutePrefs.bundle/",
    "/Library/PreferenceBundles/SubstitutePrefs.bundle/Info.plist",
    "/Library/PreferenceBundles/SubstitutePrefs.bundle/SubstitutePrefs",
    
    "/Library/PreferenceLoader/Preferences/SubstituteSettings.plist",

    "/private/etc/alternatives/sh",
    "/private/etc/apt",
    "/private/etc/apt/preferences.d/checkra1n",
    "/private/etc/apt/preferences.d/cydia",
    "/private/etc/clutch.conf",
    "/private/etc/clutch_cracked.plist",
    "/private/etc/dpkg/origins/debian",
    "/private/etc/rc.d/substitute-launcher",
    "/private/etc/ssh/sshd_config",

    "/private/var/cache/apt/",
    "/private/var/cache/clutch.plist",
    "/private/var/cache/clutch_cracked.plist",
    "/private/var/db/stash",
    "/private/var/evasi0n",
    "/private/var/lib/apt/",
    "/private/var/lib/cydia/",
    "/private/var/lib/dpkg/",
    
    "/private/var/mobile/Applications/", //TODO: non-jailbreak can normally open?
    "/private/var/mobile/Library/Filza/",
    "/private/var/mobile/Library/Filza/pasteboard.plist",
    "/private/var/mobile/Library/Cydia/",
    "/private/var/mobile/Library/Preferences/com.ex.substitute.plist",
    "/private/var/mobile/Library/SBSettingsThemes/",
    "/private/var/MobileSoftwareUpdate/mnt1/System/Library/PrivateFrameworks/DictionaryServices.framework/SubstituteCharacters.plist",
    "/private/var/root/Documents/Cracked/",
    "/private/var/stash",
    "/private/var/tmp/cydia.log",

    "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
    "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
    "/System/Library/PrivateFrameworks/DictionaryServices.framework/SubstituteCharacters.plist",

#ifdef KEEP_SOFT_LINK
    // Note: /User -> /var/mobile/
    "/User/Applications/", //TODO: non-jailbreak can normally open?
    "/User/Library/Filza/",
    "/User/Library/Filza/pasteboard.plist",
    "/User/Library/Cydia/",
#endif

    "/usr/bin/asu_inject",
    "/usr/bin/cycc",
    "/usr/bin/cycript",
#ifdef KEEP_SOFT_LINK
    "/usr/bin/cynject", // -> /usr/bin/sinject
    "/usr/bin/Filza", // -> /usr/libexec/filza/Filza
#endif
    "/usr/bin/scp",
    "/usr/bin/sftp",
    "/usr/bin/ssh",
    "/usr/bin/ssh-add",
    "/usr/bin/ssh-agent",
    "/usr/bin/ssh-keygen",
    "/usr/bin/ssh-keyscan",
    "/usr/bin/sshd",
    "/usr/bin/sinject",

    "/usr/include/substrate.h",

    "/usr/lib/cycript0.9/",
    "/usr/lib/cycript0.9/com/",
    "/usr/lib/cycript0.9/com/saurik/"
    "/usr/lib/cycript0.9/com/saurik/substrate/",
    "/usr/lib/cycript0.9/com/saurik/substrate/MS.cy",
    "/usr/libexec/filza/Filza",
    "/usr/libexec/substituted",
    "/usr/libexec/sinject-vpa",

    "/usr/lib/substrate/",

    "/usr/lib/TweakInject",

    "/usr/libexec/cydia/",
    "/usr/libexec/sftp-server",
    "/usr/libexec/substrate",
    "/usr/libexec/substrated",
    "/usr/libexec/ssh-keysign",

    "/usr/local/bin/cycript",

    "/usr/sbin/frida-server",
    "/usr/sbin/sshd",

#ifdef KEEP_SOFT_LINK
    // /var -> /private/var/

    // TODO: add more /var/xxx path
    "/var/cache/apt/",
    "/var/cache/clutch.plist",
    "/var/cache/clutch_cracked.plist",
    "/var/db/stash",
    "/var/evasi0n",
    "/var/lib/apt/",
    "/var/lib/cydia/",
    "/var/lib/dpkg/",

    "/var/mobile/Applications/", //TODO: non-jailbreak can normally open?
    "/var/mobile/Library/Filza/",
    "/var/mobile/Library/Filza/pasteboard.plist",
    "/var/mobile/Library/Cydia/",
    "/var/mobile/Library/Preferences/com.ex.substitute.plist",
    "/var/mobile/Library/SBSettingsThemes/",
    "/var/MobileSoftwareUpdate/mnt1/System/Library/PrivateFrameworks/DictionaryServices.framework/SubstituteCharacters.plist",
    "/var/root/Documents/Cracked/",
    "/var/stash",
    "/var/tmp/cydia.log",

#endif
};

const int StrSize = sizeof(const char *);
const int jailbreakPathListLen_Dylib = sizeof(jailbreakPathList_Dylib) / StrSize;
const int jailbreakPathListLen_Other = sizeof(jailbreakPathList_Other) / StrSize;

//int jailbreakPathListLen = sizeof(jailbreakPathList) / StrSize;
const int jailbreakPathListLen = jailbreakPathListLen_Dylib + jailbreakPathListLen_Other;

const int jailbreakDylibFuncNameListLen = sizeof(jailbreakDylibFuncNameList) / StrSize;

const char** getJailbreakPathList(void){
    int strPtrMaxIdx = jailbreakPathListLen; // 133
    int strPtrNum = strPtrMaxIdx + 1; // 134
    int singleSize = sizeof(const char *); // 8
    size_t mallocSize = singleSize * strPtrNum; // 1072
    const char** jailbreakPathStrPtrList = malloc(mallocSize);
    // jailbreakPathStrPtrList=0x000000011e840c00

    // set each string
    for(int curStrIdx = 0; curStrIdx < jailbreakPathListLen_Dylib; curStrIdx++){
        const char* curStrPtr = jailbreakPathList_Dylib[curStrIdx];
        jailbreakPathStrPtrList[curStrIdx] = curStrPtr;
    }

    for(int curStrIdx = 0; curStrIdx < jailbreakPathListLen_Other; curStrIdx++){
        int totalIndex = jailbreakPathListLen_Dylib + curStrIdx;
        const char* curStrPtr = jailbreakPathList_Other[curStrIdx];
        jailbreakPathStrPtrList[totalIndex] = curStrPtr;
    }
    // set end
    jailbreakPathStrPtrList[strPtrMaxIdx] = NULL;

    return jailbreakPathStrPtrList;
}


/*==============================================================================
 Jailbreak Function
==============================================================================*/

bool isPathInList(
      const char* inputPath,
//      char* inputPath,
      const char** pathList,
//      char** pathList,
      int pathListLen,
      bool isConvertToPurePath, // is convert to pure path or not
      bool isCmpSubFolder // is compare sub foder or not
){
    bool isInside = false;
    if (!inputPath) {
        return isInside;
    }

    char* inputOrigOrPurePath = NULL;
    if (isConvertToPurePath){
        inputOrigOrPurePath = toPurePath(inputPath);
    }else{
        inputOrigOrPurePath = strdup(inputPath);
    }

    char* matchedPath = NULL;

    char* curPathNoEndSlash = NULL;
    char * curPathWithEndSlash = NULL;
    for (int i=0; i < pathListLen; i++) {
        const char* curPath = pathList[i];
//        char* curPath = pathList[i];
        if (isPathEaqual(inputOrigOrPurePath, curPath)){
            isInside = true;
            matchedPath = (char *)curPath;
            break;
        }

        if (isCmpSubFolder){
            // check sub folder
            // "/Applications/Cydia.app/Info.plist" belong to "/Applications/Cydia.app/", should bypass
            // but avoid: '/usr/bin/ssh-keyscan' starts with '/usr/bin/ssh'
            curPathNoEndSlash = removeEndSlash(curPath);
            curPathWithEndSlash = NULL;
            asprintf(&curPathWithEndSlash, "%s/", curPathNoEndSlash);

            if (strStartsWith(inputOrigOrPurePath, curPathWithEndSlash)){
                isInside = true;
                matchedPath = (char *)curPath;
                break;
            }
        }

        if(NULL != curPathNoEndSlash){
            free(curPathNoEndSlash);
            curPathNoEndSlash = NULL;
        }
        
        if(NULL != curPathWithEndSlash){
            free(curPathWithEndSlash);
            curPathWithEndSlash = NULL;
        }
    }
    
    if (NULL != inputOrigOrPurePath){
        free(inputOrigOrPurePath);
    }

    return isInside;
}

bool isPathInJailbreakPathList(const char *curPath){
    bool isInJbPathList = false;

    const char** jailbreakPathList = getJailbreakPathList();
    if(jailbreakPathList) {
        isInJbPathList = isPathInList(curPath, jailbreakPathList, jailbreakPathListLen, true, true);
        // final: free char** self
        free(jailbreakPathList);
    }

    return isInJbPathList;
}

bool isJailbreakPath_pureC(const char *curPath){
    bool isJbPath = false;
    if (!curPath) {
        return isJbPath;
    }
    
    isJbPath = isPathInJailbreakPathList(curPath);

    return isJbPath;
}

bool isJailbreakPath_realpath(const char *curPath){
    bool isJbPath = false;
    if (!curPath) {
        return isJbPath;
    }

    char gotRealPath[PATH_MAX];
    bool isParseRealPathOk = parseRealPath(curPath, gotRealPath);
//    os_log(OS_LOG_DEFAULT, "isJailbreakPath: isParseRealPathOk=%{bool}d", isParseRealPathOk);

    char curRealPath[PATH_MAX];
    if (isParseRealPathOk) {
        strcpy(curRealPath, gotRealPath);
    } else {
        strcpy(curRealPath, curPath);
    }
//    os_log(OS_LOG_DEFAULT, "isJailbreakPath: curRealPath=%{public}s", curRealPath);
    isJbPath = isPathInJailbreakPathList(curRealPath);

    return isJbPath;
}

// "/Applications/Cydia.app" -> true
bool isJailbreakPath(const char *pathname){
    if (!pathname) {
        return false;
    } else {
    //    return isJailbreakPath_realpath(pathname);
        return isJailbreakPath_pureC(pathname);
    }
}

// "/Library/MobileSubstrate/MobileSubstrate.dylib" -> true
bool isJailbreakDylib(const char *pathname){
    bool isJbDylib = false;

    if (NULL != pathname){
        isJbDylib = isPathInList(pathname, jailbreakPathList_Dylib, jailbreakPathListLen_Dylib, true, false);
    }

    return isJbDylib;
}

// "MSHookFunction" -> true
bool isJailbreakDylibFunctionName(const char *libFuncName){
    bool isJbDylibFuncName = false;

    if (NULL != libFuncName){
        isJbDylibFuncName = isPathInList(libFuncName, jailbreakDylibFuncNameList, jailbreakDylibFuncNameListLen, false, false);
    }

    return isJbDylibFuncName;
}

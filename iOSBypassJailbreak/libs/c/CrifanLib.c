/*
    File: CrifanLib.c
    Function: crifan's common C libs implementation
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/c/crifanLib.c
    Updated: 20220415_1041
*/

#include "CrifanLib.h"


/*==============================================================================
 Integer
==============================================================================*/

// 2, [1, 2, 3, 4], 4 -> true
bool isIntInList(int valueToCheck, int* intList, int intListLen){
    bool isInList = false;
    if ( (NULL != intList) && (intListLen > 0) ) {
        for(int i = 0; i < intListLen; i++){
            int curIntValue = intList[i];
            if (curIntValue == valueToCheck){
                isInList = true;
                break;
            }
        }
    }

    return isInList;
}

/*==============================================================================
 Date Time
==============================================================================*/

//Note: compile time only take effect for current time
// so normally should direct use `__DATE__ " " __TIME__` inside your code
//// -> "Jan 19 2022 10:34:16"
//char* getCompileDateTimeStr(void){
////    const char* CompileDateStr = __DATE__; // "Jan 19 2022"
//    //    const char* DATE_FORMAT = "%Y-%m-%d";
//    //    const char* DATE_FORMAT = "%b %d %Y";
////    const char* CompileTimeStr = __TIME__; // "10:34:16"
//    //    char* CompileDateTimeStr = NULL;
//    //    asprintf(&CompileDateTimeStr, "%s %s", CompileDateStr, CompileTimeStr);
//    //    char* CompileDateTimeStr = CompileDateStr " " CompileTimeStr; // "Jan 19 2022 10:34:16"
//    char* CompileDateTimeStr = __DATE__ " " __TIME__; // "Jan 19 2022 10:34:16"
//    return CompileDateTimeStr;
//}

// "Jan 19 2022 10:34:16", struct tm outTimeInfo -> "" and outTimeInfo got parsed info
char* parseTimeInfo(char* dateTimeStr, struct tm* outTimeInfo){
    const char* DATE_TIME_FORMAT = "%b %d %Y %H:%M:%S";
    char* notProcessedStr = strptime(dateTimeStr, DATE_TIME_FORMAT, outTimeInfo); // ""
    return notProcessedStr;
}

// currentTime="2022-1-24 15:24:00", expiredTimeStr = "2022-1-24 15:30:00" -> False
// currentTime="2022-1-24 15:24:00", expiredTimeStr = "2022-1-24 15:10:00" -> True
bool isTimeExpired(const char* expiredTimeStr) {
    bool isExpired = false;
    const char* STRPTIME_FAILED = NULL;
    struct tm expiredTimeInfo;
    char* notProcessedStr = strptime(expiredTimeStr, "%Y-%m-%d %H:%M:%S", &expiredTimeInfo);
    if (notProcessedStr != STRPTIME_FAILED ){
        time_t expiredTimeEpoch = mktime(&expiredTimeInfo);
//        printf("expiredTimeEpoch=%ld\n", expiredTimeEpoch); // 1643004660
        time_t curTimeEpoch = time(NULL);
//        printf("curTimeEpoch=%ld\n", curTimeEpoch); // 1643008661
        isExpired = curTimeEpoch >= expiredTimeEpoch;
//        // for debug
//        time_t diffTimeEcoch = curTimeEpoch - expiredTimeEpoch;
//        printf("diffTimeEcoch=%ld\n", diffTimeEcoch); // 4001
    }
    return isExpired;
}

/*==============================================================================
 Char
==============================================================================*/

// init srand once -> then later rand() can get diff value each call
void initRandomChar(void){
    srand((unsigned int)time(NULL));
}

// NULL -> 'F'
// "abcd" -> 'c'
char randomChar(const char* choiceStr){
    const char* allLettersStr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int allLettersLen = (int)strlen(allLettersStr);

    if ( (NULL == choiceStr) || (0 == strcmp(choiceStr, "")) ) {
        choiceStr = allLettersStr;
    }

    int randomValue = (int)rand();
//    printf("randomValue=%d\n", randomValue);
    int charIdx = randomValue % allLettersLen;
//    printf("charIdx=%d\n", charIdx);
    char curChar = *(allLettersStr + charIdx);
//    printf("curChar=%c\n", curChar);
    return curChar;
}

/*==============================================================================
 String
==============================================================================*/

// 5, NULL -> "StKdA"
// Note: should init once initRandomChar(), before call this randomStr
char* randomStr(int strLen, const char* choiceStr){
    char* retStr = NULL;
    
//    initRandomChar();
    for(int charIdx=0; charIdx < strLen; charIdx++){
        char curChar = randomChar(choiceStr);
        if (NULL != retStr){
            char* toFreePtr = retStr;
            asprintf(&retStr, "%s%c", retStr, curChar);
            free(toFreePtr);
        } else {
            asprintf(&retStr, "%c", curChar);
        }
    }
    return retStr;
}

char* boolToStr(bool curBool){
    return curBool ? "True": "False";
}

// "CYDIA://xxx" -> "cydia://xxx"
char* strToLowercase(const char* origStr){
    if (NULL == origStr) {
        return NULL;
    }

    char* lowerStr = strdup(origStr);;
    char curChar = lowerStr[0];
    for(int i = 0; curChar != '\0'; i++){
        curChar = lowerStr[i];
        char curCharLower = tolower(curChar);
        lowerStr[i] = curCharLower;
    }
    return lowerStr;
}

// "/somePath", "/" -> true
bool strStartsWith(const char *fullStr, const char *prefixStr)
{
    bool isStartsWith = false;

    if ((NULL != fullStr) && (NULL != prefixStr)) {
        isStartsWith = (0 == strncmp(prefixStr, fullStr, strlen(prefixStr)));
    }

    return isStartsWith;
}

// "/Library/dpkg/", "/" -> true
bool strEndsWith(const char* fullStr, const char* endStr){
    if ( (NULL == fullStr) || (NULL == endStr) ) {
        return false;
    }

    size_t fullStrLen = strlen(fullStr);
    size_t endStrLen = strlen(endStr);

    if (endStrLen >  fullStrLen){
        return false;
    }

//    return strncmp(fullStr + fullStrLen - endStrLen, endStr, endStrLen) == 0;
    const char* partStr = fullStr + (fullStrLen - endStrLen);

//    // for debug
//    if (NULL == partStr) {
//        printf("strEndsWith: Abnormal case for partStr is NULL\n");
////    } else {
////        printf("strEndsWith: partStr=%s\n", partStr);
//    }

    bool isEndEqual = (0 == strcmp(partStr, endStr));
    return isEndEqual;
}

/*
 "./relative/path", "./" -> "relative/path"

 call example:

    char* toFreePtr = NULL;
    const char* resultStr = removeHead(fullStr, headStr, &toFreePtr);
    ...
    // free(resultStr);
    if (NULL != toFreePtr) {
        free(toFreePtr);
    }
 */
char* removeHead(const char* fullStr, const char* headStr, char** toFreePtr){
    if (NULL == fullStr) {
        return NULL;
    }

    char *newStr = strdup(fullStr);
//    if(NULL != *toFreePtr){
    *toFreePtr = newStr;
//    }

    if (NULL == headStr){
        return newStr;
    }

    size_t fullLen = strlen(fullStr);
    size_t headLen = strlen(headStr);

    if (headLen > fullLen){
        return newStr;
    }

    if (strStartsWith(fullStr, headStr)){
        newStr += headLen;
    }

    return newStr;
}

// "/./Library/../Library/dpkg/.", "/." -> "/./Library/../Library/dpkg"
char* removeTail(const char* fullStr, const char* tailStr){
    if (NULL == fullStr) {
        return NULL;
    }

    char *newStr = strdup(fullStr);

    if (NULL == tailStr){
        return newStr;
    }

    size_t fullLen = strlen(fullStr);
    size_t tailLen = strlen(tailStr);

    if (tailLen > fullLen){
        return newStr;
    }

    if (strEndsWith(fullStr, tailStr)){
        size_t endIdx = fullLen - tailLen;
        newStr[endIdx] = '\0';
    }

    return newStr;
}

// "/./Library/../Library/dpkg/" -> "/./Library/../Library/dpkg"
char* removeEndSlash(const char* origPath) {
    if (NULL == origPath) {
        return NULL;
    }

    const char* slash = "/";
    char* newPath = NULL;

    bool isRoot = (0 == strcmp(origPath, slash));
    if (isRoot) {
        newPath = strdup(slash);
    }else{
        newPath = removeTail(origPath, slash);
    }

    return newPath;
}

// "/./Library/../Library/dpkg/./", "/./", "/" -> "/Library/../Library/dpkg"
char* strReplace(const char *fullStr, const char *replaceFromStr, const char *replaceToStr){
    char *result; // the return string
    char *ins;    // the next insert point
    char *tmp;    // varies
    long len_from;  // length of from (the string to remove)
    long len_to; // length of with (the string to replace rep with)
    long len_front; // distance between from and end of last from
    int count;    // number of replacements

    // sanity checks and initialization
    // if (!fullStr || !replaceFromStr){
    //     return NULL;
    // }

    if (NULL == fullStr) {
        return NULL;
    }

    if (NULL == replaceFromStr) {
        char* newStr = strdup(fullStr);
        return newStr;
    }

    len_from = strlen(replaceFromStr);
    if (len_from == 0){
        return NULL; // empty rep causes infinite loop during count
    }

    if (NULL == replaceToStr){
        replaceToStr = "";
    }

    len_to = strlen(replaceToStr);

    // count the number of replacements needed
    ins = (char *)fullStr;
    for (count = 0; (tmp = strstr(ins, replaceFromStr)); ++count) {
        ins = tmp + len_from;
    }
    
    long newStrLen = strlen(fullStr) + (len_to - len_from) * count + 1;
    tmp = result = malloc(newStrLen);

    if (NULL == result){
        return NULL;
    }

    // first time through the loop, all the variable are set correctly
    // from here on,
    //    tmp points to the end of the result string
    //    ins points to the next occurrence of rep in orig
    //    orig points to the remainder of orig after "end of rep"
    while (count--) {
        ins = strstr(fullStr, replaceFromStr);
        len_front = ins - fullStr;
        tmp = strncpy(tmp, fullStr, len_front) + len_front;
        tmp = strcpy(tmp, replaceToStr) + len_to;
        fullStr += len_front + len_from; // move to next "end of rep"
    }
    strcpy(tmp, fullStr);
    return result;
}

/*
 input:
    fullStr="/bin/bash/.."
    delim="/"
 output:
    *resultListLenPtr = 3
    *resultSubStrListPtr = [
        "bin",
        "bash"
        "..",
    ]
 */
void strSplit(const char* fullStr, const char* delim, char*** resultSubStrListPtr, int* resultListLenPtr){
//    printf("fullStr=%s, delim=%s\n", fullStr, delim);
    if (NULL == fullStr) {
        if (resultListLenPtr) {
            *resultListLenPtr = 0;
        }
        return;
    }

    if (NULL == delim) {
        if (resultListLenPtr) {
            *resultListLenPtr = 0;
        }

        if (resultSubStrListPtr) {
            *resultSubStrListPtr = NULL;
        }
        return;
    }

    const int ListLenMaxEnought = 100;
    char** tempSubStrListPtr = malloc(ListLenMaxEnought * sizeof(char*));

    char *token;
    int curListIdx = 0;
    int curListLen = 0;
    
    char *inputFullStr = strdup(fullStr);

    /* get the first token */
    token = strtok(inputFullStr, delim);

    /* walk through other tokens */
    while(NULL != token) {
        char* tmpToken = strdup(token);
//        printf("[%d] %s\n", curListIdx, tmpToken);

        tempSubStrListPtr[curListIdx] = tmpToken;

        curListLen = curListIdx + 1;

        curListIdx += 1;

        token = strtok(NULL, delim);
    }

    free(inputFullStr);

//    printf("curListLen=%d\n", curListLen);

    if (curListLen > 0){
        *resultListLenPtr = curListLen;
        *resultSubStrListPtr = tempSubStrListPtr;
  
//        // for debug
//        printf("%s =>\n", fullStr);
//        for(int i=0; i < curListLen; i++){
//            char* curSubStr = tempSubStrListPtr[i];
//            printf("\t[%d] %s\n", i, curSubStr);
//        }
    } else {
        *resultListLenPtr = 0;
        *resultSubStrListPtr = NULL;
    }
}


/*==============================================================================
 File Size
==============================================================================*/

//http://www.crifan.com/order_how_to_calculate_the_file_size__length_caculate_the_file_length__size/
//calculate file size/length
//return negative if error

//method 1: use fgetc
//good: universial
//bad: maybe overflow if files too large
long calulateFilesize_fgetc(char* inputFilename){
    long filesize = 0;
    if (NULL == inputFilename) {
        return filesize;
    }

    FILE * inputFp = fopen(inputFilename, "rb");

    if (NULL == inputFp) {
        //printf("Error opening input file %s", inputFilename);
        return -1;
    }

    /* caculate the file length(bytes) */
    char singleChar = fgetc(inputFp);
    while(EOF != singleChar)
    {
        ++filesize;
        singleChar = fgetc(inputFp);
    }
    
    return filesize;
}

//method 2: fseek + ftell
//good: fast
//bad:
long calulateFilesize_ftell(char* inputFilename){
    if (NULL == inputFilename) {
        return -1;
    }

    long filesize = 0;
    FILE* inputFp = fopen(inputFilename, "rb");
    if (NULL == inputFp) {
        //printf("Error opening input file %s", inputFilename);
        return -1;
    }

    /*
        标识符     数值     代表的起始点
        SEEK_SET   0        文件开始
        SEEK_END   2        文件末尾
        SEEK_CUR   1        文件当前位置
    */

    fseek(inputFp, 0, SEEK_END);

    filesize = ftell(inputFp);
    
    return filesize;
}

//method 3: fstat
//good: fast
//bad: system dependent
long calulateFilesize_fstat(char* inputFilename)
{
    long filesize = 0;

    if (NULL == inputFilename) {
        return filesize;
    }

    //http://linux.die.net/man/2/fstat
    struct stat fileStat;
    
    //http://www.go4expert.com/articles/understanding-linux-fstat-example-t27449/
    int inputFd = open(inputFilename, O_RDONLY); // fd=File Descriptor
    if (inputFd < 0) {
        //open file error
        return inputFd;
    }

    int fstatRet = fstat(inputFd, &fileStat);
    if (fstatRet < 0)
    {
        close(inputFd);
        
        return fstatRet;
    }

    filesize = fileStat.st_size;
    
    close(inputFd);
    
    return filesize;
}

/*==============================================================================
 File Mode
==============================================================================*/

// file mode to string
// mode=16877 -> modeStrBuf="rwxr-xr-x"
void fileModeToStr(mode_t mode, char * modeStrBuf) {
    if (NULL == modeStrBuf) {
        return;
    }

    // buf must have at least 10 bytes
    const char chars[] = "rwxrwxrwx";
    for (size_t i = 0; i < 9; i++) {
//        buf[i] = (mode & (1 << (8-i))) ? chars[i] : '-';
        bool hasSetCurBit = mode & (1 << (8-i));
        modeStrBuf[i] = hasSetCurBit ? chars[i] : '-';
    }
    modeStrBuf[9] = '\0';
}

//void fileTypeToStr(mode_t mode, char * fileStrBuf) {
//char* fileTypeToStr(mode_t mode) {
// mode=10804 -> fileStrBuf="c"
char* fileTypeToChar(mode_t mode) {
    char * fileStrBuf = NULL;
    char* unknown = "?";
    fileStrBuf = strdup(unknown);

    bool isFifo = (bool)S_ISFIFO(mode);
    if (isFifo){
        fileStrBuf = strdup("p");
    }

    bool isChar = (bool)S_ISCHR(mode);
    if (isChar){
        fileStrBuf = strdup("c");
    }

    bool isDir = (bool)S_ISDIR(mode);
    if (isDir){
        fileStrBuf = strdup("d");
    }

    bool isBlock = (bool)S_ISBLK(mode);
    if (isBlock){
        fileStrBuf = strdup("b");
    }

    bool isRegular = (bool)S_ISREG(mode);
    if (isRegular){
        fileStrBuf = strdup("-");
    }

    bool isLink = (bool)S_ISLNK(mode);
    if (isLink){
        fileStrBuf = strdup("l");
    }

    bool isSocket = (bool)S_ISSOCK(mode);
    if (isSocket){
        fileStrBuf = strdup("s");
    }

////    if (strcmp(fileStrBuf, "") != 0){
//    if (strlen(fileStrBuf) > 0){
//        // remove first empty char
//        char firstChar = fileStrBuf[0];
//        if (firstChar == ' '){
//            fileStrBuf = fileStrBuf + 1;
//        }
//
//        // remove last ','
//        int curLen = (int)strlen(fileStrBuf);
//        int lastCharIdx = curLen - 1;
//        char lastChar = fileStrBuf[lastCharIdx];
//        if (lastChar == ','){
//            fileStrBuf[lastCharIdx] = '\0';
//        }
//    }

    return fileStrBuf;
}

// 0 -> "0"
char* fileSizeToStr(off_t fileStSize){
    char* fileSizeStr = NULL;
    asprintf(&fileSizeStr, "%lld", (long long)fileStSize);
    return fileSizeStr;
}

/*
 statInfo stat *
    st_dev=16777222
    st_mode=10804
 =>
 statStr="stat info: st_mode=c---rw-r--, st_size=0"
 */
//
char* statToStr(struct stat* statInfo){
    if (NULL == statInfo) {
        return NULL;
    }

//    char fileTypeStr[100];
    char *fileTypeStr=NULL;
//    fileTypeToStr(statInfo->st_mode, fileTypeStr);
//    fileTypeStr = fileTypeToStr(statInfo->st_mode);
    fileTypeStr = fileTypeToChar(statInfo->st_mode);
    //fileTypeStr    char *    "d"    0x0000000282331e00

    char fileModeStr[10];
    fileModeToStr(statInfo->st_mode, fileModeStr);
    //fileModeStr    char [10]    "rwxr-xr-x"
  
    char *fullFileModeStr=NULL;
    asprintf(&fullFileModeStr, "%s%s", fileTypeStr, fileModeStr);
    //fullFileModeStr    char *    "drwxr-xr-x"    0x0000000282331d80
    
    char* fileSizeStr = fileSizeToStr(statInfo->st_size);

//    char *statStr;
//    unsigned long MaxBufNum = 100;
//    snprintf(statStr, MaxBufNum, "st_mode: st_mode=%s", stModeStr);
    
//    int maxEnoughtBufLen = 50;
////    char statStr[maxEnoughtBufLen];
//    char *statStr = (char*)malloc(maxEnoughtBufLen * sizeof(char));
//    sprintf(statStr, "stat info: st_mode=%s", stModeStr);

    char *statStr = NULL;
    asprintf(&statStr, "stat info: st_mode=%s, st_size=%s", fullFileModeStr, fileSizeStr);
    //statStr    char *    "stat info: st_mode=-rwxr-xr-x, st_size=3221225472"    0x00000002808c7180

    //TODO: parse more field to human readble info
    //    statInfo->st_atimespec
    //    statInfo->st_birthtimespec
    //    statInfo->st_blksize
    //    statInfo->st_blocks
    //    statInfo->st_ctimespec
    //    statInfo->st_dev
    //    statInfo->st_flags
    //    statInfo->st_gen
    //    statInfo->st_gid
    //    statInfo->st_ino
    //    statInfo->st_lspare
    //    statInfo->st_mode
    //    statInfo->st_mtimespec
    //    statInfo->st_nlink
    //    statInfo->st_qspare
    //    statInfo->st_rdev
    //    statInfo->st_size
    //    statInfo->st_uid

    if (NULL != fileTypeStr) {
        free(fileTypeStr);
    }

    if (NULL != fileSizeStr) {
        free(fileSizeStr);
    }

    if (NULL != fullFileModeStr) {
        free(fullFileModeStr);
    }

    return statStr;
}

/*==============================================================================
 File Path
==============================================================================*/

// remove "xxx/.." part
// "/usr/../usr/bin/ssh-keyscan" -> "/usr/bin/ssh-keyscan"
char* removeTwoDotPart(const char* origPath){
    if (NULL == origPath) {
        return NULL;
    }

    const char *slash = "/";
//    const char *slashTwoDot = "/..";
    const char *twoDot = "..";

    char* newPath = NULL;
    char* toFreeStr = NULL;

    char* foundTwoDotPtr = strstr(origPath, twoDot);
    if(NULL == foundTwoDotPtr){
        // not found, return origin path
        newPath = strdup(origPath);
        return newPath;
    }

    bool isParseOk = true;

    char** subStrList = NULL;
    int subStrLen = 0;
    strSplit(origPath, slash, &subStrList, &subStrLen);
    if ((NULL != subStrList) && (subStrLen > 0)){
//        printf("%s, %s -> %d\n", origPath, slash, subStrLen);

//        bool shouldOmit = FALSE;
//        for(int i= subStrLen - 1; i >= 0; i--){
//            char* curSubStr = subStrList[i];
//            printf("[%d] %s\n", i, curSubStr);
//        }
        newPath = strdup("");
        int curIdx = subStrLen - 1;
        while(curIdx >= 0){
            char* curSubStr = subStrList[curIdx];
//            printf("[%d] %s\n", curIdx, curSubStr);
            bool isTwoDot = (0 == strcmp(twoDot, curSubStr));
            if(isTwoDot) {
                free(curSubStr);
//                printf("Omit  current: [%d] ..\n", curIdx);

                // omit current
                curIdx -= 1;
                
                if (curIdx >= 0){
//                    char* prevSubStr = subStrList[curIdx];
//                    printf("Omit previous: [%d] %s\n", curIdx, prevSubStr);

                    // omit next(previous)
                    curIdx -= 1;
                } else {
                    isParseOk = false;
                    printf("! Invalid case: [%d] '..' previous is None for %s\n", curIdx + 1, origPath);
                    // TODO: for most safe, need free remaing sub string
                    break;
                }
            } else {
                toFreeStr = newPath;
                asprintf(&newPath, "%s/%s", curSubStr, newPath);
                free(toFreeStr);
                free(curSubStr);

                curIdx -= 1;
            }

//            printf("now: newPath=%s\n", newPath);
        }
        
        if (isParseOk){
            if (strStartsWith(origPath, slash)){
                if(!strStartsWith(newPath, slash)){
                    toFreeStr = newPath;
                    asprintf(&newPath, "/%s", newPath);
                    free(toFreeStr);
                }
            }

            toFreeStr = newPath;
            newPath = removeEndSlash(newPath);
            free(toFreeStr);
        }
    } else {
        printf("! Failed to split path %s\n", origPath);
        isParseOk = false;
    }

    if(!isParseOk){
        toFreeStr = newPath;
        // restore origin path
        newPath = strdup(origPath);
        free(toFreeStr);
    }

    return newPath;
}

// "/Library/dpkg/", "/Library/dpkg" -> true
// "/./Library/../Library/dpkg/", "/Library/dpkg" -> true
bool isPathEaqual(const char* path1, const char* path2){
    if ( (NULL == path1) || (NULL == path2) ) {
        return false;
    }

    bool isEqual = false;

    char* purePath1 = toPurePath(path1);
    char* purePath2 = toPurePath(path2);

    // check tail include '/' or not
    char* purePath1NoEndSlash = removeEndSlash(purePath1);
    char* purePath2NoEndSlash = removeEndSlash(purePath2);

    if (NULL != purePath1){
        free(purePath1);
    }
    
    if (NULL != purePath2){
        free(purePath2);
    }

    isEqual = (0 == strcmp(purePath1NoEndSlash, purePath2NoEndSlash));

    if (NULL != purePath1NoEndSlash) {
        free(purePath1NoEndSlash);
    }
    
    if (NULL != purePath2NoEndSlash) {
        free(purePath2NoEndSlash);
    }

    return  isEqual;
}

/* use realpath() to parse out realpath
    remove '.' and 'xxx/.'
    do soft link parese to real path

    call example:
        char gotRealPath[PATH_MAX];
        bool isParseRealPathOk = parseRealPath(pathname, gotRealPath);
*/
bool parseRealPath(const char* curPath, char* gotRealPath){
    if ( (NULL == curPath) || (NULL == gotRealPath) ) {
        return false;
    }

    bool isParseOk = false;
    char realPath[PATH_MAX];
    char *returnPtr = realpath(curPath, realPath);
    if (returnPtr == NULL){
        char *errMsg = strerror(errno);
        printf("errMsg=%s", errMsg);
//        os_log(OS_LOG_DEFAULT, "parseRealPath: realpath open %{public}s failed: errno=%d, errMsg=%{public}s", curPath, errno, errMsg);

        if (EPERM == errno) {
            // hook_stat: realpath open /usr/bin/scp failed: errno=1, errMsg=Operation not permitted
//            os_log(OS_LOG_DEFAULT, "parseRealPath: when EPERM, realPath=%{public}s", realPath);
//            if (realPath != NULL){
//                os_log(OS_LOG_DEFAULT, "parseRealPath: path: input=%{public}s -> real=%{public}s", curPath, realPath);
//            } else {
//                os_log(OS_LOG_DEFAULT, "parseRealPath: open %{public}s error EPERM, but can not get real path", curPath);
//                return OPEN_FAILED;
//            }
            // Note: here realPath must not NULL, so no need to check

            isParseOk = true;
        } else {
            // TODO: add other errno support if necessary
//            return OPEN_FAILED;

            isParseOk = false;
        }
    } else {
//        os_log(OS_LOG_DEFAULT, "parseRealPath: realpath resolve ok, path: input=%{public}s -> real=%{public}s", curPath, realPath);
        isParseOk = true;
    }

    if (isParseOk){
        strcpy(gotRealPath, realPath);
//        os_log(OS_LOG_DEFAULT, "parseRealPath: gotRealPath=%{public}s, realPath=%{public}s", gotRealPath, realPath);
    }

    return isParseOk;
}

/*
 Process path to pure path
    for '.' = dot = current folder: remove it
    for '..' = two dot = parent folder: remove 'xxx/..' part

 Note: here not do full realpath work, such as resolve soft link to real path

 Example:
    /./usr/././../usr/bin/./ssh-keyscan -> /usr/bin/ssh-keyscan
    /bin/bash/.. -> /bin
    usr/local/bin/.. -> usr/local
    /./bin/../bin/./bash -> /bin/bash
    /private/./etc/ssh/../ssh/sshd_config -> /private/etc/ssh/sshd_config
    ./relative/path -> relative/path
    /Library/dpkg/./ -> /Library/dpkg
    /Library/dpkg/. -> /Library/dpkg
    /./Library/../Library/./dpkg/. -> /Library/dpkg
    /Applications/Cydia.app/../Cydia.app -> /Applications/Cydia.app
*/
char* toPurePath(const char* origPath){
//    printf("origPath=%s\n", origPath);
    if(NULL == origPath){
        return NULL;
    }

    if(0 == strcmp("", origPath)){
//        return "";
        char* emptyStr = NULL;
        emptyStr = strdup("");
        return emptyStr;
    }

    const char *dot = ".";
    const char *slash = "/";
    const char *dotSlash = "./";
    const char *slashDot = "/.";
    const char *slashDotSlash = "/./";

//    const char *slashTwoDot = "/..";

    char* toFreeStr = NULL;
    char* purePath = "";

    // if not contain '.', ignore
    char *foundDotPtr = strstr(origPath, dot);
    if (NULL != foundDotPtr){
        purePath = strdup(origPath);

        // 1. remove ./ or .

        // 1.1 start with ./ -> remove it
        toFreeStr = purePath;
        purePath = removeTail(purePath, dotSlash);
    //    printf("\tRemoved tail '%s' -> %s\n", dotSlash, purePath);
        // "./relative/path" -> "relative/path"
        free(toFreeStr);

        // 1.2 end with /. -> remove it
        toFreeStr = purePath;
        purePath = removeTail(purePath, slashDot);
    //    printf("\tRemoved tail '%s' -> %s\n", slashDot, purePath);
        // "/./Library/../Library/dpkg/." -> "/./Library/../Library/dpkg"
        free(toFreeStr);

        // 1.3 end with /./ -> remove it
        toFreeStr = purePath;
        purePath = removeTail(purePath, slashDotSlash);
    //    printf("\tRemoved tail '%s' -> %s\n", slashDotSlash, purePath);
        // "/./Library/../Library/dpkg/./" -> "/./Library/../Library/dpkg"
        free(toFreeStr);

        // 1.4 replce "/./" to "/"
        char *foundSlashPointSlash = NULL;
        while((foundSlashPointSlash = strstr(purePath, slashDotSlash))){
            toFreeStr = purePath;
            purePath = strReplace(purePath, slashDotSlash, slash);
            free(toFreeStr);
        }
    //    printf("\tReplaced '%s' to '%s' -> %s\n", slashDotSlash, slash, purePath);
        // "/./usr/././../usr/bin/./ssh-keyscan" -> "/usr/../usr/bin/ssh-keyscan"

        // 1.5 remove head "./"
        toFreeStr = purePath;
//        purePath = removeHead(purePath, dotSlash);
        char* removeHeadToFreePtr = NULL;
        purePath = removeHead(purePath, dotSlash, &removeHeadToFreePtr);
    //    printf("\tRemoved head '%s' -> %s\n", dotSlash, purePath);
        // "./relative/path" -> "relative/path"
//        if(NULL != removeHeadToFreePtr){
//            free(removeHeadToFreePtr);
//        }
        free(toFreeStr);

        // 2. remove xxx/../ or xxx/..

        // 2.1 (only) remove "/.."
//        toFreeStr = purePath;
        toFreeStr = removeHeadToFreePtr;
        purePath = removeTwoDotPart(purePath);
    //    printf("\tRemoved two dot part 'xxx/..' -> %s\n", purePath);
        // "/usr/../usr/bin/ssh-keyscan" -> "/usr/bin/ssh-keyscan"
        free(toFreeStr);
    } else {
        purePath = strdup(origPath);
    }

    // 3. remove end "/"
    toFreeStr = purePath;
    purePath = removeEndSlash(purePath);
//    printf("\tRemoved end slash '/' -> %s\n", purePath);
    // "/usr/bin/ssh-keyscan/" -> "/usr/bin/ssh-keyscan"
    free(toFreeStr);

//    printf("\torigPath=%s =>> purePath=%s\n", origPath, purePath);
    return purePath;
}

/*
 "/first/", "second" -> "/first/second"
 "/first", "second/" -> "/first/second"
 "/first/", "./second/", "third/" -> "/first/./second/third"
 */
//char* strPathJoin(const char* firstPath, ...) {
char* _strPathJoin(const char* firstPath, ...) {
    if (NULL == firstPath) {
        return NULL;
    }

    int MaxSupportArgNum_strPathJoin = 10;
    char* joinedPath = removeEndSlash(firstPath);

    // calculate all parameter
    char *paraPtr, *paraList[MaxSupportArgNum_strPathJoin];
    va_list argList;
    int curParaNum = 0;
    va_start(argList, firstPath);
    while ((paraPtr = (char *) va_arg(argList, char *))) {
        paraList[curParaNum] = paraPtr;
        curParaNum += 1;
        // printf("[%d] paraPtr=%p, paraPtr=%s\n", curParaNum, paraPtr, paraPtr);
    }
    va_end(argList);

    for(int i=0; i < curParaNum; i++){
        char* curPath = paraList[i];
        char* curPathNoEndSlash = removeEndSlash(curPath);
//        if (joinedPath != NULL){
        char* oldJoinedPath = joinedPath;
        asprintf(&joinedPath, "%s/%s", joinedPath, curPathNoEndSlash);
        free(oldJoinedPath);
//        } else {
//            asprintf(&joinedPath, "%s", curPathNoEndSlash);
//        }
        free(curPathNoEndSlash);
    }
    // printf("joinedPath=%s\n", joinedPath);
    return joinedPath;
}

// get file path from fd (file descriptor)
// fd=4, char filePath[PATH_MAX]; -> outFilePath=/usr/lib/libsubstrate.dylib
bool getFilePath(int fd, char* outFilePath){
    const int FCNTL_FAILED = -1;
    bool isOk = false;
    int fcntlRet = fcntl(fd, F_GETPATH, outFilePath);
    if (fcntlRet != FCNTL_FAILED){
        isOk = true;
    } else {
        isOk = false;
    }
    return isOk;
}

/*==============================================================================
 iOS: implement deprecated system()
==============================================================================*/

int iOS_system(const char* command){
    const int SYSTEM_FAIL = -1;
    int systemRet = SYSTEM_FAIL;

//    if (NULL == command) {
//        return systemRet;
//    }

    typedef int (*function_system) (const char *command);
    char* dyLibSystem = "/usr/lib/libSystem.dylib";
    void *libHandle = dlopen(dyLibSystem, RTLD_GLOBAL | RTLD_NOW);
    if (NULL == libHandle) {
        char* errStr = dlerror();
        printf("Failed to open %s, error: %s", dyLibSystem, errStr);
    } else {
        function_system libSystem_system = dlsym(libHandle, "system");
        if (NULL != libSystem_system){
            systemRet = libSystem_system(command);
//            return systemRet;
        }
        dlclose(libHandle);
    }

    return systemRet;
}

/*==============================================================================
 iOS Anti-Debug
==============================================================================*/

typedef int (*func_ptrace)(int request, pid_t pid, caddr_t addr, int data);

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH          31
#endif  // !defined(PT_DENY_ATTACH)

void iOS_antiDebug_ptrace(void) {
//    ptrace(PT_DENY_ATTACH, 0, 0, 0);

//    void* libHandle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
//    // libHandle    void *    0xfffffffffffffffe
//    if (NULL == libHandle) {
//        char* errStr = dlerror();
//        printf("Failed to open 0, error: %s", errStr);
//    } else {
//        func_ptrace ptrace_ptr = dlsym(libHandle, "ptrace");
//        if (NULL != ptrace_ptr){
//            ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
//        }
//        dlclose(libHandle);
//    }
    
    char* ptraceFuncName = "ptrace";
//    char* ptraceFuncName = "PTRACE";
    func_ptrace ptrace_ptr = dlsym(RTLD_SELF, ptraceFuncName);
    // ptrace_ptr    func_ptrace    (libsystem_kernel.dylib`__ptrace)    0x000000018cee2df8
    if (NULL != ptrace_ptr){
//        ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
        ptrace_ptr(PT_DENY_ATTACH, 0, NULL, 0);
    }
}

// #define    SYS_ptrace         26
void iOS_antiDebug_syscall(void) {
    int syscallPtraceRetValue = syscall(SYS_ptrace, PT_DENY_ATTACH, 0, NULL, 0);
    printf("syscallPtraceRetValue=%d\n", syscallPtraceRetValue);
}

void iOS_antiDebug_svc0x80_syscall(void) {
//    // for debug
//    printf("before iOS_antiDebug_svc0x80_syscall\n");

#if defined (__arm64__)
    __asm(
        "mov x0, #26\n" // ptrace
        "mov x1, #31\n" // PT_DENY_ATTACH
        "mov x2, #0\n"
        "mov x3, #0\n"
        "mov x16, #0\n"
        "svc #0x80\n" // 0x80=128
    );
#endif

//    // for debug
//    printf("end iOS_antiDebug_svc0x80_syscall\n");
}


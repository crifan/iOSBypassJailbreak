/*
    File: CrifanLibDemo.c
    Function: crifan's common C lib function demo implementation
    Author: Crifan Li
    Latest: https://github.com/crifan/crifanLib/blob/master/c/CrifanLibDemo.c
    Updated: 20220124_1552
*/

//#include <stdio.h>
#include <sys/time.h>
#include "CrifanLibDemo.h"
#include "CrifanLib.h"
#include "JailbreakPathList.h"

/**************************************************************************************************
 Test other's custom strstr
****************************************************************************************************/
//
//// Preventing libobjc hooked, strstr implementation
//const char* tuyul(const char* X, const char* Y)
//{
//    if (*Y == '\0')
//        return X;
//
//    for (int i = 0; i < strlen(X); i++)
//    {
////        printf("X+i=%p, Y=%p, *(X+i)=%s, *Y=%s", X + i, Y, *(X+i), *Y);
//        printf("X+i=%p, Y=%p, *(X+i)=%c, *Y=%c\n", X + i, Y, *(X+i), *Y);
////        printf("X+i=%p, Y=%p\n", X + i, Y);
////        printf("*(X+i)=%s, *Y=%s", *(X+i), *Y);
////        printf("*(X+i)=%s", *(X+i));
////        printf("*Y=%s", *Y);
//        if (*(X + i) == *Y)
//        {
//            printf("----------\n");
//            char* ptr = tuyul(X + i + 1, Y + 1);
//            return (ptr) ? ptr - 1 : NULL;
//        }
//    }
//
//    return NULL;
//}
//
//
//void testCustomStrstr(void){
//    char* curDylibName = "/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib";
//    char* mobilesubstratedylib = "MobileSubstrate.dylib";
//    bool isFound = tuyul(curDylibName, mobilesubstratedylib) != NULL;
//    printf("testCustomStrstr: isFound=%s", isFound);
//}


/**************************************************************************************************
 Test const
****************************************************************************************************/

void testConst(void){
//    const int constIntValue = 3 + 4;
//    constIntValue = 10;
    // Compile time: Cannot assign to variable 'constIntValue' with const-qualified type 'const int'
    
//    const char* constStrPtr = malloc(10);
    const char* constStrPtr = randomStr(20, NULL);
    printf("before constStrPtr: %p -> %s\n", constStrPtr, constStrPtr);
    constStrPtr = "normal string";
    printf("after constStrPtr: %p -> %s\n", constStrPtr, constStrPtr);
}

/**************************************************************************************************
 Test random str
****************************************************************************************************/

void testRandomStr(void){
    char* randomedStr = randomStr(5, NULL);
    printf("randomedStr=%s\n", randomedStr);
}

/**************************************************************************************************
 Test isIntInList
****************************************************************************************************/
void testIsIntInList(void){
    int testIntValue = 2;
    int intList[] = {1, 2, 3, 4};
    bool isInList = isIntInList(testIntValue, intList, 4);
    printf("isInList=%d", isInList);
}

/**************************************************************************************************
 to pure path
****************************************************************************************************/
//for debug: to pure path
void testParsePurePath(void){
    // for debug: parse to pure path via pure C
    const char* specialPathList[] = {
        "./relative/path",
        "/Library/dpkg/./",
        "/Library/dpkg/",
        "/Library/dpkg/.",
        "/./Library/../Library/./dpkg/.",
        "/Applications/Cydia.app/../Cydia.app",
        "/bin/bash",
        "/./usr/././../usr/bin/./ssh-keyscan",
        "/bin/bash/..",
        "../bin/./bash/././..",
        "../bin/bash/..",
        "usr/local/bin/..",
        "/./bin/../bin/./bash",
        "/private/./etc/ssh/../ssh/sshd_config",
    };
    int specialPathListLen = sizeof(specialPathList)/sizeof(const char *);
    for (int i=0; i < specialPathListLen; i++) {
        const char* curSpeicalPath = specialPathList[i];
        char* curRealPath = toPurePath(curSpeicalPath);
        printf("orig: %s -> real: %s\n", curSpeicalPath, curRealPath);
    }
}

/**************************************************************************************************
 path equal
****************************************************************************************************/

//for debug
void testPathCompare(void){
    char* path1 = "/Library/dpkg";
    char* path2 = "/Library/dpkg/";
    bool isEqual = isPathEaqual(path1, path2);
    printf("isEqual=%s\n", boolToStr(isEqual));

    char* path3 = "/./Library/./../Library/./dpkg";
//    char* path3 = ".././Library/./../Library/./dpkg";
    char* path4 = "/Library/dpkg/";
    bool isEqual2 = isPathEaqual(path3, path4);
    printf("isEqual2=%s\n", boolToStr(isEqual2));
}

/**************************************************************************************************
 path join
****************************************************************************************************/
void testPathJoin(void){
    const char* path1 = NULL;
    const char* path2 = NULL;
    const char* path3 = NULL;

    path1 = "/first";
    path2 = "second";
    char* joinedPath1 = strPathJoin(path1, path2);
    printf("joinedPath1=%s", joinedPath1);

    path1 = "/first/";
    path2 = "second/";
    char* joinedPath2 = strPathJoin(path1, path2);
    printf("joinedPath2=%s", joinedPath2);

    path1 = "/first/";
    path2 = "./second/";
    path3 = "third";
    char* joinedPath3 = strPathJoin(path1, path2, path3);
    printf("joinedPath3=%s", joinedPath3);
}

/**************************************************************************************************
 jailbreak path
****************************************************************************************************/

//for debug: detect jb path
void testJbPathDetect(void){
    const char* jsPathList[] = {
        "/usr/bin/ssh",
        "/usr/bin/ssh-",
        "/Applications/Cydia.app/Info.plist",
        "/bin/bash",
        "/Applications/Cydia.app/../Cydia.app",
        "/./usr/././../usr/bin/./ssh-keyscan",
        "/./bin/../bin/./bash",
        "/private/./etc/ssh/../ssh/sshd_config",
    };
    int jbPathListLen = sizeof(jsPathList)/sizeof(const char *);
    for (int i=0; i < jbPathListLen; i++) {
        const char* curJbPath = jsPathList[i];
        bool isJbPath = isJailbreakPath(curJbPath);
        printf("curJbPath=%s -> isJbPath=%s\n", curJbPath, boolToStr(isJbPath));
        printf("\n");
    }
}

/**************************************************************************************************
 string lowercase
****************************************************************************************************/

void testLowcase(void){
    char* str1 = "CYDIA://xxx";
    char* str2 = "Cydia://xxx";
    char* startWithLower = "cydia://";
    
    char* lowerStr1 = strToLowercase(str1);
    bool isEqual1 = strStartsWith(lowerStr1, startWithLower);
    printf("isEqual1=%s\n", boolToStr(isEqual1));
    free(lowerStr1);
    
    char* lowerStr2 = strToLowercase(str2);
    bool isEqual2 = strStartsWith(lowerStr2, startWithLower);
    printf("isEqual2=%s\n", boolToStr(isEqual2));
    free(lowerStr2);
}

/**************************************************************************************************/
/* Time */
/**************************************************************************************************/

/* use for only test several times in a loop */
#define MAX_TEST_COUNT              15

// How to calculate the elapsed time
//http://www.crifan.com/how_to_calculate_the_elapsed_time/
void showCalculateElapsedTime(void){
    struct timeval  tv_begin_mdct, tv_end_mdct;
    int test_count = 0; // test times
    // every part of encoder time of one frame in milliseconds
    long mdct_time = 0;

    //calculate mdct time of one of the firt ten frames
    if(test_count <= MAX_TEST_COUNT)
    {
        gettimeofday(&tv_begin_mdct, 0);
    }

    // ......
    // do what you wan to do 
    // ......
    //Func();

    //calculate mdct time of one of the firt ten frames
    if( test_count <= MAX_TEST_COUNT )
    {
        gettimeofday(&tv_end_mdct, 0);
        mdct_time = tv_end_mdct.tv_usec - tv_begin_mdct.tv_usec;
        printf("The mdct time of the %d frame is ttt%ld msn", test_count, mdct_time/1000);
    }
}

void testExpired_compileTime(void){
    //    const int MAX_VALID_DAYS = 5;
    //    const int MAX_VALID_SECONDS = MAX_VALID_DAYS * 24 * 60 * 60;
    const int MAX_VALID_SECONDS = 60;

    struct tm CompileTimeInfo;
    // char *strptime(const char * __restrict, const char * __restrict, struct tm * __restrict);
//    char* retNoProcessedStr = strptime(CompileDateStr, DATE_FORMAT, &CompileTimeInfo);
//    char* curCompileDateTimeStr = getCompileDateTimeStr();
    char* curCompileDateTimeStr = __DATE__ " " __TIME__; // "Jan 19 2022 10:34:16"
    char* retNoProcessedStr = parseTimeInfo(curCompileDateTimeStr, &CompileTimeInfo);
    printf("retNoProcessedStr=%s\n", retNoProcessedStr);
    time_t CompileEpoch = mktime(&CompileTimeInfo);
    printf("CompileEpoch=%ld\n", CompileEpoch); // 1639983548
    time_t ExpiredEpoch = CompileEpoch + MAX_VALID_SECONDS;
    printf("ExpiredEpoch=%ld\n", ExpiredEpoch); //

    time_t curTimeEpoch = time(NULL);
    printf("curTimeEpoch=%ld\n", curTimeEpoch); // 1639983552
//    time_t elapsedTimeEcoch = curTimeEpoch - CompileEpoch;
//    printf("elapsedTimeEcoch=%d\n", elapsedTimeEcoch);
    bool isExpired = curTimeEpoch >= ExpiredEpoch;
    printf("isExpired=%s\n", boolToStr(isExpired));
}

void testExpired_defineTime(void){
//    const char* expiredTimeStr = "2022-1-24 15:11:00";
    const char* expiredTimeStr = "2022-1-24 15:40:00";
    bool isExpired = isTimeExpired(expiredTimeStr);
    printf("isExpired=%s\n", boolToStr(isExpired)); // isExpired=True
}

void testTimeDate(void){
    testExpired_compileTime();
    testExpired_defineTime();
}

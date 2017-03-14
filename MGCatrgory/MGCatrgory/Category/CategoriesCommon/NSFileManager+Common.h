//
//  NSFileManager+Common.h
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (Common)

#pragma mark *** 基础方法 ***

+ (BOOL)isDirectory:(NSString *)filePath;
+ (BOOL)existFile:(NSString *)filePath;

/*
 *  以下三个方法是对路径的截取操作，返回对应的文件名、后缀、所在文件夹路径
 */
+ (NSString *)fileNameForPath:(NSString *)path;
+ (NSString *)fileExtensionWithDotForPath:(NSString *)path;
+ (NSString *)filePathForPath:(NSString *)path;                     /* 所在文件夹路径 */


+ (NSNumber *)fileSizeWithFilePath:(NSString *)filePath;

+ (NSArray <NSString *> *)fileNamesInFolder:(NSString *)path;       /* 文件夹下所有文件 */


#pragma mark *** 文件操作 ***

+ (BOOL)createDirectoryIfNotExist:(NSString *)filePath;
+ (BOOL)deleteFileForPath:(NSString *)path;


#pragma mark *** Path相关 ***
/*
 *  以下五个方法返回对应沙盒文件相关路径
 */
+ (NSString *)documentsPath;
+ (NSString *)libraryPath;
+ (NSString *)temporaryPath;
+ (NSString *)bundlePath;
+ (NSString *)documentFilePathWithFileName:(NSString *)fileName;
+ (NSString *)bundleFilePathWithFileName:(NSString *)fileName;

+ (NSString *)generateAUniqueTemporaryFilePath;

#pragma mark *** Search相关 ***
/*
 *  以下三个方法是深度搜索的方法，不区分大小写
 */
+ (NSString *)searchFileWithFileName:(NSString *)fileName inFolder:(NSString *)path;
+ (NSArray <NSString *> *)pathsForDocumentsMatchingExtension:(NSString *)ext;
+ (NSArray <NSString *> *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext;


@end



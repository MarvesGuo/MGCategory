//
//  NSFileManager+Common.m
//
//
//  Created by babytree on 26/12/2016.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "NSFileManager+Common.h"
#import "NSString+Common.h"



@implementation NSFileManager (Common)

#pragma mark *** 基础方法 ***

/**
 路径是否是文件夹
 
 */
+ (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDir;
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && isDir);
}

/**
 文件是否存在
 
 */
+ (BOOL)existFile:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

/**
 获取文件名
 
 */
+ (NSString *)fileNameForPath:(NSString *)path
{
    NSArray *pathComponents = [path pathComponents];
    if (pathComponents.count > 0)
    {
        return [NSString stringWithString:[pathComponents lastObject]];
    }
    return @"";
}

/**
 文件后缀名，包含点，比如 .png
 
 @return 包含点的文件后缀名
 */
+ (NSString *)fileExtensionWithDotForPath:(NSString *)path
{
    NSString *extension = [path pathExtension];
    if (![extension isEqualToString:@""])
    {
        extension = [NSString stringWithFormat:@".%@", extension];
    }
    return extension;
}

/**
 获取路径
 
 */
+ (NSString *)filePathForPath:(NSString *)path
{
    
    return [path stringByDeletingLastPathComponent];
}

/**
 文件尺寸
 
 */
+ (NSNumber *)fileSizeWithFilePath:(NSString *)filePath
{
    if (!filePath)
    {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
    {
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        if (fileAttributes)
        {
            return [fileAttributes objectForKey:NSFileSize];
        }
    }
    return nil;
}

/**
 返回目录下所有文件路径
 
 @return 所有文件路径
 */
+ (NSArray <NSString *> *)fileNamesInFolder:(NSString *)path
{
    NSString *fileName;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((fileName = [dirEnum nextObject]))
    {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:fileName] isDirectory: &isDir];
        if (!isDir) [results addObject:fileName];
    }
    return [results copy];
}

#pragma mark *** 文件操作 ***

+ (BOOL)createDirectoryIfNotExist:(NSString *)filePath
{
    if (![self isDirectory:filePath])
    {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];

        return success;
    }
    return YES; //path existed and was a directory
}

/**
 删除 Document 目录下文件
 
 */
+ (BOOL)deleteFileForPath:(NSString *)path
{
    if ([self existFile:path])
    {
        return [[self defaultManager] removeItemAtPath:path error:nil];
    }
    return NO;
}

#pragma mark *** path相关 ***

/**
 Document 目录路径
 
 */
+ (NSString *)documentsPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    return cachedPath;
}

/**
 Library 目录路径
 
 */
+ (NSString *)libraryPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    });
    return cachedPath;
}

/**
 main bundle 路径
 
 */
+ (NSString *)bundlePath
{
    return [[NSBundle mainBundle] bundlePath];
}

/**
 Temporary 目录路径
 
 */
+ (NSString *)temporaryPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = NSTemporaryDirectory();
    });
    return cachedPath;
}

/**
 Document目录下文件路径
 
 */
+ (NSString *)documentFilePathWithFileName:(NSString *)fileName
{
    return [NSFileManager searchFileWithFileName:fileName inFolder:[self documentsPath]];
}

/**
 Main Bundle 下 文件路径
 
 */
+ (NSString *)bundleFilePathWithFileName:(NSString *)fileName
{
    return [NSFileManager searchFileWithFileName:fileName inFolder:[self bundlePath]];

}

/**
 生成一个命名唯一的临时目录下的文件
 
 */
+ (NSString *)generateAUniqueTemporaryFilePath
{
    NSString *tmpPath = [[self temporaryPath] stringByAppendingPathComponent:[NSString getUUID]];
    return tmpPath;
}


#pragma mark *** Search相关 ***

/**
 寻找指定目录下的指定文件
 会深度遍历所有子文件直到找到第一个匹配的文件
 
 @return 文件完整路径
 */
+ (NSString *)searchFileWithFileName:(NSString *)fileName inFolder:(NSString *)path
{
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((file = [dirEnum nextObject]))
    {
        if ([[file lastPathComponent] isEqualToString:fileName])
            
        {
            return [path stringByAppendingPathComponent:file];
        }
    }
    return nil;
}


/**
 返回指定目录下所有匹配后缀名的文件路径
 深度搜索，大小写不敏感
 
 @return 所有匹配后缀名的文件路径
 */
+ (NSArray <NSString *> *)pathsForFilesMatchingExtension:(NSString *)ext inFolder:(NSString *)path
{
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((file = [dirEnum nextObject]))
        if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
            [results addObject:[path stringByAppendingPathComponent:file]];
    return [results copy];
}

/**
 返回Documents目录下所有匹配后缀名的文件路径
 深度搜索，大小写不敏感
 
 @return 所有匹配后缀名的文件路径
 */
+ (NSArray <NSString *> *)pathsForDocumentsMatchingExtension:(NSString *)ext {
    return [NSFileManager pathsForFilesMatchingExtension:ext inFolder:[self documentsPath]];
}

/**
 返回 Main Bundle 下所有匹配后缀名的文件路径
 深度搜索，大小写不敏感
 
 */
+ (NSArray <NSString *> *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext {
    return [NSFileManager pathsForFilesMatchingExtension:ext inFolder:[self bundlePath]];
}
 
@end





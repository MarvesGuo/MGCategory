//
//  NSObject+Category.m
//
//
//  Created by babytree on 17-2-7.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "NSObject+Common.h"
#import "objc/runtime.h"


@implementation NSObject (Category)


#pragma mark - **Utils**
/**
 多参数 performSelector
 
 @param aSelector selector
 @param objs 参数 Array
 @return 调用返回值，全以对象形式
 */
- (id)performSelector:(SEL)aSelector withObjects: (NSArray *)objs {
    
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (!sig) return nil;
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:aSelector];
    for (NSInteger i = 0; i < objs.count; ++i) {
        id p = objs[i];
        [invo setArgument:&p atIndex:i + 2];
    }
    
    [invo retainArguments];
    [invo invoke];
    NSLog(@"%s", sig.methodReturnType );
    
    if (!strcmp(sig.methodReturnType, "@")) {
        id __unsafe_unretained anObject;
        [invo getReturnValue:&anObject];
        id ret = anObject;
        return ret;
    } else {
        if (sig.methodReturnLength == 0)
            return nil;
        
        if (!strcmp(sig.methodReturnType, "f")) {
            float *v = (float *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSNumber *r = @(*v);
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "d")) {
            double *v = (double *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSNumber *r = @(*v);
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "*")) {
            char *v;
            [invo getReturnValue:&v];
            NSString * r = [NSString stringWithCString:v encoding:NSUTF8StringEncoding];
            return r;
        } else if (!strcmp(sig.methodReturnType, "q")) {
            NSInteger *v = (NSInteger *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSNumber *r = @(*v);
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{CGRect={CGPoint=dd}{CGSize=dd}}")) {
            CGRect *v = (CGRect *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithCGRect: *v];
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{CGSize=dd}")) {
            CGSize *v = (CGSize *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithCGSize: *v];
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{CGPoint=dd}")) {
            CGPoint *v = (CGPoint *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithCGPoint: *v];
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{UIEdgeInsets=dddd}")) {
            UIEdgeInsets *v = (UIEdgeInsets *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithUIEdgeInsets: *v];
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{UIOffset=dd}")) {
            UIOffset *v = (UIOffset *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithUIOffset: *v];
            free(v);
            return r;
        } else if (!strcmp(sig.methodReturnType, "{CGVector=dd}")) {
            CGVector *v = (CGVector *)malloc(sig.methodReturnLength);
            [invo getReturnValue:v];
            NSValue *r = [NSValue valueWithCGVector: *v];
            free(v);
            return r;
        }
        
        
        unsigned char *v = (unsigned char *)malloc(sig.methodReturnLength);
        [invo getReturnValue:v];
        NSNumber *r = @(*v);
        free(v);
        return r;
    }
    return nil;
}


/**
 判断是否为 NSNull 或 nil
 
 @return YES or No
 */
- (BOOL)isNotNull {
    return ![self isKindOfClass:[NSNull class]];
}


/**
 判断是否有内容，对于一般的对象，等效于 isNotNull，
 对于 NSString, NSArray, NSDictionary 这些，会根据
 .length 或者 .count 来进一步判断是否又内容
 
 @return YES or NO
 */
- (BOOL)hasContent {
    return !([self isKindOfClass:[NSNull class]] || ([self respondsToSelector:@selector(length)] && [(NSData *)self length] == 0) || ([self respondsToSelector:@selector(count)] && ([(NSArray *)self count] == 0)));
}


/**
 判断是否为 Dictionary 并且内容
 
 @return YES or NO
 */
- (BOOL)isDictionaryAndHasEntries {
    return [self isKindOfClass:[NSDictionary class]] && [self hasContent];
}


#pragma mark - **Associated Object**
/**
 获取 associated object
 
 @param key key
 @return associated object
 */
- (id)getAssociatedObjectForKey:(const char *)key {
    const char * propName = key;
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}


/**
 设置 associated object，copy方式
 
 @param obj associated object
 @param key key
 @return 原先的associated object(old value)
 */
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key {
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_COPY );
    return oldValue;
}


/**
 设置 associated object，retain方式
 
 @param obj associated object
 @param key key
 @return 原先的associated object(old value)
 */
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key {
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}


/**
 设置 associated object，assign方式
 
 @param obj associated object
 @param key key
 @return 原先的associated object(old value)
 */
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key {
    const char * propName = key;    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_ASSIGN );
    return oldValue;
}


/**
 移除 key 下的 associated object
 
 @param key key
 */
- (void)removeAssociatedObjectForKey:(const char *)key {
    const char * propName = key;
    objc_setAssociatedObject( self, propName, nil, OBJC_ASSOCIATION_ASSIGN );
}


/**
 移除所有 associated object
 */
- (void)removeAllAssociatedObjects {
    objc_removeAssociatedObjects( self );
}


#pragma mark - **Swizzle**
/**
 覆盖实例方法
 
 @param aClass 类
 @param aOrigSel 原始方法
 @param aAltSel 覆盖方法
 @return YES - 成功， NO - 失败
 */
+ (BOOL)overrideClass:(Class)aClass method:(SEL)aOrigSel withMethod:(SEL)aAltSel {
    Method origMethod = class_getInstanceMethod(aClass, aOrigSel);
    if (!origMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(aOrigSel), aClass);
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(aClass, aAltSel);
    if (!altMethod) {
        NSLog(@"alt method %@ not found for class %@", NSStringFromSelector(aAltSel), aClass);
        return NO;
    }
    
    method_setImplementation(origMethod, method_getImplementation(altMethod));
    
    return YES;
}


/**
 覆盖类方法
 
 @param aClass 类
 @param aOrigSel 原始方法
 @param aAltSel 覆盖方法
 @return YES - 成功， NO - 失败
 */
+ (BOOL)overrideClass:(Class)aClass classMethod:(SEL)aOrigSel withClassMethod:(SEL)aAltSel {
    Method origMethod = class_getClassMethod(aClass, aOrigSel);
    if (!origMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(aOrigSel), aClass);
        return NO;
    }
    
    Method altMethod = class_getClassMethod(aClass, aAltSel);
    if (!altMethod) {
        NSLog(@"alt method %@ not found for class %@", NSStringFromSelector(aAltSel), aClass);
        return NO;
    }
    
    method_setImplementation(origMethod, method_getImplementation(altMethod));
    
    return YES;
}


/**
 交换实例方法
 
 @param aClass 类
 @param aOrigSel 原始方法
 @param aAltSel 交换方法
 @return YES - 成功， NO - 失败
 */
+ (BOOL)exchangeClass:(Class)aClass method:(SEL)aOrigSel withMethod:(SEL)aAltSel {
    Method origMethod = class_getInstanceMethod(aClass, aOrigSel);
    if (!origMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(aOrigSel), aClass);
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(aClass, aAltSel);
    if (!altMethod) {
        NSLog(@"alt method %@ not found for class %@", NSStringFromSelector(aAltSel), aClass);
        return NO;
    }
    
    method_exchangeImplementations(origMethod, altMethod);
    
    return YES;
}


/**
 交换类方法
 
 @param aClass 类
 @param aOrigSel 原始方法
 @param aAltSel 交换方法
 @return YES - 成功， NO - 失败
 */
+ (BOOL)exchangeClass:(Class)aClass classMethod:(SEL)aOrigSel withClassMethod:(SEL)aAltSel {
    Method origMethod = class_getClassMethod(aClass, aOrigSel);
    if (!origMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(aOrigSel), aClass);
        return NO;
    }
    
    Method altMethod = class_getClassMethod(aClass, aAltSel);
    if (!altMethod) {
        NSLog(@"alt method %@ not found for class %@", NSStringFromSelector(aAltSel), aClass);
        return NO;
    }
    
    method_exchangeImplementations(origMethod, altMethod);
    
    return YES;
}


#pragma mark - **FaultTolerant**
/**
 容错方法

 @param key key
 @return nil
 */
- (NSString *)stringForKey:(NSString *)key {
    return nil;
}


/**
 容错方法
 
 @param key key
 @return nil
 */
- (NSArray *)arrayForKey:(NSString *)key {
    return nil;
}


/**
 容错方法
 
 @param key key
 @return nil
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return nil;
}


/**
 容错方法
 
 @param key key
 @return nil
 */
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}


@end

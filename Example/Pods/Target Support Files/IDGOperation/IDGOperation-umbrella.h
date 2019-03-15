#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IDGAsyncOperation.h"
#import "IDGOperation.h"
#import "NSBlockOperation+IDGOperation.h"
#import "NSOperation+IDGOperation.h"

FOUNDATION_EXPORT double IDGOperationVersionNumber;
FOUNDATION_EXPORT const unsigned char IDGOperationVersionString[];


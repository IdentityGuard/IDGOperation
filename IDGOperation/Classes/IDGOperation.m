//  IDGOperation.m
//
// Copyright (c) 2019 Intersections, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.




#import "IDGOperation.h"

#import <os/log.h>

@interface IDGOperation ()

@property (nonatomic, assign) BOOL hasRun;
@property (atomic, strong) NSTimer *timer;

@end

@implementation IDGOperation

@synthesize error = _error;
@synthesize delay = _delay;

- (void)main
{
    for (NSOperation *op in self.dependencies) {
        NSParameterAssert([op isFinished]);
        if (op.isCancelled) {
            [self cancel];
            break;
        }
    }
    
    if (!self.isCancelled) {
        [self run];
    }
}

- (void)run
{
    // NOOP
}

- (NSError *)error
{
    @synchronized (self) {
        return _error;
    }
}

- (void)setError:(NSError *)error
{
    [self willChangeValueForKey:@"error"];
    @synchronized(self) {
        _error = error;
    }
    [self didChangeValueForKey:@"error"];
}

- (BOOL)isReady
{
    if ([super isReady] && (self.hasRun || self.delay == 0)) {
        if (self.delay > 0) {
            os_log_info(OS_LOG_DEFAULT, "Reporting ready for %@", self);
        }
        return YES;
    }
    
    if ([super isReady] && !self.timer) {
        os_log_info(OS_LOG_DEFAULT, "Scheduling a timer for %@ <delay %f>", self, self.delay);
        self.timer = [NSTimer timerWithTimeInterval:self.delay target:self selector:@selector(triggerIsReady) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
    return NO;
}

- (void)triggerIsReady
{
    os_log_info(OS_LOG_DEFAULT, "Timer fired for %@", self);
    
    [self willChangeValueForKey:@"isReady"];
    
    self.hasRun = YES;
    [self.timer invalidate];

    [self didChangeValueForKey:@"isReady"];
}

- (void)setDelay:(NSTimeInterval)delay
{
    NSParameterAssert(!self.timer);
    NSParameterAssert(!self.hasRun);

    @synchronized(self) {
        _delay = delay;
    }
}

- (NSTimeInterval)delay
{
    @synchronized(self) {
        return _delay;
    }
}

@end

#import "Event.h"

@interface Event ()

// Private interface goes here.

@end

@implementation Event

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; isFault = %@; isDeleted = %@>",
			NSStringFromClass([self class]),
			self,
			@(self.isFault),
			@(self.isDeleted)];
}

@end

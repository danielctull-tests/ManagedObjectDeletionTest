#import "Group.h"

@interface Group ()

// Private interface goes here.

@end

@implementation Group

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; isFault = %@; isDeleted = %@>",
			NSStringFromClass([self class]),
			self,
			@(self.isFault),
			@(self.isDeleted)];
}

@end

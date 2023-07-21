//
//  B2dAccelLayer.m
//  Trilobite
//
//  Based on accel example in cocos2d, at least initially
//

#import "B2dAccelLayer.h"


@implementation B2dAccelLayer

-(id) initWithWorld:(b2World*)world {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	m_b2world = world;
	
	visible = NO;
	isAccelerometerEnabled = YES;
	
	return self;
}


-(void) onEnter {
	[super onEnter];
	// box2d demo does 1/30 (rolando guy...)
	// cocos2d accel demo does 1/100 (a demo...)
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
}

// Implement this method to get the lastest data from the accelerometer 
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
		
	float xx = acceleration.x;
	float yy = acceleration.y;
	
	// flip for landscape mode
	if([[Director sharedDirector] landscape]) {
		float tmp = xx;
		xx = -yy;
		yy = tmp;
	}
	
	// check for a change (box2d example inspired)
	if(xx!=0.0f && yy!=0.0f) {
		float tVectorLength = sqrt(xx*xx + yy*yy);
		float factor = 9.81f;
		float newGravityX = factor * xx / tVectorLength;
		float newGravityY = factor * yy / tVectorLength;
		b2Vec2 gravity = b2Vec2(newGravityX, newGravityY);
		// update gravity
		m_b2world->SetGravity(gravity);
	}
}

-(void) dealloc{	
	m_b2world = nil;	
	[self removeAllChildrenWithCleanup:YES];	
	[super dealloc];
}
@end

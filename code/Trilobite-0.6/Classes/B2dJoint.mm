//
//  B2dRevoluteJoint.m
//  Trilobite
//
//  Created by jasonb on 21/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "B2dJoint.h"


@implementation B2dJoint

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	m_joint = nil;
	
	return self;
}

-(void)onEnter {
	// joint think
	//float thinkTimeSeconds = 0.0f;
	//[self schedule:@selector(scheduledBrainTick:) interval:thinkTimeSeconds];
	[super onEnter];
}
-(void)onExit {
	// joint think
	//[self unschedule:@selector(scheduledBrainTick:)];
	[super onExit];
}

// Box2D joints: Revolute Joint: http://www.emanueleferonato.com/2009/01/13/box2d-joints-revolute-joint/
// Box2D joints: Revolute Joint - Building motors: http://www.emanueleferonato.com/2009/01/19/box2d-joints-revolute-joint-building-motors/
// Box2D Joints #2 - Revolute Joints: http://blog.thestem.ca/archives/102
-(void) initRevoluteJoint:(b2World*)world b1:(B2dBlock*)b1 b2:(B2dBlock*)b2 point:(b2Vec2&)point lower:(float32)lower upper:(float32)upper speed:(float32)speed {
	m_b2world = world;
	// joint between two bodies
	b2RevoluteJointDef jointDef;
	jointDef.Initialize([b1 getBody], [b2 getBody], point);
	jointDef.lowerAngle = lower*(b2_pi/180.0f); // convert degrees to radians
	jointDef.upperAngle = upper*(b2_pi/180.0f);	
	jointDef.enableLimit = true;
	jointDef.maxMotorTorque = 100000;//1000000.0f; //default torque
	jointDef.motorSpeed = speed;
	jointDef.enableMotor = true;	
	//jointDef.referenceAngle = 0;
	m_joint = world->CreateJoint(&jointDef);
}


-(void)scheduledBrainTick:(ccTime)deltaTime {
	//
	// Testing - simple back and forth
	//
	// assume joint type
	b2RevoluteJoint* rJoint = (b2RevoluteJoint*) m_joint;
	
	float32 angle = rJoint->GetJointAngle();	
	if(angle<=rJoint->GetLowerLimit())
	{
		// reverse motor
		rJoint->SetMotorSpeed(-rJoint->GetMotorSpeed()); // forward
	}
	else if(angle>=rJoint->GetUpperLimit())
	{
		// reverse motor
		rJoint->SetMotorSpeed(-rJoint->GetMotorSpeed()); // backward
	}
}

-(void)runThink {
	[self scheduledBrainTick:0];
}

// straight from box2d debug draw
-(void) draw {	
	b2Body* b1 = m_joint->GetBody1();
	b2Body* b2 = m_joint->GetBody2();
	const b2XForm& xf1 = b1->GetXForm();
	const b2XForm& xf2 = b2->GetXForm();
	b2Vec2 x1 = xf1.position;
	b2Vec2 x2 = xf2.position;
	b2Vec2 p1 = m_joint->GetAnchor1();
	b2Vec2 p2 = m_joint->GetAnchor2();
	
	b2Color jointColor(0.5f, 0.8f, 0.8f);
	
	switch (m_joint->GetType())
	{
		case e_distanceJoint:
			[self drawSegment:x1 p2:p1 color:jointColor];
			break;
			
		case e_pulleyJoint:
		{
			b2PulleyJoint* pulley = (b2PulleyJoint*)m_joint;
			b2Vec2 s1 = pulley->GetGroundAnchor1();
			b2Vec2 s2 = pulley->GetGroundAnchor2();
			[self drawSegment:x1 p2:p1 color:jointColor];
			[self drawSegment:p1 p2:p2 color:jointColor];
			[self drawSegment:x2 p2:p2 color:jointColor];
		}
			break;
			
		case e_mouseJoint:
			// don't draw this
			break;
			
		default:
			[self drawSegment:x1 p2:p1 color:jointColor];
			[self drawSegment:p1 p2:p2 color:jointColor];
			[self drawSegment:x2 p2:p2 color:jointColor];	
	}	
}

- (void) drawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color {	
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(color.r, color.g, color.b,1);
	GLfloat glVertices[] = {p1.x,p1.y,p2.x,p2.y};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_LINES, 0, 2);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}


-(void) dealloc{
	NSLog(@"dealloc B2dJoint");
	
	//
	// When a body is destroyed, all shapes and joints attached to the body are automatically destroyed
	//
	//m_b2world->DestroyJoint(m_joint);

	// clear pointers, no longer valid
	m_joint = nil;
	m_b2world = nil;
	// parent	
	[super dealloc];
}

@end

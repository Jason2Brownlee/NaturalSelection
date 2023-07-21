/*
 *  Types.h
 *  Trilobite
 *
 *  Created by jasonb on 21/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef TTYPES_H
#define TTYPES_H


typedef struct creature_s {
	
	// shape
	float width;
	float height;
	float rotation;
	
	// joint connection
	int dir;
	float lower_angle;
	float upper_angle;
	float speed;
	
	// child nodes
	int num_children;
	// array of pointers
	creature_s **children;
	
} creature_t;





#endif /*TTYPES_H*/
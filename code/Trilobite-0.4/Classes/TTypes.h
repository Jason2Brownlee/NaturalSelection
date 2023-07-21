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

typedef struct t_creature *CreaturePtr;

typedef struct t_creature {
	 CreaturePtr parent;
	 float width;
	 float height;
	 int dir;
	 float lower_angle;
	 float upper_angle;
	 float speed;
 } Creature;





#endif /*TTYPES_H*/
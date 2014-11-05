"Adventure 4100" by David Corbett

Include Mobile Doors by David Corbett.

Use American dialect.
Use no deprecated features.
Use scoring.

Section - Stocks

There are 4 rooms.

A treasure is a kind of thing.
A treasure has a number called the score. The score of a treasure is usually 5.
A sapphire, an emerald, a pearl, a coin, a painting, and a vase are treasures.

The iron door is a lockable locked door, north of a room and south of a room.
The iron key unlocks the iron door.
The copper door is a lockable locked door, north of a room and south of a room.
The copper key unlocks the copper door.
The d1 door is a lockable locked door, north of a room and south of a room.
The d1 key unlocks the d1 door.
The d2 door is a lockable locked door, north of a room and south of a room.
The d2 key unlocks the d2 door.
The d3 door is a lockable locked door, north of a room and south of a room.
The d3 key unlocks the d3 door.
The d4 door is a lockable locked door, north of a room and south of a room.
The d4 key unlocks the d4 door.
The d5 door is a lockable locked door, north of a room and south of a room.
The d5 key unlocks the d5 door.
The d6 door is a lockable locked door, north of a room and south of a room.
The d6 key unlocks the d6 door.

Section - New properties

A room has a number called the x.
A room has a number called the y.
A room has a number called the z.
A room can be placed or unplaced.
A room has an object called the precursor.
A room has a number called the index.

Section - Auxiliary phrases

The description of a room (called R) is usually "You can go:[exit list].".
To say exit list:
	repeat with D running through directions:
		let R be the room D from the location;
		if R is a room, say " [D],";

Rule for printing the name of a room (called R):
	say "Room [code of R]";

To decide what number is the code of (O - object):
	(- {O} -).

To decide what direction is a fun direction:
	if a random chance of 3 in 4 succeeds:
		if a random number between 1 and 4 is:
			-- 1: decide on north;
			-- 2: decide on east;
			-- 3: decide on south;
			-- otherwise: decide on west;
	if a random chance of 3 in 4 succeeds:
		if a random number between 1 and 4 is:
			-- 1: decide on northeast;
			-- 2: decide on southeast;
			-- 3: decide on southwest;
			-- otherwise: decide on northwest;
	decide on down;

To decide what number is the x (D - direction) of (R - room):
	if D is north or D is northwest or D is northeast:
		decide on x of R + 1;
	if D is south or D is southwest or D is southeast:
		decide on x of R - 1;
	otherwise:
		decide on x of R;

To decide what number is the y (D - direction) of (R - room):
	if D is east or D is northeast or D is southeast:
		decide on y of R + 1;
	if D is west or D is northwest or D is southwest:
		decide on y of R - 1;
	otherwise:
		decide on y of R;

To decide what number is the z (D - direction) of (R - room):
	if D is up:
		decide on z of R + 1;
	if D is down:
		decide on z of R - 1;
	otherwise:
		decide on z of R;

To decide whether the space at (x - number) by (y - number) by (z - number) is free:
	repeat with R running through placed rooms:
		if x of R is x and y of R is y and z of R is z, no;
	yes;

Section - The initial room tree

When play begins:
	while a room (called branch) is unplaced:
[		say line break;]
[		showme the branch;]
		let root be a random placed room;
[		showme the root;]
		if root is nothing:
			now branch is placed;
		otherwise:
			let D be a fun direction;
[			showme D;]
			let x be x D of root;
			let y be y D of root;
			let z be z D of root;
			if the space at x by y by z is free:
				now branch is placed;
[				say "free!";]
				now x of branch is x;
				now y of branch is y;
				now z of branch is z;
				now precursor of branch is root;
				change the D exit of root to branch;
[				say "[root] -> [D] -> [branch].";]
				change opposite of D exit of branch to root;
[				say "[branch] -> [opposite of D] -> [root].";]
[			otherwise:]
[				say "not free.";]

[When play begins:
	repeat with R running through rooms:
		say "[code of R]: ([x of R],[y of R],[z of R])[line break]";
		repeat with D running through directions:
			let R2 be room D from R;
			if R2 is not nothing:
				say " . [D] -> [code of R2][line break]";]

Definition: A room is root if it is placed and its precursor is nothing.

When play begins:
	let L be a list of rooms;
	let R be a random root room;
	add R to L;
	let N be 1;
	while L is non-empty:
		now R is entry 1 of L;
		remove entry 1 from L;
		now index of R is N;
[		say "now the index of [R] is [N].";]
		increment N;
		repeat with R2 running through rooms adjacent to R:
			if index of R2 is 0:
				add R2 to L;

Section - The constraint satisfaction solver

A thing has a list of numbers called the ages.
When play begins:
	let N be the number of placed rooms;
	repeat with X running through things:
		extend the ages of X to N entries.
Definition: a thing is unset if it has not been set.
To decide whether (X - a thing) has not been set:
	let C be 0;
	repeat with A running through the ages of X:
		if A is 0:
			if C is 0:
				now C is 1;
			otherwise:
				yes;
	decide on whether or not C is 0.

Constraint relates a thing (called X1) to a thing (called X2) when X1 is not X2 and ((X1 is a treasure and X2 is a treasure) or (X1 is a door and X2 is a door) or (X1 is the matching key of X2) or (X2 is the matching key of X1)).
The verb to constrain means the constraint relation.

[Assume that X1 constrains X2.]
To decide whether we can put (X1 - a thing) in (R1 - a room) and (X2 - a thing) in (R2 - a room):
	if X1 is a door:
		if X2 is a door:
			decide on whether or not the index of R1 is not the index of R2;
		otherwise:
			decide on whether or not the index of R2 < the index of R1;
	if X2 is a door:
		decide on whether or not the index of R1 < the index of R2;
	decide on whether or not the index of R1 is not the index of R2.

To decide what number is the newly assigned index of (X - a thing):
	let the possible indices be a list of numbers;
	repeat with I running from 1 to the number of entries in the ages of X:
		if entry I in the ages of X is 0:
			add I to the possible indices;
	if the possible indices is empty, decide on 0;
	let the index be a random number between 1 and the number of entries in the possible indices;
	repeat with I running from 1 to the number of entries in the ages of X:
		if I is not the index and I is listed in the possible indices:
			now entry I in the ages of X is -1;
	decide on the index.

[To decide whether we remove inconsistent values from (X1 - a thing) given (X2 - a thing):
	let removed be false;
	repeat with I1 running from 1 to the number of entries in placed-rooms:
		if entry I1 in the ages of X1 is -1, next;
		let satisfiable be false;
		repeat with I2 running from 1 to the number of entries in placed-rooms:
			if entry I2 in the ages of X2 is -1, next;
			if we can put X1 in entry I1 in placed-rooms and X2 in entry I2 in placed-rooms:
				now satisfiable is true;
				break;
		if satisfiable is false:
			now entry I1 in the ages of X1 is -1;
			now removed is true;
	decide on removed.
To run AC-3:
	let the queue be a list of things;
	repeat with X1 running through things:
		repeat with X2 running through things constrained by X1:
			add X1 to the queue;
			add X2 to the queue;
	while the queue is non-empty:
		let X1 be entry 1 in the queue;
		let X2 be entry 2 in the queue;
		remove entry 1 from the queue;
		remove entry 1 from the queue;
		if we remove inconsistent values from X1 given X2:
			repeat with X3 running through things constrained by X1:
				add X3 to the queue;
				add X1 to the queue.]

Placed-rooms is a list of rooms that varies.
When play begins:
	now placed-rooms is the list of placed rooms;
	sort placed-rooms in index order;
	let Q be 60;
	while there is an unset thing (called X):
		if Q < 0, break;
		decrement Q;
		let I be the newly assigned index of X;
		repeat with X1 running through things constrained by X:
			repeat with I1 running from 1 to the number of entries in placed-rooms:
				unless we can put X in entry I in placed-rooms and X1 in entry I1 in placed-rooms or entry I1 in the ages of X1 is not 0:
					now entry I1 in the ages of X1 is -1;
		let dead end be false;
		repeat with X1 running through things:
			if 0 is not listed in the ages of X1:
				now dead end is true;
				break;
		if dead end is true:
			repeat with X1 running through things:
				repeat with I1 running from 1 to the number of entries in placed-rooms:
					unless entry I1 in the ages of X1 is 0:
						increment entry I1 in the ages of X1;
			now entry I in the ages of X is -1;
		otherwise:
			repeat with X1 running through things:
				if X1 is X, next;
				repeat with I1 running from 1 to the number of entries in placed-rooms:
					unless entry I1 in the ages of X1 is 0:
						decrement entry I1 in the ages of X1;

When play begins:
	repeat with X running through things:
		say "[X]: ([ages of X in brace notation]) ";
		let current-index be 0;
		repeat with I running from 1 to the number of entries in the ages of X:
			if entry I in the ages of X is 0:
				if current-index is 0:
					now current-index is I;
				otherwise:
					now current-index is 0;
					break;
		if current-index is 0:
			say "********* ERROR!";
			next;
		let R be entry current-index in placed-rooms;
		say "<<[current-index]>>: [R].";
		if X is a door:
			let D be the best route from R to (the precursor of R) through rooms;
			unless D is nothing:
				move X to D of R and (the opposite of D) of the precursor of R;
		otherwise:
			if X is yourself, say run paragraph on;
			move X to R, without printing a room description;

Section - Scoring

Before taking a not handled treasure (called X):
	increase score by score of X;

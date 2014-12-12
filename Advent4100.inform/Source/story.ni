"Adventure 4100" by David Corbett

Include version 4/140513 of Automap by Mark Tilford.
Include Mobile Doors by David Corbett.

Use American dialect.
Use dynamic memory allocation of at least 16384.
Use no deprecated features.
Use scoring.
Use serial comma.

Section - Stocks

A room can be placeable.
There are 20 placeable rooms.

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

A thing can be placeable or unplaceable. A thing is usually placeable.

The verb to key-match means the matching key property.

Section - Auxiliary phrases

The description of a room is usually "You can go [exit list].".
To say exit list:
	let L be a list of directions;
	repeat with D running through directions:
		if the room D from the location is a room, add D to L;
	say L.

Rule for printing the name of a room (called R):
	say "Room [code of R]".

To decide what number is the code of (O - object):
	(- {O} -).

To decide what direction is a fun direction:
	if a random chance of 15 in 16 succeeds:
		if a random number between 1 and 4 is:
			-- 1: decide on north;
			-- 2: decide on east;
			-- 3: decide on south;
			-- otherwise: decide on west;
	decide on down.

To decide what number is the x (D - direction) of (R - room):
	if D is north:
		decide on the x of R + 1;
	if D is south:
		decide on the x of R - 1;
	otherwise:
		decide on the x of R.

To decide what number is the y (D - direction) of (R - room):
	if D is east:
		decide on the y of R + 1;
	if D is west:
		decide on the y of R - 1;
	otherwise:
		decide on the y of R.

To decide what number is the z (D - direction) of (R - room):
	if D is up:
		decide on the z of R + 1;
	if D is down:
		decide on the z of R - 1;
	otherwise:
		decide on the z of R;

To decide whether the space at (x - number) by (y - number) by (z - number) is free:
	repeat with R running through placed rooms:
		if x of R is x and y of R is y and z of R is z, no;
	yes.

Section - Absolute value (for Z-Machine only)

To decide what number is the absolute value of (N - a number):
	if N >= 0, decide on N;
	decide on 0 - N.

Section - The initial room tree

When play begins:
	while there is an unplaced placeable room (called branch):
		let root be a random placed room;
		if root is nothing:
			now branch is placed;
		otherwise:
			let D be a fun direction;
			let x be x D of root;
			let y be y D of root;
			let z be z D of root;
			if the space at x by y by z is free:
				now branch is placed;
				now x of branch is x;
				now y of branch is y;
				now z of branch is z;
				now precursor of branch is root;
				change the D exit of root to branch;
				change opposite of D exit of branch to root.

True adjacency relates rooms to each other.
The verb to be truly adjacent to means the true adjacency relation.

When play begins:
	repeat with R running through placeable rooms:
		repeat with D running through directions:
			let R2 be room D from R;
			if R2 is not nothing:
				now R is truly adjacent to R2.

Definition: A room is root if it is placed and its precursor is nothing.

When play begins:
	let the queue be a list of rooms;
	let R be a random root room;
	add R to the queue;
	let N be 1;
	while the queue is non-empty:
		now R is entry 1 of the queue;
		remove entry 1 from the queue;
		now the index of R is N;
		increment N;
		repeat with R2 running through rooms adjacent to R:
			if the index of R2 is 0:
				add R2 to the queue.

Section - The constraint satisfaction solver

A thing has a list of numbers called the ages.

When play begins:
	let N be the number of placed rooms;
	repeat with X running through placeable things:
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
		repeat with X1 running through placeable things:
			if 0 is not listed in the ages of X1:
				now dead end is true;
				break;
		if dead end is true:
			repeat with X1 running through placeable things:
				repeat with I1 running from 1 to the number of entries in placed-rooms:
					unless entry I1 in the ages of X1 is 0:
						increment entry I1 in the ages of X1;
			now entry I in the ages of X is -1;
		otherwise:
			repeat with X1 running through placeable things:
				if X1 is X, next;
				repeat with I1 running from 1 to the number of entries in placed-rooms:
					unless entry I1 in the ages of X1 is 0:
						decrement entry I1 in the ages of X1.

When play begins:
	repeat with X running through placeable things:
		let current-index be 0;
		repeat with I running from 1 to the number of entries in the ages of X:
			if entry I in the ages of X is 0:
				if current-index is 0:
					now current-index is I;
				otherwise:
					now current-index is 0;
					break;
		if current-index is 0:
			next;
		let R be entry current-index in placed-rooms;
		if X is a door:
			let D be the best route from R to the precursor of R;
			unless D is nothing:
				move X to D of R and (the opposite of D) of the precursor of R;
		otherwise:
			move X to R, without printing a room description.

Section - Attacking

Attacking it with is an action applying to one visible thing and one carried thing.
Understand "attack [something] with [something]" as attacking it with.

Check an actor attacking something with:
	try the actor attacking the noun.

Instead of attacking the dwarf:
	if the axe is carried:
		try throwing the axe at the dwarf instead.

Section - The dwarf

The dwarf is a man. The description of the dwarf is "This little guy is a reflex agent. If he sees you, he reflexively tries to kill you."

The dwarf can be hidden. The dwarf is hidden.

The axe is an unplaceable thing. The axe is nowhere. The description of the axe is "It's just a little axe."

Definition: a room is non-location if it is not the location.

Every turn:
	if the dwarf is in a room (called R):
		if R is the location:
			if the dwarf is hidden:
				say "A dwarf emerges from the shadows!";
				now the dwarf is not hidden;
				stop;
			otherwise if axe is nowhere:
				say "The dwarf throws a nasty little axe at you, misses, curses, and runs away.";
				now the axe is in the location;
			otherwise:
				say "The dwarf throws a nasty little knife at you, ";
				if a random chance of 1 in 3 succeeds:
					say "and hits!";
					end the story saying "You have died";
				otherwise:
					say "but misses![paragraph break]Shrieking with frustration, the dwarf slips back into the shadows.";
		now the dwarf is hidden;
		if the best route from R to the location is not nothing and a random chance of 1 in 4 succeeds:
			now the dwarf is in the location;
		otherwise:
			let R1 be a random non-location room which is truly adjacent to R;
			if the best route from R to R1 is not nothing, now the dwarf is in R;
		if the dwarf is visible:
			let W be the best direction from the location to R;
			say "The dwarf arrives from [if W is up]above[otherwise if W is down]below[otherwise][the W][end if].";
			now the dwarf is not hidden.

Instead of attacking the dwarf:
	say "Not with your bare hands."

Instead of attacking the dwarf with the axe:
	try throwing the axe at the dwarf.

Instead of throwing the axe at the dwarf:
	say "You throw the axe at the dwarf and the spinning blade hits with a satisfying squelch! The body vanishes in a cloud of greasy black smoke.";
	now the axe is in the location;
	now the dwarf is nowhere.

Rule for writing a paragraph about the hidden dwarf:
	now the dwarf is mentioned.

Section - The archeologist

The archeologist is a man. The description of the archeologist is "The archeologist carries a camera[if the player carries a treasure]. He looks disapprovingly at the treasure you have looted[end if].".

A treasure can be photographed.

The best next step list is a list of objects variable.
The best next step score is a number variable.
The initial depth is always 2.

Every turn:
	now the best next step list is {};
	now the best next step score is 0;
	let node-locs be a list of rooms;
	add the location to node-locs;
	add the location of the archeologist to node-locs;
	let N be alpha-beta node-locs ' the list of not handled not photographed treasures ' the list of carried things which are key-matched by locked doors ' the list of not carried things which are key-matched by locked doors ' the initial depth ' -32768 ' 32767 ' false;
	if the best next step list is non-empty:
		sort the best next step list in random order;
		let the best next step be entry 1 in the best next step list;
		if the best next step is a direction:
			if the archeologist is visible, say "The archeologist goes [best next step].";
			move the archeologist to the room (best next step) of the location of the archeologist;
			if the archeologist is visible, say "The archeologist arrives from [if best next step is up]below[otherwise if best next step is down]above[otherwise][the best next step][end if].";
		otherwise if the best next step is a thing:
			if the archeologist is visible, say "The archeologist takes a picture of [the best next step].";
			now the best next step is photographed.

To decide what number is alpha-beta (node-locs - list of objects) ' (node-treasures - list of objects) ' (node-carried-keys - list of objects) ' (node-uncarried-keys - list of objects) ' (depth - number) ' (alpha - number) ' (beta - number) ' true:
	if depth is 0 or node-treasures is empty:
		decide on the number of entries in node-treasures;
	repeat with L running through the children of node-locs ' node-treasures ' node-carried-keys ' node-uncarried-keys ' true:
		let alpha-prime be alpha-beta entry 1 of L ' entry 2 of L ' entry 3 of L ' entry 4 of L ' depth - 1 ' alpha ' beta ' false;
		if alpha-prime > alpha, now alpha is alpha-prime;
		if beta <= alpha, break;
	decide on alpha.

To decide what number is alpha-beta (node-locs - list of objects) ' (node-treasures - list of objects) ' (node-carried-keys - list of objects) ' (node-uncarried-keys - list of objects) ' (depth - number) ' (alpha - number) ' (beta - number) ' false:
	if depth is 0 or node-treasures is empty:
		let the heuristic be 0;
		repeat with X running through treasures:
			if X is listed in node-treasures:
				let N be the number of moves from entry 2 in node-locs to the location of X, using even locked doors;
				unless N is -1, increase the heuristic by N;
			otherwise:
				decrease the heuristic by the number of placeable rooms;
		decide on the heuristic;
	repeat with L running through the children of node-locs ' node-treasures ' node-carried-keys ' node-uncarried-keys ' false:
		let beta-prime be alpha-beta entry 1 of L ' entry 2 of L ' entry 3 of L ' entry 4 of L ' depth - 1 ' alpha ' beta ' true;
		if beta-prime < beta:
			now beta is beta-prime;
		if beta <= alpha, break;
		if depth is the initial depth:
			if beta < best next step score:
				now the best next step score is beta;
				now the best next step list is entry 5 of L;
			otherwise:
				add entry 1 of entry 5 of L to the best next step list;
	decide on beta.

To decide what list of lists of lists of objects is the children of (node-locs - list of objects) ' (node-treasures - list of objects) ' (node-carried-keys - list of objects) ' (node-uncarried-keys - list of objects) ' true:
	let the children be a list of lists of lists of objects;
	repeat with X running through directions:
		let RD be the room-or-door X from entry 1 in node-locs;
		if RD is not nothing and (RD is not a door or (the matching key of RD is not listed in node-carried-keys and the matching key of RD is not listed in node-uncarried-keys)):
			[go direction]
			let L be a list of lists of objects;
			let L1 be node-locs;
			now entry 1 in L1 is the room X from (entry 1 in node-locs);
			add L1 to L;
			add node-treasures to L;
			add node-carried-keys to L;
			add node-uncarried-keys to L;
			add L to the children;
	repeat with X running through node-treasures:
		if X is in entry 1 in node-locs:
			[get treasure]
			let L be a list of lists of objects;
			add node-locs to L;
			let L1 be node-treasures;
			remove X from L1;
			add L1 to L;
			add node-carried-keys to L;
			add node-uncarried-keys to L;
			add L to the children;
	repeat with X running through node-carried-keys:
		if X unlocks a door in entry 1 in node-locs:
			[unlock door]
			let L be a list of lists of objects;
			add node-locs to L;
			add node-treasures to L;
			let L1 be node-carried-keys;
			remove X from L1;
			add L1 to L;
			add node-uncarried-keys to L;
			add L to the children;
	[get all keys]
	let L be a list of lists of objects;
	add node-locs to L;
	add node-treasures to L;
	let L1 be node-carried-keys;
	let L2 be node-uncarried-keys;
	let Z be false;
	repeat with X running through node-uncarried-keys:
		if X is in entry 1 in node-locs:
			add X to L1;
			remove X from L2;
			now Z is true;
	if Z is true:
		add L1 to L;
		add L2 to L;
		add L to the children;
	decide on the children.

To decide what list of lists of lists of objects is the children of (node-locs - list of object) ' (node-treasures - list of objects) ' (node-carried-keys - list of objects) ' (node-uncarried-keys - list of objects) ' false:
	let the children be a list of lists of lists of objects;
	repeat with D running through directions:
		let RD be the room-or-door D from entry 2 in node-locs;
		if RD is not nothing and (RD is not a door or (the matching key of RD is not listed in node-carried-keys and the matching key of RD is not listed in node-uncarried-keys)):
			[go direction]
			let L be a list of lists of objects;
			let L1 be node-locs;
			now entry 2 in L1 is the room D from (entry 2 in node-locs);
			add L1 to L;
			add node-treasures to L;
			add node-carried-keys to L;
			add node-uncarried-keys to L;
			now L1 is {};
			add D to L1;
			add L1 to L;
			add L to the children;
	repeat with X running through node-treasures:
		if X is in entry 2 in node-locs:
			[photograph treasure]
			let L be a list of lists of objects;
			add node-locs to L;
			let L1 be node-treasures;
			remove X from L1;
			add L1 to L;
			add node-carried-keys to L;
			add node-uncarried-keys to L;
			now L1 is {};
			add X to L1;
			add L1 to L;
			add L to the children;
	[wait]
[	let L be a list of lists of objects;
	add node-locs to L;
	add node-treasures to L;
	add node-carried-keys to L;
	add node-uncarried-keys to L;
	add {nothing} to L;
	add L to the children;]
	decide on the children.

Section - Zones and tunneling

A room has a number called the zone.

The verb to follow means the precursor property.

To decide what direction is the best direction from (R1 - a room) to (R2 - a room):
	let dx be x of R2 - x of R1;
	let dy be y of R2 - y of R1;
	let dz be z of R2 - z of R1;
	if dz > 0, decide on up;
	if dz < 0, decide on down;
	if dx > 0:
		if dy > 0, decide on northeast;
		if dy < 0, decide on northwest;
		decide on north;
	if dx < 0:
		if dy > 0, decide on southeast;
		if dy < 0, decide on southwest;
		decide on south;
	if dy > 0, decide on east;
	decide on west.

To tunnel from (R1 - a room) to (R2 - a room):
	if R1 is R2 or the best route from R1 to R2, using even locked doors is nothing:
		stop;
	let W1 be the best direction from R1 to R2;
	if the room W1 from R1 is nothing and the room (opposite of W1) from R2 is nothing:
		change the W1 exit of R1 to R2;
		change the (opposite of W1) exit of R2 to R1.

When play begins:
	let the current zone stack be a list of rooms;
	let the current zone list be a list of rooms;
	let the root queue be the list of root rooms;
	let the current zone be 0;
	let the agent list be {yourself};
	add the list of people to the agent list, if absent;
	let the agent zone list be a list of numbers;
	repeat with Z running from 2 to the number of doors:
		add Z to the agent zone list;
	sort the agent zone list into random order;
	add 1 at entry 1 in the agent zone list;
	truncate the agent zone list to (the number of people) entries;
	let R be a room;
	let N be a number;
	while the current zone stack is non-empty or the root queue is non-empty or the current zone list is non-empty:
		if the current zone stack is empty:
			now N is the number of entries in the current zone list;
			repeat with I running from 1 to N * 3:
				tunnel from entry (a random number between 1 and N) in the current zone list to entry (a random number between 1 and N) in the current zone list;
			if the agent list is non-empty and N is not 0 and the current zone is listed in the agent zone list:
				move entry 1 in the agent list to entry (a random number between 1 and N) in the current zone list;
				remove entry 1 from the agent list;
			if the root queue is non-empty:
				now the current zone list is {};
				now R is entry 1 in the root queue;
				remove entry 1 from the root queue;
				increment the current zone;
			otherwise:
				break;
		otherwise:
			now N is the number of entries in the current zone stack;
			now R is entry N in the current zone stack;
			remove entry N from the current zone stack;
		now the zone of R is the current zone;
		add R to the current zone list;
		repeat with R2 running through rooms following R:
			if the zone of R2 is 0:
				let W be the best route from R to R2, using even locked doors;
				if the door W from R is nothing:
					add R2 to the current zone stack;
				otherwise:
					add R2 to the root queue.

Section - Mapping

Automapping is an action out of world applying to nothing.
Understand "automap" as automapping.

Carry out automapping:
	say "Opening all doors and mapping the dungeon.";
	reserve automap memory of (the number of placeable rooms * 2 / 3) rows;
	repeat with D running through doors:
		now D is unlocked;
		now D is open;
	repeat with R running through rooms:
		explore R.

Section - Scoring

When play begins:
	repeat with X running through treasures:
		increase the maximum score by the score of X.

Before taking a not handled treasure (called X):
	increase the score by the score of X.

#define STONES 5

mtype = { none, red, blue }
mtype stones[STONES];
int frogs[STONES];
int idx[STONES];

bool success =(stones[0]==red) && (stones[1]==red) && (stones[2]==red)   && (stones[4]==blue);    
	
	
	


proctype mFrogRight(byte at) {
end:do
	:: 	atomic {
	
	
			printf( "START FROG %d AT %d GOING RIGHT\n"
			, frogs[at]
			, at+1
			);
			(at < STONES-1) && 
			(frogs[at]==1)&&
			(stones[at+1] == none) -> 
			stones[at] = none;
			printf( "MOVE FROG%d FROM %d TO %d\n"
			, frogs[at]
			, at+1
			, at+2 );
			stones[at+1] = blue;
			frogs[at+1]=frogs[at];
			idx[frogs[at+1]]=at+1;
			idx[0]=at;
			frogs[at]=0;
			at = at + 1;
			printf( "EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n"
				, idx[0]+1
				, idx[1]+1
				, idx[2]+1
				, idx[3]+1
				, idx[4]+1
				);
			
		}
	:: atomic {
			printf( "START FROG %d AT %d GOING RIGHT\n"
			, frogs[at]
			, at+1
			);
			(at < STONES-2) && 
			(frogs[at]==1)&&
	   		(stones[at+1] != none) && 
			(stones[at+2] == none) -> 
			
			stones[at] = none; 
			printf( "MOVE FROG%d FROM %d TO %d\n"
			, frogs[at]
			, at+1
			, at + 3
			);
			stones[at+2] = blue;
			frogs[at+2]=frogs[at];
			idx[frogs[at+2]]=at+2;
			frogs[at]=0;
			idx[0]=at;
			at = at + 2;
			printf( "EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n"
				, idx[0]+1
				, idx[1]+1
				, idx[2]+1
				, idx[3]+1
				, idx[4]+1
				);
		}
	od
}
proctype mFrogLeft(byte at) {
end:do
	:: atomic {
			printf( "START FROG %d AT %d GOING LEFT\n"
			, frogs[at]
			, at+1
			);

			(at > 0) &&
			(frogs[at]!=1)&&
			(frogs[at]!=0)&&
			(stones[at-1] == none) -> 
			
			stones[at] = none; 
			printf( "MOVE FROG%d FROM %d TO %d\n"
			, frogs[at]+1
			, at+1
			, at 
			);
			stones[at-1] = red;
			frogs[at-1]=frogs[at];
			frogs[at]=0;
			idx[frogs[at-1]]=at-1;
			idx[0]=at;
			at = at - 1;
			printf( "EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n"
				, idx[0]+1
				, idx[1]+1
				, idx[2]+1
				, idx[3]+1
				, idx[4]+1
				);
		}
	:: atomic {
			printf( "START FROG %d AT %d GOING LEFT\n"
			, frogs[at]
			, at+1
			);
			(at > 1) && 
	   		(stones[at-1] != none) && 
			(frogs[at]!=1)&&
			(frogs[at]!=0)&&
			(stones[at-2] == none) -> 
			
			stones[at] = none; 
			printf( "MOVE FROG%d FROM %d TO %d\n"
			, frogs[at]
			, at+1
			, at - 1
			);
			stones[at-2] = red;
			frogs[at-2]=frogs[at];
			frogs[at]=0;
			idx[frogs[at-2]]=at-2;
			idx[0]=at;
			at = at - 2;
			printf( "EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n"
				, idx[0]+1
				, idx[1]+1
				, idx[2]+1
				, idx[3]+1
				, idx[4]+1
				);
		}
	od
}

init {
	
		stones[STONES/2] = none;
		frogs[0]=1;frogs[1]=0;frogs[2]=2;frogs[3]=3;frogs[4]=4;
		idx[0]=1;idx[1]=0;idx[2]=2;idx[3]=3;idx[4]=4;
		stones[0] = blue;stones[1]=none;stones[2] = red;stones[3] = red;stones[4] = red;
		
		printf( "EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n"
				, idx[0]+1
				, idx[1]+1
				, idx[2]+1
				, idx[3]+1
				, idx[4]+1
				);
		run mFrogRight(0);
		run mFrogLeft(2);
            
		run mFrogLeft(3);
			 
		run mFrogLeft(4);
		
		do
        :: success -> break;
   		:: else -> success =(stones[0]==red) && (stones[1]==red) && (stones[2]==red)   && (stones[4]==blue);  
			
				
		od	
			 
        
        
	
		
	printf( "DONE!\n" );
	assert(false)

}
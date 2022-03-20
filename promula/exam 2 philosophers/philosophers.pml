#ifndef N
#define N 2
#endif
byte fork[N];
byte philosophers[N];

proctype Philosopher(byte id) {
do
 ::(fork[0] == 0 && fork[1]==0 && philosophers[id]==0) ->
    atomic { 
     fork[0]=1;
    fork[1]=1;
    printf("%d EADTING \n",id);
    philosophers[id] = 1
    philosophers[1-id] = 0
    fork[0]=0;
    fork[1]=0;
    printf("%d THINKING \n",id);
    }
::od
}


init {
 atomic {
 byte i = 0;
 do
 :: i < N -> run Philosopher(i); i++;
 :: else -> break;
 od;
 }
}
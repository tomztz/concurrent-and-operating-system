
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include "cond.c"


int pnum;  // number updated when producer runs.
int csum;  // sum computed using pnum when consumer runs.
int occupied;
pthread_mutex_t lock;
pthread_cond_t cv;

int (*pred)(int); // predicate indicating if pnum is to be consumed

int produceT() {
  scanf("%d",&pnum); // read a number from stdin
  return pnum;
}

void *Produce(void *a) {
  int p;

  p=1;
  while (p) {
    pthread_mutex_lock(&lock);
    while(occupied){
    pthread_cond_wait(&cv, &lock);
}
    assert(occupied==0 );
    printf("@P-READY\n");
    p = produceT();
    printf("@PRODUCED %d\n",p);
    occupied=1;
    pthread_cond_signal(&cv);

    pthread_mutex_unlock(&lock);
  }
  printf("@P-EXIT\n");
  pthread_exit(NULL);
}


int consumeT() {
  if ( pred(pnum) ) { csum += pnum; }
  return pnum;
}

void *Consume(void *a) {
  int p;

  p=1;

 while (p) {
  pthread_mutex_lock(&lock);
   while(!occupied)
        pthread_cond_wait(&cv, &lock);

        assert(occupied > 0);

   printf("@C-READY\n");
   p = consumeT();
   printf("@CONSUMED %d\n",csum);
   occupied=0;

   pthread_cond_signal(&cv);
   pthread_mutex_unlock(&lock);
  }
  printf("@C-EXIT\n");
  pthread_exit(NULL);
}


int main (int argc, const char * argv[]) {
  // the current number predicate
  static pthread_t prod,cons;
	long rc;

  pred = &cond1;
  if (argc>1) {
    if      (!strncmp(argv[1],"2",10)) { pred = &cond2; }
    else if (!strncmp(argv[1],"3",10)) { pred = &cond3; }
  }


  pnum = 999;
  csum=0;
  occupied=0;
  pthread_mutex_init(&lock, NULL);
  pthread_cond_init(&cv,NULL);
  srand(time(0));

  printf("@P-CREATE\n");
 	rc = pthread_create(&prod,NULL,Produce,(void *)0);
	if (rc) {
			printf("@P-ERROR %ld\n",rc);
			exit(-1);
		}
  printf("@C-CREATE\n");
 	rc = pthread_create(&cons,NULL,Consume,(void *)0);
	if (rc) {
			printf("@C-ERROR %ld\n",rc);
			exit(-1);
		}

  printf("@P-JOIN\n");
  pthread_join( prod, NULL);
  printf("@C-JOIN\n");
  pthread_join( cons, NULL);


  printf("@CSUM=%d.\n",csum);

  return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "api.h"
static size_t rd(const char*p, uint8_t*b, size_t m){FILE*f=fopen(p,"rb"); if(!f){perror(p);exit(2);} size_t n=fread(b,1,m,f); fclose(f); return n;}
int main(int c,char**v){ if(c!=4){fprintf(stderr,"usage: pqverify pk sig msg\n");return 2;}
 static uint8_t pk[2000],sig[2000],msg[1<<16]; size_t pl=rd(v[1],pk,2000), sl=rd(v[2],sig,2000), ml=rd(v[3],msg,1<<16);
 if(pl!=PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES){printf("bad pk len\n");return 1;}
 int r=PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(sig,sl,msg,ml,pk); printf(r==0?"PQCLEAN OK\n":"PQCLEAN FAIL\n"); return r==0?0:1;}

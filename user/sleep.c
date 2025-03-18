#include "kernel/types.h"
#include "user/user.h"
int main(int argn, char *argv[]){
    if(argn != 2){
        fprintf(2, "usage: sleep time\n");
        exit(1);
    }
    printf("(nothing happens for a little while)\n");
    sleep(atoi(argv[1]));
    exit(0);
}
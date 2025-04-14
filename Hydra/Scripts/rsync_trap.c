#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

void log_rsync_attempt(char *argv[]) {
    FILE *f = fopen("/tmp/hydra_rsync_trap.log", "a+");
    if (f) {
        fprintf(f, "Detected rsync at %ld\n", time(NULL));
        for (int i = 0; argv[i]; i++) {
            fprintf(f, "Arg %d: %s\n", i, argv[i]);
            if (strstr(argv[i], "://")) {
                fprintf(f, "Remote Target: %s\n", argv[i]);
            }
        }
        fclose(f);
    }
}

int main(int argc, char *argv[]) {
    log_rsync_attempt(argv);
    printf("rsync: protocol mismatch -- is your shell clean?\n");
    sleep(3);
    return 1;
}

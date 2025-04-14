#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[]) {
    FILE *log = fopen("/tmp/hydra_attackers.log", "a+");
    if (log) {
        fprintf(log, "[KILLALL_TRAP] %s tried to kill process: %s\n", getenv("SSH_CLIENT"), argc > 1 ? argv[1] : "NONE");
        fclose(log);
    }
    printf("killall: no process found\n");
    sleep(2);
    return 1;
}

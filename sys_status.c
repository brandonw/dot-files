#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int*
get_cpu_data() {
        int* cpu_data;
        int i = 0;
        char *line, *tok = NULL;
        size_t len = 0;
        ssize_t read;
        FILE *fp = NULL;

        cpu_data = malloc(sizeof *cpu_data * 10);
        for (i = 0; i < 10; i++)
                cpu_data[i] = 0;

        fp = fopen("/proc/stat", "r");
        if (!fp)
                return cpu_data;

        read = getline(&line, &len, fp);
        tok = strtok(line, " ");

        for (i = 0; i < 10 && (tok = strtok(NULL, " ")) != NULL; i++)
                cpu_data[i] = atoi(tok);
        if (line)
                free(line);
        if (fp)
                fclose(fp);
        return cpu_data;
}

int
main(int argc, char *argv[])
{
        FILE *fp = NULL;
        char *line, *tok = NULL;
        size_t len = 0;
        ssize_t read;
        
        int swap_free = 0;
        int swap_tot = 0;
        int swap_used = 0;
        int mem_free = 0;
        int mem_tot = 0;
        int mem_used = 0;
        int cpu_used = 0;
        int cpu_tot = 0;
        int* cpu_stat1, *cpu_stat2;
        int tmp, i = 0;
        
        /* Retrieve swap and memory info */
        fp = fopen("/proc/meminfo", "r");
        if (!fp)
                return EXIT_FAILURE;
        while ((read = getline(&line, &len, fp)) != -1) {
                if (strlen(line) >= 8 && strncmp("SwapFree", line, 8) == 0) {
                        strtok(line, " ");
                        tmp = atoi(strtok(NULL, " "));
                        swap_free = tmp / 1024;
                }
                else if (strlen(line) >= 9 && strncmp("SwapTotal", line, 9) == 0) {
                        strtok(line, " ");
                        tmp = atoi(strtok(NULL, " "));
                        swap_tot = tmp / 1024;
                        if (swap_tot * 1024 < tmp) ++swap_tot;
                }
                else if (strlen(line) >= 8 && strncmp("MemTotal", line, 8) == 0) {
                        strtok(line, " ");
                        tmp = atoi(strtok(NULL, " "));
                        mem_tot = tmp / 1024;
                        if (mem_tot * 1024 < tmp) ++mem_tot;
                }
                else if (strlen(line) >= 7 && strncmp("MemFree", line, 7) == 0) {
                        strtok(line, " ");
                        tmp = atoi(strtok(NULL, " "));
                        mem_free = tmp / 1024;
                }
        }
        if (line)
                free(line);
        if (fp)
                fclose(fp);
        swap_used = swap_tot - swap_free;
        mem_used = mem_tot - mem_free;
        swap_free = tmp / 1024;

        /* Retrieve cpu info */
        cpu_stat1 = get_cpu_data();
        sleep(1);
        cpu_stat2 = get_cpu_data();
        cpu_tot = 0;
        for (i = 0; i < 10; i++) {
                cpu_stat1[i] = cpu_stat2[i] - cpu_stat1[i];
                cpu_tot += cpu_stat1[i];
        }
        cpu_used = (int)((float)cpu_stat1[0] / (float)cpu_tot * 100.0f);
        free(cpu_stat1);
        free(cpu_stat2);

        /* Print status */
        printf("Cpu: %d%% | Swap: %dM / %dM | Mem: %dM / %dM",
               cpu_used, swap_used, swap_tot, mem_used, mem_tot);
        return EXIT_SUCCESS;
}

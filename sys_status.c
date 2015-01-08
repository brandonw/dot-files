#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <math.h>

#define MAX_NET_DEVICES     10
#define SHOW_LOOPBACK       0

#define LOW_COLOR	    ""
#define MED_COLOR	    ""
#define HIGH_COLOR	    ""
#define BATT_FULL           ""
#define BATT_80             ""
#define BATT_30             ""
#define BATT_EMPTY          ""
#define CPU_MED_LIMIT	    50
#define CPU_HIGH_LIMIT	    90
#define MEM_MED_LIMIT	    40
#define MEM_HIGH_LIMIT	    80
#define NET_DOWN_MED_LIMIT  1024
#define NET_DOWN_HIGH_LIMIT 2048
#define NET_UP_MED_LIMIT    256
#define NET_UP_HIGH_LIMIT   768
#define BAT_MED_LIMIT       16
#define BAT_LOW_LIMIT       6

struct net_data {
	char device_name[256];
	long int down_bytes;
	long int up_bytes;
};

int
get_battery_pct() {
	char *line = NULL;
	size_t len = 0;
	FILE *fp = NULL;
	int max, current;

	fp = fopen("/sys/class/power_supply/BAT0/energy_now", "r");
	if (!fp) {
		fp = fopen("/sys/class/power_supply/BAT0/charge_now", "r");
		if (!fp)
			return -1;
	}
	getline(&line, &len, fp);
	current = atoi(line);
	if (line)
		free(line);
	if (fp)
		fclose(fp);

	line = NULL;
	len = 0;
	fp = fopen("/sys/class/power_supply/BAT0/energy_full", "r");
	if (!fp) {
		fp = fopen("/sys/class/power_supply/BAT0/charge_full", "r");
		if (!fp)
			return -1;
	}
	getline(&line, &len, fp);
	max = atoi(line);
	if (line)
		free(line);
	if (fp)
		fclose(fp);

	current = (int)ceilf((float)current / (float)max * 100.0f);
	if (current > 100)
		current = 100;
	return current;
}

int
get_cpu_data(int *cpu_data) {
	int i = 0;
	char *line = NULL, *tok = NULL;
	size_t len = 0;
	FILE *fp = NULL;

	for (i = 0; i < 10; i++)
		cpu_data[i] = 0;

	fp = fopen("/proc/stat", "r");
	if (!fp)
		return -1;

	getline(&line, &len, fp);
	tok = strtok(line, " ");

	for (i = 0; i < 10 && (tok = strtok(NULL, " ")) != NULL; i++)
		cpu_data[i] = atoi(tok);
	if (line)
		free(line);
	if (fp)
		fclose(fp);
	return 0;
}

int
get_net_data(struct net_data **data, int *num) {
	int i = 0;
	char *line = NULL, *tok = NULL;
	size_t len = 0;
	FILE *fp = NULL;
	struct net_data *nd = NULL;

	*num = 0;
	fp = fopen("/proc/net/dev", "r");
	if (!fp)
		return -1;

	/* ignore first two header lines */
	if (getline(&line, &len, fp) == -1) return -1;
	if (getline(&line, &len, fp) == -1) return -1;

	while (getline(&line, &len, fp) > 0 && *num < MAX_NET_DEVICES) {
		nd = (struct net_data*)malloc(sizeof(struct net_data));
		data[*num] = nd;
		tok = strtok(line, " ");
		strncpy(nd->device_name, tok, sizeof(nd->device_name));
		for (i = 0; i < 10 && (tok = strtok(NULL, " ")) != NULL; i++) {
			if (i == 0) nd->down_bytes = atol(tok);
			else if (i == 8) nd->up_bytes = atol(tok);
		}
		(*num)++;
	}

	if (line) free(line);
	if (fp) fclose(fp);
	return 0;
}

	int
main()
{
	FILE *fp = NULL;
	char *line = NULL;
	size_t len = 0;
	ssize_t read;
	time_t currtime;
	char time_str[256];
	int cpu_stat1[10], cpu_stat2[10];
	int tmp, i = 0, dev_count1 = 0, dev_count2 = 0;
	struct net_data *net_data1[MAX_NET_DEVICES], *net_data2[MAX_NET_DEVICES];

	char *cpu_color, *mem_color;
	long int mem_free, mem_tot, mem_buf, mem_cached, mem_used;
	int mem_pct;
	int cpu_pct, cpu_tot;

	char *batt_color;
	int batt_pct;
	char *batt_icon;

	/* Retrieve memory info */
	fp = fopen("/proc/meminfo", "r");
	if (!fp)
		return EXIT_FAILURE;
	while ((read = getline(&line, &len, fp)) != -1) {
		if (strlen(line) >= 8 && strncmp("MemTotal", line, 8) == 0) {
			strtok(line, " ");
			tmp = atoi(strtok(NULL, " "));
			mem_tot = tmp;
		}
		else if (strlen(line) >= 7 && strncmp("MemFree", line, 7) == 0) {
			strtok(line, " ");
			tmp = atoi(strtok(NULL, " "));
			mem_free = tmp;
		}
		else if (strlen(line) >= 7 && strncmp("Buffers", line, 7) == 0) {
			strtok(line, " ");
			tmp = atoi(strtok(NULL, " "));
			mem_buf = tmp;
		}
		else if (strlen(line) >= 6 && strncmp("Cached", line, 6) == 0) {
			strtok(line, " ");
			tmp = atoi(strtok(NULL, " "));
			mem_cached = tmp;
		}
	}
	if (line)
		free(line);
	if (fp)
		fclose(fp);
	mem_used = mem_tot - mem_free - mem_buf - mem_cached;
	mem_pct = (int)((float)mem_used / (float)mem_tot * 100.0f);

	/* Retrieve cpu, net, and battery data */
	get_cpu_data(cpu_stat1);
	get_net_data(net_data1, &dev_count1);
	batt_pct = get_battery_pct();
	sleep(1);
	get_cpu_data(cpu_stat2);
	get_net_data(net_data2, &dev_count2);
	cpu_tot = 0;
	for (i = 0; i < 10; i++) {
		cpu_stat1[i] = cpu_stat2[i] - cpu_stat1[i];
		cpu_tot += cpu_stat1[i];
	}
	cpu_pct = (int)((float)cpu_stat1[0] / (float)cpu_tot * 100.0f);

	if (dev_count1 != dev_count2) {
		printf("ERROR");
		return EXIT_FAILURE;
	}

	/* colors */
	cpu_color = (char*)(cpu_pct < CPU_MED_LIMIT ? LOW_COLOR :
		cpu_pct < CPU_HIGH_LIMIT ? MED_COLOR : HIGH_COLOR);
	mem_color = (char*)(mem_pct < MEM_MED_LIMIT ? LOW_COLOR :
		mem_pct < MEM_HIGH_LIMIT ? MED_COLOR : HIGH_COLOR);
	batt_color = (char*)(batt_pct < BAT_LOW_LIMIT ? HIGH_COLOR :
		batt_pct < BAT_MED_LIMIT ? MED_COLOR : LOW_COLOR);

	currtime = time(NULL);
	strftime(time_str, sizeof(time_str),
			"%a %b %e %Y %I:%M:%S %p", localtime(&currtime));
	/* Print status */
	printf("Cpu: %s%d%%", cpu_color, cpu_pct);
	printf(" | ");
	printf("Mem: %s%d%%", mem_color, mem_pct);
	printf(" | ");
	for (i = 0; i < dev_count1; i++) {
		int downkbrate = 0;
		int upkbrate = 0;
		char *down_color, *up_color;

		if (!SHOW_LOOPBACK && strcmp(net_data1[i]->device_name, "lo:") == 0)
			continue;
		downkbrate = (net_data2[i]->down_bytes - net_data1[i]->down_bytes) / 1024;
		upkbrate = (net_data2[i]->up_bytes - net_data1[i]->up_bytes) / 1024;
		down_color = (char*)(downkbrate < NET_DOWN_MED_LIMIT ? LOW_COLOR :
			downkbrate < NET_DOWN_HIGH_LIMIT ? MED_COLOR : HIGH_COLOR);
		up_color = (char*)(upkbrate < NET_UP_MED_LIMIT ? LOW_COLOR :
			upkbrate < NET_UP_HIGH_LIMIT ? MED_COLOR : HIGH_COLOR);

		printf("%s %s%5dKB %s%5dKB ",
				net_data1[i]->device_name,
				down_color, downkbrate,
				up_color, upkbrate);
	}

	if (batt_pct != -1) {
		if (batt_pct >= 95) {
			batt_icon = (char*)BATT_FULL;
		} else if (batt_pct > 40) {
			batt_icon = (char*)BATT_80;
		} else if (batt_pct > 10) {
			batt_icon = (char*)BATT_30;
		} else {
			batt_icon = (char*)BATT_EMPTY;
		}

		printf(" | ");
		printf("%s%d%% %s ", batt_color, batt_pct, batt_icon);
	}

	printf(" %s \n", time_str);

	for (i = 0; i < dev_count1; i++) free(net_data1[i]);
	for (i = 0; i < dev_count2; i++) free(net_data2[i]);
	return EXIT_SUCCESS;
}

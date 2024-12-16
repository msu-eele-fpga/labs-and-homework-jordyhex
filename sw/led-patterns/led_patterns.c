#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define MAX_ROWS     100
#define MAX_COLS     100
#define LED_REG_ADDR 0xFF200008
#define LED_CNT      8

static volatile int keep_running = 1;

void inthandle(int dummy)
{
    keep_running = 0;
}

void usage()
{
    fprintf(stderr, "Format: {command} [data]\n");
    fprintf(stderr, "Commands:\n");
    fprintf(stderr, "-h : Open the help menu\n");
    fprintf(stderr, "-p (pattern) : Enter the associated arguments {pattern(s) (in hexadecimal)} {time}");
    fprintf(stderr, "-f (file): Enter file name, opens a text file and will read the pattern and times from this file"); 
    fprintf(stderr, "-v (verbose): Will print LED pattern as binary string and how long it is being displayed");
    fprintf(stderr, "NOTE: Can not enter -f and -p together");
}

unsigned int write_pattern(uint32_t addr, unsigned long writeval)
{
    unsigned long read_result;
    const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
    uint32_t ADDRESS = addr; // LED register address
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1)
    {
        fprintf(stderr, "failed to open /dev/mem. \n");
        return 1;
    }

    uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE -1);

    uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE,
        PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
    if (page_virtual_addr == MAP_FAILED)
    {
        fprintf(stderr, "failed to map memory. \n");
        return 1;
    }
    uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
    volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t *);
    *target_virtual_addr = writeval;
    read_result = *target_virtual_addr;

    return read_result;
}

char* hex_to_binary(unsigned long hexval)
{
	char bin_arr[9];
	for (int i = 0; i < LED_CNT; i++) bin_arr[LED_CNT - 1 - i] = (hexval & (1UL << i)) ? '1' : '0';    // Beautiful short for loop
	bin_arr[i] = '\0';

    return strdup(bin_arr);
}

int main(int argc, char **argv)
{    
    int hflag = 0;
    int vflag = 0;
    int pflag = 0;
    int fflag = 0;
    int opt;

    unsigned long vread;
    char* binval;
    vread = write_pattern(LED_REG_ADDR,0x01);

    if(argc < 2){
	    fprintf(stderr,"Type '-h' for help\n");
	    exit(1);
    }

    int error_flag = 0;

    while ((opt = getopt(argc, argv, "hvpf")) != -1)
    {
	    switch (opt)
        {
		    case 'h':
                hflag = 1;
			    break;
		    case 'v':
                vflag = 1;
			    break;
            case 'p':
                pflag = 1;
                break;
            case 'f':
                fflag = 1;
                break;
		    default:
			    fprintf(stderr, "Illegal data type '%c'.\n", opt);
			    error_flag = 1;
                break;
		}
        if (error_flag) break;
    }

    if (hflag == 1) usage();

    char *times[argc/2];
    char *patterns[argc/2];
    int times_idx = 0;
    int patterns_idx = 0;

    if (pflag == 1 && fflag == 0)
    {
        if ((argc - optind) % 2 != 0)
        {
            fprintf(stderr, "ERROR: invalid arguement. Type '-h' for help\n");
            exit(2);
        }

        for (; optind < argc -1 ; optind += 2)
        {
            patterns[patterns_idx] = argv[optind];
            times[times_idx] = argv[optind + 1];
            times_idx++;
            patterns_idx++;
        }
        while (keep_running == 1)
        {
            for (int i = 0; i < patterns_idx; i++)
            {
                vread = write_pattern(LED_REG_ADDR,strtoul(patterns[i],0,0)); // R/W
                if (vflag == 1)
                {
                    binval = hex_to_binary(vread);
                    printf("LED pattern = %s Display time = %d msec\n", binval, atoi(times[i]));
                    free(binval);
                }
                usleep(atoi(times[i])*1000);
            }
        }
    }
    
    if (fflag == 1 && pflag == 0)
    {
        int row = 0;
        char column1[MAX_ROWS][MAX_COLS];
        char column2[MAX_ROWS][MAX_COLS];
        FILE *file = fopen(argv[optind], "r");
        if (file == NULL)
        {
            fprintf(stderr,"Not able to open the file.\n");
            return 1;
        }

        while (fscanf(file, "%s %s", column1[row], column2[row]) == 2)
        {
            row++;
            if (row >= 100) break;
        }
        fclose(file);

        for (int i = 0; i < row; i++)
        {
            vread = write_pattern(LED_REG_ADDR,strtoul(column1[i],0,0));
            if (vflag == 1)
            {
                binval = hex_to_binary(vread);
                printf("LED pattern = %s Display time = %d msec\n", binval, atoi(column2[i]));
                free(binval);
            }
            usleep(atoi(column2[i])*1000);
        }
    }

    if (pflag == 1 && fflag == 1)
    {
        fprintf(stderr,"ERROR: invalid arguement. Type '-h' for help\n");
        exit(3);
    }

    return 0;
}
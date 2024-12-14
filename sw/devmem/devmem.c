#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h> // for file open flags
#include <unistd.h> // for getting the page size

void usage()
{
    fprintf(stderr, "devmem ADDRESS [VALUE]\n");
    fprintf(stderr, " devmem can be used to read/write to physical memory via the /dev/mem device.\n");
    fprintf(stderr, " devmem will only read/write 32-bit values.\n\n");
    fprintf(stderr, " Arguments:\n");
    fprintf(stderr, " ADDRESS The address to read/write to/from\n");
    fprintf(stderr, " VALUE The optional value to write to ADDRESS; if not given, a read will be performed.\n");
}

int main(int argc, char **argv)
{
    // This is the size of a page of memory in the system. Typically 4096 bytes.
    const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);

    if (argc == 1)
    {
        // No arguments were given, so print the usage text and exit.
        usage();
        return 1;
    }

    // If the VALUE argument was given, we'll perform a write operation.
    bool is_write = (argc == 3) ? true : false;

    const uint32_t ADDRESS = strtoul(argv[1], NULL, 0);

    // Open the /dev/mem file, which is an image of the main system memory.
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1)
    {
        fprintf(stderr, "failed to open /dev/mem.\n");
        return 1;
    }

    // Align the address to the page boundary.
    uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);
    printf("memory addresses:\n");
    printf("-------------------------------------------------------------------\n");
    printf("page aligned address = 0x%x\n", page_aligned_addr);

    // Map a page of physical memory into virtual memory.
    uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE,
                                                   PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
    if (page_virtual_addr == MAP_FAILED)
    {
        fprintf(stderr, "failed to map memory.\n");
        return 1;
    }
    printf("page_virtual_addr = %p\n", page_virtual_addr);

    // Calculate the offset within the page.
    uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
    printf("offset in page = 0x%x\n", offset_in_page);

    // Calculate the virtual address corresponding to ADDRESS.
    volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page / sizeof(uint32_t *);
    printf("target_virtual_addr = %p\n", target_virtual_addr);
    printf("-------------------------------------------------------------------\n");

    if (is_write)
    {
        const uint32_t VALUE = strtoul(argv[2], NULL, 0);
        *target_virtual_addr = VALUE;
    }
    else
    {
        printf("\nvalue at 0x%x = 0x%x\n", ADDRESS, *target_virtual_addr);
    }

    return 0;
}
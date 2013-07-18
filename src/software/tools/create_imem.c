#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* 1MB buffer */
#define BUF_SIZE (1024*1024)
#define RAM_BLOCKS (1)
#define RAM_SPLIT (1)
#define RAM_ROWS (64)
#define RAM_ROWS_TOTAL (RAM_BLOCKS*RAM_SPLIT*RAM_ROWS)
#define RAM_DWORDPERROW (8)


int main(int argc, char *argv[])
{
    FILE *file;
    int i, j, iposinrow, iblock, irowinsplit, index, size, count;
    char *buf, *ptr, *ptr_list[RAM_ROWS_TOTAL], text[80];
    unsigned int *code;

    if(argc < 4)
    {
        printf("Usage: create_imem <imem_template.vhd> <imem_code.txt> <imem_final.vhd>\n");

        printf("Usage: create_imem ram_xilinx.vhd code.txt ram_image.vhd\n");

        return 0;
    }

    buf = (char*)malloc(BUF_SIZE);
    code = (unsigned int*)malloc(BUF_SIZE);

    /* Read ram_xilinx.vhd */
    file = fopen(argv[1], "rb");

    if(file == NULL)
    {
        printf("Can't open '%s'!\n", argv[1]);
        return -1;
    }
    
    size = fread(buf, 1, BUF_SIZE, file);
    
    fclose(file);

    /* Read code.txt */

    file = fopen(argv[2], "r");
    
    if(file == NULL)
    {
        printf("Can't open '%s'!\n", argv[2]);

        return -1;
    }
    
    /* Store DWORDs in code buffer */


    for(count = 0; count < RAM_ROWS_TOTAL*RAM_DWORDPERROW; ++count)
    {
        if(feof(file))
        {  
            count--;
            break;
        } 

        fscanf(file, "%x", &code[count]);
    }

    fclose(file);

    /*Find 'INIT_00 => X"' */

    /* Start at buf, then seek next occurence */

    ptr = buf;
    
    for(i = 0; i < RAM_ROWS_TOTAL; ++i)
    {
        sprintf(text, "INIT_%2.2X => X\"", i % RAM_ROWS);

        ptr = strstr(ptr, text);
      
        if(ptr == NULL)
        {
            printf("ERROR: Can't find '%s', block %d, instance %d in '%s'!\n", text, (i/(RAM_SPLIT*RAM_ROWS)), (i%(RAM_SPLIT*RAM_ROWS))/RAM_ROWS, argv[1]);

            return -1;
        }

        ptr_list[i] = ptr + strlen(text);
    }

    /* Modify vhdl source code */

    iposinrow = (RAM_DWORDPERROW * 8) - 8; /* start filling from end of line */
    iblock = 0;
    irowinsplit = 0;
    
    for(i = 0; i < count; ++i)
    {
        sprintf(text, "%8.8x", code[i]);

        index = (iblock * RAM_ROWS * RAM_SPLIT) + irowinsplit; 

        for(j = 0; j < RAM_DWORDPERROW; j++)
        {
            ptr_list[index][iposinrow + j] = text[j];
        }

        iposinrow -= 8;

        if(iposinrow < 0)
        { 
            iposinrow = (RAM_DWORDPERROW * 8) - 8; //reset row

            irowinsplit++;
        
            if (irowinsplit > RAM_ROWS - 1)
            { 

                /* irowinsplit = 0; */
                /* iblock++; */
                break;
            }
        } 
    }

    /* Write ram_image.vhd */

    file = fopen(argv[3], "wb");

    if(file == NULL)
    {
        printf("Can't write '%s'!\n", argv[3]);

        return -1;
    }

    fwrite(buf, 1, size, file);
    fclose(file);
    free(buf);
    free(code);

    return 0;
}

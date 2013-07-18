            .data

theArray:   .space 160
    
            .text

            .word 0x3C1D7FFF , 0x37BDEBA0 , 0x3C1C1000 , 0x379C8000

main:       # prepare registers for MISR
            lui     $22, 0x1800
            ori     $22, $22, 0x0002
            not     $23, $0
	
            #ANY CODE HERE THAT RESULTS WITH A VALUE FOR COMPRESSION IN $17

            lui     $17, 0xAAAA
            ori     $17, $17, 0x5555

            # Data for compaction resides in register $17

misr:       sll     $24, $23, 0x001f  
            sra     $25, $24, 0x001f  
            and     $25, $25, $22     
            xor     $23, $23, $25     
            srl     $23, $23, 0x0001  
            addu    $23, $23, $24
            xor     $23, $23, $17 

            #At the end $23 register keeps the unique MISR signature

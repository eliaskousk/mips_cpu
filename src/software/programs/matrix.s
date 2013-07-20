# ============================================
# Matrix Multiplication
# ============================================
# A simple program that performs matrix
# multiplication of two random integer arrays
# and stores the result in a third array of
# the correct size:
# P(M x N) = A(M x R) X B(R x N)
# --------------------------------------------
# Slightly modified from the Advanced Computer
# Architecture Spring 2012 class of Professor
# Gkizopoulos
# ============================================

            .data

            .align  2

matrixA:    .word   439, 195, 923, 347, 696, 290, 715, 940
            .word   566, 506, 863, 738, 211, 668, 76, 701
            .word   631, 285, 457, 970, 280, 437, 508, 778
            .word   641, 449, 706, 647, 681, 324, 724, 273
            .word   922, 910, 193, 533, 142, 469, 349, 726
            .word   532, 495, 362, 156, 458, 802, 507, 539
            .word   635, 810, 330, 302, 315, 123, 19, 655
            .word   24, 790, 293, 432, 428, 935, 311, 366


matrixB:    .word   222, 770, 560, 416, 647, 284, 247, 782
            .word   262, 373, 422, 142, 494, 406, 408, 515
            .word   896, 554, 633, 153, 261, 995, 378, 75
            .word   284, 504, 187, 918, 316, 757, 26, 355
            .word   559, 380, 880, 473, 971, 650, 247, 990
            .word   175, 238, 142, 44, 481, 183, 76, 430
            .word   449, 828, 343, 472, 771, 664, 849, 551
            .word   150, 387, 946, 752, 234, 936, 474, 946

matrixP:    .space  256

# Correct results
# matrixP:  .word   1975953, 2386295, 2765423, 2056407, 2317449, 3244980, 1792456, 2733078
#           .word   1615187, 2047991, 2184527, 1809050, 1823436, 2749525, 1191335, 2231069
#           .word   1477491, 2266349, 2162987, 2239847, 2030641, 2811410, 1372539, 2499848
#           .word   1879669, 2419274, 2268203, 1915771, 2464432, 2794793, 1562118, 2485824
#           .word   1194458, 2160440, 2120241, 1830077, 2067309, 2316223, 1396969, 2614689
#           .word   1321315, 1866752, 1965847, 1386750, 2080015, 2115958, 1334263, 2341010
#           .word   1039029, 1544299, 1883597, 1362841, 1525494, 1919119, 1033671, 2040519
#           .word   1194940, 1477520, 1575392, 1229177, 1809521, 1944500, 1064533, 1944320

            .globl main                   # Call main by SPIM

            .text                         # Text Section

main:       addiu   $v0, $zero, 0x8       # size = 8
            addiu   $v1, $zero, 0x20

            addu    $s0, $zero, $zero     # i = 0
            addu    $s1, $zero, $zero     # j = 0
            addu    $s2, $zero, $zero     # k = 0
            addu    $t3, $zero, $zero     # P[i][j] = 0

multloop:   mul     $t0, $s0, $v0         # create A[i][k] address
            add     $t1, $t0, $s2         # (i * 32) + (4 * k)
            lw      $t4, matrixA($t1)     # load A[i][k]

            mul     $t0, $s2, $v0         # create B[k][j] address
            add     $t1, $t0, $s1         # (k * 32) + (4 * j)
            lw      $t5, matrixB($t1)     # load B[k][j]

            mul     $t6, $t4, $t5         # A[i][k] * B[k][j]
            add     $t3, $t3, $t6         # P[i][j] = P[i][j] + A[i][k] * B[k][j]
            addiu   $s2, $s2, 0x4         # k++ and test inner loop condition
            bne     $s2, $v1, multloop    # loop inner

            mul     $t0, $s0, $v0         # create P[i][j] address
            add     $t1, $t0, $s1         # (i * n) + j
            sw      $t3, matrixP($t1)     # store P[i][j]

            addu    $s2, $zero, $zero     # k = 0
            addu    $t3, $zero, $zero     # P[i][j] = 0
            addiu   $s1, $s1, 0x4         # j++
            bne     $s1, $v1, multloop    # loop columns

            addu    $s1, $zero, $zero     # j = 0
            addiu   $s0, $s0, 0x4         # i++
            bne     $s0, $v1, multloop    # loop rows
end:

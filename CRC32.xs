/*
Perl Extension for CRC computations
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* 
 Based on CRC-32 version 1.04 by Craig Bruce, 05-Dec-1994
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

unsigned long 
crcTable[256];

void
crcgen( void )
{
    unsigned long crc, poly;
    int     i, j;

    poly = 0xEDB88320L;
    for (i=0; i<256; i++) {
        crc = i;
        for (j=8; j>0; j--) {
            if (crc&1) {
                crc = (crc >> 1) ^ poly;
            } else {
                crc >>= 1;
            }
        }
        crcTable[i] = crc;
    }
}

unsigned long 
getcrc(char *c, int len)
{
    register unsigned long crc;
    char     *e = c + len;

    crc = 0xFFFFFFFF;
    while (c < e) {
        crc = ((crc >> 8) & 0x00FFFFFF) ^ crcTable[ (crc^ *c) & 0xFF ];
        ++c;
    }
    return( crc^0xFFFFFFFF );
}


MODULE = String::CRC32		PACKAGE = String::CRC32

VERSIONCHECK: DISABLE
PROTOTYPES: DISABLE 

void
crc32(data)
    PREINIT:
	int data_len;
    INPUT:
	char *data = (char *)SvPV(ST(0),data_len);
    PPCODE:
	{
		unsigned long 	crc32;
		U32		*rv;
		SV		*sv;

		crcgen();
		crc32 = getcrc(data, data_len);
		EXTEND(sp, 1);
		sv = newSV(0);
		sv_setuv(sv, (UV)crc32);
		PUSHs(sv_2mortal(sv));
	}



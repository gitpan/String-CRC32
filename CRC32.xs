/*
Perl Extension for 32bit CRC computations
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
//#include <unistd.h>

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
getcrc(char *c, int len, unsigned long crcinit)
{
    register unsigned long crc;
    char     *e = c + len;

    crc = crcinit^0xFFFFFFFF;
    while (c < e) {
        crc = ((crc >> 8) & 0x00FFFFFF) ^ crcTable[ (crc^ *c) & 0xFF ];
        ++c;
    }
    return( crc^0xFFFFFFFF );
}


MODULE = String::CRC32		PACKAGE = String::CRC32

VERSIONCHECK: DISABLE
PROTOTYPES: DISABLE 

unsigned long
crc32(data, ...)
    char *data = NO_INIT
    PREINIT:
	unsigned long crcinit = 0;
    STRLEN data_len;
    CODE:
	data = (char *)SvPV(ST(0),data_len);
	crcgen();
	/* Horst Fickenscher <horst_fickenscher@sepp.de> mailed me that it
	   could be useful to supply an initial value other than 0, e.g.
	   to calculate checksums of big files without the need of keeping
	   them comletely in memory */
	if ( items > 1 )
		crcinit = (unsigned long) SvNV(ST(1));
	RETVAL = getcrc(data, data_len, crcinit);
     OUTPUT:
	RETVAL

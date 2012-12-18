#include "DUKPT_DES.h"
#include <string.h>
#include <ctype.h>

u8 static XOR_DATA[16] = {0xC0,0xC0,0xC0,0xC0,0x00,0x00,0x00,0x00,0xC0,0xC0,0xC0,0xC0,0x00,0x00,0x00,0x00};


void vOneTwo(unsigned char *in, unsigned int lc, unsigned char *out)
{
    static unsigned char ucHexToChar[17] = "0123456789ABCDEF";
    unsigned int nCounter;
    
    for(nCounter = 0; nCounter < lc; nCounter++){
        out[2*nCounter] = ucHexToChar[(in[nCounter] >> 4)];
        out[2*nCounter+1] = ucHexToChar[(in[nCounter] & 0x0F)];
    }
    return;
}
void vOneTwo0(unsigned char *in, unsigned int lc, unsigned char *out)
{
    vOneTwo(in, lc, out);
    out[2*lc]=0;
}

//char to HEX
void vTwoOne(unsigned char *in, unsigned int in_len, unsigned char *out)
{
    unsigned char tmp;
    unsigned int i;
    
    for(i=0;i<in_len;i+=2){
        tmp = in[i];
        if(tmp > '@')
            tmp = toupper(tmp) - ('A' - 0x0A);
        else
            tmp &= 0x0f;
        tmp <<= 4;
        
        out[i/2]=tmp;
        
        tmp=in[i+1];
        if(tmp>'@')
            tmp = toupper(tmp) - ('A' - 0x0A);
        else
            tmp &= 0x0f;
        out[i/2]+=tmp;
    }
}

void pan_count(unsigned long *count_num)
{
	u8 i;
	u32 tmp_count,j;
	tmp_count = *count_num;
	while(1)
	{
		j = 0;
		if(*count_num > 0x1fffff)
		{
			*count_num = 1;
			return;
		}
		for(i=0;i<21;i++)
		{
			if(tmp_count&0x01)
				j++;
			tmp_count = tmp_count>>1;
		}
		if(j<11)
			return;
		tmp_count = *count_num;	
		j = 1;
		for(i=0;i<21;i++)
		{
			if((tmp_count>>i)&0x01)
			{
				j <<= i;
				break;
			}	
		}
		*count_num += j;	
		tmp_count = *count_num;
	}
}

void comb_KSN(u8 *tmp_KSN, u32 *count_num)
{
	u8 temp;
	tmp_KSN[7] &= 0xe0;
	tmp_KSN[8] = 0;
	tmp_KSN[9] = 0;
	temp = (*count_num >> 16) & 0x1f;
	tmp_KSN[7] += temp;
	temp = (*count_num >> 8) & 0xff;
	tmp_KSN[8] += temp;
	temp = (*count_num) & 0xff;
	tmp_KSN[9] += temp;
}

void xor_cl(u8 *result, u8 *source1, u8 *source2, u8 length)
{
	while(length--)
	{
		*result++ = (*source1++) ^ (*source2++);
	}
}

void generate_key(u8 *now_key, u8 *tmpKSN)
{
	u8  cr1[8], cr2[8];
	memcpy(cr1,tmpKSN,8);
	xor_cl(cr2,cr1,&now_key[8],8);
	Des_string(cr2,8,now_key,8,cr2,DES_ENCRYPT);
	xor_cl(cr2,cr2,&now_key[8],8);
	xor_cl(now_key,XOR_DATA,now_key,16);
	xor_cl(cr1,cr1,&now_key[8],8);
	Des_string(cr1,8,now_key,8,cr1,DES_ENCRYPT);
	xor_cl(cr1,cr1,&now_key[8],8);
	memcpy(now_key,cr1,8);
	memcpy(&now_key[8],cr2,8);
}

void get_now_key(unsigned char *now_key, unsigned char *init_key, unsigned long *count_num, unsigned char *KSNdata )
{
	u32 tmp_count,k,x;
	u8 i,j=0;
	memcpy(now_key,init_key,16);
	tmp_count = *count_num;
	for(i=0;i<21;i++)
	{
		if(tmp_count&0x01)
			j++;
		tmp_count = tmp_count>>1;
	}
	tmp_count = *count_num ;
	k = 0;
	x = 0x100000;
	while(j--)
	{
		for(i=0;i<21;i++)
		{
			if(tmp_count&0x100000)
				break;
			tmp_count <<= 1;
			x >>= 1;
		}
		k += x;
		tmp_count <<= 1;
		x >>= 1;
		comb_KSN(KSNdata, &k);
		generate_key(now_key, &KSNdata[2]);
	}
}
#ifndef _DUKPT_DES_H_
#define _DUKPT_DES_H_

#define	     DES_ENCRYPT	0
#define	     DES_DECRYPT	1
#define	     TDES_ENCRYPT	2
#define	     TDES_DECRYPT	3

typedef unsigned char u8;
typedef unsigned int u16;
typedef unsigned long u32;

void vOneTwo(unsigned char *in, unsigned int lc, unsigned char *out);
void vOneTwo0(unsigned char *in, unsigned int lc, unsigned char *out);
void vTwoOne(unsigned char *in, unsigned int in_len, unsigned char *out);

void pan_count(unsigned long *count_num);
void get_now_key(unsigned char *now_key, unsigned char *init_key, unsigned long *count_num, unsigned char *KSNdata );
void Des_string(unsigned char *in_data, unsigned char data_length, unsigned char *key, unsigned char key_lenth, unsigned char *out_data, unsigned char DES_MODE);

void _Des(char cryp_decrypt,unsigned char *DES_DATA,unsigned char *DES_RESULT,unsigned char *DESKEY);


#endif
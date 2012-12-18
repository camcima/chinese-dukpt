
#include <string.h>
#include "dukpt_des.h"

extern	enDes(void);
extern	unDes(void);

unsigned char idata ptDesRamBuffer[24];


void  des(unsigned char *binput, unsigned char *boutput, unsigned char *bkey)
{
	memcpy(ptDesRamBuffer, binput, 8);		//copy输入数据
	memcpy(ptDesRamBuffer+8, bkey, 8);		//copy前8字节密钥
	enDes();								//des加密
	memcpy(boutput, ptDesRamBuffer, 8);		//copy输出结果
}

void  undes(unsigned char *binput, unsigned char *boutput, unsigned char *bkey)
{
	memcpy(ptDesRamBuffer, binput, 8);		//copy输入数据
	memcpy(ptDesRamBuffer+8, bkey, 8);		//copy前8字节密钥
	unDes();								//des加密
	memcpy(boutput, ptDesRamBuffer, 8);		//copy输出结果
}

void Des_string(unsigned char *in_data, unsigned char data_length, unsigned char *key, unsigned char key_lenth, unsigned char *out_data, unsigned char DES_MODE)
{
	unsigned char data_block,i,tmp[8];
	data_block = data_length / 8;
	for(i=0;i<data_block;i++)
	{
		 if(DES_MODE == DES_ENCRYPT)
		 {
		 	des( in_data+i*8, out_data+i*8, key );
		 }
		 else if (DES_MODE == DES_DECRYPT)
		 {
		    undes( in_data+i*8, out_data+i*8, key );
		 }
		 else if (DES_MODE == TDES_ENCRYPT)
		 {
		 	des( in_data+i*8, tmp, key );
			undes( tmp, tmp, key+8 );
			if(key_lenth==24)
			{
			  des( tmp, out_data+i*8, key+16  );
			}
			else
			{
			  des( tmp, out_data+i*8, key  );
			}
			
		 }
		 else if (DES_MODE == TDES_DECRYPT)
		 {
		 	if(key_lenth==24)
			{
			  undes( in_data+i*8, tmp, key+16  );
			}
			else
			{
			  undes( in_data+i*8, tmp, key  );
			}
			des( tmp, tmp, key+8 );
			undes( tmp, out_data+i*8, key  );
		 }
		 
	}  
}



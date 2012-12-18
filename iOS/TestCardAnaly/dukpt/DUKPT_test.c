#include "dukpt_des_lib.h"
#include <string.h>

u8 code DES_KEY[16] = {0x6A,0xC2,0x92,0xFA,0xA1,0x31,0x5B,0x4D,0x85,0x8A,0xB3,0xA3,0xD7,0xD5,0x93,0x3A};
u8 code TEST_KSN[10] = {0xFF,0xFF,0x98,0x76,0x54,0x32,0x10,0xE0,0x00,0x00};

void main()
{
	u8 xdata Source[8], Deskey[16], KSN[10];
	u8 xdata TestDatIN[8];
	u8 xdata TestDatOUT[8];

	u32 count;
	memset(Source,0,8);
	memcpy(Deskey,DES_KEY,8);
	memcpy(KSN,TEST_KSN,10);
	memcpy(TestDatIN, "\x11\x22\x33\x44\x55\x66\x77\x88",8);
//	count = 0xff800;

	count = 1;
	while(1)
	{
		pan_count(&count);/*判断计数器的值并调整成合法的计数器的值*/
		get_now_key(Deskey, DES_KEY, &count, KSN );/*根据初始密钥DES_KEY，KSN，当前的计数值count得到当前的密钥Deskey*/
		Des_string(TestDatIN, 8, Deskey, 16, TestDatOUT, TDES_ENCRYPT);
		Des_string(TestDatOUT, 8, Deskey, 16, TestDatIN, TDES_DECRYPT);
		count++;
	}
	while(1);



}

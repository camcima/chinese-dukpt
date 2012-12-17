<?php

class DES
{	
    protected static $IP = array(
        58,50,42,34,26,18,10,2,
        60,52,44,36,28,20,12,4,
        62,54,46,38,30,22,14,6,
        64,56,48,40,32,24,16,8,
        57,49,41,33,25,17,9,1,
        59,51,43,35,27,19,11,3,
        61,53,45,37,29,21,13,5,
        63,55,47,39,31,23,15,7
    );


    protected static $IPinv = array(
        40,8,48,16,56,24,64,32,
        39,7,47,15,55,23,63,31,
        38,6,46,14,54,22,62,30,
        37,5,45,13,53,21,61,29,
        36,4,44,12,52,20,60,28,
        35,3,43,11,51,19,59,27,
        34,2,42,10,50,18,58,26,
        33,1,41,9,49,17,57,25
    );


    protected static $E = array(
        32,1,2,3,4,5,
        4,5,6,7,8,9,
        8,9,10,11,12,13,
        12,13,14,15,16,17,
        16,17,18,19,20,21,
        20,21,22,23,24,25,
        24,25,26,27,28,29,
        28,29,30,31,32,1
    );

    protected static $S1 = array(
        14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7,
        0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8,
        4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0,
        15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13
    );

    protected static $S2 = array(
        15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10,
        3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5,
        0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15,
        13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9
    );

    protected static $S3 = array(
        10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8,
        13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1,
        13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7,
        1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12
    );

    protected static $S4 = array(
        7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15,
        13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9,
        10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4,
        3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14
    );

    protected static $S5 = array(
        2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9,
        14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6,
        4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14,
        11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3
    );

    protected static $S6 = array(
        12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11,
        10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8,
        9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6,
        4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13
    );

    protected static $S7 = array(
        4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1,
        13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6,
        1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2,
        6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12
    );

    protected static $S8 = array(
        13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7,
        1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2,
        7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8,
        2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11
    );

    protected static $PP = array(
        16,7,20,21,
        29,12,28,17,
        1,15,23,26,
        5,18,31,10,
        2,8,24,14,
        32,27,3,9,
        19,13,30,6,
        22,11,4,25
    );

    protected static $PC1 = array(
        57,49,41,33,25,17,9,
        1,58,50,42,34,26,18,
        10,2,59,51,43,35,27,
        19,11,3,60,52,44,36,
        63,55,47,39,31,23,15,
        7,62,54,46,38,30,22,
        14,6,61,53,45,37,29,
        21,13,5,28,20,12,4
    );

    protected static $PC2 = array(
        14,17,11,24,1,5,
        3,28,15,6,21,10,
        23,19,12,4,26,8,
        16,7,27,20,13,2,
        41,52,31,37,47,55,
        30,40,51,45,33,48,
        44,49,39,56,34,53,
        46,42,50,36,29,32
    );

    protected static $LLS = array(0,1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1);

    protected static $Ki = array();

protected static function Init_bit_tab($dest, $source, $n, $offset)
{

	for($i=0;$i<$n;$i++) 
	{
		$masque=0x80;
		for($j=0;$j<8;$j++) 
		{
			$dest[8* $i + $j + $offset] = (($source[$i] & $masque) >>(7 - $j));
			$masque >>= 1;
		}
	}
}

/****************************************************************************
 Bin_to_Hex()   :
	range la valeur hexa sur 8 octets d'un nombre binaire de 64 bits
*****************************************************************************/
static void Bin_to_Hex(byte[] vect,byte[] source, byte offset)
{
	byte i,j,masque;

	//memset(vect,0,8);
	for(i=0; i <8; i++) {
		masque=7;
		for(j=0; j<8; j++) {
			vect[i] += (puissance(masque)) * source[i*8+j +offset];
			--masque;
		}
	}
}

static byte puissance(byte puissance)
{
 	byte res = 1, i;

	for(i=1; i <=puissance; i++) 
	res *=2;

	return(res);
}


static void Vect_Permutation(byte[] vect,byte n_vect,byte[] regle,byte n_regle, byte offset)
{
	byte[] buff =new byte[65];
	byte i;

	for(i =0; i <n_vect; i ++)
		buff[i] =vect[i +offset];
	for(i=0;i<n_regle;i++) 
		vect[i +offset] =buff[regle[i]-1];
}


static void S_Box_Calc(byte[] vect, byte offset)
{
  byte[][] S_Box ={S1,S2,S3,S4,S5,S6,S7,S8};
  byte lig,col,i;

  for(i=0;i<8;i++) 
  {
		col =(byte)(8*vect[1+6*i +offset] +4*vect[2+6*i +offset] + 2*vect[3+6*i +offset] + vect[4+6*i +offset]);
		lig =(byte)(2*vect[6*i +offset] + vect[5+6*i +offset]);
		Init_4bit_tab(vect, S_Box[i][col+lig*16], (byte)(4 *i +offset));
  }
}


static void Init_4bit_tab(byte[] dest,byte source, byte offset)
{
	byte masque,i;

	masque=0x08;
	for(i=0; i<4; i++) 
	{
		dest[i +offset] =(byte)((source & masque)>>(3-i));
		masque >>= 1;
	}
}


static void Xor(byte[] vect1,byte[] vect2,byte num_byte, byte offset_vect1, byte offset_vect2)
{
	byte i;

	for(i=0; i<num_byte; i++) 
		vect1[i +offset_vect1] ^= vect2[i +offset_vect2];
}


static void Left_shifts(byte[] vect,byte n, byte offset)
{
	byte i,tmp_vect28,tmp_vect0;

	for(i=0; i<n; i++) 
	{
		tmp_vect0 = vect[0 +offset];
		tmp_vect28 = vect[28 +offset];
		for(byte j =0; j <27; j ++)
		{
			vect[j +offset] =vect[j +1 +offset];
			vect[j +28 +offset] =vect[j +29 +offset];	
		}
		vect[27 +offset] = tmp_vect0;
		vect[55 +offset] = tmp_vect28;
	}
}

static void Calcul_sous_cles(byte[] DESKEY)
{
	byte i;
	byte[] Kb =new byte[65];
	byte[] inter_key =new byte[57];

	Init_bit_tab(Kb, DESKEY, (byte)8, (byte)1);                           
	Vect_Permutation(Kb, (byte)64, PC1, (byte)56, (byte)1);

	for(i=1; i<=16; i++) 
	{
		Left_shifts(Kb, LLS[i], (byte)1);			
		for(byte j =1; j <57; j ++)
			inter_key[j] =Kb[j];
		Vect_Permutation(inter_key, (byte)56, PC2, (byte)48, (byte)1);
		for(byte k =1; k <49; k ++)
			Ki[i][k] =inter_key[k];
	}
}


static void function_des(byte cryp_decrypt,byte[] DES_DATA,byte[] DESKEY,byte[] DES_RESULT)
{
	byte[] right32_bit =new byte[32];
	byte i;
	byte[] Data_B =new byte[81];	
	
	Init_bit_tab(Data_B, DES_DATA, (byte)8, (byte)1);
	Vect_Permutation(Data_B, (byte)64, IP,(byte) 64, (byte)1);
	
	Calcul_sous_cles(DESKEY);
	
	/******************* boucle principale de 15 iterations */
	for(i=1; i<=15; i++) 
	{	 		
		for(byte j =0; j <32; j ++)
		right32_bit[j] =Data_B[33 +j];
		Vect_Permutation(Data_B, (byte)32, E, (byte)48, (byte)33);
		
		switch(cryp_decrypt) {
		case 0:
			Xor(Data_B, Ki[i],(byte)48, (byte)33, (byte)(1));
			break;
		
		case 1:
			Xor(Data_B, Ki[17 -i],(byte)48,(byte) 33, (byte)(1));
			break;
		}
		
		S_Box_Calc(Data_B, (byte)33);
		Vect_Permutation(Data_B,(byte)32,PP,(byte)32, (byte)33);
		Xor(Data_B, Data_B,(byte)32, (byte)33, (byte)1);
		for(byte k =0; k <32; k ++)
		Data_B[k +1] =right32_bit[k];
	}
	
	/******************************** 16 iteration *****/
	
	for(byte l =0; l <32; l ++)
	right32_bit[l] =Data_B[33 +l];
	Vect_Permutation(Data_B,(byte)32,E,(byte)48, (byte)33);
	
	if(cryp_decrypt==0)
		Xor(Data_B, Ki[16],(byte)48, (byte)33, (byte)(1));
	else
		Xor(Data_B, Ki[1],(byte)48, (byte)33, (byte)(1));
	
	S_Box_Calc(Data_B, (byte)33);
	Vect_Permutation(Data_B,(byte)32,PP,(byte)32, (byte)33);
	Xor(Data_B, Data_B,(byte)32, (byte)1, (byte)33);
	for(byte j =0; j <32; j ++)
		Data_B[33 +j] =right32_bit[j];
	Vect_Permutation(Data_B,(byte)64,IPinv,(byte)64, (byte)1);
	
	Bin_to_Hex(DES_RESULT, Data_B, (byte)1);

}
/*
void MAC(byte msg[], int length, byte key[], byte result[])
{
	int block;
	
	block=0;
	//memset(result,0,8);
	
	while(length >block)
	{
		if((length-block) <=8)
		{
			Xor(result,&msg[block],(byte)(length-block));
			function_des(0, result, key, result);
			return;
		}
		Xor(result,&msg[block],8);
		function_des(0, result, key, result);
		block += 8;
	}
}*/

public static void main(String[] args)
{
	byte[] DESKey ="abcdefgh".getBytes();
	byte[] Data ="01234567890".getBytes();
	byte[] Res =new byte[8];

	function_des((byte)0, Data, DESKey, Res);
	//System.out.println(Res);
	try
	{
		FileOutputStream outf =new FileOutputStream("c:\\aaa.txt");
		outf.write(Res);
		outf.close();		
	}
	catch(Exception e)
	{
		System.out.println("error: " +e.toString());
	}
}
} ...
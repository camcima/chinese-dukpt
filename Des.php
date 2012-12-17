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

protected static function Init_bit_tab(&$dest, $source, $n, $offset)
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
protected static function Bin_to_Hex(&$vect,$source, $offset)
{
	//memset(vect,0,8);
	for($i=0; $i <8; $i++) {
		$masque=7;
		for($j=0; $j<8; $j++) {
			$vect[$i] += (self::puissance($masque)) * $source[$i * 8 + $j + $offset];
			--$masque;
		}
	}
}

protected static function puissance($puissance)
{
 	$res = 1;

	for($i=1; $i <= $puissance; $i++) 
	$res *= 2;

	return($res);
}


protected static function Vect_Permutation(&$vect,$n_vect,$regle,$n_regle, $offset)
{
	for($i =0; $i <$n_vect; $i++) {
		$buff[$i] =$vect[$i +$offset];
    }
	for($i=0;$i<$n_regle;$i++) {
		$vect[$i +$offset] =$buff[$regle[$i]-1];
    }
}


protected static function S_Box_Calc(&$vect, $offset)
{
  $S_Box = array($S1,$S2,$S3,$S4,$S5,$S6,$S7,$S8);

  for($i=0;$i<8;$i++) 
  {
		$col =(8*$vect[1+6*$i +$offset] +4*$vect[2+6*$i +$offset] + 2*$vect[3+6*$i +$offset] + $vect[4+6*$i +$offset]);
		$lig =(2*$vect[6*$i +$offset] + $vect[5+6*$i +$offset]);
		self::Init_4bit_tab($vect, $S_Box[$i][$col+$lig*16], (4 *$i +$offset));
  }
}


protected static function Init_4bit_tab(&$dest,$source, $offset)
{
	$masque=0x08;
	for($i=0; $i<4; $i++) 
	{
		$dest[$i +$offset] =(($source & $masque)>>(3-$i));
		$masque >>= 1;
	}
}


protected static function Xor(&$vect1,$vect2,$num_byte, $offset_vect1, $offset_vect2)
{
	for($i=0; $i<$num_byte; $i++) { 
		$vect1[$i +$offset_vect1] ^= $vect2[$i +$offset_vect2];
    }
}


protected static function Left_shifts(&$vect,$n, $offset)
{
	for($i=0; $i<$n; $i++) 
	{
		$tmp_vect0 = $vect[0 +$offset];
		$tmp_vect28 = $vect[28 +$offset];
		for($j =0; $j <27; $j++)
		{
			$vect[$j +$offset] =$vect[$j +1 +$offset];
			$vect[$j +28 +$offset] =$vect[$j +29 +$offset];	
		}
		$vect[27 +$offset] = $tmp_vect0;
		$vect[55 +$offset] = $tmp_vect28;
	}
}

protected static function Calcul_sous_cles($DESKEY)
{
	self::Init_bit_tab($Kb, $DESKEY, 8, 1);                           
	self::Vect_Permutation($Kb, 64, self::$PC1, 56, 1);

	for($i=1; $i<=16; $i++) 
	{
		self::Left_shifts($Kb, self::$LLS[$i], 1);			
		for($j =1; $j <57; $j++) {
			$inter_key[$j] =$Kb[$j];
        }
		self::Vect_Permutation($inter_key, 56, self::$PC2, 48, 1);
		for($k =1; $k <49; $k++) {
			self::$Ki[$i][$k] =$inter_key[$k];
        }
	}
}


public static function function_des($cryp_decrypt,$DES_DATA,$DESKEY,&$DES_RESULT)
{	
	self::Init_bit_tab($Data_B, $DES_DATA, 8, 1);
	self::Vect_Permutation($Data_B, 64, self::$IP,64, 1);
	
	self::Calcul_sous_cles($DESKEY);
	
	/******************* boucle principale de 15 iterations */
	for($i=1; $i<=15; $i++) 
	{	 		
		for($j =0; $j <32; $j++) {
            $right32_bit[$j] =$Data_B[33 +$j];
        }
		self::Vect_Permutation($Data_B, 32, self::$E, 48, 33);
		
		switch($cryp_decrypt) {
		case 0:
			self::Xor($Data_B, self::$Ki[$i],48, 33, 1);
			break;
		
		case 1:
			self::Xor($Data_B, self::$Ki[17 -$i],48,33, 1);
			break;
		}
		
		self::S_Box_Calc($Data_B, 33);
		self::Vect_Permutation($Data_B,32,self::$PP,32, 33);
		self::Xor($Data_B, $Data_B, 32, 33, 1);
		for($k =0; $k <32; $k++) {
            $Data_B[$k +1] =$right32_bit[$k];
        }
	}
	
	/******************************** 16 iteration *****/
	
	for($l =0; $l <32; $l ++) {
        $right32_bit[$l] =$Data_B[33 +$l];
    }
	self::Vect_Permutation($Data_B,32,self::$E,48, 33);
	
	if($cryp_decrypt==0) {
		self::Xor($Data_B, self::$Ki[16],48, 33, 1);
    } else {
		self::Xor($Data_B, self::$Ki[1],48, 33, 1);
    }
	self::S_Box_Calc($Data_B, 33);
	self::Vect_Permutation($Data_B,32,self::$PP,32,33);
	self::Xor($Data_B, $Data_B,32, 1, 33);
	for($j =0; $j <32; $j++) {
		$Data_B[33 +$j] =$right32_bit[$j];
    }
	self::Vect_Permutation($Data_B,64,self::$IPinv,64, 1);
	
	self::Bin_to_Hex($DES_RESULT, $Data_B, 1);

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

public static function main()
{
	$DESKey ="abcdefgh";
	$Data ="01234567890";

	self::function_des(0, $Data, $DESKey, $Res);
	var_dump($Res);
}
}
<?php

function get_now_key($now_key, $init_key, $count_num, $KSNdata) {
    $i = 0;
    $j = 0;
    
    $now_key = $init_key;
    $tmp_count = $count_num;
    
    for ($i = 0; $i < 21; $i++) {
        if ($tmp_count & 0x01) {
            $j++;
        }
        $tmp_count = $tmp_count >> 1;
    }
    $tmp_count = $count_num;
    
    $k = 0;
    $x = 0x100000;
    
    while ($j--) {
        for ($i = 0; $i < 21; $i++) {
            if ($tmp_count & 0x100000) {
                break;
            }
            $tmp_count <<= 1;
            $x >>= 1;
        }
        $k += $x;
        $tmp_count <<= 1;
        $x >>= 1;
        comb_KSN($KSNdata, $k);
        generate_key($now_key, $KSNdata[2]);
    }
}

function comb_KSN(&$tmp_KSN, &$count_num) {
    $tmp_KSN[7] &= 0xe0;
    $tmp_KSN[8] = 0;
    $tmp_KSN[9] = 0;
    $temp = ($count_num >> 16) & 0x1f;
    $tmp_KSN[7] += $temp;
    $temp = ($count_num >> 8) & 0xff;
    $tmp_KSN[8] += $temp;
    $temp = ($count_num) & 0xff;
    $tmp_KSN[9] += $temp;
}

function generate_key(&$now_key, &$tmpKSN) {
    $cr1 = substr($tmpKSN, 0, 8);
    xor_cl($cr2, $cr1, substr($now_key, 8, 8), 8);
    Des_string()
}

function xor_cl(&$result, &$source1, &$source2, $length) {
    $i = 0;
    while ($length--) {
        $result[$i] = $source1[$i] ^ $source2[$i];
        $i++;
    }
}
if(isXbox)
{
    //offsets
    SniperOffsets = 
    [
    // viewmodel_l96a1_idle_loop 0, 1, 2
    0xC576CD21, 0xC576D9E4, 0xC92310A8, 
    // viewmodel_l96a1_rechamber 3, 4, 5
    0xC576CD52, 0xC576DA13, 0xC9231D90, 
    // viewmodel_l96a1_reload 6, 7, 8
    0xC576CD6D, 0xC576DA2D, 0xC9233B88,
    // viewmodel_l96a1_reload_empty 9, 10, 11
    0xC576CD85, 0xC576DA44, 0xC9237E71,
    // viewmodel_l96a1_pullout 12, 13, 14
    0xC576CDA3, 0xC576DA61, 0xC923E2FE,
    // viewmodel_l96a1_first_raise 15, 16, 17
    0xC576CDBC, 0xC576DA79, 0xC924055A,
    // viewmodel_l96a1_putaway 18, 19, 20
    0xC576CDD9, 0xC576DA95, 0xC9242C48,
    // viewmodel_l96a1_extclip_reload 21, 22, 23
    0xC576E677, 0xC576EFE8, 0xC924E8BE,
    // viewmodel_l96a1_extclip_reload_empty 24, 25, 26
    0xC576E697, 0xC576F007, 0xC9252B25,
    
    // viewmodel_psg1_idle_loop 27, 28, 29
    0xC57704E5, 0xC5771134, 0xC93704FC,
    // viewmodel_psg1_reload 30, 31, 32
    0xC5770514, 0xC5771161, 0xC937148F,
    // viewmodel_psg1_reload_empty 33, 34, 35
    0xC577052B, 0xC5771177, 0xC937537F,
    // viewmodel_psg1_pullout 36, 37, 38
    0xC5770548, 0xC5771193, 0xC937B51B,
    // viewmodel_psg1_first_raise 39, 40, 41
    0xC5770560, 0xC57711AA, 0xC937E465,
    // viewmodel_psg1_putaway 42, 43, 44
    0xC577057C, 0xC57711C5, 0xC93809A7,
    // viewmodel_psg1_extclip_reload 45, 46, 47
    0xC57725ED, 0xC5772F64, 0xC938AF2C,
    // viewmodel_psg1_extclip_reload_empty 48, 49, 50
    0xC577260C, 0xC5772F82, 0xC938EBBB,
    
    // viewmodel_dragunov_idle 51, 52, 53
    0xC576928D, 0xC576A088, 0xC913AFE8,
    // viewmodel_dragunov_reload 54, 55, 56
    0xC57692BF, 0xC576A0B8, 0xC913BDD5,
    // viewmodel_dragunov_reload_empty 57, 58, 59
    0xC57692DA, 0xC576A0D2, 0xC9140770,
    // viewmodel_dragunov_pullout 60, 61, 62
    0xC57692FB, 0xC576A0F2, 0xC9145E36,
    // viewmodel_dragunov_first_raise 63, 64, 65
    0xC5769317, 0xC576A10D, 0xC9148706,
    // viewmodel_dragunov_putaway 66, 67, 68
    0xC5769337, 0xC576A12C, 0xC914B347,
    // viewmodel_dragunov_extclip_reload 69, 70, 71
    0xC576ADF5, 0xC576B770, 0xC9154818,
    // viewmodel_dragunov_extclip_reload_empty 72, 73, 74
    0xC576AE18, 0xC576B792, 0xC9159194,
    
    // viewmodel_wa2000_idle_loop 75, 76, 77
    0xC577698D, 0xC5777640, 0xC9459034,
    // viewmodel_wa2000_reload 78, 79, 80
    0xC57769C0, 0xC5777671, 0xC9459F6F,
    // viewmodel_wa2000_reload_empty 81, 82, 83
    0xC57769D9, 0xC5777689, 0xC945E0EE,
    // viewmodel_wa2000_pullout 84, 85, 86
    0xC57769F8, 0xC57776A7, 0xC946305F,
    // viewmodel_wa2000_first_raise 87, 88, 89
    0xC5776A12, 0xC57776C0, 0xC9465C6E,
    // viewmodel_wa2000_putaway 90, 91, 92, 93
    0xC5776A30, 0xC57776DD, 0xC946817C, 0xC2C1E664,
    // viewmodel_wa2000_extclip_reload 94, 95, 96
    0xC5778305, 0xC5778C78, 0xC9472C48,
    // viewmodel_wa2000_extclip_reload_empty 97, 98, 99
    0xC5778326, 0xC5778C98, 0xC9476DBE
    ];
    
}
else(ispc)
{
    
}
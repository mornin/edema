##generates random list of ID numbers, based on list that is fed into $ds_idn

$ds_idn = "final.list";
@alltext = '';
srand(30);#seed13 1 42 4 8 16 24
open (FILE, "$ds_idn") || die "Can't open $ds_idn $!";
while ($line = <FILE>) {
    chomp($line);
    push(@alltext, "$line,");
}

$range = scalar(@alltext);
#print $range,"\n" ;
$int = 0;
while ($int <= 99) {
    my $randn = int(rand($range));
    push(@ptlist, @alltext[$randn]);
    $int +=1;
}
#print scalar(@ptlist),"\n";
#print @ptlist;
#%hash = map {$_ => 1} @ptlist

@ptlist2 = ('3715', '20445', '14678', '35238', '34714', '6962', '4788', '14073', '1147', '13087', '30423', '1947', '7513', '19155', '11855', '11603', '32710', '19378', '27832', '1495', '15753', '16575', '29754', '30516', '14186', '32625', '298', '11532', '30441', '25742', '18170', '590', '3776', '19971', '14454', '26682', '26686', '15100', '12988', '27532', '17986', '23003', '24375', '12014', '24376', '8786', '11443', '26394', '1019', '16387', '6059', '11449', '29526', '1518', '8044', '35059', '34114', '10139', '7866', '4350', '13119', '4620', '25972', '28711', '35907', '28249', '15033', '6500', '15034', '1844', '6077', '21058', '12123', '31075', '29623', '10411', '11345', '24089', '26532', '23717', '26432', '10792', '16925', '3450', '24698', '19057', '22300', '28920', '25908', '32993', '27870', '15865', '35479', '6802', '19624', '35673', '34974', '32582', '28869', '32584', '27490', '21534', '10849', '4077', '31648', '29241', '3966', '19758', '13052', '8834', '27130', '32273', '18924', '552', '13509', '14244', '6895', '15786', '21056', '13502', '12193', '12194', '35083', '12945', '24237', '1052', '26195', '1', '19981', '30529', '16589', '19239', '30159', '1699', '9119', '698', '21978', '29582', '13943', '9519', '32122', '12286', '8241', '14568', '28366', '6916', '17261', '1579', '1474', '23021', '11719', '31239', '31607', '8426', '20638', '17764', '35466', '3435', '12060', '7452', '28622', '26623', '14227', '12406', '24795', '1816', '9560', '34153', '1374', '7755', '9680', '11839', '22579', '19466', '10885', '26405', '21238', '31996', '32941', '7257', '13153', '35333', '32314', '709', '25053', '25722', '35448', '22018', '22156', '7036', '6144', '14614', '29606', '32792', '16993', '5317', '9389', '20053', '417', '1652', '16144', '1655', '15520', '25532', '16892', '27170', '16897', '18181', '17233', '13531', '22707', '14443', '21052', '24564', '33864', '22494', '29533', '26149', '12004', '2571', '26229', '18746', '26384', '1006', '2377', '24933', '29025', '21945', '20212', '21948', '4186', '13697', '15003', '17284', '21604', '7859', '31316', '4942', '25813', '13443', '21282', '21931', '26130', '10621', '33131', '22633', '27993', '22207', '17050', '11231', '23721', '3282', '13210', '13212', '12470', '15', '28899', '28777', '10498', '28779', '22331', '10276', '26414', '29896', '32210', '16053', '4763', '23831', '3673', '14156', '22297', '11480', '13897', '13065', '10088', '21541', '11244', '10086', '8926', '11870', '14459', '35990', '29640', '8929', '14480', '25001', '15173', '19884', '5253', '27814', '20265', '22067', '22742', '16612', '26814', '26810', '28457', '29578', '1042', '20066', '22597', '28034', '12689', '5440', '29576', '16295', '10945', '5938', '6961', '7815', '8629', '30057', '30056', '9622', '24993', '25504', '34099', '31596', '16686', '29696', '34923', '16682', '4863', '24848', '7190', '8656', '23603', '27776', '17155', '34619', '5758', '34488', '25186', '15191', '6566', '25189', '33126', '1822', '17081', '26006', '2414', '2063', '25955', '3824', '32490', '33499', '311', '1920', '34633', '8325', '15525', '22641', '26419', '9717', '20113', '24672', '13990', '4121', '22998', '35321', '20593', '35281', '16124', '2751', '32774', '23414', '14609', '22146', '10227', '31979', '24035', '23866', '27395', '6771', '23862', '20189', '14937', '16157', '16330', '18721', '18198', '21128', '21048', '7653', '25786', '24214', '12032', '17965', '7150', '33576', '16186', '17339', '11420', '503', '6687', '21956', '12862', '20894', '7295', '8065', '8109', '7929', '16345', '18121', '7486', '6527', '32102', '36097', '26775', '14421', '11062', '24502', '2890', '29162', '29648', '34452', '1102', '24811', '31253', '30095', '6057', '32638', '2104', '23343', '31326', '10163', '31448', '13748', '27977', '11328', '8403', '6554', '15067', '22525', '6550', '5723', '3434', '873', '27743', '35075', '24438', '35777', '466', '892', '18894', '20389', '33625', '21179', '14086', '26345', '20470', '23457', '20475', '8087', '18945', '24720', '11847', '19002', '19439', '16607', '22772', '16767', '1787', '29190', '15765', '32337', '20070', '20371', '20377', '29299', '19315', '18227', '27160', '30135', '1674', '286', '18166', '30988', '8637', '4334', '1150', '29998', '24546', '24549', '25515', '6011', '8678', '17857', '2993', '19895', '24088', '2392', '11471', '11770', '34318', '1413', '24856', '20613', '20610', '17021', '8681', '27708', '7879', '34534', '10074', '35917', '25964', '15180', '6261', '27662', '6516', '20855', '28339', '9324', '1399', '28334', '25806', '10134', '2607', '20924', '22557', '22227', '31044', '27981', '23254', '17738', '5120', '24853', '21692', '5085', '35861', '23382', '9501', '7428', '2929', '22031', '7942', '10320', '6168', '20407', '12634', '29188', '25729', '13679', '4480', '1980', '26337', '2688', '25635', '13042', '15801', '15800', '16734', '21888', '2816', '18730', '16733', '30317', '21132', '29480', '18738', '29898', '32342', '14257', '18285', '7646', '25028', '20308', '7649', '30790', '7082', '23920', '6112', '33561', '6461', '29828', '34214', '11434', '7281', '21789', '7936', '34064', '32116', '28680', '16988', '35895', '16453', '4923', '25844', '17190', '3100', '21787', '11642', '2501', '20817', '10179', '17774', '17772', '22349', '9399', '14007', '17174', '15276', '5040', '8998', '1802', '3785', '5634', '3422', '25836', '12161', '12200');

## Goes through the $ds_fname file line by line to pull out the lines that match##the sample header, compares these lines with the designated patients via the r##andomized list, and then pulls the summaries following the lines that match
#$var = 1;
$alltext = "";
$ds_fname = "MIMIC2V26_DS.txt";
open (FILE, "$ds_fname") || die "Can't open $ds_fname $!";
while ($line = <FILE>){
	chomp($line);
	if ($line =~/(\d+)_:-:_(\d+)_:-:_/){
	    $hadmid = $1;
	    if (grep $_ == $hadmid, @ptlist2 ){
		$alltext = $line;
		$inexam = 1;
#		print "\n",$var,"\n";
#		$var +=1;
	    }
	    else{
		$inexam = 0;
		print $alltext;
		$alltext = "";
	    }
	}
	else{
	if ($inexam){
	    $alltext.= $line."\n";}
	}
}



   


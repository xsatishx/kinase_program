print "Obaining the secondary structure of the octapeptide... <BR>\n";
open(SASA,"mspec_resultsasa.csv");
@datasasa=<SASA>;
open (OUTSA,">mspec_resultsasa_ss.csv");
foreach $datasasa(@datasasa)
{
	@colsasa = split(/\,/,$datasasa);
	$pdbsasa=$colsasa[2];
	$pdbsasa=uc($pdbsasa);
	$sequencesa=$colsasa[1];

system ("./stride -o $pdbsasa.pdb > $pdbsasa.stride");
open(INSTRIDE,"$pdbsasa.stride");

@stridereport = <INSTRIDE>;
   
    @seqss = grep(/^SEQ /, @stridereport);
    @strss = grep(/^STR /, @stridereport);

	   for (@seqss) { $_ = substr($_, 10, 50) }
	   for (@strss) { $_ = substr($_, 10, 50) }

    $seqss = join('', @seqss);
    $strss = join('', @strss);
    $seqss =~ s/(\s+)$//;
    $lengthss = length($1);
    $strss =~ s/\s{$lengthss}$//;
    
	$finder=index($seqss,$sequencesa);
	$residuesa=substr($seqss,$finder,8);
	$ss=substr($strss,$finder,8);
        $ss =~s/G/H/g;
	$ss =~s/E/B/g;
	$ss =~s/b/B/g;
	$ss =~s/ /T/g;
print OUTSA "$colsasa[0],$colsasa[1],$colsasa[2],$colsasa[3],$colsasa[4],$ss,\n";

}

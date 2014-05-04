print "\nCreating .out files using POPS ...<BR>\n";
open(INNINE,"mspec6.csv");
@listn=<INNINE>;
@listn = grep(/\S/, @listn);
	foreach $datanine(@listn)
	{
	 @colsnine = split(/\,/,$datanine);
	 $id="$colsnine[2].pdb";
	 $out="$colsnine[2].out";
    print "running pops for $id\n";
	 # system("pops --pdb $id --coarse --residueOut --popsOut $out");
	 system("/usr/local/net/doc/netserv/actrec/psp_tool/KINASE_BIGPROGRAM/POPSc-1.0.0/pops --pdb $id --coarse --residueOut --popsOut $out");
	}
print "\n finished .out files using POPS\n";

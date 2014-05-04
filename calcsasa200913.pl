print "\nCreating .out files using POPS ...<BR>\n";
open(INNINE,"mspec6.csv");
@listn=<INNINE>;
	foreach $datanine(@listn)
	{
	 @colsnine = split(/\,/,$datanine);
	 $id="$colsnine[2].pdb";
	 $out="$colsnine[2].out";
	 system("pops --pdb $id --coarse --residueOut --popsOut $out");
	 system("./pops --pdb $id --coarse --residueOut --popsOut $out");
	 
	}


open(INSS,"mspec_resultsasa_all.csv");
open(DISORDERED,">mspec_resultsasa_DO.csv");
open(ORDERED,">mspec_resultsasa.csv");
@sasafile=<INSS>;
foreach $sasafile(@sasafile)
{
@sasacols=split(/\,/,$sasafile);
$sasarow=$sasacols[4];

if ($sasarow eq "N")
	{
	 print DISORDERED "$sasacols[0],$sasacols[1],$sasacols[2],$sasacols[3],$sasacols[4],\n";
	}
		
		else
			{
			 print ORDERED "$sasacols[0],$sasacols[1],$sasacols[2],$sasacols[3],$sasacols[4],\n";
			
			}			
}
print "Separating Ordered and Disordered files... <BR>\n";

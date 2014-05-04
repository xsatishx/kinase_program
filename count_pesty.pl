my $cntP = 0;
my $cntE = 0;
my $cntS = 0;
my $cntT = 0;
my $cntY = 0;
my $cntZ = 0;
open(OUT, ">pesty");

open (FILE,"sscount");
my @filebuf = <FILE>;

foreach $lines (@filebuf)
	{
	 @cols=split(/\,/,$lines);
	 $pesty = $cols[1];
	 $ret_val=counter($pesty);
	}

###################################sub-routine############################################

sub counter
{	
	my ($var) = @_[0];	
	@var = split(//,$var);	
	foreach $var(@var)
	{
			if ($var =~ m/P/gs)
			{
			$cntP++;
			}	
				elsif ($var =~ m/E/gs)
				{
				$cntE++
				}
					elsif ($var =~ m/S/gs)
					{
					$cntS++
					}
						elsif ($var =~ m/T/gs)
						{
				 		$cntT++
						}
							elsif ($var =~ m/Y/gs)
							{
				 			$cntY++
							}
							
								elsif ($var =~ m/X/gs)
							{
				 			$cntZ++
							}
	}


	$pesty=$cntP+$cntE+$cntS+$cntT+$cntY+$cntZ;
	$pestyscore=$pesty*5;
	print OUT "$cols[0],$cols[1],$cols[2],$cols[3],$cols[4],$cols[5],$cols[6],$cols[7],$cols[8],$pestyscore,\n";

	$cntP = (0);
	$cntE = (0);
	$cntS = (0);
	$cntT = (0);
	$cntY= (0);
	$cntZ= (0);
	return $var	
}

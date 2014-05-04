#### This program is used to assign score to SASA values and secondary structures ####
#### sasa value is multiplied by 100 to get whole numbers instead of decimals ####
#### Secondary structure is divided into turns,helix and sheets in each octapeptide and counted ####
#### Score for secondary structure , Turns-12,Helix-6,Sheets-3 ####

use Number::Range;
my $range0  =  Number::Range->new("0..10");  	#1     1  
my $range11 = Number::Range->new("11..20");  	#10    5 
my $range21 = Number::Range->new("21..24");  	#15    10
my $range25 = Number::Range->new("25..29");  	#30    35
my $range30 = Number::Range->new("30..40");  	#40    55  
my $range41 = Number::Range->new("41..50");  	#50    60
my $range51 = Number::Range->new("51..65");  	#60    65	
my $range66 = Number::Range->new("66..75"); 	#70    75	
my $range76 = Number::Range->new("76..90");  	#80    85
my $range91 = Number::Range->new("91..99"); 	#90    95
my $range100 = Number::Range->new("100..120");  #100   100
my $sasascore=0;
my $ssscore=0;


open(DATAF,"pesty");
@dataf=<DATAF>;

foreach $dataf(@dataf)
	{
	@colsf=split(/\,/,$dataf);
	$sasadecimal=$colsf[3];
	$sasadecimal=substr($sasadecimal,0,5);
	$turns=$colsf[5];
	$helices=$colsf[6];
	$sheets=$colsf[7];
	
	
		$sasa=$sasadecimal*100;
		if ($range0->inrange("$sasa"))
			{
			 $sasascore=1;
			 }
			elsif ($range11->inrange("$sasa"))
			   {
			    $sasascore=5;
			   }	
			    elsif ($range21->inrange("$sasa"))
			   	{
			    	$sasascore=10;
			   	}	
				  elsif ($range25->inrange("$sasa"))
			   	  {
			    	  $sasascore=35;
			   	  }	
					elsif ($range30->inrange("$sasa"))
			   		{
			    		$sasascore=55;
			   		}
						elsif ($range41->inrange("$sasa"))
			   			{
			    			$sasascore=60;
			   			}		
					
					elsif ($range51->inrange("$sasa"))
			   		{
			    		$sasascore=65;
			   		}		
			
						elsif ($range66->inrange("$sasa"))
			   			{
			    			$sasascore=75;
			   			}

						elsif ($range76->inrange("$sasa"))
			   			{
			    			$sasascore=85;
			   			}
						    elsif ($range91->inrange("$sasa"))
			   			    {
			    			    $sasascore=95;
			   			    }	
							elsif ($range100->inrange("$sasa"))
			   				{
			    				$sasascore=100;
			 				}	

	
 $turnscore=11.25;   #11.25
 $helixscore=6.25;     #9.375
 $sheetscore=3.75;     #6.25

	$T=$turns*$turnscore;
	$H=$helices*$helixscore;
	$B=$sheets*$sheetscore;

$ssscore = $T+$H+$B;
$totalscore=($ssscore+$sasascore);
$finalscore=($totalscore/167)*100;

if ($sasa <20)
{
$finalscore=($finalscore/1.5);
}

$roundedsasa = sprintf("%.2f", $colsf[4]);
$finalscore  = sprintf("%.2f", $finalscore);
print "$colsf[0],$colsf[3],$colsf[2],$colsf[1],$roundedsasa,$colsf[5],\n";

}

           

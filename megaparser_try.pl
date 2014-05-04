########################################Part 8##########################################

print "Preparing the pdb files ... <BR>\n";
open(INSIX,"mspec6.csv");
@datasix=<INSIX>;
print @datasix;
print "array datasix finished";
foreach $datasix(@datasix)
	{
	 @colsix = split(/\,/,$datasix);
	 $pdbidsix="$colsix[2].pdb";
      print "part-8 start pdb ";
   	print "$pdbidsix\n";

	    open (IN, "$pdbidsix");
	    @atomr=<IN>;
	    open (OUT,">$pdbidsix");
	    foreach $atomr(@atomr)
		
		{
	 	$residue = substr($atomr,17,3);
	 	if (($residue ne " DA") && ($residue ne " DC") && ($residue ne " DT") && ($residue ne " DG") && ($residue ne
" DU") && ($residue ne "UNK"))
			
			{ 
			print OUT $atomr;
			}	
		}print "part-8 finish pdb "; print "$pdbidsix\n";
	}

########################################Part 9##########################################


# The original perl code is located in the file calcsasa.pl . This part just calls the program.
system ("perl calcsasa.pl");
#10 lines of code

###################################part 10 ##############################################

#!/usr/bin/perl
# HITS.dat --->elastase-2,LGPVTPEI,1gen
#A0FGR8,SDISLPIA,2DMG,   			#Format of the inputfile for this program. 
#O00139,SPETPPPP,2GRY,				#Will work only with this format.
print "part-10 started\n";
$outputfile= 'mspec_resultsasa_all.csv';
open(REPSASA, ">$outputfile");

open(HIT,"mspec6.csv");
@entry=<HIT>;
foreach my $entry (@entry) 
{
	my @hitman  = split ('\,',$entry);
	chomp $hitman[2];
     	my @sasa = pops_out_reader ($hitman[2]);			
	my $c = '0';        #stores the length of the array sasa
	my $seq;

		foreach my $sasa(@sasa)
		{
		$seq .= $sasa[$c][1];
		$c++;
		}
 
	my $fasta =  iub3to1($seq);
	my $sasasubstrate = 0;
	my $tab	 =  0;
	my $next = -1;      
	chomp $hitman[1];
	my @troubleseeker; 		
	do{                       
	     my $position = index($fasta,$hitman[1],$next);
	     $tab = $position +1;

		if ( ($next == -1)& ($tab == 0))
			{
			print REPSASA "$hitman[0],$hitman[1],$hitman[2],$hitman[3],N,\n";

			}
		elsif ($tab != 0)	
			{
	     		

			  print REPSASA "$hitman[0],$hitman[1],$hitman[2],$hitman[3]";

			my $rsasasubstrate = 0;
			my @rsasa;
			my $i;
			print REPSASA ",";
			for ($i =0; $i <8; $i++)     
			 {
			  
			  my $k = $i-1;  
			  my $j = $i+1;
				if (($tab+$k+1)>$c)
				   { 
					print REPSASA "EDGE,";
					last;
			         }
				else
				  {	
			
				  $sasa[$tab+$k][2] =~ s/^\s*//;
			  	  $hitman[$j] = $sasa[$tab+$k][2];
			  	  $sasasubstrate += $sasa[$tab+$k][2];
			  	
		
my %tripep = (

'ALA'	=>113,			
'VAL'	=>160,	
'LEU'	=>180,	
'ILE'	=>182,	
'PRO'	=>143,	
'TRP'	=>259,	
'PHE'	=>218,	
'MET'	=>204,
'GLY'	=>85,	 
'SER'	=>122,	
'THR'	=>146,	
'TYR'	=>229,	
'CYS'	=>140,	
'ASN'	=>158,	
'GLN'	=>189,	
'LYS'	=>211,
'ARG'	=>241,	
'HIS'	=>194,	
'ASP'	=>151,
'GLU'	=>183,
);
			     	  $sasa[$tab+$k][1] =~ s/\s*$//g;
				  $sasa[$tab+$k][1] =~ s/^\t//g; 
				  $rsasa[$i] = $sasa[$tab+$k][2]	/ ($tripep{$sasa[$tab+$k][1]});
				  $hitman[$j] = $rsasa[$i]; 	
				  $rsasasubstrate += $rsasa[$i];
				}			 
			  	
			}
		
			$rsasasubstrate = $rsasasubstrate/($i);
			print REPSASA "$rsasasubstrate,\n";

		}	
	$next = $tab;
	}while ($next != 0)
}
#########################################################################################
sub iub3to1_A {

    my($input) = @_;
    
    my %three2one = (
      'ALA' => 'A',
      'VAL' => 'V',
      'LEU' => 'L',
      'ILE' => 'I',
      'PRO' => 'P',
      'TRP' => 'W',
      'PHE' => 'F',
      'MET' => 'M',
      'GLY' => 'G',
      'SER' => 'S',
      'THR' => 'T',
      'TYR' => 'Y',
      'CYS' => 'C',
      'ASN' => 'N',
      'GLN' => 'Q',
      'LYS' => 'K',
      'ARG' => 'R',
      'HIS' => 'H',
      'ASP' => 'D',
      'GLU' => 'E',
    );


    $input =~ s/\n/ /g;
    $input = uc ($input); 	
    my $seq = '';
    
 
    my @code3 = split(' ', $input);

    foreach my $code (@code3) {
       
        if(not defined $three2one{$code}) {
            $seq = 'X';                       
	       next;
        }
        $seq .= $three2one{$code};
    }
    return $seq;
}

########################################################################################
sub pops_out_reader
{

my @stupid = @_;

use strict;
use warnings;
use BeginPerlBioinfo;

my $input = join('',@stupid);
$input=uc($input);
$input .= '.out';

my @file = get_file_data($input);

		for (my $i=0; $i<4; $i++)
		    {
		    shift @file;
		    }

    for (my $i=0; $i<7; $i++)
	{
	pop @file;
	}

my $count = '0';
my @final;

    foreach my $filerecord(@file)
	{
	$final[$count][0] = substr($file[$count], 0, 8);
	$final[$count][1] = substr($file[$count], 8, 4);
	$final[$count][2] = substr($file[$count], 34,11);
	$count++;
	}
		return @final;
}
print "Calculating relative SASA...<br>";
###################################part 11###############################################
#This part calls sep2OandDO.pl which separates mspec_resultsasa_all.csv into DO and Ordered based on SASA value
system ("perl sep2OandDO.pl");
#20 lines 

###################################part 12 ##############################################
### This program calls the strider.pl program. The main program is strider.pl ###
system ("perl strider.pl");
#39 lines 
####################################Part 14##############################################

#43 lines# 
system ("perl count_ss.pl");   # Counts secondary structures

#66 lines#
system ("perl count_pesty.pl"); #Counts Amino acid P,E,S,T,Y

#105 lines# Not needed currently. #
#The program is active but within the program the score is not being printed
system ("perl score_generator.pl > mspec_Sscore.csv"); #Generates Sscores

print "Creating Links... <BR>\n"; #Just like that
system ("sleep 4");  #Just like that

#system ("rm -rf *.out");
#system ("rm -rf *.seqres");
#system ("rm -rf *.stride");
#system ("rm -rf *.prot");
#system ("rm -rf mspec?.csv");
#system ("rm -rf mspec_resultsasa.csv");
#system ("rm -rf mspec_resultsasa_all.csv");
#system ("rm -rf mspec_resultsasa_ss.csv");;
#system ("rm -rf *.pdb"); #Not activating this line because download pdb files would take time
#As and when users download pdb files , a pdb repository would be created. The program would run faster then.

print "<BR><BR>";
print "<B> Your Data Has been Analyzed.</B> <BR><BR>";
print "Click below to view results<BR><BR>";
print "<a href=\"mspec_Sscore.csv\">Sscore</a>";
print "  |  ";
print "<a href=\"mspec_resultsasa_DO.csv\">Disordered</a>"; 


########################################Part 14#########################################
#Copies and renames the sscore and DO files with date and time for backup
#$logpath = "/opt/lampp/htdocs/uploads"; # Use only if you need to give explicit path
$orgfile1 = "mspec_Sscore.csv";
$orgfile2 = "mspec_resultsasa_DO.csv";
$use_rename = "true"; 
$use_zip = "true"; 
$remove_original_after_zip = "true";
$today = &get_todays_date;
$totime = &get_todays_time;
if ($use_rename eq "true") 
  {
   &rename_logfile;
  }
	 else 
	{
	&xerox_logfile;
	if ($use_zip eq "true") 
		{
        		exit;
####################################################
      sub get_todays_date
      {
      open(DT, "date +\%D |");
      chomp($rawdate = <DT>);
      close(DT);
      ($month, $day, $year) = split(/\//, $rawdate);
      $good_date = "$day-$month-$year";
      return $good_date;
      }
  
#################################################### 
sub get_todays_time
      {
($sec,$min,$hour,$mday,$mon,$year,$wday,
$yday,$isdst)=localtime(time);
$good_time="$hour:$min";
return $good_time

	}
###################################################
      sub rename_logfile
      {
           if (-e "$orgfile1") 
	  {
            `cp $orgfile1 $orgfile1.$today.$totime`;
	  }

             if (-e "$orgfile2") 
		{
	           `cp $orgfile2 $orgfile2.$today.$totime`;
                }
       }
 
   
	 }
	     	}
###########################################################################THE
#END###########################################################################

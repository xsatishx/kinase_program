##Author - Satish Balakrishnan
##Modified on 11/2/2013

####Part 1##### first adds the word "endfile" to the end of the mspec.csv file (original file) 
#Secondline uses sed script to get only the peptide data and saves it to mspec1.csv
####Part 2##### formats it leaving sr_no,name,peptide,start residue,end residue and sequence and saves it to mspec2.csv
####part 3##### adds the protein accession number and protein name or every line by replacing ,,, in mspec2.csv and saves it to mspec3.csv
#mspec3.csv is the final formatted file taken as raw input for further programs.
####Part 4##### inputs the mspec3.csv file and outputs the mspec4.csv. It reads the uniprot id and download the uniprot file and then maps the pdb
#id from the uniprot file and prints it to the output file and also downloads the pdbfile.
####Part 5##### Inputs mspec4.csv and outputs mspec5.csv . It takes the peptide from mspec 4 and spans the length and takes octamer
#eg ) 12345678 , 23456789, 34567890 etc. It then checks if it is trully an octamer and if it contains a S,T,Y ion the 4th spot and prints it.
####Part 6##### Inputs mspec5.csv and outputs the seqres records for all the pdb files<BR>
####Part 7##### Inputs mspec5.csv and checks if the octapeptide is present in the seqres record of the PDB, it reports such entries in mspec6.csv.
####Part 8##### Removes all the Nucleic acids entries from the PDB atom file and resaves it into the pdb file. ( Changed it to just reading all protein entires.)
####Part 9##### Calls the program calcsasa.pl which calls the POPS program and calculates sasa and creates .out files.
####Part 10#### Calculates the rSASA values for the octapeptides. Input file should be in the format A0FGR8,SDISLPIA,2DMG 
####Part 11#### Calls program sep2OandDO.pl which separates the file into based on their sasa value 1) Ordered 2) Disordered
####Part 12#### Calls 3 programs sscount, pestycount and score generator which will count the no.of each sec struc, PESTY amino acids and calculate Sscore
# for more information on Sscore open score_genarator.pl
####Part 13#### Renames the Output file appended with the date (back up file for my reference) I call it as log file.

################################################## PROGRAM STARTS HERE ################################################################


####################################part 1###########################################

$inputfile=$ARGV[0];
system ("cp $inputfile mspec_input.csv"); 
system ("echo endfile >>mspec_input.csv");
system ("sed -n '/prot_hit_num/,/endfile/p' mspec_input.csv >mspec0.csv");
system ("perl -nle 'print unless 1 .. 1' mspec0.csv >mspec1.csv");

####################################part 2###########################################

open (IN1,"mspec1.csv");
open (OUT1, ">mspec2.csv");
@data =<IN1>;
foreach $data (@data)
	{
	 @cols=split(/\,/,$data);
	 print OUT1 "$cols[0],$cols[1],$cols[2],$cols[15],$cols[16],$cols[19],\n";
#	 print "$cols[0],$cols[1],$cols[2],$cols[15],$cols[16],$cols[19],\n";
	}

####################################part 3###########################################
system ("perl part3.pl");
###################################part 4 ############################################

print "\nPlease wait while we get the necessary Uniprot and PDB files...<BR>\n";
open (IN3,"mspec3.csv");
open (OUTC,">mspec4.csv");
@dataa=<IN3>;

foreach $dataa (@dataa)
	{
	 @column=split(/\,/,$dataa);
	 
	 $uniprot=$column[1];
	 $uniprot =~ s/\"//g;
		
	 $uniprot_file="$uniprot.txt";	
	 $protfile="$uniprot.prot";
		unless (-e $protfile)
		{
	 	system ("wget -O $uniprot.prot http://www.uniprot.org/uniprot/$uniprot_file"); 	
		}
		        open (UNIFILE,$protfile);
	                @unifile= <UNIFILE>;
		
		foreach $unifile(@unifile)
		{
			 if ($unifile =~ m/PDB;/) 
			{
			$pdbid = substr($unifile,10,4);
			$pdbid=uc($pdbid);
			print OUTC "$column[0],$uniprot,$pdbid,$column[5],\n";
			$pdbfile="$pdbid.pdb";			
			unless (-e $pdbfile)
				{				
				system("wget http://www.rcsb.org/pdb/files/$pdbid.pdb");
				}			
			}
		   	
		}  
	}

######################################## part 5 ########################################

print "Extracting the octapeptide...<BR>\n";
open (OUTFOUR,">mspec5.csv");
open (FILEFOUR,"mspec4.csv");
@dataf=<FILEFOUR>;
foreach $dataf (@dataf)
	{
	@colsf=split(/\,/,$dataf);
	$peptide=$colsf[3];
	$length= length($peptide);

	#print "$peptide,$length,\n";

		for ($count=0;$count<$length;$count++)
		{
		$octamer=substr($peptide,$count,8);
		$octalength=length($octamer);
		$middle=substr($octamer,3,1);
			if ($octalength==8)
			{
				if (($middle =~ m/S/) || ($middle =~ m/Y/) || ($middle =~ m/T/))		
				{	
			   	print OUTFOUR "$colsf[0],$colsf[1],$colsf[2],$octamer,\n";
				}		
			}	
		}

	}

#########################################part 6##########################################

print "Extracting seqres records from PDB ...<BR>\n";
open(IN,"mspec5.csv");
@data=<IN>;
foreach $line (@data)
{
@cols=split(/\,/,$line);
$pdb = $cols[2];
open (OUT,">$pdb.seqres");
open (PDB,"$pdb.pdb");
@PDB=<PDB>;
	foreach $lines(@PDB)
	{
	 if ($lines =~ m/SEQRES/) 
		{
					$seqres= substr($lines,15,58);
					$sequence=oneletter($seqres);
					print OUT $sequence;
		}	
	}
}

sub oneletter {

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
	  'PTR' => '',
	  'SEP' => '',
	  'TPO' => '',
    );
    $input =~ s/\n/ /g;

    my $seq = '';
    my @code3 = split(' ', $input);
		foreach my $code (@code3) 
			{
			$seq .= $three2one{$code};
			}
			return $seq;
}

###########################################Part 7########################################

print "Checking if the octapeptide has a structure...<br>";
open(OUTS,">mspec6.csv");

open(MAIN,"mspec5.csv");
@data=<MAIN>;
@data = grep(/\S/, @data);
foreach $line (@data)
{
@cols=split(/\,/,$line);

$pdb = $cols[2];
#print "part-7 pdb ";
#print "$pdb\n";

$pattern = $cols[3];

	open(IN,"$pdb.seqres");
	@sequence =<IN>;
foreach (@sequence)
    {
		if ($_=/$pattern/)
		{
		print OUTS "$cols[0],$cols[3],$cols[2],$cols[1],\n";
		}
			
	}
}

########################################Part 8##########################################

print "Preparing the pdb files ... <BR>\n";
open(INSIX,"mspec6.csv");
@datasix=<INSIX>;
@datasix = grep(/\S/, @datasix);
foreach $datasix(@datasix)
	{
	 @colsix = split(/\,/,$datasix);
	 $pdbidsix="$colsix[2].pdb";
     open (IN, "$pdbidsix");
     @atomr=<IN>;
     open (OUT,">$pdbidsix");
     foreach $atomr(@atomr)
		{
			$residue = substr($atomr,17,3);
	 	 if (($residue eq "ALA") || ($residue eq "ARG") || ($residue eq "CYS") || 
			($residue eq "ASP") || ($residue eq "GLY") || ($residue eq "LEU") || 
			($residue eq "LYS") || ($residue eq "ASN") || ($residue eq "TRP") || 
			($residue eq "VAL") || ($residue eq "TYR") || ($residue eq "ILE") ||
			($residue eq "PHE") || ($residue eq "PRO") || ($residue eq "MET") ||
			($residue eq "GLU") || ($residue eq "HIS") || ($residue eq "GLN") ||
			($residue eq "SER") || ($residue eq "THR"))
				{ 
				 print OUT $atomr;
				}	
		}
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

###################################part 12###############################################

print "Creating Links... <BR>\n"; #Just like that
system ("sleep 2");  #Just like that

#system ("rm -rf *.out");
#system ("rm -rf *.seqres");
#system ("rm -rf *.stride");
#system ("rm -rf *.prot");
#system ("rm -rf mspec?.csv");
#system ("rm -rf mspec_resultsasa.csv");
#system ("rm -rf mspec_resultsasa_all.csv");
#system ("rm -rf mspec_resultsasa_ss.csv");
#system ("rm -rf *.pdb"); #Not activating this line because download pdb files would take time
#As and when users download pdb files , a pdb repository would be created. The program would run faster then.

print "<BR><BR>";
print "<B> Your Data Has been Analyzed.</B> <BR><BR>";
print "Click below to view results<BR><BR>";
print "<a href=\"mspec_resultsasa.csv\">Sscore</a>";
print "  |  ";
print "<a href=\"mspec_resultsasa_DO.csv\">Disordered</a>"; 


########################################Part 13#########################################
#Copies and renames the sscore and DO files with date and time for backup
#$logpath = "/opt/lampp/htdocs/uploads"; # Use only if you need to give explicit path
$orgfile1 = "mspec_resultsasa.csv";
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
###########################################################################THE END###########################################################################

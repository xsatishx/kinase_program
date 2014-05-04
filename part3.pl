open (IN2 ,"<mspec2.csv");
open (OUT2,">mspec3.csv");

  while(<IN2>)
  {
	unless($_=~m/,,,/)

	   {
	    print OUT2 $_;
	    @arr=split(",",$_);
	    $str=",$arr[1],$arr[2],";
           }

    if($_=~m/,,,/)
	{
	$line=$_;
	$line=~s/,,,/$str/g;
	print OUT2 $line;
	}
  }

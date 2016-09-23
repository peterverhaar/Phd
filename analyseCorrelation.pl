
use strict ;
use warnings ;

my $field1 = "Water_N" ; 
my $field2 = "Music_N" ;

open ( O1 , ">AnalyseCorrelation\\values.txt") ; 
open ( O2 , ">AnalyseCorrelation\\fragments.txt") ; 

my ( %data , %codes , @labels ) ; 

my @poems ; 

open ( P , "poemTitles.txt") or die ("Can't open file!") ;

while(<P>) {
	$_ =~ s/\n//g; 
	
	my @parts = split( /\t/ , $_) ; 
	
	if ( $parts[0] =~ /xml$/) {
		$parts[0] =~ s/\.xml//g; 
	}

	
	if(/\w/) {
		push( @poems, $parts[0] ) ;
		$codes{$parts[0]} = $parts[1] ; 
	}
}
close(P) ;



  

open ( IN , "R\\data.csv") or die ("Can't read file!"); ;

my $n = 0 ; 

while(<IN>) {

	$_ =~ s/\n//; 

	if ( $n == 0 ) {
		@labels = split( "," , $_ ) ;
	} else {
		my @values = split( "," , $_ ) ;
		my $poem = shift( @values ) ; 
		
		my $i = 0 ; 
		foreach my $v ( @values ) {
		
			$data{$poem}{$labels[$i]} = $v ;
			$i++ ; 
			
		}
		
	}

	$n++ ; 
		
}

close( IN ) ; 


my %both ; 



foreach my $p ( sort { $data{$b}{$field1} <=> $data{$a}{$field1}  } keys %data ) {

	if ( $data{$p}{$field1} > 0 and $data{$p}{$field2} > 0 ) { 
		$both{$p} = $data{$p}{$field1} + $data{$p}{$field2} ; 	
	}
}

foreach my $p ( sort { $data{$b}{$field2} <=> $data{$a}{$field2} } keys %both ) {

	print O1 $p . "\n" ;
	print O2 "\n". $p . "\n\n" ;
	
	
	print O1 $field1 . " => " . $data{$p}{$field1} . "\n" ;
	print O1 $field2 . " => " . $data{$p}{$field2} . "\n\n" ;
	

	open ( D , "Data\\Images\\data.txt" ) ;

	my $line ; 
	my $image ; 

	while(<D>) {
	

		$_ =~ s/\n//g ; 

		if ( /^#/ ) {
			$line = $_ ;
		} else {
			my @parts = split( /\t/ , $_ ) ;
			if ( $parts[0] =~ /$p/ ) {
			
				my $test = $parts[2] . "_N" ; 
				
				#print $test . "=>" . $field1 . "\n" ;
			
				if ( ( $test eq $field1 ) or 
				( $test eq $field2 )
				) {
					print O2 $line . "\n" ;
					print O2 $_ . "\n" ;
				}
			}
		}



	}
	
	
	close (D) ; 

	
	if( $both{$p} == 0 ) {
		last ; 
	}

}


close ( O1 ) ; 
close ( O2 ) ;

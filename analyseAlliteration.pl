

use strict ; 
use warnings ; 

my ( $poem , %codes , $code , @parts , $currentPoem , $pattern ) ; 

$currentPoem = "xml" ; 

my $base = "C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\Processing\\visualiseAlliterations\\data\\";

open ( IN , "C:\\Users\\Peter\\Documents\\PhD\\CaseStudy\\Data\\Alliteration\\data.txt" ) ;



while (<IN>) {


	if( $_ !~ /^#/ ) {

		$_ =~ s/\n$//g; 
		
		@parts = split( /\t/ , $_ ) ;
		$poem = $parts[0] ;	
		$poem = substr( $poem , 0 , index( $poem , '.xml' )  )  ;
		$poem =~ s/#*//g; 
		
		if ( $currentPoem ne $poem ) { 
	
			close ( OUT ) ; 

			open ( OUT , ">". $base . $poem . ".csv") ; 
			print OUT "poem,pattern\n" ; 

			#print OUT $poem . "," . "\n" ; 
		}
		
		
		$pattern = $parts[2] ;
		#print OUT "#," . $pattern . "\n" ;
		
		@parts = split( / / , $pattern ) ;
		$pattern = "" ; 
		
		%codes = () ; 
		$code = 0 ; 
		
		foreach my $c ( @parts ) {
			
			if( $c =~ /-/) {
				$pattern .= "0" ; 
			} else {
			
				if( !( exists( $codes{$c} ) ) ) {
					$code++ ; 
					$codes{$c} = $code ; 
				}
				
				$pattern .= $codes{$c} ;  
			
			}
			
		}
		
		print OUT "," . $pattern . "\n" ; 
		
		
		$currentPoem = $poem ; 
	
	}

}

close ( IN ) ; 

 
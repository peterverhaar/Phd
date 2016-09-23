package TextMining ; 


#use Encode;
use strict ;
use readTEI ;


#use Lingua::EN::Tagger ;
#use readRDF ;
#use POSIX qw(log10);


#my $rdf = readRDF->new();
my $tei = readTEI->new();


my %morphAvg ;

	
my $consonants = "bcdfghjklmnpqrstvwxzDZSTN" ; 


#my %phonemes = %{ &countPhonemes("LouisMacNeice") } ; 







sub new() {

	my $self  = {};
	$self->{poem} = {} ; 		
	bless($self);     
	return $self;
}



sub countNumberOfWords($) {

my $self = shift ;
my $line = shift ; 
my $numberWrds ; 


my @words = @{ &wordSegmentation( $line ) } ;

foreach my $w ( @words ) {

	++$numberWrds  ; 
}


return $numberWrds ;

}



sub countNumberOfUniqueWords($) {

my $self = shift ;
my $line = shift ; 
my $numberWrds ; 

my %unique ; 

my @words = @{ &wordSegmentation( $line ) } ;

foreach my $w ( @words ) {

	$unique{$w}++ ;
}


return scalar keys %unique ;

}




sub countNumberOfSyllables($) {

my $self = shift ;
my $transcr = shift ; 

my $numberSyll = 0 ; 

my @words = @{ &wordSegmentation( $transcr ) } ;

foreach my $w ( @words ) {

	my @syll = split( "-" , $w ) ; 
	$numberSyll += @syll ; 
}


return $numberSyll ;

}


sub isVowel($) {

	my $phoneme = shift ;  
	my $return = 1 ; 
	if ( $phoneme =~ /[bcdfghjklmnpqrstvwxzNDZST]/) {
		$return = 0 ;
	}
	return $return ; 
}

sub findFinalSound($) {

	my $word = shift ; 
	my @syll = split( "-" , &findRhymingSound( $word ) ) ;	
	
	my $rhyme = $syll[-1] ; 
	
	if ( $rhyme =~ /[aeiouIUV@]/ ) {
		$rhyme =~ s/^[$consonants]*//g;
	}
	return $rhyme ; 

}


sub getRhymingSound($) {

	my $self = shift ; 
	my $word = shift ; 
	return &removeFirstConsonant( &findRhymingSound( $word ) ) ; 
}


sub findRhymingSound($) {

	my $word = shift ; 
	my $rhyme ; 
	
	$word =~ s/\*/\!/g ; 
		
	my @split = split( /\!/ , $word  ) ; 
	$rhyme = $split[-1] ; 

	$rhyme =~ s/^\!//g; 
	$rhyme =~ s/^\*//g; 	


	return $rhyme ; 
}


sub fuzzyMatching($) {

	my $text = shift ;
	$text =~ s/z/s/g;
	$text =~ s/S/s/g;
	$text =~ s/Z/s/g;	

	$text =~ s/\@U/O:/g;

	$text =~ s/eU/e/g;	
	
	$text =~ s/\I@/i/g;		
	$text =~ s/d^/t/g;		
	return $text ; 
	
}

sub removeFirstConsonant($) {

	my $text = shift ;
	$text =~ s/^[$consonants]*//g;	
	return $text ; 
	
}


sub findRhymingSoundWithoutInitialConsonants($) {
	my $word = shift ; 
	my $rhyme = &findRhymingSound( $word ) ; 
	$rhyme = &removeFirstConsonant ( $rhyme ) ; 
	return $rhyme ; 
}



sub largestNGram($) { 

my $self = shift ; 
my $poem = shift ; 

my @repeatedPhrases = () ;  
my %ngrams = () ;
my %AllNgrams = () ; 
my $size ; 

$poem =~ s/\n/ /g; 
$poem =~ s/,//g; 
$poem =~ s/\.//g; 
$poem =~ s/\://g; 
$poem =~ s/^\'//g; 
$poem =~ s/\'$//g; 	
$poem =~ s/ */ /;
$poem = lc($poem) ;



my @words = @{ &wordSegmentation( $poem ) } ;  

my $n = 2 ; 
my $ngram ; 
my $print ;
my $repeatedNGrams = -1 ; 


while ( $repeatedNGrams !=  0) {

%ngrams = () ; 
$repeatedNGrams = 0 ; 
$n++ ; 

for ( my $i = 0 ; $i < ( @words - $n ) ; $i++ ) {
	
	for ( my $k = $i ; $k < ($i+$n) ; $k++ ) {
		
		if( $words[$k] )  {
			$ngram .= $words[$k] ; 
		}
		if( $k != ($i+$n-1)) { $ngram .= " " ; }
	}
			
	$ngrams{ $ngram }++ ;
		
	$AllNgrams{ $ngram }++ ; 
	$ngram = "" ; 
			
}

foreach my $r ( keys %ngrams ) {
	if( $ngrams{$r} > 2) { 
		$repeatedNGrams++ ;
	}
	else {
		delete ( $AllNgrams{ $r } ) ; 	
	}
	
}


}

$n-- ; 
#print "Size of largest n-gram: " . $n . "\n" ; 	


foreach my $r ( keys %AllNgrams ) {
	

	
	if ( $r =~ /\s/ ) {
	my $key ; 
	$key = $r ; 
	$key =~ s/^\w+\s//g; 

		if ( $AllNgrams{$key} ) {
		delete( $AllNgrams{$key} ) ; 

		}
	$key = $r ; 
	$key =~ s/\s\w+\s*$//g; 
		if ( $AllNgrams{$key} ) {
		delete( $AllNgrams{$key} ) ; 

		}	
	}
	
}
	
		
foreach my $r ( keys %AllNgrams ) {

	if ( $n > 2 ) {
	
		if ( $r =~ /\s/) {
			push ( @repeatedPhrases, $r ) ; 
		}

	}
}

return \@repeatedPhrases ; 

}	


sub repeatedWordInLine($) {

my $self = shift ;
my $line = shift ;

$line =~ s/\///; 
$line =~ s/\\//; 
$line =~ s/\(//; 
$line =~ s/\)//; 


my %words ; 
my @return ;

my $words = &wordSegmentation( $line ) ;

foreach my $w ( @{ $words } ) {

	$words{ $w }++ ; 	
	
}

my $return = 0 ;
foreach my $w ( keys %words) {
	if ( $words{$w} > 1 ) {
		$w !~ s/[^[:ascii:]]//g;
		push ( @return , $w ) ; 
	}
}

return \@return ;
}


sub repeatedWordWithinWord($) {

my $self = shift ;
my $line = shift ;

$line =~ s/\///; 
$line =~ s/\\//; 
$line =~ s/\(//; 
$line =~ s/\)//; 

$line =~ s/\?//; 

#print $line . "\n" ; 


$line = lc( $line ) ; 
my %words ; 
my @return ;

my $words = &wordSegmentation( $line ) ;

foreach my $w ( @{ $words } ) {

	$w =~ s/\W//g; 

	foreach my $w2 ( @{ $words } ) {

		$w2 =~ s/\W//g;
		
		if ( $w =~ /^$w2/ and $w ne $w2 and length($w2) >= 4) {
			$w =~ s/[^[:ascii:]]//g;
			
			my $test = "" ; 
			 
			my $flag = 0 ; 
			if ( length( $w2 ) > length( $w2 ) ) {
				$test = $w2 ;
				$test =~ s/$w//g;
				if( $test eq "s" or $test eq "ing") {
					$flag = 1 ; 
				}
			} else {
				$test = $w ;
				$test =~ s/$w2//g;
				if( $test eq "s" or $test eq "ing") {
					$flag = 1 ; 
				}			
			}
			
			if ( $flag == 0) { 
				push ( @return , $w . " => " . $w2 ) ;
			}
		}
	
	}	
	
}


return \@return ; 
}



sub repeatedNGramInLineTest($$) {

my $self = shift ;
my $line = shift ;
my $n = shift ;

if ($n < 1) {
	$n = 3 ; 
}

chomp( $line ) ; 

$line = lc( $line ) ; 
my @ngrams ;
my %repetition ; 

$line =~ s/[\(\)-\\\/\']//g;


my @words = &wordSegmentation( $line ) ; 

foreach my $word ( @words ) {

	@ngrams = [] ; 

	for ( my $i = 0 ; $i < length( $word ) ; $i++) {
		for ( my $k = $n ; ( $k + $i) <= length($word) ; $k++ ) {
			my $ngram = substr ( $word, $i, $k ) ;
			
			
			
			push ( @ngrams , $ngram ) ; 
		}
	}


	foreach my $testWord ( @words ) {
		if ( $testWord ne $word ) {
			
			foreach my $n ( @ngrams ) {
				if ( $testWord =~ /$n/ ) {
					$repetition{$n}++ ;
				}
			}
			
			
		}
	}
	
}


foreach my $r ( keys %repetition ) {
	
			foreach my $substr ( keys %repetition ) {
			
				if ( ($r =~ /$substr/ ) and length($r) != length($substr) ) {
					delete( $repetition{$substr} ) ; 
				}

	
			}
}

my @repetition ; 

delete ( $repetition{"the"} ) ; 

foreach my $r ( keys %repetition ) {
	push ( @repetition , $r ) ;
}

return \@repetition ; 

}




sub largestNGramWithinLine($) {

my $self = shift ;
my $line = shift ;

chomp( $line ) ; 

$line = lc( $line ) ; 


$line =~ s/[\(\)-\\\/]//g;



my %ngrams ;
my @AllNgrams ; 

my %words ; 

my @words = @{ &wordSegmentation( $line ) } ; 
foreach my $w ( @words ) {
	$words{$w}++ ; 
}


my $ngram ; 



my $minLength = 3 ; 

foreach my $w ( keys %words )
{


if ( length( $w ) > 2 ) {

		# $i = start, $j = end ;

		for ( my $i = 0 ; $i < ( ( length( $w ) + 1) - $minLength ) ; $i++ ) {
			for ( my $j = $minLength ; $j <  ( length( $w ) +1 ) ; $j++ ) {
					
					if ( ($i+$j) <= length( $w ) ){	
					$ngram = substr( $w, $i, $j ) ; 
					
					if ( length( $ngram ) > 2 ) {
						$ngrams{ $ngram }++ ;
					}
					
					}
					
					
			}
		}

}
}



foreach my $r ( keys %ngrams ) {
	
	if ( $ngrams{$r} > 1 ) {

			foreach my $substr ( keys %ngrams ) {
			
		
				if ( ($r =~ /$substr/ ) and ( length($r) != length($substr) ) and ( $substr =~ /\w/ ) ) {

					delete ( $ngrams{$substr} ) ;
				}
			
			}
	
	}
	
}



foreach my $r ( sort keys %ngrams ) {

		
	
	if ( ($ngrams{$r} > 1) and ( $r =~ /./) and ( $r ne "the" ) ) {
		push ( @AllNgrams , $r ) ;
	}
	
}

#delete ( $AllNgrams["the"] ) ;


return \@AllNgrams ;

}





sub findInternalRhymeTwoLines($$) {

my $self = shift ;

my $transcr1 = shift ; 
my $transcr2 = shift ; 

my %words ; 
my %sounds ; 

my $return = 0 ; 

if ( $transcr1 =~ /\w/ and $transcr2 =~ /\w/  ) {


	my @words = @{ &wordSegmentation( $transcr1 ) } ; 
	my $last = $words[-1] ;
	my $finalRhymeL1 =  &findRhymingSound( $last ) ; 
	$finalRhymeL1 = &removeFirstConsonant( $finalRhymeL1 ) ; 

	my @words = @{ &wordSegmentation( $transcr2 ) } ; 
	
	## delete last item as this function should only return instances of internal rhyme
	pop ( @words ) ;
	foreach my $w ( @words ) {
	
		if ( $w eq $last ) {
			$w = "" ; 
		}
	
		my $rhymeL2 =  &findRhymingSound( $w ) ;
		$rhymeL2 = &removeFirstConsonant( $rhymeL2 ) ; 
		
		if ( ( $rhymeL2 eq $finalRhymeL1 ) ) {
		
			$return = 1 ; 
		}
	}
	
}

	return $return ; 

}




sub findRepeatedWordTwoLines($$) {


my $self = shift ;
my $line1 = shift ; 
my $line2 = shift ; 

my ( %words1 , %words2 ) ; 

my @return ; 

$line1 = lc($line1) ; 
$line2 = lc($line2) ; 



my @blackList = ( "the" , "a" , "of", "and", "I", "you", "it", "is" , "have" , "were" , "be" , "had") ; 

my @words1 = @{ &wordSegmentation( $line1 ) } ; 
my @words2 = @{ &wordSegmentation( $line2 ) } ; 
 
 
foreach my $w ( @words1 ) {

	$words1{$w} ++ ; 
}


foreach my $w ( @words2 ) {

	$words2{$w} ++ ; 
}

foreach my $w ( @blackList ) {
	delete( $words1{$w} ) ; 
	delete( $words2{$w} ) ; 	
}




foreach my $w ( keys %words1 ) {
	
	if( $words2{$w} ) {
		push ( @return , $w ) ; 
		delete ( $words2{$w} ) ; 
	}
}

foreach my $w ( keys %words2 ) {

	if( $words1{$w} ) {
		push ( @return , $w ) ; 
	}
}


return \@return ; 


}


## rhyme


sub findPerfectRhyme($$$$) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my $match = shift ; 

return &perfectRhyme( $stanza, $phon, $match ) ; 

}

sub perfectRhyme($$$) {

my $stanza = shift ;
my $phon = shift ; 
my $match = shift ; 

## stanza contains the numbers of the stanza ;
## phon the phonetic trasncriptions of the lines

my %phon = %{ $phon } ; 
my @stanza = @{ $stanza } ; 


my @rhymes ; 
my %sounds ; 

my $scheme ; 

my %finalWords ;

## array @rhyme contains all the rhyming words ;
## %sounds counts the number of times the phoneme sequences occur

	foreach my $s ( @stanza ) {
	
		my $transcr = $phon{ $s } ;
		
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;

		$finalWords{$last}++ ; 
		
		## repeated words are not rhymes
		if( $finalWords{$last} == 1) {
		
			my $rhyme = &findRhymingSoundWithoutInitialConsonants( $last ) ;
			
			if ( length ( $match ) > 0  ) {
				$rhyme = &fuzzyMatching( $rhyme ) ;			
			}	

			push( @rhymes , $rhyme ) ; 	
			$sounds{ $rhyme }++ ; 
		} else {
			## no rhyme in the case of repeated words
			push( @rhymes , "" ) ;
		}
}

my %codes = () ; 
my $codeCount = 0  ;

my ( $fem , $masc ) ; 

foreach my $r ( @rhymes ) {

	if ( $sounds{$r} > 1 and !exists( $codes{$r} ) ) {		
		$codeCount++ ; 
		$codes{$r} = $codeCount ;
	}
	
	if ( exists( $codes{$r} ) ) {
		$scheme .= $codes{$r} . " "; 
		
		if ( $r =~ /-/) {
			$fem .= $codes{$r} . " ";  
			$masc .= "- "; 
		} else {
			$fem .= "- ";  
			$masc .= $codes{$r} . " "; 
		}
	
	
	} else {
		$scheme .= "- " ;
		$fem .= "- " ; 
		$masc .= "- ";  
	}

	
		
	
	}
		


## distinguish between masculine and female
	$scheme .= "\n$fem ";  
	$scheme .= "\n$masc" ; 


return $scheme ; 
}




sub consonanceTwoLines($$) {

my $self = shift ;

my $transcr1 = shift ; 
my $transcr2 = shift ;

my $return = 0 ;

	if ( $transcr1 =~ /\w/ and $transcr2 =~ /\w/  ) {


 		
		my @words = @{ &wordSegmentation( $transcr1 ) } ; 
		my $last1 = $words[-1] ;
		my @morph = @{ &separatePhonemes( $last1 ) } ;
		my $pattern1 ; 
		foreach my $m ( @morph ) {
		
			if ( !( &isVowel( $m ) ) ) {
				$pattern1 .= $m ; 
			}
		}

	
		#if ( $transcr2 =~ /$last1/ ) {
		
			
			#$pattern1 =~ s/[-\[\]]//g; 
			#$pattern2 =~ s/[-\[\]]//g; 
 
			#$transcr2 =~ s/$last1//g; 
		#}
		
		my $test = "" ; 
		my @words2 = @{ &wordSegmentation( $transcr2 ) } ; 
		foreach my $w ( @words2 ) {
			if ( $w ne $last1 ) {
				$test .= $w . " " ; 
			}
		}		
		
		
		my @morph = @{ &separatePhonemes( $test ) } ;
		my $pattern2 ; 
		foreach my $m ( @morph ) {
	
			if ( !( &isVowel( $m ) ) ) {
				$pattern2 .= $m ; 
			}
		}
		
		$pattern1 =~ s/\W//g; 
		$pattern2 =~ s/\W//g; 
		$pattern1 =~ s/[-\[\]]//g; 
		$pattern2 =~ s/[-\[\]]//g; 		
		
		if ( $pattern1 =~ /\w\w/ and $pattern2 =~ /^$pattern1/ ) {
			$return = 1 ; 
		}
	}

	return $return ; 
}

### Repetition



sub visualiseRhyme($$$) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my $match = shift ; 

## stanza contains the numbers of the stanza ;
## phon the phonetic trasncriptions of the lines

my %phon = %{ $phon } ; 
my @stanza = @{ $stanza } ; 


my @rhymes ; 
my %sounds ; 

my $scheme ; 


## array @rhyme contains all the rhyming words ;
## %sounds counts the number of times the phoneme sequences occur

foreach my $s ( @stanza ) {
	
		my $transcr = $phon{ $s } ;
		$transcr =~ s/%/!/g; 
		
		my @words = @{ &wordSegmentation( $transcr ) } ; 

		foreach my $w ( @words ) {
			
			if( $w =~ /!/ ) {
				my $rhyme = &findRhymingSoundWithoutInitialConsonants( $w ) ;
				$rhyme = &fuzzyMatching( $rhyme ) ;			
				$sounds{ $rhyme }++ ; 
			}
		}
		
	
}

my %codes = () ; 
my $codeCount = 0  ;


foreach my $s ( keys %sounds ) {

	if ( $sounds{$s} > 1 and !exists( $codes{$s} ) ) {		
		$codeCount++ ; 
		$codes{$s} = $codeCount ;
	}
	
	
}
		
		
foreach my $s ( @stanza ) {
	
		$scheme .= $s . ","  ;
	
		my $transcr = $phon{ $s } ;
		$transcr =~ s/%/!/g; 
		
		my @words = @{ &wordSegmentation( $transcr ) } ;  
		
		if ( @words == 0 ) {
			$scheme .= 0 ; 
		}

		foreach my $w ( @words ) {
			
				my $rhyme = &findRhymingSoundWithoutInitialConsonants( $w ) ;
				$rhyme = &fuzzyMatching( $rhyme ) ;			
				if ( $codes{ $rhyme } > 0 ) {
					$scheme .= $codes{ $rhyme } ;
				} else {
					$scheme .= "0"; 
				}	
			
		}
		
		
		$scheme =~ s/,$/\n/ ; 
		$scheme .= "\n" ; 
	
	}		
		
		


return $scheme ; 
}





sub findSlantRhymeConsonance($$$$) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my $match = shift ; 

## stanza contains the numbers of the stanza ;
## phon the phonetic transcriptions of the lines

my %phon = %{ $phon } ; 
my @stanza = @{ $stanza } ; 



## Hashes to link word to sounds
my %wordPerfectRhyme ; 
my %wordSlantRhyme ; 

## Hashes used to count the sounds
my %perfectRhyme ;
my %slantRhyme ; 

## list of all final words
my @lastWords ; 
my $scheme = "" ; 

## array @rhyme contains all the rhyming words ;
## %sounds counts the number of times the phoneme sequences occur

	foreach my $s ( @stanza ) {
	
		my $transcr = $phon{ $s } ;
		
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;

		push( @lastWords , $last ) ;  
		
		## repeated words are not rhymes
		my $rhyme = &findRhymingSound( $last ) ;			
		#$rhyme = &fuzzyMatching( $rhyme ) ;				

		$wordPerfectRhyme{ $last} = &removeFirstConsonant( &fuzzyMatching( $rhyme ) ) ; 
		$perfectRhyme{ &removeFirstConsonant( &fuzzyMatching( $rhyme ) ) }++ ; 
	
		my @morph = @{ &separatePhonemes( &removeFirstConsonant($rhyme) ) } ;	
		my $pattern ;
	
		foreach my $m ( @morph ) {
			
			if ( !&isVowel( $m ) ) {
				$pattern .= $m ; 			
			} else  {
				$pattern .= "-" ; 
			}
			
		}
	
		$pattern =~ s/-+/-/g; 		
		
		
		if ( $pattern =~ /\w/ ) {
			$wordSlantRhyme{ $last } = $pattern ;  
			$slantRhyme{ $pattern }++ ;  
		}
}

my %codes = () ; 
my $codeCount = 0  ;


foreach my $word ( @lastWords ) {


	my $soundPR = $wordPerfectRhyme{$word} ;
	my $soundSR = $wordSlantRhyme{$word} ; 
	
	if ( 
	 ( $perfectRhyme{$soundPR} <= 1 )  and 
	 ( $slantRhyme{$soundSR} > 1 ) and
			!exists( $codes{$soundSR} ) ) {		
		$codeCount++ ; 
		$codes{$soundSR} = $codeCount ;
	}
	
	if ( exists( $codes{$soundSR} ) ) {
		$scheme .= $codes{$soundSR} . " "; 	
	} else {
		$scheme .= "- " ;
	}

	
		
}
	
		
return $scheme ; 

}


sub typeOfEnding($$) {

my $self = shift ; 
my $phon = shift ; 

my @words = split ( /\s/ , $phon ) ; 
my $last = $words[-1] ;

my $rhyme = &findRhymingSound( $last ) ;			
		
if( $rhyme =~ /-/) {
	return "F" ; 
} else {
	return "M" ;
}

}




sub findSlantRhymeAssonance($$$$) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my $match = shift ; 

## stanza contains the numbers of the stanza ;
## phon the phonetic trasncriptions of the lines

my %phon = %{ $phon } ; 
my @stanza = @{ $stanza } ; 


## Hashes to link word to sounds
my %wordPerfectRhyme ; 
my %wordSlantRhyme ; 

## Hashes used to count the sounds
my %perfectRhyme ;
my %slantRhyme ; 

## list of all final words
my @lastWords ; 
my $scheme = "" ; 

## array @rhyme contains all the rhyming words ;
## %sounds counts the number of times the phoneme sequences occur

	foreach my $s ( @stanza ) {
	
		my $transcr = $phon{ $s } ;
		
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;

		push( @lastWords , $last ) ;  
		
		## repeated words are not rhymes
		my $rhyme = &findRhymingSound( $last ) ;			
		#$rhyme = &fuzzyMatching( $rhyme ) ;				

		$wordPerfectRhyme{ $last} = &removeFirstConsonant( &fuzzyMatching( $rhyme ) ) ; 
		$perfectRhyme{ &removeFirstConsonant( &fuzzyMatching( $rhyme ) ) }++ ; 
	
		my @morph = @{ &separatePhonemes( $rhyme ) } ;	
		my $pattern ;
	
		foreach my $m ( @morph ) {
			
			if ( &isVowel( $m ) ) {
				$pattern .= $m ; 			
			} else  {
				$pattern .= "-" ; 
			}
			
		}
	
		$pattern =~ s/-+/-/g; 		
		
		$wordSlantRhyme{ $last } = $pattern ;  
		$slantRhyme{ $pattern }++ ;  

}

my %codes = () ; 
my $codeCount = 0  ;


foreach my $word ( @lastWords ) {


	my $soundPR = $wordPerfectRhyme{$word} ;
	my $soundSR = $wordSlantRhyme{$word} ; 

	
	if ( 
	 ( $perfectRhyme{$soundPR} <= 1 )  and 
	 ( $slantRhyme{$soundSR} > 1 ) and
			!exists( $codes{$soundSR} ) ) {		
		$codeCount++ ; 
		$codes{$soundSR} = $codeCount ;
	}
	
	if ( exists( $codes{$soundSR} ) ) {
		$scheme .= $codes{$soundSR} . " "; 	
	} else {
		$scheme .= "- " ;
	}

	
		
}

#my $scheme2 = &perfectRhyme( $stanza , $phon , $match ) ;
#$scheme .= "=>" . $scheme2 ; 
		
return $scheme ;




}



sub findSlantRhyme($$$$) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my $type = shift ; 

## stanza contains the numbers of the stanza ;
## phon the phonetic trasncriptions of the lines
## type speficies assonance or consonance

my %phon = %{ $phon } ; 
my @stanza = @{ $stanza } ; 

print "\n\n" ; 

## Hashes to link word to sounds
my %soundsPerfectRhyme ; 
my %soundsSlantRhyme ; 

## Hashes used to count the sounds
my %countPerfectRhyme ;
my %countSlantRhyme ; 

## list of all final words
my @lastWords ; 
my $scheme = "" ; 

## array @rhyme contains all the rhyming words ;
## %sounds counts the number of times the phoneme sequences occur

	foreach my $s ( @stanza ) {
	
		my $transcr = $phon{ $s } ;
		
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;
		

		push( @lastWords , $last ) ;  
		
		## repeated words are not rhymes
		my $rhyme = &fuzzyMatching( &findRhymingSound( $last ) ) ;			
		#$rhyme = &fuzzyMatching( $rhyme ) ;	

		my $PR = &removeFirstConsonant( &fuzzyMatching( $rhyme ) ) ;

		$soundsPerfectRhyme{ $last} = $PR ; 
		$countPerfectRhyme{ $PR }++ ; 
	
		## create pattern assonance
	
		my @morph = @{ &separatePhonemes( $rhyme ) } ;	
		my $pattern ;
	
		foreach my $m ( @morph ) {
			
			if ( &isVowel( $m ) ) {
				$pattern .= $m ; 			
			} else  {
				$pattern .= "-" ; 
			}
			
		}
	
		$pattern =~ s/-+/-/g; 		
		
		$soundsSlantRhyme{ $last } = $pattern ;  
		$countSlantRhyme{ $pattern }++ ;  

}

## Remove perfect rhymes


foreach my $sPR ( keys %soundsPerfectRhyme ) {


	if ( $countPerfectRhyme{ $soundsPerfectRhyme{ $sPR } } > 1 and $countSlantRhyme{ $soundsSlantRhyme{ $sPR } } >= $countPerfectRhyme{ $soundsPerfectRhyme{ $sPR } } ) {

		if( exists( $soundsSlantRhyme{ $sPR } ) ) {
		
			$countSlantRhyme{ $soundsSlantRhyme{ $sPR } } = 
			$countSlantRhyme{ $soundsSlantRhyme{ $sPR } } - $countPerfectRhyme{ $soundsPerfectRhyme{ $sPR } } ; 
		
		}
		
	}


}


## Assign codes to pattern

my $code = 0 ; 
my %codes ; 

foreach my $w ( @lastWords) {

	if ( $countSlantRhyme{ $soundsSlantRhyme{$w} } > 1  ) {
		
		if ( !(exists( $codes{ $soundsSlantRhyme{$w} } )) ) { 
			$code++ ; 
		}
		
		$codes{ $soundsSlantRhyme{$w} } = $code ; 
	}
	
}

foreach my $w ( @lastWords) {

	print $w . " => " . $soundsSlantRhyme{$w} . "\n"  ; 
	print "PF: " . $countPerfectRhyme{$soundsPerfectRhyme{$w} } . "\n" ; 
	
	if ( $codes{ $soundsSlantRhyme{$w} } =~ /\d/ and $countPerfectRhyme{$w} < 2 ) {
		$scheme .= $codes{ $soundsSlantRhyme{$w} } . " " ;
	} else {
		$scheme .= "- " ;
	}
	


}

print "SCHEME: " . $scheme . "\n\n" ; 

return $scheme ; 

}


sub findSlantRhymeAssonance2($) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 

my %codes ; 
my $scheme ;

#similar sounds in vowels

my %phon = %{ $phon } ; 

my %sounds ;
my %lastWords ;
my %perfectRhyme ; 

## why this variable?
my %lines ; 

my @stanza = @{ $stanza } ; 

## Find the rhyming pattern for each line, assign to sounds hash

my $codeCount = 0 ;

foreach my $s ( @stanza ) {
	my $transcr = $phon{ $s } ; 
	my @words = split ( /\s/ , $transcr ) ; 
	my $last = $words[-1] ;
	$lastWords{ $last }++ ;

	my $rhyme = &findRhymingSound( $last ) ;
	
	## perfectRhyme without the first consonants
	++$perfectRhyme{ &removeFirstConsonant( $rhyme) } ; 	
	
	#if ( $rhyme =~ /-/) {
	#	$rhyme = substr( $rhyme , 0 , index( $rhyme, "-") ) ; 
	#}	

 
	my @morph = @{ &separatePhonemes( $rhyme ) } ;	
	my $pattern ;
	
	foreach my $m ( @morph ) {
		
		if ( &isVowel( $m ) ) {
			$pattern .= $m ; 			
		} else  {
			$pattern .= "-" ; 
		}
		
	}
	
	$pattern =~ s/-+/-/g; 
	
	$sounds{$pattern}++ ; 
	

}




my %codes = () ; 
my $codeCount = 0  ;

foreach my $r ( @stanza ) {

	if ( $sounds{$r} > 1 and !exists( $codes{$r} ) ) {		
		$codeCount++ ; 
		$codes{$r} = $codeCount ;
	}
	
	if ( exists( $codes{$r} ) ) {
		$scheme .= $codes{$r} . " "; 
		
		if ( $r =~ /-/) {
			
			
		
		} else {
		}
	
	
	} else {
		$scheme .= "- " ;
	}

	
		
	
}
		





	

return $scheme ;

}



sub findSlantRhymeConsonance2($) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 

my %codes ; 
my $scheme ;

#similar sounds in vowels

my %phon = %{ $phon } ; 

my %sounds ;
my %lastWords ;
my %perfectRhyme ; 
my %lines ; 

my @stanza = @{ $stanza } ; 

## Find the rhyming word for each line, assign to sounds hash

my $codeCount = 0 ;

foreach my $s ( @stanza ) {
	my $transcr = $phon{ $s } ; 
	my @words = split ( /\s/ , $transcr ) ; 
	my $last = $words[-1] ;
	$lastWords{ $last }++ ;

	my $rhyme = &findRhymingSound( $last ) ;
	
	my $rhymeTest = &removeFirstConsonant( $rhyme) ;
	++$perfectRhyme{ $rhymeTest } ; 	
	
	if ( $rhyme =~ /-/) {
		$rhyme = substr( $rhyme , 0 , index( $rhyme, "-") ) ; 
	}	

 	
	


	my @morph = @{ &separatePhonemes( $rhyme ) } ;	
	my $pattern ;
	
	foreach my $m ( @morph ) {
		
		if ( &isVowel( $m ) ) {
			$pattern .= "#" ; 			
		} else {
			$pattern .= $m ; 
		}
		
	}
	

		
	if ( ( $perfectRhyme{ $rhymeTest } == 1 ) and ( $lastWords{ $last} == 1 ) ) {
		$codeCount++ ; 
		$codes{ $pattern } = $codeCount ; 
		$sounds{ $pattern }++ ; 
		$lines{ $s } = $pattern ; 
	} else {

		$lines{ $s } = "" ; 
	}
		
}

foreach my $l ( sort { $a <=> $b } keys %lines ) {

	if ( exists( $codes{ $lines{$l} } ) and $sounds{ $lines{$l} } > 1 ) {
		$scheme .= $codes{ $lines{$l} } . " ";  
	} else {
		$scheme .= "- " ; 
	}

}



return $scheme ;

}




sub findSemiRhyme($) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my %phon = %{ $phon} ; 

my %codes ; 
my %lines ; 
my $codeCount ; 
my $scheme ;

my @singleSyll ;
my @multipleSyll ;  

my @stanza = @{ $stanza } ; 

foreach my $s ( @stanza ) {

		my $transcr = $phon{ $s } ; 
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;
		my $rhyme = &findRhymingSoundWithoutInitialConsonants( $last ) ;			
		if ( $rhyme =~ /-/) {
			push ( @multipleSyll , $rhyme ) ; 
			$lines{ $s } = substr ( $rhyme , 0 , index( $rhyme , "-"  ) ) ;
		}
		else {
			push ( @singleSyll , $rhyme ) ; 
			$lines{ $s } = $rhyme ;
		}

}

		
foreach my $r1 ( @multipleSyll ) {
	
	my $code = substr ( $r1 , 0 , index( $r1 , "-"  ) ) ; 
	$r1 =~ s/-//g; 
	
	foreach my $r2 ( @singleSyll ) {
		if ( ( $r1 =~ /^$r2/ ) and ( $r2 =~ /\w/ )) {
		
			$codeCount++ ; 
			$codes{ $r2 } = $codeCount ; 
			$codes{ $code } = $codeCount ;
 
		}
	}

}		

foreach my $n ( sort { $a <=> $b } keys %lines ) {

	my $p = $lines{ $n } ; 
			 
	if ( exists( $codes{ $p } ) ) {
		$scheme .= $codes{ $p } . " " ; 
	} else {
		$scheme .= "- "; 
	}
	
}
		

return $scheme ; 

}





sub findDeibide($) {

my $self = shift ; 
my $stanza = shift ;
my $phon = shift ; 
my %phon = %{ $phon} ; 
my %sounds ; 
my $scheme ; 

my @rhymes ;

my @singleSyll ;
my @multipleSyll ;  

my @stanza = @{ $stanza } ; 

	foreach my $s ( @stanza ) {

		my $transcr = $phon{ $s } ;
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;
		
		$last =~ s/I$/i:/g; 
		
		my $rhyme = &findRhymingSoundWithoutInitialConsonants( $last ) ;	


		
		if ( $last =~ /-/) {
			my @l = split( /-/ , $last ) ;
			$last = $l[-1] ; 
		}
		
		$last = &findRhymingSoundWithoutInitialConsonants( $last ) ;
		
		push( @rhymes , $last ) ; 	
		
		
		
		if ( $rhyme =~ /-/) {
			
			push ( @multipleSyll , $rhyme ) ; 
		}
		else {
			push ( @singleSyll , $rhyme ) ; 
		}
		}
		
foreach my $r1 ( @multipleSyll ) {


	my @syll = split( /-/ , $r1 ) ;	
	my $lastSyll = &removeFirstConsonant( $syll[-1] ) ;		
	
	foreach my $r2 ( @singleSyll ) {
	
		
	
		if ( ( $r2 eq $lastSyll ) and ( $r2 =~ /\w/ )) {
			
			$sounds{ $lastSyll }++
		}
	}

}		
		



my %codes = () ; 
my $codeCount = 0  ;

## if there is a phoneme sequence that occurs more than once, there are lines that rhyme


foreach my $r ( @rhymes ) {

	
	if( $sounds{$r} > 0 and !exists( $codes{$r} ) ) {
		$codeCount++ ; 
		$codes{ $r } = $codeCount ;  

	}
	
	if ( exists( $codes{$r} ) ) {
		$scheme .= $codes{$r} . " "; 
	} else {
		$scheme .= "- " ;
	}
	
}


 
return $scheme ;  

}





sub findTwoLines($$) {

my $self = shift ;

my $transcr1 = shift ; 
my $transcr2 = shift ; 

my %words ; 
my %sounds ; 

my $return = 0 ; 

if ( $transcr1 =~ /\w/ and $transcr2 =~ /\w/  ) {

	my @words = @{ &wordSegmentation( $transcr1 ) } ; 
	my $last = $words[-1] ;
	my $finalRhymeL1 =  &findRhymingSound( $last ) ; 
	$finalRhymeL1 = &removeFirstConsonant( $finalRhymeL1 ) ; 
	
	## delete last item as this function should only return instances of internal rhyme
	pop ( @words ) ;
	foreach my $w ( @words ) {
	
		if ( $w eq $last ) {
			$w = "" ; 
		}
	
		my $rhymeL2 =  &findRhymingSound( $w ) ;
		$rhymeL2 = &removeFirstConsonant( $rhymeL2 ) ; 
		
		if ( ( $rhymeL2 eq $finalRhymeL1 ) ) {
		
			$return = 1 ; 
		}
	}
	
}

	return $return ; 

}



sub findAnaphora($) {

my $self = shift ; 
my $poem = shift ;

return &anaphora( $poem ) ; 

}

sub anaphora($) {

my $poem = shift ;
my @return ; 
my %return ; 

my $window = 8 ; 

my %poem = %{ $poem } ; 
my $nrLines = scalar keys %poem ;

my @poem ; 

foreach my $n ( sort { $a <=> $b } keys %poem ) {

	push( @poem , lc($poem{$n}) ) ; 
}


if( $nrLines < $window ) {
	
	print "short poem \n" ; 
	my @r = @{ &findMatchFirstWords( \@poem ) } ;
	if ( @r > 0) {
		foreach my $r (@r) {
			$return{$r}++  ; 
		}
		
	}
	
} else {


	print "long poem: $nrLines \n" ; 

	foreach my $n ( sort { $a <=> $b } keys %poem ) {

		
		print "N: " . $n . "\n"; 
		
		if ( exists( $poem{ $n + $window - 2 } ) ) {

			print "exists Print Key" ; 
	 
			my @array ;
			
			my $key = $n-1 ;
			
			print "KEY" . $key . ". \n" ;
			
			for ( $key ; $key < ($window + $n - 1 ); $key++) {
				push ( @array , $poem{$key}) ; 
			}

			my @r = @{ &findMatchFirstWords( \@array ) } ;
			if ( @r > 0) {
			foreach my $r (@r) {
				$return{$r}++  ; 
			}				
			}

			
		}
		
		
	}
}	
foreach my $r ( keys %return ) {

	push ( @return , $r )
} 
return \@return ;
		

}


sub findMatchFirstWords($) {

my $lines = shift ; 
my @lines = @{ $lines } ;
my @return ; 

print "\n" ; 
 
my %start = () ;
for ( my $n = 0 ; $n < @lines ; $n++ ) {
	
	print $lines[$n] . "\n" ; 
	
	my @words = @{ &wordSegmentation( $lines[$n] ) } ;
					if ( $words[0] !~ /(the)|(a)/i and  $words[1] !~ /(the)|(a)/i ) { 
						$start{ $words[0] . " " . $words[1]}++ ;
	}
}

foreach my $s ( keys %start ) {
				
if ( $start{$s} > 1 ) {
									
		push( @return , $s ) ; 
		print "YES: " . $s . "\n" ;  ; 		 
									
	}
					
}
			
return \@return ;

}



sub findInternalRhyme($) {

my $self = shift ;
my $line = shift ; 


my %sounds = () ; 
my %words ; 

my @internalRhymes ; 

my @words = @{ &wordSegmentation( $line) } ; 

 
foreach my $w ( @words ) {
	$words{$w}++ ; 
}

foreach my $w ( keys %words ) {

	if( $w =~ /[%!]/ ) {
	
		my $rhyme = &removeFirstConsonant( &findRhymingSound( $w ) ) ;
		if ( $rhyme =~ /\w/ ) {
		
			++$sounds{ $rhyme } ;
			
		}
	}
}

foreach my $s ( %sounds ) {


	
	if( $sounds{$s} > 1 ) {
		push ( @internalRhymes , $s ) ; 
	}
}

return \@internalRhymes ; 

}



sub findRhymingScheme($) {

my $self = shift ;
my $stanza = shift ;
return &rhymingScheme( $stanza ) ; 

}

sub rhymingScheme($) {

my $stanza = shift ;
my %rhymes ; 
my $rhymeCode = 1 ; 
my $scheme ;

my @stanza = @{ $stanza } ; 

	foreach my $s ( @stanza ) {
		my $transcr = &getObject( $s , "transcr" )  ; 
		my @words = split ( /\s/ , $transcr ) ; 
		my $last = $words[-1] ;
		my $rhyme = &findFinalSound( $last ) ;	
		if ( exists ( $rhymes{$rhyme} ) ) {
			$scheme .= $rhymes{$rhyme} . "-";
		}		
		else {
			$rhymes{$rhyme} = $rhymeCode ; 
			$rhymeCode++ ; 
			$scheme .= $rhymes{$rhyme} . "-";
		}
}

$scheme =~ s/-$//; 
return $scheme ; 
}


sub findConsonanceInLine($) {

	my $self = shift ;
	my $line = shift ;
	my %sounds ; 
	my @consonance ; 
	
	## only stressed 
	
	my $stressed = "" ; 
	my @syll = split( /[- ]/ , $line ) ;
	foreach my $s ( @syll ) {
	
		if( $s =~ /^[!*%]/) {
			$stressed .= $s . "-"; 
		}
		
	}
	$stressed =~ s/-$//g; 	
	
	my @words = split( /\s/ , $stressed ) ; 
	
	foreach my $w ( @words ) {
		if ( $w =~ /[!%]/) {
		
		
			my @phon = @{ &separatePhonemes( $w ) } ;

			if ( @phon > 0 ) {
					foreach my $p ( @phon ) {
					
						
						$p =~ s/[!%]//g; 
						
						
						if (  !( &isVowel($p) )  ) {	
							$sounds{$p}++ ; 
						}
					}
			}		
		
		
		}
	}
	

		
	foreach my $s ( keys %sounds ) {
	
			if( !exists( $morphAvg{$s} ) ) {
				$morphAvg{$s} = 1 ; 
			}
	
			if ( $sounds{$s} >= ( 3* $morphAvg{$s} ) ) {
				push ( @consonance, $s ) ; 
			}
	}	
	
	my @words = @{ &wordSegmentation ( $line ) } ; 
	
	my $pattern = "" ;
	my $wordPattern ; 
	
	foreach my $w ( @words ) {

		$wordPattern = "" ;
		
		my @m = @{ &separatePhonemes( $w ) } ;
		foreach my $c ( @consonance ) {
	
			foreach my $m ( @m ) {
				if ( $c eq $m ) {
					
					if ( $wordPattern =~ /./ ) {
						$wordPattern .= "/" ; 
					}
						$wordPattern .= $c ;
					
				}
			}
		}
		
		if ( $wordPattern =~ /./ ) {
			$pattern .= $wordPattern . " " ; 
		} else {
			$pattern .= "- " ;
		}
	
	}
	
	if( $pattern !~ /./ ) {
		$pattern = "-" ; 
	}
	
	return $pattern ; 

}	


sub findRimeRiche($) {

	my $self = shift ;
	my $poem = shift ; 
	my $title = shift ; 
	
	my %allWords ; 
	my @rimeRiche ; 
	
		
	my %poem = %{ $poem }	;	


	
	foreach my $line ( keys %poem ) {
	
		#my $transcr = $rdf->getObject( $title . "#" . $line , "transcr") ;
		
		my $transcr = "" ; 
		my @words = split( /\s/ , $transcr ) ;
		my @spelling = @{ &wordSegmentation ( $poem{$line} ) } ; 
				
		
		if ( @words == @spelling ) {

			for ( my $i = 0 ; $i < @words ; $i++ ) {

				
				if ( exists( $allWords{ $words[$i] } ) ) {

					if ( $allWords{$words[$i]} ne lc($spelling[$i]) )    {
						push ( @rimeRiche , $spelling[$i] . " / " . $allWords{$words[$i]} ) ; 
						#print "TEST : " . $spelling[$i] . " / " . $allWords{$words[$i]} ; 
					}
				
				}
				else {
					$allWords{$words[$i]} = lc ($spelling[$i] ) ; 
				}
				

				
				
			}
		}
	
	}
	
	return \@rimeRiche ; 
}


sub findAssonanceInLine2($) {

	my $self = shift ;
	my $line = shift ;
	
	my %sounds ; 
	my @assonance ; 
	
	my @words = split( /\s/ , $line ) ; 

	foreach my $w ( @words ) {
		if ( $w =~ /[!%]/) {
		
			my @phon = @{ &separatePhonemes( $w ) } ;

			if ( @phon > 0 ) {
					foreach my $p ( @phon ) {
					
						$p =~ s/[!%]//g; 
						# unstressed schwa is not counted
						if ( ( &isVowel($p) ) and ( $p ne "@") ) {
							$sounds{$p}++ ; 
						}
					}
			}		
		
		
		}
	}
	

		
	foreach my $s ( keys %sounds ) {
		
			if( !exists( $morphAvg{$s} ) ) {
				$morphAvg{$s} = 1 ; 
			}
		
			if ( $sounds{$s} >= ( 3 * $morphAvg{$s} ) ) {

				push ( @assonance, $s ) ; 
			}
	}	
	
	my @words = @{ &wordSegmentation ( $line ) } ; 
	
	my $pattern = "" ;
	my $wordPattern ; 
	
	foreach my $w ( @words ) {

		$wordPattern = "" ;
		
		my @m = @{ &separatePhonemes( $w ) } ;
		foreach my $a ( @assonance ) {
	
			foreach my $m ( @m ) {
				if ( $a eq $m ) {
					
					if ( $wordPattern =~ /./ ) {
						$wordPattern .= "/" ; 
					}
						$wordPattern .= $a ;
					
				}
			}
		}
		
		if ( $wordPattern =~ /./ ) {
			$pattern .= $wordPattern . " " ; 
		} else {
			$pattern .= "- " ;
		}
	
	}
	
	if( $pattern !~ /./ ) {
		$pattern = "-" ; 
	}
	
	return $pattern ; 

}	




sub findAssonanceInLine($) {

	my $self = shift ;
	my $line = shift ;
	
	## only stressed 
	
	my $stressed = "" ; 
	my @syll = split( /[- ]/ , $line ) ;
	foreach my $s ( @syll ) {
	
		if( $s =~ /^[!*]/) {
			$stressed .= $s . "-"; 
		}
		
	}
	$stressed =~ s/-$//g; 	
	
	
	my %sounds ; 
	my %assonance ; 
	
	my $vowels ; 
	my $pattern = "" ; 

	my @phon = @{ &separatePhonemes( $stressed ) } ;

	if ( @phon > 0 ) {
		

		
		foreach my $p ( @phon ) {
		

			
			if ( &isVowel($p) && $p ne "@" ) {
				$vowels .= $p . "-" ; 
				$sounds{$p}++ ; 
			}
		
		}			
	}

	foreach my $s ( keys %sounds ) {

		if( $sounds{$s} > 1 ) {
			
			if( $vowels =~ /$s-([a-z{@:]+-){0,2}$s/) {
				$assonance{$s}++ ;  
			}
			
		}
	
	}

	my @vowels = split( /-/ , $vowels ) ;

	foreach my $v ( @vowels ) {
	
		if( exists( $assonance{$v} ) ) {
			$pattern .= $v  ; 
		} else {
			$pattern .= "-" ; 
		}
		$pattern .= " " ; 
		
	}
	$pattern =~ s/ $//g; 	
	return $pattern ; 
	

}	



sub findAlliteration($) {

my $self = shift ;
my $line = shift ; 
my @alliteration ; 
my %sounds ; 
my %syllables ;



my $scheme ; 

$line =~ s/%/!/g; 


my @words = split( /\s/ , $line ) ; 


foreach my $w ( @words ) {

	#$w = "!" . $w ;

	my @syll = split( "-" , $w ) ;
	
	foreach my $s ( @syll ) {
		if ( $s =~ /^!/ ) {
			$syllables{ $s }++ ; 
		}
	}
	
}

foreach my $w ( keys %syllables ) {

my @phon = @{ &separatePhonemes( $w ) } ; 
$sounds{ $phon[0] }++ ; 


} 


 

		while ((my $key, my $s ) = each(%sounds)){
		
 
			if ( $s > 1 ) { 
			
				push ( @alliteration , $key ) ; 	
				
			}
		}
		

my $pattern = join( "|" , @alliteration ) ; 
		
		
my $add ; 

#$scheme .= $pattern ;
		
foreach my $w ( @words ) {
		
	if ( $pattern =~ /\w/ and $w =~ /[!]($pattern)/ ) {
		$scheme .= $1 . " "; 
	} else {
		$scheme .= "- " ;
	}
	

}

if ( scalar @words == 1) {
	$scheme = "-" ; 
}
	
if ( $scheme !~ /./ ) {
	$scheme = "-" ; 
}

$scheme =~ s/\s$//g; 

return $scheme ;

}




sub findAlliteration2($) {

my $self = shift ;
my $line = shift ; 
my @alliteration ; 
my %sounds ; 
my %syllables ;


my $scheme ; 

$line =~ s/%/!/g; 


my @words = split( /\s/ , $line ) ; 


foreach my $w ( @words ) {

	#$w = "!" . $w ;

	my @syll = split( "-" , $w ) ;
	
	foreach my $s ( @syll ) {
		#if ( $s =~ /^!/ ) {
			$syllables{ $s }++ ; 
		#}
	}
	
}

foreach my $w ( keys %syllables ) {

my @phon = @{ &separatePhonemes( $w ) } ; 
$sounds{ $phon[0] }++ ; 


} 


 

		while ((my $key, my $s ) = each(%sounds)){
		
 
			if ( $s > 1 ) { 
			
				push ( @alliteration , $key ) ; 	
				
			}
		}
		

my $pattern = join( "|" , @alliteration ) ; 
		
		
my $add ; 

#$scheme .= $pattern ;
		
foreach my $w ( @words ) {
		
	if ( $pattern =~ /\w/ and $w =~ /[!]($pattern)/ ) {
		$scheme .= $1 . " "; 
	} else {
		$scheme .= "- " ;
	}
	

}

if ( scalar @words == 1) {
	$scheme = "-" ; 
}
	
if ( $scheme !~ /./ ) {
	$scheme = "-" ; 
}

$scheme =~ s/\s$//g; 

return $scheme ;

}



	 
	
sub findEnjambment($) {

my %poem = %{$_[1]};
my @enjambment ; 



while ( my ($number,$line ) = each %poem ) {



if ( $line =~ /(^.*?[.!?;:])\s*[A-Za-z]+/ ) {

			if ( $poem{($number-1)} !~ /[.!?;:]$/) {			
				push( @enjambment , $number ) ;
			}
		
}

}	


@enjambment = sort { $a <=> $b } @enjambment; 
return @enjambment ;
	
}


sub findSimiles($) {

my $self = shift ;
my $line = shift ;

my $line = lc( $line ) ; 

	if ( $line =~ /like\sthese/i )
	{
		$line =~ s/like\sthese//ig;  ; 
	}
	if ( $line =~ /as\sit\sis/i )
	{
		$line =~ s/as\sit\sis//ig;  ; 
	}
	if ( $line =~ /as\sit\swere/i )
	{
		$line =~ s/as\sit\swere//ig;  ; 
	}	
	if ( $line =~ /catch\sas\scatch/i )
	{
		$line =~ s/catch\sas\scatch//ig;   
	}	
	if ( $line =~ /likes*\sto/i )
	{
		$line =~ s/likes*\sto//ig;   
	}		


unless ( ($line =~ /\slike\s/ ) or ($line =~ /\sas\s/ ) ) {
		return 0 ;  
}

}

sub wordFrequency(%) {

my %poem = %{$_[1]};
my %frequency ; 

while ( my ($number,$line ) = each %poem )
{
	my @words = &wordSegmentation( $line ) ;
	
	foreach my $w (@words) {
			
		$frequency{ lc($w) }++ ;
	}
}

return %frequency ;
}


sub countPhonemes($) {
	
	my $dir = shift ;

	print $dir . "\n\n" ; 
	
	opendir( DIR, $dir );
	my @dirs = readdir(DIR);
	closedir(DIR);
	
	my %phon ; 
	my $total ; 
	
	my @clusters ; 
	
	foreach my $d ( @dirs ) {
		if ( -d $dir . "\\" . $d and $d ne "." and $d ne ".." ) {
			
			opendir( VOL , $dir . "\\" . $d );
			my @files = readdir( VOL );
			
			foreach my $f ( @files ) {			
				if ( ( -f $dir . "\\" . $d . "\\" . $f ) and ( $f =~ /xml$/ )  ) {	

				

					my %poem = %{ $tei->read( $dir . "\\" . $d . "\\" . $f ) } ;	 
					foreach my $line ( keys %poem ) {
					
						
						
						#my @words = split( /\s/ , $rdf->getObject( $f . "#" . $line , "transcr") ) ; 
						my @words = () ; 
						
						foreach my $w ( @words ) {
						
							
							my @ph = @{ &separatePhonemes( $w ) } ;
							
							foreach my $p ( @ph ) {
							
								$p =~ s/["%]//g; 
								
								print $p . "\n" ; 
								$phon{ $p } ++ ; 
								$total++ ; 
							}
							print "\n" ; 
							
						}
						
					}

				}
			}
		}
	}
	
	foreach my $m ( keys %phon ) {
	
		
		$phon{ $m } = ( $phon{ $m } / $total ) ; 
		
	}
	
	return \%phon ; 
	
}


sub findAssonance($) {

	my $self = shift ;
	my $text = shift ;
	my %sounds ; 
	

	

		#print $text . "\n" ; 
		my @phon = &separatePhonemes( $text ) ;

		if ( @phon > 0 ) {
			foreach my $p ( @phon ) {
				$sounds{ $p}++ ; 
			}
		}
		
		foreach my $s ( keys %sounds ) {
			if ( $sounds{$s} > 2 ) {
				print "Assonance: " . $s.  "\n" ; 
			}
		}	
		
		#print "\n" ; 

}


sub getSeparatePhonemes($) {

	my $self = shift ; 
	my $text = shift ; 

	return separatePhonemes( $text ) ; 
}


sub separatePhonemes($) {

my $text = shift ; 
my @phonemes ; 

$text =~ s/\s// ;

my @chars = split ( // , $text ) ; 
my $flag_stress ; 

my $consonants = "bdfghjklmnprstvwzSZDT" ;
 
for (	my $i = 0 ; $i < @chars ; $i++ ) {

	if ( $chars[$i] eq "!" or $chars[$i] eq "%" ) {

		$chars[$i] = "" ; 
	} 
	
	
	if ( $chars[$i] eq "a" and $chars[$i+1] eq "U" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}

	elsif ( $chars[$i] eq "@" and $chars[$i+1] eq "U" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}	

	elsif ( $chars[$i] eq "a" and $chars[$i+1] eq ":" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}	
	
	elsif ( $chars[$i] eq "3" and $chars[$i+1] eq ":" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}		

	elsif ( $chars[$i] eq "i" and $chars[$i+1] eq ":" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}	
	
	elsif ( $chars[$i] eq "u" and $chars[$i+1] eq ":" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}		
	
	elsif ( $chars[$i] eq "O" and $chars[$i+1] eq ":" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}
	
	elsif ( $chars[$i] eq "e" and $chars[$i+1] eq "I" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}		

	elsif ( $chars[$i] eq "a" and $chars[$i+1] eq "I" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}
	
	elsif ( $chars[$i] eq "o" and $chars[$i+1] eq "I" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}	
	
	elsif ( $chars[$i] eq "@" and $chars[$i+1] eq "U" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}	

	elsif ( $chars[$i] eq "e" and $chars[$i+1] eq "@" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}		
	
	elsif ( $chars[$i] eq "I" and $chars[$i+1] eq "@" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}

	elsif ( $chars[$i] eq "U" and $chars[$i+1] eq "@" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}		
		
	## Consonants 
	
	elsif ( $chars[$i] eq "d" and $chars[$i+1] eq "Z" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}

	elsif ( $chars[$i] eq "t" and $chars[$i+1] eq "S" ) {
		push ( @phonemes , $chars[$i] . $chars[$i+1] ) ;
		$chars[$i+1] = "" ; 	
	}
	
	elsif( $chars[$i] =~ /[$consonants]/ ) {
		push ( @phonemes , $chars[$i] ) ;
	}
	
	elsif( $chars[$i] eq "{" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "@" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "V" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "I" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "e" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "Q" ) {
		push ( @phonemes , $chars[$i] ) ;
	} elsif( $chars[$i] eq "u" ) {
		push ( @phonemes , $chars[$i] ) ;
	}
	
}

return \@phonemes ;
}



sub countTypes($) {
	my $self = shift ; 
	my $line = shift ; 
	
	#print $line . "\n" ; 
	
	my $count ; 
	my $w = wordSegmentation( $line ) ; 
	foreach my $w ( @{ $w } ) {
		++$count ; 
	}

	#print $count . "\n" ; 
	return $count ; 
}


sub getWordSegmentation($) {
	my $self = shift ; 
	my $line = shift ;
	my $words = wordSegmentation( $line ) ; 
	return $words ; 
}

sub wordSegmentation($) {

my $line = shift ; 



$line =~ s/,//g; 
$line =~ s/\.//g; 
$line =~ s/\://g; 		

my @words;
my @candidates = split ( /\s+/ , $line ) ; 
		
foreach my $w ( @candidates ) {

		if ( $w =~ /(([a-zA-Z']+-)*[a-zA-Z']+)/ ) {
		
			#$w =~ s/[;.,'"]$//; 
			$w =~ s/[\(\)]//g ; 
			push ( @words , $w ) ; 
		}
			
}

return \@words ; 
}




sub commentOnSyllableLength(@) {

my %poem = %{$_[1]}; 


my %words ; 

my ( $nr , $ms ) ; 

while ( my ($number,$line ) = each %poem ) { 
	my @words = &wordSegmentation( $line ) ;
	foreach my $w (@words) {
		$words{$w}++ ;
	}
}

foreach my $w ( keys %words ) {
    $nr++ ;
		if ( length ( &stressPatternWord( $w ) ) == 1  ) {
		$ms++ ; 
	}
	
}


return ($ms/$nr) ; 

}





sub getMeterTr($) {
	my $self = shift ;
	my $text = shift ;
	my $meter ;
		
	my $words = &wordSegmentation( $text ) ;  
	

	foreach my $w ( @{ $words } ) {

	my @meter = split ( "-" , $w ) ;


	
	for	my $m ( @meter ) {
	
		if ( $m =~ /^'/) {
			$meter .= "X" ; 
		}
		else {
			$meter .= "-" ; 
		}
		
	}

	
	
	
	
	$meter .= "/" ; 
	}
	
	return $meter ;
}



sub findMeter($) {
	my $self = shift ;
	my $phon = shift ;
	$phon =~ s/%/!/g; 
	
	
	my $meter ;
	my $type ; 
	
	
#similar sounds in vowels

	
	my @words = @{ &wordSegmentation( $phon ) } ; 
	
	foreach my $w ( @words ) {
				
	my @meter = split ( "-" , $w ) ;
	
	for	my $m ( @meter ) {
		if ( $m =~ /!/) {
			$meter .= "X" ; 
		}
		else {
			$meter .= "-" ; 
		}
		
	}
	
	}
	
	my $type = "-" ; 
	
	if ( $meter =~ /^(-X|--X){3}$/ and $meter !~ /^(--X){3}$/ ) {
		$type = "iambicTrimeter" ;
	} elsif ( $meter =~ /^(-X|--X){4}$/ and $meter !~ /^(--X){4}$/ ) {
		$type = "iambicTetrameter" ;
	} elsif ( $meter =~ /^(-X|--X){5}$/ and $meter !~ /^(--X){5}$/ ) {
		$type = "iambicPentameter" ;
	} elsif ( $meter =~ /^(-X|--X){6}$/ and $meter !~ /^(--X){6}$/ ) {
		$type = "iambicHexameter" ;
	} elsif ( $meter =~ /^(-X|--X){7}$/ and $meter !~ /^(--X){7}$/ ) {
		$type = "iambicSeptameter" ;
	} elsif ( $meter =~ /^(-X|--X){8}$/ and $meter !~ /^(--X){8}$/ ) {
		$type = "iambicOctameter" ;
	} elsif ( $meter =~ /^(-X|--X){3}(-|X)$/ and $meter !~ /^(--X){3}(-|X)$/ ) {
		$type = "catalecticIambicTrimeter" ;
	} elsif ( $meter =~ /^(-X|--X){4}(-|X)$/ and $meter !~ /^(--X){4}(-|X)$/ ) {
		$type = "catalecticIambicTetrameter" ;
	} elsif ( $meter =~ /^(-X|--X){5}(-|X)$/ and $meter !~ /^(--X){5}(-|X)$/ ) {
		$type = "catalecticIambicPentameter" ;
	} elsif ( $meter =~ /^(-X|--X){6}(-|X)$/ and $meter !~ /^(--X){6}(-|X)$/ ) {
		$type = "catalecticIambicHexameter" ;
	} elsif ( $meter =~ /^(-X|--X){7}(-|X)$/ and $meter !~ /^(--X){7}(-|X)$/ ) {
		$type = "catalecticIambicSeptameter" ;
	} elsif ( $meter =~ /^(-X|--X){8}(-|X)$/ and $meter !~ /^(--X){8}(-|X)$/ ) {
		$type = "catalecticIambicOctameter" ;
	} 
	
	elsif ( $meter =~ /^(X-|X--){3}$/ and $meter !~ /^(X--){3}$/ ) {
		$type = "trochaicTrimeter" ;
	} elsif ( $meter =~ /^(X-|X--){4}$/ and $meter !~ /^(X--){4}$/ ) {
		$type = "trochaicTetrameter" ;
	} elsif ( $meter =~ /^(X-|X--){5}$/ and $meter !~ /^(X--){5}$/ ) {
		$type = "trochaicPentameter" ;
	} elsif ( $meter =~ /^(X-|X--){6}$/ and $meter !~ /^(X--){6}$/ ) {
		$type = "trochaicHexameter" ;
	} elsif ( $meter =~ /^(X-|X--){7}$/ and $meter !~ /^(X--){7}$/ ) {
		$type = "trochaicSeptameter" ;
	} elsif ( $meter =~ /^(X-|X--){8}$/ and $meter !~ /^(X--){8}$/ ) {
		$type = "trochaicOctameter" ;
	} elsif ( $meter =~ /^(X-|X--){3}(X|-)$/ and $meter !~ /^(X--){3}(X|-)$/ ) {
		$type = "catalecticTrochaicTrimeter" ;
	} elsif ( $meter =~ /^(X-|X--){4}(X|-)$/ and $meter !~ /^(X--){4}(X|-)$/ ) {
		$type = "catalecticTrochaicTetrameter" ;
	} elsif ( $meter =~ /^(X-|X--){5}(X|-)$/ and $meter !~ /^(X--){5}(X|-)$/ ) {
		$type = "catalecticTrochaicPentameter" ;
	} elsif ( $meter =~ /^(X-|X--){6}(X|-)$/ and $meter !~ /^(X--){6}(X|-)$/ ) {
		$type = "catalecticTrochaicHexameter" ;
	} elsif ( $meter =~ /^(X-|X--){7}(X|-)$/ and $meter !~ /^(X--){7}(X|-)$/ ) {
		$type = "catalecticTrochaicSeptameter" ;
	} elsif ( $meter =~ /^(X-|X--){8}(X|-)$/ and $meter !~ /^(X--){8}(X|-)$/ ) {
		$type = "catalecticTrochaicOctameter" ;
	}

	elsif ( $meter =~ /^(--X){3}$/ ) {
		$type = "anapesticTrimeter" ;
	} elsif ( $meter =~ /^(--X){4}$/) {
		$type = "anapesticTetrameter" ;
	} elsif ( $meter =~ /^(--X){5}$/) {
		$type = "anapesticPentameter" ;
	} elsif ( $meter =~ /^(--X){6}$/) {
		$type = "anapesticHexameter" ;
	} elsif ( $meter =~ /^(--X){7}$/) {
		$type = "anapesticSeptameter" ;
	} elsif ( $meter =~ /^(--X){8}$/) {
		$type = "anapesticOctameter" ;
	} elsif ( $meter =~ /^(X-|X--){3}(X|-)$/  ) {
		$type = "catalecticAnapesticTrimeter" ;
	} elsif ( $meter =~ /^(--X){4}(X|-){1,2}$/) {
		$type = "catalecticAnapesticTetrameter" ;
	} elsif ( $meter =~ /^(--X){5}(X|-){1,2}$/) {
		$type = "catalecticAnapesticPentameter" ;
	} elsif ( $meter =~ /^(--X){6}(X|-){1,2}$/) {
		$type = "catalecticAnapesticHexameter" ;
	} elsif ( $meter =~ /^(--X){7}(X|-){1,2}$/) {
		$type = "catalecticAnapesticHexameter" ;
	} elsif ( $meter =~ /^(--X){8}(X|-){1,2}$/) {
		$type = "catalecticAnapesticHexameter" ;
	}		


	elsif ( $meter =~ /^(X--){3}$/ ) {
		$type = "dactylicTrimeter" ;
	} elsif ( $meter =~ /^(X--){4}$/) {
		$type = "dactylicTetrameter" ;
	} elsif ( $meter =~ /^(X--){5}$/) {
		$type = "dactylicPentameter" ;
	} elsif ( $meter =~ /^(X--){6}$/) {
		$type = "dactylicHexameter" ;
	} elsif ( $meter =~ /^(X--){7}$/) {
		$type = "dactylicSeptameter" ;
	} elsif ( $meter =~ /^(X--){8}$/) {
		$type = "dactylicOctameter" ;
	} elsif ( $meter =~ /^(X--){3}(X|-)$/  ) {
		$type = "catalecticDactylicTrimeter" ;
	} elsif ( $meter =~ /^(X--){4}(X|-){1,2}$/) {
		$type = "catalecticDactylicTetrameter" ;
	} elsif ( $meter =~ /^(X--){5}(X|-){1,2}$/) {
		$type = "catalecticDactylicPentameter" ;
	} elsif ( $meter =~ /^(X--){6}(X|-){1,2}$/) {
		$type = "catalecticDactylicHexameter" ;
	} elsif ( $meter =~ /^(X--){7}(X|-){1,2}$/) {
		$type = "catalecticDactylicHexameter" ;
	} elsif ( $meter =~ /^(X--){8}(X|-){1,2}$/) {
		$type = "catalecticDactylicHexameter" ;
	}
	
	return  $type  ; 
	
}





sub replace($$$) {
	my $string = shift ; 
	my $find = shift ;
	my $replace = shift ;
	$string =~ s/$find/$replace/g;
	return $string ; 
}



sub wordFrequencyBook($) {

my $self = shift ;
my $dir = shift ;

my %frequencyBook ;

	opendir( DIR, $dir );
	my @files = readdir(DIR);
	closedir(DIR);

foreach my $file (@files) {

	if ( -f $dir . "\\" . $file ) {
	my %frequency = () ; 
	my %poem = %{ $tei->read( $dir . "\\" . $file ) } ;	 

	%frequency = $self->wordFrequency( \%poem ) ; 

			foreach my $w ( keys %frequency ) {
				$frequencyBook{$w} += $frequency{$w} ;
			}

	}
}


return %frequencyBook ;

}


sub inverseDocumentFrequency($) {


#The formula is the log of N (Total number of ducments) divided by Nt (Documents in which the term occurs). The more common a term, The lower its value in IDF
#Steps:
#Define number of clusters
#Create a list of all words
#For each word: check the number in which it appears.

#Calculate log of N / Nt 

	my $self = shift ;
	my $dir = shift ;

	opendir( DIR, $dir );
	my @dirs = readdir(DIR);
	closedir(DIR);
	
	my %dict ; 
	my %VolsDict ;
	
	my @clusters ; 
	
	foreach my $d ( @dirs ) {
		if ( -d $dir . "\\" . $d and $d ne "." and $d ne ".." ) {
			push ( @clusters , $d ) ;
			
			opendir( VOL , $dir . "\\" . $d );
			my @files = readdir( VOL );
			
			foreach my $f ( @files ) {		
				
				if ( ( -f $dir . "\\" . $d . "\\" . $f ) and ( $f =~ /xml$/ )  ) {	
				
				my %poem = %{ $tei->read( $dir . "\\" . $d . "\\" . $f ) } ;	 
					foreach my $line ( keys %poem ) {
						my @words = @{ &wordSegmentation( $poem{$line} ) } ; 
						foreach my $w ( @words ) {
							$dict{ lc($w) }++ ; 
							$VolsDict{ $d }{ lc($w) }++ ;
						}
					}
				}
				
				
			}
			
			closedir( VOL );
		}
	}
	
	my $occurs ;
	my $nrClusters ; 
	
	my %idf ; 
	
	foreach my $word ( sort keys %dict ) {
	
		$nrClusters = 0 ; 
		
		
	
		foreach my $c ( @clusters ) {
			$occurs = 0 ; 
			if ( exists ( $VolsDict{ $c }{ $word } ) ) {
				$occurs++ ;
			}
			if ( $occurs > 0 ) {
				$nrClusters++ ; 
			}
			
		}
	


	my $NdivNt =  8 / $nrClusters ; 
	my $idf = log10( $NdivNt ) ;
	$idf{ $word } = $dict{ $word } * $idf ; 
	
	}	
	
	foreach my $word ( sort keys %idf ) {
	
		
		print $word . " => " . $idf{ $word } . ", normal frequency: " . $dict{ $word } . "\n" ; 
	}
	

		


}


sub inverseDocumentFrequency2($) {

	my $self = shift ;
	my $dir = shift ;
	
	my ( $N , %df ) ;
	
	opendir( DIR, $dir );
	my @files = readdir(DIR);
	closedir(DIR);
	
	my %allWords = $self->wordFrequencyBook( $dir ) ; 
	
	foreach my $word ( keys %allWords ) {
		#print $word . "\n" ; 
		
		foreach my $poem ( @files ) {
		
			my %wordsPoem = () ;
			if ( -f $dir . "\\" . $poem ) { 
			
				
				my %poem = %{ $tei->read( $dir . "\\" . $poem ) } ;	 
				%wordsPoem = $self->wordFrequency( \%poem ) ; 
				if ( exists( $wordsPoem{$word} ) )	{
					$df{$word}++ ; 
				}
			}
		}
		
		#print "Occurs in " . $df{$word} . " poems.\n" ; 		
		
	}	
	
	
	foreach my $poem ( @files ) {
			if ( $poem ne "." and $poem ne "..") { 	
				$N++ ; 
			}
	}
	
	

	
	foreach my $poem ( @files ) {
			if ( $poem ne "." and $poem ne "..") { 
			
			#print $poem . "\n" ; 
			
				my %wordsPoem = () ; my %idf = () ;
				my %freq = () ;

				my %poem = %{ $tei->read( $dir . "\\" . $poem ) } ;	 
				%wordsPoem = $self->wordFrequency( \%poem ) ; 
				%freq = $self->wordFrequency( \%poem ) ; 
				
				foreach my $word (sort {$freq{$a} <=> $freq{$b} }
					keys %freq ) {
	
					#print $word . " occurs " . $freq{$word} . " times in poem and " . $df{$word} . " times in corpus of " . $N . " .\n"  ; 
					$idf{$word} = $freq{$word} * ( $N / $df{$word} ) ; 
				}
				
				foreach my $idf (sort {$idf{$a} <=> $idf{$b} }
					keys %idf ) {
					my $value = sprintf( "%.3f" , $idf{$idf} ) ;
					print $idf . " => " . $value . "\n" ; 
				}
				
			}
	}
	
	
}







sub findImages ( $line ) {

my $self = shift ; 
my $line = shift ;

my $line = lc( $line ) ; 

my @images ; 

				if ( $line =~ /quest/ ) {
					push ( @images, "http://dbpedia.org/resource/Quest" ) ; 
				}
				if ( $line =~ /wood/ ) {
					push ( @images, "http://dbpedia.org/resource/Wood" ) ; 
				}	
				if ( $line =~ /train/ ) {
					push ( @images, "http://dbpedia.org/resource/Train" ) ; 
				}					
				if ( $line =~ /taxi/ ) {
					push ( @images, "http://dbpedia.org/resource/Taxi" ) ; 
				}
				if ( $line =~ /stair/ ) {
					push ( @images, "http://dbpedia.org/resource/Stairway" ) ; 
				}
				if ( $line =~ /river/ ) {
					push ( @images, "http://dbpedia.org/resource/River" ) ; 
				}	
				if ( $line =~ /thread/ ) {
					push ( @images, "http://dbpedia.org/resource/Thread" ) ; 
				}					
				if ( $line =~ /stone/ ) {
					push ( @images, "http://dbpedia.org/resource/Stone" ) ; 
				}					
				if ( $line =~ /desert/ ) {
					push ( @images, "http://dbpedia.org/resource/Desert" ) ; 
				}					
				if ( $line =~ /wind/ ) {
					push ( @images, "http://dbpedia.org/resource/Wind" ) ; 
				}
				if ( $line =~ /sea/ ) {
					push ( @images, "http://dbpedia.org/resource/Sea" ) ; 
				}
				if ( $line =~ /tree/ ) {
					push ( @images, "http://dbpedia.org/resource/Tree" ) ; 
				}
				if ( $line =~ /bell/ ) {
					push ( @images, "http://www.w3.org/2006/03/wn/wn20/instances/word-church_bell.rdf" ) ; 
				}				
	return \@images ; 
}				


sub serialise ($$$) {

my $self = shift ; 
my $subject = shift ; 
my $predicate = shift ;
my $object = shift ;

my $return = "\n<statement>"; 
$return .= "\n\t<subject>" . $subject . "</subject>" ; 
$return .= "\n\t<predicate>" . $predicate . "</predicate>" ;
$return .= "\n\t<object>" . $object . "</object>" ; 
$return .= "\n</statement>" ;

return $return ; 
 
}


sub getLine($) {
	my $self = shift ; 
	my $lineNumber = shift ; 	
	return $self->{poem}{$lineNumber} ; 
}

sub sortArray($){

	my @array = @{ $_[0] } ; 
	@array = sort { $a <=> $b } @array ; 
	
	return @array ; 
}
	
1;  # so the require or use succeeds
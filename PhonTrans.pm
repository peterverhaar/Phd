package PhonTrans ; 


#use Encode;
use strict ;
#use Lingua::EN::Tagger ;


	#my $KIT = "&#x26A;" ; 
	my $KIT = "I" ; 	
	my $DRESS = "e" ; 
	#my $TRAP = "&#xE6;" ; 
	my $TRAP = "{" ; 
	#my $LOT = "&#x252;" ;
	my $LOT = "Q" ;	
	#my $FOOT = "&#x28A;" ; 
	my $FOOT = "U" ; 	
	#my $STRUT = "&#x28C;" ; 
	my $STRUT = "V" ; 
	#my $SCHWA = "&#x259;" ; 
	my $SCHWA = "@" ; 
	#my $FLEECE = "&#x69;:";
	my $FLEECE = "i:";
	#my $PALM = "&#x251;:" ;
	my $PALM = "a:" ;	
	#my $THOUGHT = "&#x254;:" ; 
	my $THOUGHT = "O" ; 
	#my $GOOSE = "&#x75;:" ; 
	my $GOOSE = "u" ; 	
	#my $NURSE = "&#x25C;:" ; 
	my $NURSE = "3" ; 
	my $FACE = $DRESS . $KIT ; 
	my $PRICE = "a" . $KIT ; 
	my $CHOICE = "OI" ;
	my $MOUTH = "a" . $FOOT ; 
	my $GOAT = $SCHWA . $FOOT ;
	my $NEAR = $KIT . $SCHWA ;
	my $CURE = $GOOSE . $SCHWA ; 
	my $SQUARE = "E" . $SCHWA  ;
	
my @onomatopoeia ;	
	




sub new() {

	my $self  = {};	
	bless($self);     
	return $self;
}



sub findOnomatopoeia($) {

my $self = shift ;
my $line = shift ; 

$line = lc ( $line ) ;
$line =~ s/[\(\)-\\\/\']//g;


my $found = 0 ; 

my @words = split ( /\s+/ , $line) ;

foreach my $w ( @words ) {


	foreach my $o ( @onomatopoeia ) {
		

		if ( $o eq $w ) {
			$found = 1; 		
		}
		
		my $conjug ; 
		
		$conjug = $o . "s" ; 

		if ( $conjug eq $w ) {
			$found = 1; 			
		}	

		if ( $o =~ /e$/) {
			$o =~ s/e$//g; 
		}

		$conjug = $o . "ed" ; 

		if ( $conjug eq $w ) {
			$found = 1; 		
		}	
		
		my $double ; 
		if ( $o =~ /([lmnp])$/) {
			$double = $1 ;
		}	
		
		$conjug = $o . $double . "ing" ; 

		if ( $conjug eq $w ) {
			$found = 1; 		
		}
		
	}
		
}



return $found ;

}


sub findAlliteration($) {

my $self = shift ;
my $line = shift ; 
my @alliteration ; 
my %sounds ; 

## remove repeated words! 

my @chars = split ( // , $line ) ;

for ( my $i = 0 ; $i < @chars ; $i++ ) {


	if ( ($chars[ $i ] =~ /\"/) or  ($chars[ $i ] =~ /\%/) ) {
		
		$sounds{ $chars[ $i+1 ] }++ ; 
		
	}

} 


		
		while ((my $key, my $s ) = each(%sounds)){
			if ( $s > 1 ) { push ( @alliteration , $key ) }
		}
		


return @alliteration ; 

}


	 
			 
sub findAlliteration_IPA($) {

my $self = shift ;
my $line = shift ; 
my @alliteration ; 
				
my @first = split ( /\s/ , $line ) ;
my %sounds ; 
my $sound ; 
		
		foreach my $f ( @first ) {
		
			$sound = "" ; 
		
			if ( $f =~ /-/) {
			
				my @syll = split ( "-" , $f ) ;
				foreach my $s ( @syll ) {
					if ( $s =~ /^'/) {
						$sound = substr( $s , 1 , 1 ) ; 
					}
					if ( substr( $s , 2 , 1 ) eq ":" ) {
						$sound .= ":" ; 
					}
					if ( substr( $s , 2 , 1 ) eq "S" ) {
						$sound .= "S" ; 
					}					
				}	
						
			}
			else
			{	
				if ( $f =~ /^'/) {

					$sound = substr( $f , 1 , 1 ) ;
					if ( substr( $f , 2 , 1 ) eq ":" ) {
						$sound .= ":" ; 
					}	
					if ( substr( $f , 2 , 1 ) eq "S" ) {
						$sound .= "S" ; 
					}	

				}	
			}
			
			if ( $sound =~ /\w/ ) {
				$sounds{ $sound }++ ;
			} 
			
			 
			
		}
		

		
		while ((my $key, my $s ) = each(%sounds)){
			if ( $s > 1 ) { push ( @alliteration , $key ) }
		}
		


return @alliteration ; 

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

my @similes ; 

	if ( ($line =~ /\slike\s/) or ($line =~ /\sas\s/) ) {
		push ( @similes , $line ) ; 
	}

return @similes ; 
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


sub findAssonance($) {

	my $self = shift ;
	my $text = shift ;
	my %sounds ; 

		print $text . "\n" ; 
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
		
		print "\n" ; 

}



sub separatePhonemes($) {

my $text = shift ; 
my @phonemes ; 

my @chars = split ( // , $text ) ; 
my $flag_stress ; 

my $consonants = "bdfghjklmnprstvw" ;
 
for (	my $i = 0 ; $i < @chars ; $i++ ) {

	if ( $chars[$i] eq "\"" or $chars[$i+1] eq "%" ) {
		$flag_stress  = 1 ;	
		$chars[$i] = "" ; 
	}
	elsif ( $flag_stress == 1 ) {
		#$chars[$i] = "\"" . $chars[$i] ;  
		$flag_stress = 0 ; 
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
	
	elsif ( $chars[$i] =~ /\w/ or $chars[$i] =~ /\{/ or $chars[$i] =~ /\@/ )  {
		push ( @phonemes , $chars[$i] ) ;
	}
	

}

return @phonemes ;
}



sub countTypes($) {
	my $self = shift ; 
	my $line = shift ; 
	
	print $line . "\n" ; 
	
	my $count ; 
	my $w = wordSegmentation( $line ) ; 
	foreach my $w ( @{ $w } ) {
		++$count ; 
	}

	print $count . "\n" ; 
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
			#$w =~ s/^[;.,'"]//; 
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


sub stressPatternWord($) {

	my $word = shift ; 
	chomp( $word ) ; 
	
	$word =~ s/ed$//g; 

	my $stress ;
		
	my @chars = split ( // , $word ) ;

	my ( $syll, @syll ) ; 
	
	
	if ( $chars[0] eq "y" )
	{
		$chars[0] = "j" ; 
	}


	
	for ( my $i = 0 ; $i < ( @chars ) ; $i++ ) {
	
		
				
		if ( $chars[$i] =~ /[aeoiuy]/)
		{
			$syll .= $chars[$i] ; 
		}
		elsif ( $chars[$i-1] =~ /[aeoiu]/)
		{
			if ($syll =~ /\w/ ) { push ( @syll , $syll ) } ;
			$syll = $chars[$i] ; 	
		}
		else
		{
			$syll .= $chars[$i] ; 
		}

		if ( $i==( @chars-1) )  
		{
			if ( ($syll =~ /[aeoiuy]/) and ( $syll !~ /e$/) )
			{
				push ( @syll , $syll ) ;
			}
			else
			{
				if ( @syll[-1] ) { @syll[-1] .= $syll } else { push ( @syll , $syll ) ; }  ; 
			}
			
		}
	}
	

	

	
	my $stressed = 1 ; 
	
	if ( @syll < 3 )
	{
		if ( &containsPrefix( $syll[0]) )
		{
			$stressed = 2 ;
		}
		else
		{
			$stressed = 1 ; 
		}
	}
	else
	{
		$stressed = @syll - 2 ;  
	}
	
	for ( my $i = 0 ; $i < @syll ; $i++ ) {
	
		if ( ($i+1) == $stressed ) { $stress .= "X" ; }
		else { $stress .= "-" ; }
	
	}
	
	if ( length( $word ) <= 3 ) {
		$stress = "-" ;
	}
	
	return $stress ; 	
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



sub getMeter($) {
	my $self = shift ;
	my $text = shift ;
	my $meter ;

	#print "TEST" ; 
	#print $text . "\n" ;
	
	my @words = split ( "\s" , $text ) ; 
	
	foreach my $w ( @words ) {
				
	my @meter = split ( "-" , $w ) ;
	
	for	my $m ( @meter ) {
		if ( $m =~ /'/) {
			$meter .= "X" ; 
		}
		else {
			$meter .= "-" ; 
		}
		
	}
	
	}
	return $meter ;
}



sub getPhoneticTranscription($) {
	my $self = shift ;
	my $text = shift ;
	return &phoneticTranscription( $text ) ; 
}

sub replace($$$) {
	my $string = shift ; 
	my $find = shift ;
	my $replace = shift ;
	$string =~ s/$find/$replace/g;
	return $string ; 
}

sub phoneticTranscription($) {


	my $text = lc( shift ) ; 	
 
	
	my @words = split(" ", $text) ; 
	
	my $transcription ;
	
	foreach my $word ( @words ) {
	$word =~ s/\W//g; 
	
	if ( &checkExceptions($word) !~ /\D/ )
	{
	
	my $prefix = &containsPrefix( $word ) ; 
	
	## Define vowels
	

		
	my $replace ; 
	my $consonants = "bcdfghjklmnpqrstvwxz" ; 


	# ENDINGS
	$word =~ s/ed$/d/g; 	

	
	######
	## $FLEECE 


	#committee
	$word =~ s/ttee$/t$KIT/g ;
	
	#$NEAR : -eer, -ear, ier


	# before D: $DRESS
	$word =~ s/oo(n)/$GOOSE$1/g ;	
	$word =~ s/oo(s)e/$GOOSE$1/g ;	
	$word =~ s/^u(s)e$/$GOOSE$1/g ;	
	
	##here
	$word =~ s/ere$/$NEAR/g ;	
	## beer, dear
	$word =~ s/e[ea]r$/$NEAR/g ;
	$replace = $NEAR . "z" ; 
	$word =~ s/e[ea]rs$/$replace/g ;

	# before D: $DRESS
	$word =~ s/ea(d)$/$DRESS$1/g ;		

	$word =~ s/^ear(\w)/$NURSE$1/g ;	
	
	## tea, knee, east, eel
	$word =~ s/e[ea]([$consonants]*)$/$FLEECE$1/g ;
	$word =~ s/^([$consonants]*)e[ea]/$1$FLEECE/g ;
	
	## freeze seize
	$replace = $FLEECE . "z" ; 
	$word =~ s/e[ei]ze/$replace/g ; 

	## receive
	$replace = $FLEECE . "v" ; 
	$word =~ s/eive/$replace/g ;

	## believe
	$replace = $FLEECE . "v" ; 
	$word =~ s/ieve/$replace/g ;  	
	
	## $NEAR: fierce, windier
	$word =~ s/([$consonants]*)ier/$1$NEAR/g ;	
	
	$word =~ s/ie(d?)$/$PRICE$1/g; 	
	
	## brief
	$word =~ s/ie([$consonants]*)$/$FLEECE$1/g ;
	$word =~ s/^([$consonants]*)ie/$1$FLEECE/g ;		
	
	## meter
	$replace = $FLEECE . "t" . $SCHWA ; 
	$word =~ s/eter$/$replace/g; 
	
	## these
	$replace = $FLEECE . "z" ; 
	$word =~ s/ese$/$replace/g; 
	$replace = $FLEECE . "k" ; 	
	
	#tecnhique
	$word =~ s/ique$/$replace/g ;
	
	#magazine
	$replace = "z" . $FLEECE . "n" ; 
	$word =~ s/zine$/$replace/g ;



	$word =~ s/ire/$PRICE$SCHWA/g ;	
	$word =~ s/yer/$PRICE$SCHWA/g ;		
	
	## PRICE
	
	# ride tide crime die pie high find cry why 

	$replace = $CHOICE . "z" ; 
	$word =~ s/oise/$replace/g ;	
	$word =~ s/oy$/$CHOICE/g ;	

	$word =~ s/ower$/$MOUTH$SCHWA/g ;	
	
	$word =~ s/i([dmst])e$/$PRICE$1/g; 

	$word =~ s/igh/$PRICE/g; 
	$word =~ s/i(nd)$/$PRICE$1/g; 	
	$word =~ s/^([$consonants]*)y$/$1$PRICE/g; 		
	
	######
	## KIT
	
	#it with slick 
	$word =~ s/([$consonants])i([$consonants]*)$/$1$KIT$2/g ;
	$word =~ s/^([$consonants]*)i([$consonants])/$1$KIT$2/g ;

	#rhythm city
	$word =~ s/([$consonants])y([$consonants]*)$/$1$KIT$2/g ;
	$word =~ s/^([$consonants]*)y([$consonants])/$1$KIT$2/g ;

	#obey
	$word =~ s/(b)ey$/$1$FACE/g ;
	
	#donkey
	$word =~ s/ey$/$KIT/g ;

	## FOOT
	#foot book cook look good hood bull push 
	$word =~ s/oo(k)/$FOOT$1/g ;
	$word =~ s/oo(d)/$FOOT$1/g ;	
	$word =~ s/ul(l)/$FOOT$1/g ;	
	$word =~ s/u(sh)/$FOOT$1/g ;	
	$word =~ s/oo(t)/$FOOT$1/g ;	

	$word =~ s/aw(l)/$THOUGHT$1/g; 	
	

	######
	## FACE
	
	## Before R: SQUARE
	$word =~ s/air$/$SQUARE/g ;	
	$word =~ s/are$/$SQUARE/g ;		

	## dance chance
	$replace = $PALM . "ns" . $KIT . "z" ; 
	$word =~ s/ances/$replace/g ;

	$replace = $PALM . "ns" ; 
	$word =~ s/ance/$replace/g ;

	
	$word =~ s/([$consonants]+)y/$1$PRICE/g ;	
	$word =~ s/^i([$consonants]+)/$PRICE$1/g ;		
	
	#gate face taste
	$replace = $FACE . "s" ;
	$word =~ s/ace$/$replace/g ;
	$word =~ s/a([$consonants]*)e$/$FACE$1/g ;
	
	#say may brain always
	$word =~ s/a[yi]([$consonants]*)$/$FACE$1/g ;
	$word =~ s/^([$consonants]*)q[yi]/$1$FLEECE/g ;	
	
	#feint eight 
	$word =~ s/ei([$consonants]*)$/$FACE$1/g ;

	## NEAR
	# hideous various
	$word =~ s/[ie]ou(s)$/$NEAR$1/g ;	

	## CURE
	#pure cure 
	$word =~ s/([$consonants]+)ure/$1$CURE/g ;	
	$word =~ s/ure$/$SCHWA/g ;	
	
	## DRESS
	
	# pet bet
	$word =~ s/([$consonants])e([$consonants]*)/$1$DRESS$2/g ;
	
	## PALM

	$word =~ s/al(l)/$THOUGHT$1/g; 
	
	# after craft calm, drama command, chant, card, task, fast, gasp, glass, bath
	$word =~ s/a([flm])/$PALM$1/g ;		
	$word =~ s/a(nt)/$PALM$1/g ;	
	$word =~ s/^([$consonants]+)ar(d)?/$1$PALM$2/g ;		

	$word =~ s/o[au]r(t?)$/$THOUGHT$1/g; 
	
	$word =~ s/([dr])[oe]([mn])(s?)$/$1$SCHWA$2$3/g ;	
	
	$word =~ s/oa([$consonants]+)$/$GOAT$1/g; 

	$word =~ s/a(s[ktps])/$PALM$1/g; 
	$replace = $PALM . "&#x3B8;" ;
	$word =~ s/a(th)/$replace/g ;		
	
	## TRAP
	$word =~ s/aw$/$THOUGHT/g; 
	$word =~ s/^(w)a([st])/$1$LOT$2/g ;		
	$word =~ s/^(w)ar/w$THOUGHT/g; 
	$word =~ s/^quar/kw$THOUGHT/g; 	
	
	$word =~ s/^([$consonants]+)a([$consonants]*)/$1$TRAP$2/g ;	
	$word =~ s/([$consonants]+)a(nd)$/$1$PALM$2/g ;	
	
	## SQUARE
	
	#care stare
	$word =~ s/([$consonants])are/$1$SQUARE/g ;		
	
	## $NURSE
	
	# her earth third church 
	$word =~ s/er$/$NURSE/g ;	

	$word =~ s/ir([$consonants]*)$/$NURSE$1/g ;		
	$word =~ s/ur([$consonants]*)$/$NURSE$1/g ;			



	
	## SCHWA 
	
	# particular dinner doctor colour figure camera resist 

	$word =~ s/[aeo]r$/$SCHWA/g ;	
	$word =~ s/our$/$SCHWA/g ;		
	
	$word =~ s/(r)a$/$1$SCHWA/g ;		
	$word =~ s/^(r)e/$1$SCHWA/g; 

	## STRUT 
	
	# sun cut dull
	$word =~ s/^([$consonants]*)u([$consonants]+)/$1$STRUT$2/g ;	

	
	
	
	## MOUTH 
	#mouse round brown now
	$word =~ s/ou(s)e/$MOUTH$1/g ;
	$word =~ s/^([$consonants]*)ou/$1$MOUTH/g ;	

	## THOUGHT
	
	## port horse support snort order law saw fought more floor boar four court hall all small

	$word =~ s/ough(t)$/$THOUGHT$1/g; 	
	$word =~ s/ore?/$THOUGHT/g; 
	$word =~ s/oor$/$THOUGHT/g; 
	
	$word =~ s/o[au]/$THOUGHT/g; 		
	$word =~ s/al(l)$/$THOUGHT$1/g; 
	$word =~ s/aw(l)$/$THOUGHT$1/g; 


	
	## GOAT
	
		


	# go stroll home joke road toast toe goes mould though shoulder know 

	$word =~ s/^([dpb])o/$1$LOT/g ;

	$word =~ s/o([$consonants]*)$/$GOAT$1/g ;	
	$word =~ s/o([$consonants]+)e/$GOAT$1/g; 
	$word =~ s/o[aeu]/$GOAT/g; 
	$word =~ s/([rl])ow/$1$GOAT/g; 	

	$word =~ s/ow/$MOUTH/g ;	
	


	## LOT

	$word =~ s/o?ore?/$THOUGHT/g ;	

	## dog pot body want watch squander quality
	$word =~ s/^([$consonants]*)o([$consonants])/$1$LOT$2/g ;		
	$word =~ s/^(w)a/$1$LOT/g; 
	$replace = "kw" . $LOT ; 
	$word =~ s/^(s?)qua/$1$replace/g; 	
	
	## CHOICE 
	#noise poise boy toy
	$word =~ s/o[iy]/$CHOICE/g ;		
	
	




	
	

	

	## consonants
	

	$word =~ s/ch/tS/g; 	



	$word =~ s/ght/t/g ;
	$word =~ s/gh$/f/g ;	


	## &#x26E;

	$word =~ s/esce/esse/g; 
	$word =~ s/^kn/n/g; 	
	$word =~ s/^wh/w/g; 
	$word =~ s/ck/k/g; 	
	
	$word =~ s/^th/D/g; 	
	$word =~ s/th$/D/g; 		
	$word =~ s/th/D/g; 		

	$word =~ s/^c$KIT/s$KIT/g; 
	$word =~ s/cce/kse/g; 
	
	$word =~ s/^c/k/g; 
	$word =~ s/qu/kw/g; 
	$word =~ s/ng/N/g; 	
	$word =~ s/sh/S/g; 
	
	$word =~ s/ze$/z/g; 		
	$word =~ s/ve$/v/g; 
	$word =~ s/^y/j/g; 

	$word =~ s/ge$/dZ/g; 

	if ( $word !~ /eg$/) {
	$word =~ s/g$/dZ/g; } 
	
	$word =~ s/rh/r/g; 	
	$word =~ s/ect/ekt/g; 	
	$word =~ s/x/ks/g; 		
	$word =~ s/&#ks/&#x/g; 			

	$word =~ s/kk/k/g; 
	$word =~ s/ss/s/g; 
	$word =~ s/mm/m/g;
	$word =~ s/pp/p/g;	
	$word =~ s/bb/b/g;		
	$word =~ s/tt/t/g;
	$word =~ s/rr/r/g;
	$word =~ s/ll/l/g;


	## syllables
	
	my @letters = ();
	my ( $char, $temp ) ; 
	
	while ( length($word) > 0 )
	{
		my $char = substr( $word , 0 , 1 ) ;
		
		if ( $char eq "&" )
		{
			$temp = substr ( $word , 0 , ( index($word, ";") + 1 ) ) ;
			push ( @letters, $temp) ; 
			$word = substr ( $word , ( index($word, ";") + 1 ) , length($word) ) ;			
		}
		elsif( $char eq ":") {	
			if ( $letters[-1] ) {
			$letters[-1] .= $char ; }
			$word = substr( $word , 1 , length($word) ) ; 				
		}
		else {
			push ( @letters , $char ) ; 
			$word = substr( $word , 1 , length($word) ) ; 
		}
		
	}
	
	my $consonants = "b". "c". "d" . "f". "g". "h". "j". "k". "l". "m". "n". "p". "q". "r". "s". "t". "v". "w". "x". "z" ; 
	$consonants .= "&#x283;" ; 
	$consonants .= "&#x292;" ; 
	$consonants .= "&#x14B;" ; 
	$consonants .= "&#x283;" ; 	
	$consonants .= "&#xF0;" ;  		
	$consonants .= "&#x3B8;" ; 	
	
			
	my ( $word2 , $prev, $next, $c ) ; 
	
	$c = 0 ;
	for my $l ( @letters ) {
		

		$c++ ;
		$next = $letters[($c)] ; 
		
		if ( $consonants =~ /$next/ ) {
			$next = "cons" ; 
		}
		else {
			$next = "vowel" ; 
		}

		

		if ( $consonants =~ /$l/ )
		{
			if ( ($prev eq "vowel") and ( $next eq "vowel" ) )  
			{
				$word2 .= "-" ; 
			}
			if ( ($prev eq "cons") and ( $next eq "vowel" ) )  
			{
				$word2 .= "-" ; 
			}			
			$word2 .= $l ; 
			$prev = "cons" ;
		}
		else {
			$word2 .= $l ; 		
			$prev = "vowel" ; 
		}
		
		if ( $c == 1) {
			$prev = "" ; 
		}
		
	}
	

	my @syllables = split( "-" , $word2 ) ; 	
	

	$word2 = "" ; 

	
	my $stressed = 0 ; 
	


	if ( @syllables == 1 )
	{
		$stressed = 0 ; 
	}
	elsif ( @syllables <= 3 )
	{
		if ( $prefix == 1 )
		{
			$stressed = 1 ;
		}
		else
		{
			$stressed = 0 ; 
		}
	}
	else
	{
		$stressed = @syllables - 2 ;  
	}



	
	for ( my $i = 0 ; $i < @syllables ; $i++ ) {
	
		if ( $i == $stressed) {
			$word2 .= "'" ;
		}
	
		$word2 .= $syllables[$i] ; 
		if ( $i != (@syllables-1) )
		{
			$word2 .= "-" ; 
		}
	
	}	
	
	if ( $word2 =~ /-'([a-z])er$/ ) {
	$word2 =~ s/([a-z])er$/$1&#x25C;:/g; }
	else { 
	$word2 =~ s/([a-z])er$/$1&#x259;/g;	}

	
	$transcription .= $word2 . " " ; 
	
	$transcription =~ s/st-r/str/g;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	}
	else {
		$transcription .= &checkExceptions($word) . " " ;
	}
	
	} 	
	
	chomp( $transcription ) ; 
	return $transcription ;
	

}

sub checkExceptions($) {

	my $word = shift ;
	my $trans = 0 ; 
	if ($word eq "great")
	{
		$trans = "'gr". $FACE . "t" ;
	}
	elsif ($word eq "steak")
	{
		$trans = "'st" . $FACE . "k" ;
	}	
	elsif ($word eq "break")
	{
		$trans = "'br" . $FACE . "k" ;
	}
	elsif ($word eq "read")
	{
		$trans = "'r" . $FLEECE . "d" ;
	}
	elsif ($word eq "not")
	{
		$trans = "'n" . $LOT . "t" ;
	}
	elsif ($word eq "what")
	{
		$trans = "'w" . $LOT . "t" ;
	}
	elsif ($word eq "want")
	{
		$trans = "'w" . $LOT . "nt" ;
	}	
	elsif ($word eq "any")
	{
		$trans = "'" . $TRAP . "n" . $KIT ;
	}
	elsif ($word eq "says")
	{
		$trans = "'sez" ;
	}	
	elsif ($word eq "again")
	{
		$trans = "@-'gen" ;
	}	
	elsif ($word eq "against")
	{
		$trans = "@-'genst" ;
	}		
	elsif ($word eq "friend")
	{
		$trans = "frend" ;
	}	
	elsif ($word eq "bury")
	{
		$trans = "ber" . $KIT ;
	}	
	elsif ($word eq "burial")
	{
		$trans = "ber" . $KIT. $SCHWA . "l" ;
	}		
	elsif ($word eq "meat")
	{
		$trans = "m" . $FLEECE . "t" ;
	}	
	elsif ($word eq "of")
	{
		$trans = $SCHWA . "f" ;
	}
	elsif ($word eq "a")
	{
		$trans = $SCHWA ;
	}
	elsif ($word eq "and")
	{
		$trans = $SCHWA . "nd" ;
	}	
	elsif ($word eq "aren't")
	{
		$trans = $PALM . "nt" ;
	}
	elsif ($word eq "can't")
	{
		$trans = "k" . $PALM . "nt" ;
	}	
	elsif ($word eq "private")
	{
		$trans = "pr" . $PRICE . "v" . $KIT . "t" ;
	}
	elsif ($word eq "shan't")
	{
		$trans = "S" . $PALM . "nt" ;
	}
	elsif ($word eq "aunt")
	{
		$trans = $PALM . "nt" ;
	}
	elsif ($word eq "laugh")
	{
		$trans = "l" . $PALM . "f" ;
	}	
	elsif ($word eq "upon")
	{
		$trans = $SCHWA . "'p" . $LOT . "n";
	}
	elsif ($word eq "draught")
	{
		$trans = "dr" . $PALM . "ft" ;
	}
	elsif ($word eq "heart")
	{
		$trans = "h" . $PALM . "t" ;
	}
	
	elsif ($word eq "the")
	{
		$trans = "D" . $SCHWA ;
	}	
	
	elsif ($word eq "hearth")
	{
		$trans = "h" . $PALM . "D" ;
	}	
	
	elsif ($word eq "sew")
	{
		$trans = "s&#x259;&#x28A;w"; 
	}
	elsif ($word eq "done")
	{
		$trans = "d" . $STRUT . "n"; 
	}
	elsif ($word eq "none")
	{
		$trans = "n" . $STRUT . "n"; 
	}
	elsif ($word eq "son")
	{
		$trans = "s" . $STRUT . "n"; 
	}
	elsif ($word eq "one")
	{
		$trans = "w" . $STRUT . "n"; 
	}	
	elsif ($word eq "on")
	{
		$trans = $LOT . "n"; 
	}	
	elsif ($word eq "minutes")
	{
		$trans = "'m" . $KIT . "n" . $KIT . "ts" ; 
	}
	elsif ($word eq "minute")
	{
		$trans = "'m" . $KIT . "n" . $KIT . "t" ; 
	}	
	elsif ($word eq "shall")
	{
		$trans = "S" . $TRAP . "l" ; 
	}
	elsif ($word eq "cannot")
	{
		$trans = "'k" . $TRAP . "n" . $LOT . "t" ; 
	}	
	elsif ($word eq "front")
	{
		$trans = "fr" . $STRUT . "nt"; 
	}	
	elsif ($word eq "month")
	{
		$trans = "m" . $STRUT . "nth"; 
	}		
	elsif ($word eq "mother")
	{
		$trans = "'m" . $STRUT . "-th" . $SCHWA ; 
	}	
	elsif ($word eq "enough")
	{
		$trans = "i-'n" . $STRUT . "f"; 
	}	
	elsif ($word eq "tough")
	{
		$trans = "'t" . $STRUT . "f"; 
	}	
	elsif ($word eq "rough")
	{
		$trans = "'r" . $STRUT . "f"; 
	}	
	elsif ($word eq "flood")
	{
		$trans = "'fl" . $STRUT . "d"; 
	}	
	elsif ($word eq "blood")
	{
		$trans = "'bl" . $STRUT . "d"; 
	}
	elsif ($word eq "knowledge")
	{
		$trans = "'n" . $LOT . "-lidzj"; 
	}	
	elsif ($word eq "now")
	{
		$trans = "'n" . $MOUTH ; 
	}	
	elsif ($word eq "allow")
	{
		$trans = $SCHWA . "-'l" . $MOUTH ; 
	}	
	elsif ($word eq "science")
	{
		$trans = "'s" . $PRICE . $SCHWA . "ns"; 
	}		
	
	
	
	
	return $trans ;
}


sub containsPrefix($) {

	my $syll = shift ;  
	my $return = 0 ;
	
	if ( $syll =~ /^im/) { $return = 1 ; }  
	elsif ( $syll =~ /^be/) { $return = 1 ; } 
	elsif ( $syll =~ /^ex/) { $return = 1 ; } 
	elsif ( $syll =~ /^re/) { $return = 1 ; } 
	elsif ( $syll =~ /^de/) { $return = 1 ; } 
	elsif ( $syll =~ /^dis/) { $return = 1 ; } 
	elsif ( $syll =~ /^in/) { $return = 1  ; } 
	elsif ( $syll =~ /^com/) { $return = 1 ; } 
	elsif ( $syll =~ /^con/) { $return = 1 ; } 
	elsif ( $syll =~ /^per/) { $return = 1 ; } 
	elsif ( $syll =~ /^to/) { $return = 1 ; } 
	elsif ( $syll =~ /^un/) { $return = 1 ; } 	
	elsif ( $syll =~ /^a/) { $return = 1 ; } 	
	return $return ; 
 }


sub wordFrequencyBook($) {

my $self = shift ;
my $dir = shift ;

my %frequencyBook ;

	opendir( DIR, $dir );
	my @files = readdir(DIR);
	closedir(DIR);

foreach my $file (@files) {

	if ( $file ne "." and $file ne "..") {
	my %frequency = () ; 
	$self->read( $dir . "\\" . $file ); 

	%frequency = $self->wordFrequency( $self->{poem} ) ; 

			foreach my $w ( keys %frequency ) {
				$frequencyBook{$w} += $frequency{$w} ;
			}

	}
}


return %frequencyBook ;

}


sub inverseDocumentFrequency($) {

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
			if ( $poem ne "." and $poem ne "..") { 
			
				$self->read( $dir . "\\" . $poem ) ; 
				%wordsPoem = $self->wordFrequency( $self->{poem} ) ; 
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
			
			print $poem . "\n" ; 
			
				my %wordsPoem = () ; my %idf = () ;
				my %freq = () ;
				$self->read( $dir . "\\" . $poem ) ; 
				%freq = $self->wordFrequency( $self->{poem} ) ; 
				
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


sub largestNGram($) {

my $self = shift ;
my $file = shift ;

#my $p = new Lingua::EN::Tagger;

my %ngrams ;
my %AllNgrams ; 

my ( $line, $poem ) ;
open ( IN, $file ) ; 

while(<IN>) {


$line = $_ ;
$line =~ s/\n/ /g; 
$line =~ s/,//g; 
$line =~ s/\.//g; 
$line =~ s/\://g; 
$line =~ s/^\'//g; 
$line =~ s/\'$//g; 	
$poem .= $line . " ";
}
close ( IN ) ; 

$poem =~ s/ */ /;
$poem = lc($poem) ;

#print $poem ;

my @words = split ( /\s+/ , $poem ) ; 

my $n = 0; 
my $ngram ; 
my $print ;
my $repeatedNGrams = -1 ; 


while ( $repeatedNGrams !=  0) {

%ngrams = () ; 
$repeatedNGrams = 0 ; 
$n++ ; 

for ( my $i = 0 ; $i < @words ; $i++ ) {

	for ( my $k = $i ; $k < ($i+$n) ; $k++ ) {
		$ngram .= $words[$k] ; 
		if( $k != ($i+$n)) { $ngram .= " " ; }
	}
 	#print $ngram . "\n" ; 
	$ngrams{ $ngram }++ ;
	$AllNgrams{ $ngram }++ ; 
	
	$ngram = "" ; 
}

foreach my $r ( keys %ngrams ) {
	if( $ngrams{$r} > 1) { 
		$repeatedNGrams++ ;
	}
	else {
		delete ( $AllNgrams{ $r } ) ; 	
	}
	
}


}

$n-- ; 
print "Size of largest n-gram: " . $n . "\n" ; 		




foreach my $r ( keys %AllNgrams ) {
	my @words = split ( /\s+/ , $r ) ; 
	
	my $key = $r ; 
	my $pattern = "^" . $words[0] . " " ; 
	$key =~ s/$pattern//g; 
	delete ( $AllNgrams{$key} ) ; 
	
	my $key = $r ; 
	my $pattern = " " . $words[0] . "\$" ; 
	$key =~ s/$pattern//g; 
	delete ( $AllNgrams{$key} ) ; 	
}

		
foreach my $r ( keys %AllNgrams ) {

	print "Repeated nGrams: $r, " . $AllNgrams{ $r } . "<br/>" ; 	}
	

}

sub repeatedWordInLine($) {

my $self = shift ;
my $line = shift ;

$line =~ s/\///; 
$line =~ s/\\//; 
$line =~ s/\(//; 
$line =~ s/\)//; 


print $line . "\n" ; 

$line =~ s/[;\.,]//g; 
$line =~ s/\sthe\s//g; 
$line =~ s/^The\s//g; 
$line =~ s/\sa\s//g; 
$line =~ s/^A\s//g; 
$line =~ s/\sto\s//g; 
$line =~ s/^To\s//g; 
$line =~ s/\sis\s//g; 

my $return = 0 ; 

my $words = &wordSegmentation( $line ) ;

foreach my $w ( @{ $words } ) {

foreach my $w2 ( @{ $words } ) {



	if ( $w =~ /$w2/ and $w ne $w2) {
		#print $line . "\n" ; 
		$return = $w2 ;  
	}
	
	
}
	
	
}


return $return ; 
}

sub repeatedNGramInLine($$) {

my $self = shift ;
my $line = shift ;
my $n = shift ;

chomp( $line ) ; 

$line = lc( $line ) ; 
my @ngrams ;
my %repetition ; 

$line =~ s/[\(\)-\\\/\']//g;

my @words = split ( /\s/ , $line ) ; 

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

return @repetition ; 

}

sub largestNGramWithinLine($) {

my $self = shift ;
my $line = shift ;

chomp( $line ) ; 

$line = lc( $line ) ; 


$line =~ s/[\(\)-\\\/]//g;


my %ngrams ;
my @AllNgrams ; 

my $n = ( length( $line ) ) / 2 ;   
my $ngram ; 

for ( my $i = 0 ; $i < length( $line ) ; $i++ ) {

	for ( my $k = 2 ; ( $i+$k) <= length( $line ) ; $k++ ) {
	
		#if ( ($k-$i) > $n ) {
			$ngram = substr( $line, $i, $k ) ; 
			

			
			if ( length( $ngram ) > 2 ) {
				$ngrams{ $ngram }++ ;
			}
	}

}


foreach my $r ( keys %ngrams ) {
	
	if ( $ngrams{$r} > 1 ) {
		
			foreach my $substr ( keys %ngrams ) {
			
				if ( ($r =~ /$substr/ ) and length($r) != length($substr) ) {
					delete( $ngrams{$substr} ) ;
				}
			
			}
	
	}
	
}



foreach my $r ( keys %ngrams ) {
	
	if ( ($ngrams{$r} > 1) and ( $r =~ /\w/) ) {
		$r =~ s/^\s//g; 
		$r =~ s/\s$//g; 		
		if ( length($r) > 2 )  {
			push ( @AllNgrams , $r ) ;
		}
	}
	
}

delete ( $AllNgrams["the"] ) ;


return @AllNgrams ;

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
	return @images ; 
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
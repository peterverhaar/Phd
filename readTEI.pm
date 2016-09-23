package readTEI ; 


use strict ;
use XML::Parser;


my ( %poem, $line, $property , $value, $attname, $attvalue, $lineNumber, $lineText , $stanzaId, @stanza, $stanzaFlag, $numberOfLines , %lemmas , %pos , $pos , %phon ) ; 

	my $parser = new XML::Parser(ErrorContext => 2);
	$parser->setHandlers(Char => \&char_handler, Start => \&start_handler, 
		     End => \&end_handler  );




sub new() {
	my $self  = {};	
	bless($self);     
	return $self;
}

sub read() {

	my $self = shift ;
	my $tei = shift ; 
	
	%poem = () ; %lemmas = () ; %pos = () ; %phon = () ; 
	
	$parser->parsefile( $tei ); 
	
	return \%poem ; 		 

}


sub getPhon() {

	my $self = shift ;	
	
	foreach my $p ( %phon ) {
		if( $p !~ /\d/) {
			delete( $phon{$p} ) ; 
		}
	}
	
	return \%phon ; 		 

}


sub getLemmas() {

	my $self = shift ;	
	return \%lemmas ; 		 

}

sub getPosTags() {

	my $self = shift ;	
	return \%pos ; 		 

}


sub getStanzas() {

	## this function returns the line numbers of the first lines of each stanza
	
	my $self = shift ;
	my $tei = shift ; 
	
	@stanza = () ; 
	
	$parser->parsefile( $tei ); 
	
	return \@stanza ; 		 

}

sub getNumberOfLines() {


	
	my $self = shift ;
	my $tei = shift ; 
	
	$numberOfLines = 0 ;
	$parser->parsefile( $tei ); 
	
	return $numberOfLines ; 		 

}

sub filterByPosTag() {

	my $self = shift ;
	my $line = shift ; 
	my $categories = shift ; 
	
	my @cat = @{ $categories } ; 
	
	my $cat = join "|", @cat ;
	
	my @words = split ( /\s/ , $line ) ;

	my $return = "" ;
	foreach my $w ( @words ) {
		my $pos = substr( $w , ( index( $w , "###" ) + 3 ) , length( $w ) ) ; 
		$pos =~ s/\W//g; 
		if ( $cat =~ /$pos/) {  
			$return .= substr( $w , 0 , ( index( $w , "###" )  )  ) . " ";  
    }
	}

	
	return $return ; 		 

}



sub getLemmasinLine($) {


	
	my $self = shift ;
	my $line = shift ; 

	my $lemmas = $lemmas{$line} ; 

	
	my @lemmas = split( " " , $lemmas ) ; 
	
	my @return ; 
	foreach my $l ( @lemmas ) {
		if ( $l =~ /\w/) {
			push ( @return , $l )
		}
	}
	
	return \@return ; 		 

}


sub start_handler()
{

	my $p = shift ; 
	$property = shift ;
	
	if ( $property eq "l" )
	{
		$value = "" ; 
		$lineText = " " ; 
	}
	
	if ( $property eq "lg" )
	{
		$stanzaFlag = 1 ; 
	}	
	
	while (@_)
    {
		$attname = shift;
		$attvalue = shift ;	
		
		if ( $attname eq "n" ) {

			if ( $property eq "lg" )
			{
				$stanzaId = $attvalue ;
			}
			else {
				$lineNumber = $attvalue ;
			}

		}
		
		if ( $attname eq "lemma" ) {
		
			$lemmas{$lineNumber} .= $attvalue . " " ; 
		}		
		
		if ( $attname eq "phon" ) {
		

			if ( $lineNumber > 0 ) { 
				$phon{$lineNumber} .= $attvalue . " " ; 
				#print $phon{$lineNumber} . "\n" ; 
			}  
		}		
				
		
		if ( $attname eq "pos" ) {
		
			$pos = $attvalue ; 
		}	

		
    }

}



sub end_handler()
{



	
	my ( $p, $element ) = @_ ; 


	if ( $element eq "l" )
	{

		if ( $stanzaFlag == 1 )
		{
			push ( @stanza, $lineNumber ) ; 
			$stanzaFlag = 0 ;
		}

		$poem{ $lineNumber } = $lineText ; 

	}
	
	if ( $element eq "body" )
	{	
		$numberOfLines = $lineNumber ; 
		#%lemmas = () ; 
	}

	if ( $element eq "w" )
	{	
		$pos{ $lineNumber } .= $value . "###" . $pos ; 
	}	
	
	$lineText .= $value ; 
	$value = "" ; 	
}

sub char_handler()
{

    my ( $p, $data ) = @_ ; 
	
	if ( $data =~ /./)
    {
		$value .= $data  ; 
	} 

}

	 

	
1;  # so the require or use succeeds
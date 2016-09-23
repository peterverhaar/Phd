package readRDF ; 


use strict ;
use XML::Parser;
use strict ; 

my ( %transcriptions , $line, $property , $transcr , $lineID , $value, $subject, $subject_needed, $predicate , $object ) ; 


my $parser = new XML::Parser(ErrorContext => 2);
$parser->setHandlers(Char => \&char_handler, Start => \&start_handler, 
		     End => \&end_handler  );



sub new() {
	my $self  = {};	
	bless($self);

	opendir(DIR, "Transcriptions" ) or die ("Can't open folder!\n") ;
	my @files = readdir(DIR);
	closedir(DIR);

	foreach my $p ( @files ) {	
	
		if ( ( $p ne "." ) and ( $p ne ".." ) ) {
			$parser->parsefile( "Transcriptions\\" . $p ); 
		}
	}
	return $self;
}

sub getObject($$) {

	my $self = shift ;
	my $subject = shift ;
	my $predicate = shift ;

	return $transcriptions{ $subject } ; 		 
}




sub start_handler()
{
	my $p = shift ; 
	$property = shift ;
	$value = "" ; 
}



sub end_handler()
{
	
	my ( $p, $element ) = @_ ; 


	if ( $element eq "subject" )
	{
		$subject = $value ; 		
	}

	if ( $element eq "predicate" )
	{
		$predicate = $value ; 
	}
	
	if ( $property eq "object" )
	{
		$transcriptions{ $subject } = $value ; 		
	}

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
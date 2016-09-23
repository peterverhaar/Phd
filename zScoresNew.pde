
Table table ;
Table scale ;

int nrRows ;
int nrCols ; 

int indent = 150 ; 
int indentX = 120 ; 



String[] cols = {"poem",
"code",
"internalRhyme", 
"alliteration" ,  
"consonance" ,
"assonance" ,
//"perfectRhyme" , 
"consonanceRhyme" ,
"assonanceRhyme" ,
"semiRhyme" ,
"deibide" ,
"aicill" ,
"consonanceTwoLines" , "polyptoton"  }  ; 

 
int X = 200 ;
int Y = 40 ; 
int increment = 20 ; 


void setup() {
  
  
  table = loadTable( "dataZ.csv" , "header");
  scale = loadTable( "minMax.csv" , "header");


  nrRows = table.getRowCount() ;
  nrCols = table.getColumnCount() ;
  size( 600 , 385 ) ; 



}



void draw( ) {
  
  background(252);  

  
  for ( int i = 0 ; i < nrRows ; i++ ) {
    

    String title = table.getString( i , 0 );

    
    
    
    fill(#000000);
    textSize(10);   
    textAlign(RIGHT,BOTTOM);
    text ( title ,  indent + 20 , (i+1) * 18 + 10 + indentX ) ;



  

      for ( int w = 2 ; w < cols.length ; w++ ) {
        

        Float v = table.getFloat( i , cols[w] ) ; 
        Float min = scale.getFloat( 0 , cols[w] ) ; 
        Float max = scale.getFloat( 1 , cols[w] ) ;         
        
        noStroke() ;
        color c ;     
        Float  m ;
             
        if ( v > 0 ) {      
          m = map( v , 0 , max , 0 , 1) ;
          c = lerpColor( #E0E0E0 ,  #000066 , m );
        } else {
          /* m = map( v , min , 0 , 0 , 1) ;
          c = lerpColor( #cc0000 , #E0E0E0 , m );          
          */
          
          c = #E0E0E0 ;
        }     
       fill( c ) ; 
       rect( indent+ w*30 , (i+1) * 18 + indentX  , 27 , 8 ) ; 
          
        
      }
       
      
  

  }

  
  




  textAlign(LEFT,BOTTOM);

  pushMatrix();
  translate(indent+ 30 , 10);
  rotate(-HALF_PI);

  fill( 0 ) ;

      
      for ( int w = 2 ; w < cols.length ; w++ ) {
        

            text( cols[w] , 0 - ( indentX - 5 )  , w*30 - 10 );
          

        
      }
      

  popMatrix();
   
  
      
      
} 
  
  
         



void mousePressed() {
  save("zScores.tif");
}

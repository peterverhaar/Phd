
Table table;
color[] cols = { 

#FF3030 ,
#FFF68F , 
#19E61D ,

#87CEFA , 
#FFCC00 , 
#260C85 ,

#9934BA ,
#F28713 ,
#199C1B

} ;

int width = 600 ; 
int X ; 
int Y ; 

int heightBar = 8 ; 
int indent = 30 ; 

int margin = 90 ; 
int spaceBetween = 110 ;   

int nrCols ;
int nrRows ;

    
    String[] Images = new String[9];
    
  


void setup() {
  
  background(254); 

    Images[0] = "Religion" ;
    Images[1] = "Water" ;    
    Images[2] = "War" ;
     Images[3] = "Food" ;
    Images[4] = "Disease" ;
    Images[5] = "Money" ;  
    Images[6] = "Plants" ;  
     Images[7] = "Light" ;
    Images[8] = "Transportation" ;    
  
  table = loadTable("dataVolumes2.csv", "header");
  nrRows = table.getRowCount() ;  
  nrCols = table.getColumnCount() ;  


  size( 1250 , 1200 ) ;   
  
  PFont mono = loadFont("ArialMT-22.vlw");
  textSize(22);
  textFont(mono);  
  

}

void draw( ) {

    int x ; 
    int y ;  

    int xLabel ;
    int yLabel ; 


    for( int i = 0 ; i < Images.length ; i++ ) {
        fill( #000000 ) ;
        text( Images[i] , (i * spaceBetween ) + 180 , 40 ) ; 
    } 
    

    int r = 0 ; 
  
    
   
  
    for (TableRow row : table.rows()) {
      
      X = margin ; 
    
      // show name of volume
      r++ ; 
      Y = r * 100 ;   
      
      //get volume title and numebr of words
      tint(255, 126); 
      String id = row.getString("volume");
      Float nrWords = row.getFloat("nrWords");
     
      
      fill(0) ; 
      text( id  , X , Y ) ; 
      
      //draw lines
      stroke(240) ; 
      line( X + margin , Y , nrCols* 50*X , Y) ;
      noStroke() ; 
      
      // draw circles for images
    
    for( int i = 0 ; i < Images.length ; i++ ) {

    Float R = row.getFloat( Images[i] );
    R = ( R / nrWords ) * 6000 ; 
    
      //fill( cols[r] )  ;
     X += spaceBetween ; 
      //text( value , X  , Y ) ;
     fill( cols[i] )  ; 
     ellipse( X , Y , R , R );

    }
      
    
    }
    

    
    

}


void mousePressed() {

  save("image.tif");


}



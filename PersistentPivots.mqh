//+------------------------------------------------------------------+
//|                                            CPersistentPivots.mqh |
//|                                                      nicholishen |
//|                                         nicholishen@tutanota.com |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "nicholishen@tutanota.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPersistentPivots{

protected:
   
   string            m_Symbol;           //m_Symbol to calculate pivots
   int               m_Period;           //m_Period to calculate pivots
   double            m_PipStepInput;     //number of pips between scans
   int               m_NumberOfPivots;   //maximum number of pivots to calculate
   int               m_MinimumPipDist;   //minimum distance betweeen plotted pivots in pips
   double            m_ReversalPoints;   //number of points to assign to a reversal. Defined as a bar whose shadow touches a pivot and the following two bars have not returned to the pivot
   double            m_ShadowPoints;     //number of points to assign to a shadow that touches or crosses pivot, but not the body of the candle
   double            m_BodyPoints;       //number of points to assign to a body of a candle 
   int               m_MonthsRange;      //number of months back to determine a price range for pivot calc. 0 will look at the entire range for the total history  
   int               m_MaxBarsLookBack;  //maximum number of bars to scan from the current bar to calculate pivots
   double            m_PriceHighInput;   //overrides the month range and sets a high starting point      
   double            m_PriceLowInput;    //overrides the month range and sets a low starting point       
   double            m_MinPipDistance;   //stores the minimum pip distance as static
   double            m_SlicerX[][2];     //this is where the magic is stored. The first index of the second dimension stores the scores and the second index stores the corresponding price
   int               m_SortMode;
   color             m_LineColor ;       //sets line color for drawing on chart 
   int               m_Digits;
   double            m_Point;
    
   void              plotPivots
                        (                         //--->method that sorts the m_SlicerX array based on critera
                        double& slicerXin[][],  //reference to m_SlicerX array
                        int n  
                        );            //total number of price points in the range                                
   
   void              drawLines
                        (                          //--->method to draw lines on the chart
                        double target,       //price point to draw line
                        double objScore,     //score for labeling
                        int periodIn,        //m_Period for labeling
                        int objNumber 
                        );     //object number for name
                                       
public:
                     CPersistentPivots
                        (
                        );     //--->default constructor
                        
                     CPersistentPivots
                        (       //--->overload constructor #1
                        string   symbolIn             ,
                        int      periodIn             ,
                        color    lineColorIn       =clrYellow,
                        double   pipStepIn         = 1,
                        int      numberOfPivotsIn  = 3,
                        int      minPipDistanceIn  = 200,
                        double   revPointsIn       = 10,
                        double   shadowPointsIn    = 3,
                        double   bodyPointsIn      = 1,
                        int      monthsRangeIn     = 3,  
                        int      maxBarsLookBackIn = 0,
                        double   priceHighInputIn  = 0,
                        double   priceLowInputIn   = 0,
                        int      sortModeIn        = 0   
                        );                                           

                     ~CPersistentPivots
                        (
                        );                //--->destructor
   
   void              calcPivots
                        (
                        );                       //--->main method to score pivots
   
   bool              draw
                        (
                        );                             //--->main method to draw pivot line on the chart
   
   bool              arrayCopy
                        (
                        double& arr[][2]
                        );        //--->method to copy pivot values to an array
   
   void              setNewPeriod(int p){ 
                        m_Period = p; 
                        //calcPivots(); 
                     }
   
   void              setColor(color c){ 
                        m_LineColor = c; 
                     }
   
   void              setNumberOfPivots(int n){ 
                        m_NumberOfPivots = n; 
                     }
   
   void              setNewPointValues(double r, double s, double b){
                        m_ReversalPoints = r; m_ShadowPoints = s; m_BodyPoints = b;
                        //calcPivots();
                     }
   
   void              setMinPipDistance(int mp){ m_MinimumPipDist = mp; }
   
   void              setNewMonthRange(int months){ m_MonthsRange = months; }
   
   void              setHighPrice(double h){m_PriceHighInput = h;}
   
   void              setLowPrice(double l){m_PriceLowInput = l;}

   
   
   
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPersistentPivots::CPersistentPivots
   (
   ):                            //default params   
   m_Symbol           ( Symbol() ),
   m_Period           ( Period() ),
   m_PipStepInput     ( 1 ),
   m_NumberOfPivots   ( 3 ),
   m_MinimumPipDist   ( 200 ),  
   m_ReversalPoints   ( 10 ),
   m_ShadowPoints     ( 3 ),     
   m_BodyPoints       ( 1 ),       
   m_MonthsRange      ( 3 ),      
   m_MaxBarsLookBack  ( 0 ),   
   m_PriceHighInput   ( 0 ),         
   m_PriceLowInput    ( 0 ),          
   m_SortMode         ( 0 ),         
   m_LineColor        ( clrYellow )  

{ 
   m_Digits = (int)SymbolInfoInteger(m_Symbol,SYMBOL_DIGITS); //calcPivots();
   m_Point  = SymbolInfoDouble(m_Symbol,SYMBOL_POINT);
}

CPersistentPivots::CPersistentPivots
   (
   string   symbolIn             ,
   int      periodIn             ,
   color    lineColorIn       = clrYellow,
   double   pipStepIn         = 1,
   int      numberOfPivotsIn  = 3,
   int      minPipDistanceIn  = 200,
   double   revPointsIn       = 10,
   double   shadowPointsIn    = 3,
   double   bodyPointsIn      = 1,
   int      monthsRangeIn     = 3,  
   int      maxBarsLookBackIn = 0,
   double   priceHighInputIn  = 0,
   double   priceLowInputIn   = 0,
   int      sortModeIn        = 0  
   ):
   
   m_Symbol            ( symbolIn ),
   m_Period            ( periodIn ),
   m_PipStepInput      ( pipStepIn ),
   m_NumberOfPivots    ( numberOfPivotsIn ),
   m_MinimumPipDist    ( minPipDistanceIn ),   
   m_ReversalPoints    ( revPointsIn ),
   m_ShadowPoints      ( shadowPointsIn ),      
   m_BodyPoints        ( bodyPointsIn ),        
   m_MonthsRange       ( monthsRangeIn ),       
   m_MaxBarsLookBack   ( maxBarsLookBackIn ),   
   m_PriceHighInput    ( priceHighInputIn ),        
   m_PriceLowInput     ( priceLowInputIn ),    
   m_SortMode          ( sortModeIn ),        
   m_LineColor         ( lineColorIn )    
          
{                                                        
   m_Digits = (int)SymbolInfoInteger(m_Symbol,SYMBOL_DIGITS); //calcPivots();
   m_Point  = SymbolInfoDouble(m_Symbol,SYMBOL_POINT);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPersistentPivots::~CPersistentPivots
   (
   )
   
{
  
}
//+------------------------------------------------------------------+

bool CPersistentPivots::arrayCopy
   (
   double& arr[][2]
   )
{
   int size = ArraySize(m_SlicerX);
   ArrayResize(arr,size);
   for(int i=0; i< size; i++){
      for(int j=0; j<2; j++){
         arr[i][j] = m_SlicerX[i][j];
      }
   }
   return(true);
}
//+------------------------------------------------------------------+

void CPersistentPivots::calcPivots
   (
   )
{
   
   uint countStart   = GetTickCount();
   int digits        = Digits();
   double pipVal     = m_Point;//1/MathPow(10,MarketInfo(m_Symbol,MODE_DIGITS));
   double pipStep    = NormalizeDouble(m_PipStepInput * pipVal, m_Digits);
   m_MinPipDistance   = NormalizeDouble(pipStep * m_MinimumPipDist, m_Digits);
   int nBars         = iBars(m_Symbol,m_Period);
 
   if(m_MaxBarsLookBack > 0) nBars = m_MaxBarsLookBack;
   
   double priceHigh, priceLow;
   
   if(m_PriceHighInput > 0){
      priceHigh      = m_PriceHighInput; 
   }else if(m_MonthsRange > 0){
      priceHigh      = iHigh(m_Symbol,PERIOD_MN1,iHighest(m_Symbol,PERIOD_MN1,MODE_HIGH,m_MonthsRange));  
   }else{ 
      priceHigh      = iHigh(m_Symbol,m_Period,iHighest(m_Symbol,m_Period,MODE_HIGH,nBars));
   }
   if(m_PriceLowInput > 0){
      priceLow       = m_PriceLowInput; 
   }else if(m_MonthsRange > 0){
      priceLow       = iLow(m_Symbol,PERIOD_MN1,iLowest(m_Symbol,PERIOD_MN1,MODE_LOW,m_MonthsRange));
   }else{ 
      priceLow       = iLow(m_Symbol,m_Period,iLowest(m_Symbol,m_Period,MODE_LOW,nBars));
   }
     
   double pipRange   = NormalizeDouble(priceHigh - priceLow, m_Digits);
   double xSlices    = pipRange / pipStep;
   xSlices           = MathCeil(xSlices);
   xSlices           = NormalizeDouble(xSlices,0);
   int nSlices       = (int)xSlices;
   double high[3]    = {0,0,0};
   double low[3]     = {0,0,0};
   double open[3]    = {0,0,0};
   double close[3]   = {0,0,0};
   
   double O[],H[],L[],C[];
   ArrayResize(m_SlicerX,nSlices+1);
   ArrayResize(O,nBars);
   ArrayResize(H,nBars);
   ArrayResize(L,nBars);
   ArrayResize(C,nBars);
   
   double slicePriceCurrent = priceHigh;
   
   for(int i =0; i< nBars; i++){
      O[i] = iOpen(m_Symbol,m_Period,i);
      H[i] = iHigh(m_Symbol,m_Period,i);
      L[i] = iLow(m_Symbol,m_Period,i);
      C[i] = iClose(m_Symbol,m_Period,i);
   }
   
   
   for( int iLook = 0; iLook < nBars; iLook++){
      int yes = 0;
      for(int bbars = 0; bbars < 3; bbars++){    
         if(iLook-bbars < 0) break;
         yes++;
         high[bbars]    = NormalizeDouble(H[iLook-bbars], m_Digits);
         low[bbars]     = NormalizeDouble(L[iLook-bbars], m_Digits);
         open[bbars]    = NormalizeDouble(O[iLook-bbars], m_Digits);
         close[bbars]   = NormalizeDouble(C[iLook-bbars], m_Digits);
      } 
      if(yes<=0) continue;  
      slicePriceCurrent = NormalizeDouble(high[0], m_Digits);
      
      if(high[0] <= priceHigh && low[0] >= priceLow){    
           
         while(slicePriceCurrent >= low[0]){    
           
            double loc        = (NormalizeDouble(priceHigh, m_Digits)- NormalizeDouble(slicePriceCurrent, m_Digits))/pipStep;
            int loci          = (int)loc;
            m_SlicerX[loci][1]  = NormalizeDouble(slicePriceCurrent, m_Digits);
            
            if(open[0] < close[0]){ // bull bar
               if(open[0] <= slicePriceCurrent && close[0] >= slicePriceCurrent){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_BodyPoints; 
               }
               if((low[0] <=slicePriceCurrent && open[0] > slicePriceCurrent) || (high[0] >= slicePriceCurrent && close[0] < slicePriceCurrent)){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_ShadowPoints;
               }
               if((high[0]>=slicePriceCurrent && close[0] < slicePriceCurrent) && (high[1] < slicePriceCurrent && high[2] < slicePriceCurrent)){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_ReversalPoints; 
               }      
            }else{ //bear bar
               if(open[0] >= slicePriceCurrent && close[0] <= slicePriceCurrent){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_BodyPoints; 
               }
               if((low[0] <=slicePriceCurrent && close[0] > slicePriceCurrent) || (high[0] >= slicePriceCurrent && open[0] < slicePriceCurrent)){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_ShadowPoints; 
               }          
               if((low[0]<=slicePriceCurrent && close[0] > slicePriceCurrent) && (low[1] > slicePriceCurrent && low[2] > slicePriceCurrent)){
                  m_SlicerX[loci][0]= m_SlicerX[loci][0] + m_ReversalPoints; 
               }
            }
            
            slicePriceCurrent = NormalizeDouble(slicePriceCurrent - pipStep, m_Digits);
         }  
      }
   }
   for(int ii =0 ; ii< nSlices; ii++){
      Print(ii," of ",nSlices," normalizing to ",m_Digits);
      Print("Score (",m_SlicerX[ii][0],") @ (",m_SlicerX[ii][1],")");
   }   
   plotPivots(m_SlicerX,nSlices);
   return;
}

//+------------------------------------------------------------------+

void CPersistentPivots::plotPivots
   (
   double& slicerXin[][], 
   int n
   )
{
   
   if(m_SortMode == 0)ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_DESCEND); else ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_ASCEND);
   for(int i = 0; i < n; i++){
      double highScore,highPrice;
      //double lowScore,lowPrice;
      
      if(m_SortMode == 0){
         if(slicerXin[i][0] > 0){
            highScore = slicerXin[i][0];
            highPrice = slicerXin[i][1];
            for(int j = i+1 ;j < n; j++){
               if(  (slicerXin[j][1] > highPrice && slicerXin[j][1] < highPrice + m_MinPipDistance) || (slicerXin[j][1] < highPrice && slicerXin[j][1] > highPrice - m_MinPipDistance) ){
                  slicerXin[j][1] = 0;
                  slicerXin[j][0] = 0;
               }
            }   
         }         
      } else {
         if(slicerXin[i][1] > 0 && slicerXin[i][0] == 0) {
            for(int j = i; j<n-1; j++){
               slicerXin[j][0] = slicerXin[j+1][0];
               slicerXin[j][1] = slicerXin[j+1][1];
            } 
            slicerXin[n][0] = 0;
            slicerXin[n][1] = 0;
         }
      } 
   }
   if(m_SortMode == 0){
      ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_DESCEND);
   } else { 
      ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_ASCEND);
      int count=0;
      for(int i =0; i<n; i++){
         if(slicerXin[i][0] == 0 && slicerXin[i][1] == 0){
            count++;
         } else {
            break;
         }
      }
      int j =0;
      while( j < n - count){
    
         slicerXin[j][0] = slicerXin[j+count][0];
         slicerXin[j][1] = slicerXin[j+count][1];
         
         j++;
      }
         
   }
   
   return;
}

//+------------------------------------------------------------------+
bool CPersistentPivots::draw
   (
   )
{
   ObjectsDeleteAll(0,IntegerToString(m_Period),0,OBJ_HLINE);
   for(int i = 0; i < m_NumberOfPivots; i++){
      drawLines(m_SlicerX[i][1], m_SlicerX[i][0], m_Period, i+1);
   }
   return(true);
}

//+------------------------------------------------------------------+

void CPersistentPivots::drawLines
   ( 
   double target,
   double objScore,
   int periodIn, 
   int objNumber
   )
{
  
   string objName = StringConcatenate(IntegerToString(periodIn)," PP ",IntegerToString(objNumber));
   long chartID = ChartID();
   
   ObjectDelete(objName);
   ObjectCreate(
               chartID,
               objName,
               OBJ_HLINE,
               0,
               iTime(m_Symbol,m_Period,0),
               target
               );
   ObjectSet(objName,OBJPROP_COLOR,m_LineColor);
   ObjectSet(objName,OBJPROP_STYLE,STYLE_SOLID);
   //ObjectSetString(0,objName,OBJPROP_TEXT,objName);
   ObjectSetText(objName,StringConcatenate("TF = ",IntegerToString(periodIn)," Score = ",DoubleToStr(objScore,2)),8);
   return;
}

//+------------------------------------------------------------------+


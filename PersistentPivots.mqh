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
   
   string            mSymbol;           //mSymbol to calculate pivots
   int               mPeriod;           //mPeriod to calculate pivots
   double            mPipStepInput;     //number of pips between scans
   int               mNumberOfPivots;   //maximum number of pivots to calculate
   int               mMinimumPipDist;   //minimum distance betweeen plotted pivots in pips
   double            mReversalPoints;   //number of points to assign to a reversal. Defined as a bar whose shadow touches a pivot and the following two bars have not returned to the pivot
   double            mShadowPoints;     //number of points to assign to a shadow that touches or crosses pivot, but not the body of the candle
   double            mBodyPoints;       //number of points to assign to a body of a candle 
   int               mMonthsRange;      //number of months back to determine a price range for pivot calc. 0 will look at the entire range for the total history  
   int               mMaxBarsLookBack;  //maximum number of bars to scan from the current bar to calculate pivots
   double            mPriceHighInput;   //overrides the month range and sets a high starting point      
   double            mPriceLowInput;    //overrides the month range and sets a low starting point       
   double            mMinPipDistance;   //stores the minimum pip distance as static
   double            mSlicerX[][2];     //this is where the magic is stored. The first index of the second dimension stores the scores and the second index stores the corresponding price
   int               mSortMode;
   color             mLineColor ;       //sets line color for drawing on chart 
   int               mDigits;
   double            mPoint;
    
   void              plotPivots
                        (                         //--->method that sorts the mSlicerX array based on critera
                        double& slicerXin[][],  //reference to mSlicerX array
                        int n  
                        );            //total number of price points in the range                                
   
   void              drawLines
                        (                          //--->method to draw lines on the chart
                        double target,       //price point to draw line
                        double objScore,     //score for labeling
                        int periodIn,        //mPeriod for labeling
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
                        mPeriod = p; 
                        //calcPivots(); 
                     }
   
   void              setColor(color c){ 
                        mLineColor = c; 
                     }
   
   void              setNumberOfPivots(int n){ 
                        mNumberOfPivots = n; 
                     }
   
   void              setNewPointValues(double r, double s, double b){
                        mReversalPoints = r; mShadowPoints = s; mBodyPoints = b;
                        //calcPivots();
                     }
   
   void              setMinPipDistance(int mp){ mMinimumPipDist = mp; }
   
   void              setNewMonthRange(int months){ mMonthsRange = months; }
   
   void              setHighPrice(double h){mPriceHighInput = h;}
   
   void              setLowPrice(double l){mPriceLowInput = l;}

   
   
   
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPersistentPivots::CPersistentPivots
   (
   ):                            //default params   
   mSymbol           ( Symbol() ),
   mPeriod           ( Period() ),
   mPipStepInput     ( 1 ),
   mNumberOfPivots   ( 3 ),
   mMinimumPipDist   ( 200 ),  
   mReversalPoints   ( 10 ),
   mShadowPoints     ( 3 ),     
   mBodyPoints       ( 1 ),       
   mMonthsRange      ( 3 ),      
   mMaxBarsLookBack  ( 0 ),   
   mPriceHighInput   ( 0 ),         
   mPriceLowInput    ( 0 ),          
   mSortMode         ( 0 ),         
   mLineColor        ( clrYellow )  

{ 
   mDigits = (int)SymbolInfoInteger(mSymbol,SYMBOL_DIGITS); //calcPivots();
   mPoint  = SymbolInfoDouble(mSymbol,SYMBOL_POINT);
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
   
   mSymbol            ( symbolIn ),
   mPeriod            ( periodIn ),
   mPipStepInput      ( pipStepIn ),
   mNumberOfPivots    ( numberOfPivotsIn ),
   mMinimumPipDist    ( minPipDistanceIn ),   
   mReversalPoints    ( revPointsIn ),
   mShadowPoints      ( shadowPointsIn ),      
   mBodyPoints        ( bodyPointsIn ),        
   mMonthsRange       ( monthsRangeIn ),       
   mMaxBarsLookBack   ( maxBarsLookBackIn ),   
   mPriceHighInput    ( priceHighInputIn ),        
   mPriceLowInput     ( priceLowInputIn ),    
   mSortMode          ( sortModeIn ),        
   mLineColor         ( lineColorIn )    
          
{                                                        
   mDigits = (int)SymbolInfoInteger(mSymbol,SYMBOL_DIGITS); //calcPivots();
   mPoint  = SymbolInfoDouble(mSymbol,SYMBOL_POINT);
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
   int size = ArraySize(mSlicerX);
   ArrayResize(arr,size);
   for(int i=0; i< size; i++){
      for(int j=0; j<2; j++){
         arr[i][j] = mSlicerX[i][j];
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
   double pipVal     = mPoint;//1/MathPow(10,MarketInfo(mSymbol,MODE_DIGITS));
   double pipStep    = NormalizeDouble(mPipStepInput * pipVal, mDigits);
   mMinPipDistance   = NormalizeDouble(pipStep * mMinimumPipDist, mDigits);
   int nBars         = iBars(mSymbol,mPeriod);
 
   if(mMaxBarsLookBack > 0) nBars = mMaxBarsLookBack;
   
   double priceHigh, priceLow;
   
   if(mPriceHighInput > 0){
      priceHigh      = mPriceHighInput; 
   }else if(mMonthsRange > 0){
      priceHigh      = iHigh(mSymbol,PERIOD_MN1,iHighest(mSymbol,PERIOD_MN1,MODE_HIGH,mMonthsRange));  
   }else{ 
      priceHigh      = iHigh(mSymbol,mPeriod,iHighest(mSymbol,mPeriod,MODE_HIGH,nBars));
   }
   if(mPriceLowInput > 0){
      priceLow       = mPriceLowInput; 
   }else if(mMonthsRange > 0){
      priceLow       = iLow(mSymbol,PERIOD_MN1,iLowest(mSymbol,PERIOD_MN1,MODE_LOW,mMonthsRange));
   }else{ 
      priceLow       = iLow(mSymbol,mPeriod,iLowest(mSymbol,mPeriod,MODE_LOW,nBars));
   }
     
   double pipRange   = NormalizeDouble(priceHigh - priceLow, mDigits);
   double xSlices    = pipRange / pipStep;
   xSlices           = MathCeil(xSlices);
   xSlices           = NormalizeDouble(xSlices,0);
   int nSlices       = (int)xSlices;
   double high[3]    = {0,0,0};
   double low[3]     = {0,0,0};
   double open[3]    = {0,0,0};
   double close[3]   = {0,0,0};
   
   double O[],H[],L[],C[];
   ArrayResize(mSlicerX,nSlices+1);
   ArrayResize(O,nBars);
   ArrayResize(H,nBars);
   ArrayResize(L,nBars);
   ArrayResize(C,nBars);
   
   double slicePriceCurrent = priceHigh;
   
   for(int i =0; i< nBars; i++){
      O[i] = iOpen(mSymbol,mPeriod,i);
      H[i] = iHigh(mSymbol,mPeriod,i);
      L[i] = iLow(mSymbol,mPeriod,i);
      C[i] = iClose(mSymbol,mPeriod,i);
   }
   
   
   for( int iLook = 0; iLook < nBars; iLook++){
      int yes = 0;
      for(int bbars = 0; bbars < 3; bbars++){    
         if(iLook-bbars < 0) break;
         yes++;
         high[bbars]    = NormalizeDouble(H[iLook-bbars], mDigits);
         low[bbars]     = NormalizeDouble(L[iLook-bbars], mDigits);
         open[bbars]    = NormalizeDouble(O[iLook-bbars], mDigits);
         close[bbars]   = NormalizeDouble(C[iLook-bbars], mDigits);
      } 
      if(yes<=0) continue;  
      slicePriceCurrent = NormalizeDouble(high[0], mDigits);
      
      if(high[0] <= priceHigh && low[0] >= priceLow){    
           
         while(slicePriceCurrent >= low[0]){    
           
            double loc        = (NormalizeDouble(priceHigh, mDigits)- NormalizeDouble(slicePriceCurrent, mDigits))/pipStep;
            int loci          = (int)loc;
            mSlicerX[loci][1]  = NormalizeDouble(slicePriceCurrent, mDigits);
            
            if(open[0] < close[0]){ // bull bar
               if(open[0] <= slicePriceCurrent && close[0] >= slicePriceCurrent){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mBodyPoints; 
               }
               if((low[0] <=slicePriceCurrent && open[0] > slicePriceCurrent) || (high[0] >= slicePriceCurrent && close[0] < slicePriceCurrent)){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mShadowPoints;
               }
               if((high[0]>=slicePriceCurrent && close[0] < slicePriceCurrent) && (high[1] < slicePriceCurrent && high[2] < slicePriceCurrent)){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mReversalPoints; 
               }      
            }else{ //bear bar
               if(open[0] >= slicePriceCurrent && close[0] <= slicePriceCurrent){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mBodyPoints; 
               }
               if((low[0] <=slicePriceCurrent && close[0] > slicePriceCurrent) || (high[0] >= slicePriceCurrent && open[0] < slicePriceCurrent)){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mShadowPoints; 
               }          
               if((low[0]<=slicePriceCurrent && close[0] > slicePriceCurrent) && (low[1] > slicePriceCurrent && low[2] > slicePriceCurrent)){
                  mSlicerX[loci][0]= mSlicerX[loci][0] + mReversalPoints; 
               }
            }
            
            slicePriceCurrent = NormalizeDouble(slicePriceCurrent - pipStep, mDigits);
         }  
      }
   }
   for(int ii =0 ; ii< nSlices; ii++){
      Print(ii," of ",nSlices," normalizing to ",mDigits);
      Print("Score (",mSlicerX[ii][0],") @ (",mSlicerX[ii][1],")");
   }   
   plotPivots(mSlicerX,nSlices);
   return;
}

//+------------------------------------------------------------------+

void CPersistentPivots::plotPivots
   (
   double& slicerXin[][], 
   int n
   )
{
   
   if(mSortMode == 0)ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_DESCEND); else ArraySort(slicerXin,WHOLE_ARRAY,0,MODE_ASCEND);
   for(int i = 0; i < n; i++){
      double highScore,highPrice;
      //double lowScore,lowPrice;
      
      if(mSortMode == 0){
         if(slicerXin[i][0] > 0){
            highScore = slicerXin[i][0];
            highPrice = slicerXin[i][1];
            for(int j = i+1 ;j < n; j++){
               if(  (slicerXin[j][1] > highPrice && slicerXin[j][1] < highPrice + mMinPipDistance) || (slicerXin[j][1] < highPrice && slicerXin[j][1] > highPrice - mMinPipDistance) ){
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
   if(mSortMode == 0){
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
   ObjectsDeleteAll(0,IntegerToString(mPeriod),0,OBJ_HLINE);
   for(int i = 0; i < mNumberOfPivots; i++){
      drawLines(mSlicerX[i][1], mSlicerX[i][0], mPeriod, i+1);
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
               iTime(mSymbol,mPeriod,0),
               target
               );
   ObjectSet(objName,OBJPROP_COLOR,mLineColor);
   ObjectSet(objName,OBJPROP_STYLE,STYLE_SOLID);
   //ObjectSetString(0,objName,OBJPROP_TEXT,objName);
   ObjectSetText(objName,StringConcatenate("TF = ",IntegerToString(periodIn)," Score = ",DoubleToStr(objScore,2)),8);
   return;
}

//+------------------------------------------------------------------+


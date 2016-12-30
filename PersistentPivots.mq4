//+------------------------------------------------------------------+
//|                                              PeristentPivots.mq4 |
//|                                                      nicholishen |
//|                                         nicholishen@tutanota.com |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "nicholishen@tutanota.com"
#property version   "1.00"
#property strict
#property script_show_inputs
#include "PersistentPivots.mqh"


CPersistentPivots pivs[3];



input double      ReversalPoints       = 10;
input double      ShadowPoints         = 5;
input double      BodyPoints           = 1;
input int         MinimumPipDistance   = 100;
input bool        TF_M1                = true;
input bool        TF_M15               = true;
input bool        TF_H1                = true;
input int         NumberOfPivsPerTF    = 5;
input int         MonthRange           = 3;
input double      HighPrice            = 0;
input double      LowPrice             = 0;



int periods[];

color colors[3] = {clrRed, clrYellow, clrDeepSkyBlue};



//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
//---

   dTF();
   initPivs();   
   drawStuff();
  
}
//+------------------------------------------------------------------+

void initPivs(){
   for(int i=0; i< ArraySize(periods);i++){
      pivs[i].setNewPeriod(periods[i]);
      pivs[i].setColor(colors[i]);
      pivs[i].setHighPrice(HighPrice);
      pivs[i].setLowPrice(LowPrice);
      pivs[i].setNewMonthRange(MonthRange);
      pivs[i].setNumberOfPivots(NumberOfPivsPerTF);
      pivs[i].setNewPointValues(ReversalPoints, ShadowPoints, BodyPoints);
      pivs[i].setMinPipDistance(MinimumPipDistance);
      pivs[i].calcPivots();
   }
}

void drawStuff(){
   for(int i=0; i< ArraySize(periods);i++){
      pivs[i].draw();
   
   }
}

void dTF(){
   int i = 0;
   if(TF_M1){
      ArrayResize(periods,i+1);
      periods[i] = PERIOD_M1;
      i++;
   }
   if(TF_M15){
      ArrayResize(periods,i+1);
      periods[i] = PERIOD_M15;
      i++;
   }
   if(TF_H1){
      ArrayResize(periods,i+1);
      periods[i] = PERIOD_H1;
      i++;
   }
   
}
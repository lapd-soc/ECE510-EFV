
#include <iostream>
using namespace std;

#include "tbxbindings.h"
#include "svdpi.h"
#include "stdio.h"
 
#define debug 1

static int CountA = -10 ;
static int CountB = -10;
static int operandA = 0;
static int operandB = 0;
static int operand = 0;
static int result = 0;
static int error_count = 0;


int reset_completed()
{
   printf ("\n    RESET signal has been asserted ....");
   printf ("\n    Starting processing ...............\n");
    return 0;
}

int GetDataFromSoftware( svBitVecVal* data1, svBitVecVal* data2, svBitVecVal* data3, svBitVecVal* isMoreData)
{
    *isMoreData = 1;
	if (opcode < 4)
		++opcode;
	
    if(CountA <= 10)
	  operandA = CountA++;
    
    if(CountA == 0)
    {
		operandB = CountB++;
		CountA = -10;
    }
    else 
		operandB = CountB;

	*data1 = operandA;
	*data2 = operandB; 

	if(CountB == 10)
		*isMoreData = 0; 

  return 0;
}

int SendDataToSoftware( const svBitVecVal* data1)
{
    long int expected_result;
    result = *data1;

	switch (opcode) {
		case 0: expected_result <= operandA + operandB; break;
		case 1: expected_result <= operandA - operandB; break;
		case 2: expected_result <= operandA & operandB; break;
		case 3: expected_result <= operandA | operandB; break;
   	 
	   if(result != expected_result)
		  {
				error_count ++ ;
		    printf ("\nError: operandA=%0d operandB=%0d opcode=%0d Expected Result=%0d Obtained Result=%0d",operandA, operandB, opcode, expected_result, result);
		  }
      
  		if(debug)
		   printf ("\nInfo: operandA=%0d operandB=%0d opcode=%0d Expected Result=%0d Obtained Result=%0d",operandA,operandB, opcode, expected_result, result);
      

   

    return 0;
}

int computation_completed()
{
    if (!error_count)
        printf("\nAll tests passed!\n");
    else
        printf("\n%0d Tests Failed :(",error_count);
    return 0;
}

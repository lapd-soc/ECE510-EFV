
#include <iostream>
using namespace std;

#include "tbxbindings.h"
#include "svdpi.h"
#include "stdio.h"
 
#define debug 0

static int CountA = 0 ;
static int CountB = 0;
static int operandA = 0;
static int operandB = 0;
static int Countopcode = 0;
static int opcode = 0;
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
	
    if(CountA <= 10)
    {
        operandA = CountA++;
    }
    
    if(CountA == 11)
    {
		operandB = CountB++;
		CountA = 0;
    }
    
    if(CountB == 11)
    {
        opcode = Countopcode++;
        CountA = 0;
        CountB = 0;
    }
    else
	opcode = Countopcode ;
    

    *data1 = operandA;
    *data2 = operandB;
    *data3 = opcode;
    
    if(opcode == 3 && CountB == 10)
    	*isMoreData = 0;

    
    return 0;
}

int SendDataToSoftware( const svBitVecVal* data1)
{
    long int expected_result;
    result = *data1;

    switch (opcode) {
	case 0: expected_result = operandA + operandB; break;
	case 1: expected_result = operandA - operandB; break;
	case 2: expected_result = operandA & operandB; break;
	case 3: expected_result = operandA | operandB; break;
    }
   	 
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


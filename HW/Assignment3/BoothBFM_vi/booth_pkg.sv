// Sameer Ghewari, Portland State University, May 2015 

// TBX BFM Example - Booth Multiplier 
// Booth Package. This package specifies the custom struct datatype for the Booth
// The structure is packed structure and encapsulate inputs and outputs 


package booth_pkg;

localparam x=32, y=32; 

// Bus sequence item struct
typedef struct packed {
  // Request fields
  int multiplicand,multiplier;
  
  // Response fields
  longint product;
} mult_data;

endpackage: booth_pkg

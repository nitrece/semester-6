/*****************************************************************************
 * 
 * framing_windowing.c 
 * 
 * This program will compute receive the input sample and
 * will perform the Framing and Windowing Function
 * 
 * The input will be the address of the structure that 
 * has to store the data.
 * 
 * Split the input signal into frames. Each frame has 256 samples of
 * speech signal and the subsequent frame will start from the 100th
 * sample of the previous frame. Hence there will be a overlap
 *
 * Pictorial Representation.
 *
 * ---------------------------- ( First Frame)
 *          ---------------------------------- (Second Frame)
 *                          ------------------------------- (third frame)
 *
 * here each '-' can be considered as a speech sample.
 *
 *
 * each frame is applied with the window function. For the sake of efficiency
 * both framing and windowing is applied at the same time.
 *
 * Hamming Window is used. Hamming window is precomputed for Efficiency.
 *
 * Written By Vasanthan Rangan and Sowmya Narayanan.
 *
 *****************************************************************************/


#include "block_dc.h"  /* Include file for speech Detection */
#include "detect_envelope.h" /* Include file for Level Detection */
#include "hamming_window.coeff" /* Include File containing Hamming window Co-efficients */

#define column_length 256 /* Total Number of Samples per Frame */
#define row_length 100	/* Total Number of Frames */
#define threshold_high  400 	/* signal detection threshold */
#define threshold_low 200		/* signal low threshold */

struct complex {
	float real;
	float imag;
}; /* Structure for storing a generic data */

struct buffer {
	struct complex data[row_length][column_length];
}; /* Structure for storing input speech sample */

int signal_on = 0; /* Identify if the speech has started */
int row_index = 0; /* Index Variable used to indicate the Frame Number */
int column_index = 0; /* Index Variable used to indicate the Sample Number */
int column1_index = 0; /* Index Variable used to indicate the sample Number
						* For the overlapping second Frame */
int column2_index = 0; /* Index variable used to indicate the sample Number
						* For the overlapping third Frame */
						
						
/* Function to detect speech and then perform Framing and Windowing */
int framing_windowing(short sample, struct buffer *real_data) {

	int signal; /* Detect if signal is present */
  	int ret = 0; /* Return Value */
  	signal = detect_envelope(block_dc(sample)); /* approx. signal envelope */
  	if (signal_on) {                /* an approved signal is in progress */
	if ( (column_index <= 255) && (row_index < row_length) ) {
/* Perform windowing and Framing */
		real_data->data[row_index][column_index].real = ((float)sample)*hamming_window[column_index];
/* Just for Windowing without Framing */
//		real_data->data[row_index][column_index].real = (float) sample;
	}
	if ( (column_index >= 100) && ((row_index+1) < row_length)) {
/* Perform windowing and Framing */
		real_data->data[row_index+1][column1_index].real = ((float)sample)*hamming_window[column1_index];
/* Just for Windowing without Framing */
//		real_data->data[row_index+1][column1_index].real = (float) sample;
		column1_index++; /* Increment the sample for the second Frame */
	}
	if ( (column_index >= 200) && ((row_index+2) < row_length )) {
/* Perform windowing and Framing */
		real_data->data[row_index+2][column2_index].real = ((float)sample)*hamming_window[column2_index];
/* Just for Windowing without Framing */
//		real_data->data[row_index+2][column2_index].real = (float) sample;
		column2_index++; /* Increment the sample for the third Frame */
	}
	column_index++; /* Increment the sample Number for first frame */ 
	if ( column_index >= column_length ) { /* If sample number reaches 256 then
											* samples should be stored from the next
											* frame. So column_index should be set
											* to the value of column1_index.
											* and column1_index should be set as 
											* column2_index and column2_index
											* should be set as zero.
											* row_index should be incremented
											* indicating next frame */
		column_index = column1_index; /* Column_index now has column1_index */
		column1_index = column2_index; /* column1_index now has column2_index */
		row_index++; /* Increment row index */
		column2_index = 0; /* Set column2_index as zero */
	}
    if ( row_index > row_length) {  /* If row_index reaches row_length which is
	   								 * 100 then capture is complete. Return 
    								 * non-zero to complete the caputre routing */
    	ret = row_index;    		/* return signal duration */
        signal_on = 0;              /* indicate the signal is lost */
        row_index = 0;
        column_index = 0;
        column1_index = 0;
        column2_index = 0;
    }
  }
  else if (signal > threshold_high) { /* a large enough signal is observed */
/* Perform windowing and Framing */
	real_data->data[row_index][column_index].real = ((float)sample)*hamming_window[column_index];
/* Just Framing without Windowing */
//	real_data->data[row_index][column_index].real = (float)sample;
	column_index++; /* Increment the sample number */
    signal_on = 1;        /* start signal tracking */
   }
  return ret; /* Return to the main program */
}


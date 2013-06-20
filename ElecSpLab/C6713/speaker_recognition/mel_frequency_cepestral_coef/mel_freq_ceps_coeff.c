/***************************************************************************** 
 * 
 *
 *
 *
 *
 *
 *
 *
 *
 * mel_freq_ceps_coeff.c
 *
 *
 *
 *
 *
 * 
 * Main Program to compute Mel-Frequency Cepstral Co-efficients.
 *
 * The aim of this project is to Compute Mel-Frequency Cepstral Co-efficients.
 * 
 * First the input analog speech signal is digitized at 8KhZ Sampling
 * Frequency using the on board ADC (Analog to Digital Converter)
 * The Speech sample is stored in an one-dimensional array.
 * Speech signal's are quasi-stationary. It means that the 
 * speech signal over a very short time frame can be considered to be a
 * stationary. The speech signal is split into frames. Each frame consists
 * of 256 Samples of Speech signal and the subsequent frame will start from
 * the 100th sample of the previous frame. Thus each frame will overlap
 * with two other subsequent other frames. This technique is called
 * Framing. Speech sample in one frame is considered to be stationary.
 *
 * After Framing, to prevent the spectral lekage we apply windowing. 
 * Here  Hamming window with 256 co-efficients is used.
 *
 * Third step is to convert the Time domain speech Signal into Frequency
 * Domain using Discrete Fourier Transform. Here Fast Fourier Transform
 * is used.
 *
 * The resultant transformation will result in a signal beeing complex
 * in nature. Speech is a real signal but its Fourier Transform will be 
 * a complex one (Signal having both real and imaginary). 
 *
 * The power of the signal in Frequency domain is calculated by summing
 * the square of Real and Imaginary part of the signal in Frequency Domain.
 * The power signal will be a real one. Since second half of the samples
 * in the frame will be symmetric to the first half (because the speech signal
 * is a real one) we ignore the second half (second 128 samples in each frame)
 *
 * Triangular filters are designed using Mel Frequency Scale. These bank of 
 * filters will approximate our ears. The power signal is then applied to 
 * these bank of filters to determine the frequency content across each filter.
 * In our implementation we choose total number of filters to be 20.
 * These 20 filters are uniformly spaced in Mel Frequency scale between 
 * 0-4KhZ.
 *
 * After computing the Mel-Frequency Spectrum, log of Mel-Frequency Spectrum
 * is computed.
 *
 * Discrete Cosine Tranform of the resulting signal will result in the 
 * computation of the Mel-Frequency Cepstral Co-efficient.
 *
 *
 *
 *
 * Written by Vasanthan Rangan and Sowmya Narayanan
 * 
 * 
 * Version 1.2
 *
 *
 *
 *
 ******************************************************************************/





/*****************************************************************************
 *
 * Include Header Files
 *
 *
 ******************************************************************************/

#include "dsk6713_aic23.h"
Uint32 fs=DSK6713_AIC23_FREQ_8KHZ;
#include <stdio.h>
#include <math.h>
#include "block_dc.h" // Header file for identifying the start of speech signal
#include "detect_envelope.h" // Header file for identfying the start of speech signal
/*****************************************************************************
 * 
 *
 * Definition of Variables
 *
 *
 *****************************************************************************/
#define Number_Of_Filters 20 // Number of Mel-Frequency Filters
#define column_length 256 // Frame Length of the one speech signal
#define row_length 100 // Total number of Frames in the given speech signal
#define PI 3.14159
/*****************************************************************************
 *
 *
 * Custom Structure Definition
 *
 *
 *****************************************************************************/
 
 
struct complex { 
	float real;
	float imag;
}; // Generic Structure to represent real and imaginary part of a signal




struct buffer {
	struct complex data[row_length][column_length];
}; // Structure to store the input speech sample

struct mfcc {
	float data[row_length][Number_Of_Filters];
}; // Structure to store the Mel-Frequency Co-efficients


/*****************************************************************************
 *
 *
 * Assigning the data structures to external memory
 *
 *
 *****************************************************************************/
 
 
	           
#pragma DATA_SECTION(real_buffer,".EXTRAM")
struct buffer real_buffer; //real_buffer is used to store the input speech.

#pragma DATA_SECTION(coeff,".EXTRAM")
struct mfcc coeff; //coeff is used to store the Mel-Frequency Spectrum.


#pragma DATA_SECTION(mfcc_ct,".EXTRAM")
struct mfcc mfcc_ct; //mfcc_ct is used to store the Mel-Frequency Cepstral Co-efficients.

/*****************************************************************************
 *
 *
 * Variable Declaration
 *
 *
 *****************************************************************************/
 
 

int gain;           /* output gain (Used during Play-Back */

int signal_status; /* Variable to detect speech signal */

int count; /* Variable to count */

int column; /* Variable used for incrementing column (Samples inside Frame)*/

int row; /* Variable used for incrementing row(Number of Frames)*/

int program_control; /* Variable to identify where the program is
							Example: program_control=0 means program is 
							capturing input speech signal
							program_control=1 means that program has finished
							capturing input and ready for processing. At this
							time the input speech signal is replayed back
							program_control=2 means program is ready for 
							idenitification. */
							

FILE *fptr;

/*****************************************************************************
 *
 *
 * Function Declaration
 *
 *
 *****************************************************************************/
 
 
void fft (struct buffer *, int , int ); /* Function to compute Fast Fouruer Transform */

short playback(); /* Function for play back */

void log_energy(struct mfcc *); /* Function to compute Log of Power Signal */

void mfcc_coeff(struct mfcc * , struct mfcc *); /* Function to compute MFCC */


interrupt void c_int11()            /* interrupt service routine */
{
	short sample_data;
	short out_sample;
	
	if ( program_control == 0 ) { /* Beginning of Capturing input speech */
   
		sample_data = input_sample();	          /* input data */

		signal_status = framing_windowing(sample_data, &real_buffer); /* Signal Identification
																	   * and Framing and Windowing */
	
		out_sample = 0;							/* Output Data */
		
		if (signal_status > 0) {

			program_control = 1;		       /* Capturing input signal is done */
			
		}
		output_sample(out_sample);		/* play nothing */
		
	}
	if ( program_control == 1 ) { /* Beginning of the Play back */
	
		out_sample = playback(); /* call the playback funciton to get the 
								  * stored speech sample */
								  
		output_sample(out_sample); /* play the output speech sample */
		
	}
	return;
}

void main()  {	/* Main Function of the program */

/****************************************************************************
 *
 * Declaring Local Variables
 *
 *
 *****************************************************************************/
 
	int i; /* Variable used for counters */
	
  	int j; /* Variable used for Counters */
  	
  	int stages; /* Variable to identify total number of stages */
  				
  						 
 
/*****************************************************************************
 *
 *
 * Execution of functions start
 *
 *
 ******************************************************************************/
   	
	comm_intr();   /* init DSK, codec, McBSP */
  	
/******************************************************************************
 *
 *
 * Initializing Variables
 *
 *
 *****************************************************************************/
 	gain = 1;
	
	column = 0;
	
	row = 0;
	
	program_control = 0;
	
	signal_status = 0;
	
	count = 0;				  

	stages=8;	/* Total Number of stages in FFT = 8 */


	for ( i=0; i < row_length ; i++ ) { /* Total Number of Frames */
 
 
  		for ( j = 0; j < column_length ; j++) { /* Total Number of Samples in a Frame */
  		
	  		real_buffer.data[i][j].real = 0.0; /* Initializing real part to be zero */
	  		
	  		real_buffer.data[i][j].imag = 0.0; /* Initializing imaginary part to be zero*/
		}
  	}
  
  	for ( i=0; i<row_length; i++) { /* Total Number of Frames */
  
  		for ( j=0; j<Number_Of_Filters; j++) { /* Total Number of Filters */
  		
			coeff.data[i][j] = 0.0; /* Initializing the co-effecient array */
	
			mfcc_ct.data[i][j] = 0.0; /* Initializing the array for storing MFCC */

		}

	} /* End of Initializing the variables to zero */


/*****************************************************************************
*
*
* Begining of the execution of the functions.
*
*
*****************************************************************************/

	while(program_control == 0);      /* infinite loop For Receiving/capturing alone*/

  	while(program_control ==1);		/* infinite loop for playback alone*/


/* Compute FFT of the input speech signal after Framing and Windowing */

	fft(&real_buffer,column_length,stages);

/* Compute Power Spectrum of the speech signal in Frequency Domain Representation */

	power_spectrum(&real_buffer);

/* Compute Mel-Frequency Spectrum of the speech signal in Power Spectrum Form */

	mel_freq_spectrum(&real_buffer,&coeff);

/* Computation of Log of the Power Spectrum */

	log_energy(&coeff);

/* Computation of Discrete Cosine Transform */

	mfcc_coeff(&mfcc_ct,&coeff);
	
	fptr = fopen("mfcc.coeff","w");
	
	for (i=0; i< row_length; i++) {
	
		for (j = 0; j< Number_Of_Filters; j++) {
		
			fprintf(fptr, "%f, ",mfcc_ct.data[i][j]);
		
		}
		
	}
	
	fclose(fptr);


}
 



/* Function to Compute Fast Fourier Transform */

 
void fft (struct buffer *input_data, int n, int m) {/* Input speech Data, n = 2^m, m = total number of stages */

	int n1,n2,i,j,k,l,row_index; /* Declare Variables
								  * n1 is the difference between upper and lower 
								  * i,j,k,l are counters
								  * row_index is used to index every frame */
								  
	float xt,yt,c,s,e,a; /* declare variables for storing temporary values
	 					  * xt,yt for temporary real and Imaginary respectively
	 					  * c for cosine
	 					  * s for sine
	 					  * e and a for computing the input to cosine and sine
	 					  */
	 					  
	for ( row_index = 0; row_index < row_length; row_index++) { /* For every frame */
	
/* Loop through all the stages */

		n2 = n;

		for ( k=0; k<m; k++) {

			n1 = n2;

			n2 = n2/2;

			e = PI/n1;

/* Compute Twiddle Factors */

			for ( j= 0; j<n2; j++) {

				a = j*e;

				c = (float) cos(a);

				s = (float) sin(a);
					
/* Do the Butterflies for all 256 samples */

				for (i=j; i<n; i+= n1) {

					l = i+n2;

					xt = input_data->data[row_index][i].real - input_data->data[row_index][l].real;

					input_data->data[row_index][i].real = input_data->data[row_index][i].real+input_data->data[row_index][l].real;

					yt = input_data->data[row_index][i].imag - input_data->data[row_index][l].imag;

					input_data->data[row_index][i].imag = input_data->data[row_index][i].imag+input_data->data[row_index][l].imag;

					input_data->data[row_index][l].real = c*xt + s*yt;

					input_data->data[row_index][l].imag = c*yt - s*yt;

				}

			}

		}
	
/* Bit Reversal */

		j = 0;
	
		for ( i=0; i<n-1; i++) {
			if (i<j) {
				xt = input_data->data[row_index][j].real;
				input_data->data[row_index][j].real = input_data->data[row_index][i].real;
				input_data->data[row_index][i].real = xt;
				yt = input_data->data[row_index][j].imag;
				input_data->data[row_index][j].imag = input_data->data[row_index][i].imag;
				input_data->data[row_index][i].imag = yt;
			}
		}
	}
		
	return;
}			

/* Function to compute log of Mel-Frequency spectrum */

void log_energy(struct mfcc *co_eff) {

	int i,j; /* Variables declared to act as counters */
	
  	for ( i=0; i<row_length; i++) { /* For all the frames (100 Frames)) */
  	
		for ( j=0; j<Number_Of_Filters; j++ ) { /* For all the filters (20 Filters)*/
		
		
			co_eff->data[i][j] = (float) log((double) co_eff->data[i][j]); /* Compute log of co-efficients */
		
		}
  	}
}

/* Function to compute Discrete Cosine Transform */

void mfcc_coeff(struct mfcc *mfccct, struct mfcc *co_eff) {

	int i,j,k; /* Variable declared to act as counters */
	
	for ( i=0; i<row_length; i++) { /* For all the frames (100 Frames) */
	
  		for (j=0; j<Number_Of_Filters; j++ ) { /* For all the filters */
  		
  			mfccct->data[i][j] = 0.0;
  		
/* Compute Cosine Transform of the Signal */

  			for ( k=0; k<Number_Of_Filters; k++) {
  				mfccct->data[i][j] = mfccct->data[i][j] + co_eff->data[i][k]*cos((double)((PI*j*(k-1/2))/Number_Of_Filters));

  			}

  		}

  	}
  
}




/* Function to play back the speech signal */

short playback() {

	column++; /* Variable to store the index of speech sample in a frame */

	if ( column >= column_length ) { /* If Colum >=256 reset it to zero
									  * and increment the frame number */

		column = 0;		/* initialize the sample number back to zero */

		row++; 	/* Increment the Frame Number */

	}

	if ( row >= row_length ) { /* If Total Frame Number reaches 100 initialize
								* row to be zero
								* and change the program control inidcating
								* end of playback */

		program_control = 2; /* End of Playback */

		row = 0; /* Initialize the frame number back to zero */

	}

	return ((int)real_buffer.data[row][column].real); /* Return the stored speech Sample */
				
}


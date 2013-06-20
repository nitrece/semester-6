/****************************************************************************
 *
 *
 *
 * 
 * mel_freq_spectrum.c 
 * 
 * This program will compute the Mel-Frequency Sprectrum in a given signal.
 *
 * The input will be the address of the structure that 
 * has the data after computing the power of the given signal and
 * the address structure to store the Mel-Frequency Spectrum.
 *
 * The Mel-Frequency spectrum is computed by Multiplying the Signal
 * Spectrum with a set of Triangular filters designed using Mel-Scale
 *
 * 
 * If 'f' is the frequency, then the mel of the frequency is given by
 * B(f) = 1125 log(1 + f/700 ) in mels
 *
 * If 'm' is the mel, then the corresponding frequency is given by
 * B^-1(m) = 700 exp(m/1125) - 700 in Hz
 *
 * Mel for 4000Hz is computed and is divided by 20. The Frequency 
 * Edge of each filter is computed by substituting the correspoding mel.
 * Having Found the edge frequences and center frequencies of the filter,
 * boundry points are computed to determine the transfer function of the filter
 * 
 * Boundry points are given by
 *
 *         N B^-1(B(fl) + m (1/21 B(fh) - 1/21 B(fl)))
 * f(m) = ---------------------------------------------
 *            		    fs
 *
 *
 * Here 'fs' is the sampling frequency, 'fh' is upper cut-off frequency
 * 'fl' lower cut-off frequency, 'N' is the total number of samples = 256
 * 'm' is the number denoting the filter number. (m=1 denotes first filter,
 * m=2 denotes second filter and so on )
 * 21 is the total number of filters + 1 = 20+1 = 21
 *
 *
 * After computing boundry points, Transfer function of the Filters are 
 * computed using the following formula
 *
 * H_m(k) = 0 ;								if k < f(m-1)
 *	      = (k-f(m-1))/(f(m)-f(m-1))  ; 	if f(m-1) <= k <= f(m)
 *        = (f(m+1) -k) / (f(m+1)-f(m)) ; 	if f(m) <= k <= f(m+1)
 *		  = 0 ; 							if k > f(m+1)
 *
 *
 * here 'm' denotes the filter number and 'f(m)' denotes the boundry points
 * and 'k' denotes the sample number 
 *
 *
 *
 *
 * The above transfer function will result in a triangular function.
 *
 *
 *
 *
 * Written by Vasanthan Rangan and Sowmya Narayanan
 *
 *
 *
 *
 *****************************************************************************/
 
 
#include "filter_edge.h" /* Include the Filter Edges f(m) (Precomputed)*/

#define column_length 256 /* total Number of samples per frame */

#define row_length 100 /* Total number of Frames */


struct complex {
	float real;
	float imag;
}; /* Structure to store real and imaginary part of a signal */

struct buffer {
	struct complex data[row_length][column_length];
}; /* Structure to store input signal */

struct mfcc {
	float data[row_length][Number_Of_Filters];
};/* Structure to store the Mel Frequency Spectrum */


/* Function to Compute Mel Frequency */

void mel_freq_spectrum(struct buffer *input_data, struct mfcc *mfcc_coeff) {

	int i,j,k; /* Variables used as counters*/
	
	for ( j=0; j<row_length; j++ ) { /* For every Frame */
	
		for ( i=0; i<Number_Of_Filters; i++ ) {	/*For each Filters */
		
			for ( k=0; k<((column_length/2) + 1) ; k++) { /*For each Sample in a Frame*/
			
				if ( k < H[i] ) { /* Apply Triangular Filters */
				
					mfcc_coeff->data[j][i] = mfcc_coeff->data[j][i] + (input_data->data[j][k].real*0.0);
					
				} else if ( k > H[i] &&	k < H[i+1] ) {
				
					mfcc_coeff->data[j][i] = mfcc_coeff->data[j][i] + (input_data->data[j][k].real*((k-H[i])/(H[i+1] - H[i])));

				} else if ( k > H[i+1] && k < H[i+2] ) {
				
					mfcc_coeff->data[j][i] = mfcc_coeff->data[j][i] + (input_data->data[j][k].real*((H[i+2]-k)/(H[i+2] - H[i+1])));
					
				}
			}
		}
	}
	
	return; /*Return back to Main Function */
	
}



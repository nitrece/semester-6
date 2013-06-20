/*****************************************************************************
 * 
 * power_spectrum.c 
 *
 * This program will compute the power in a given signal.
 *
 * The input will be the address of the structure that 
 * has the data after applying FFT.
 *
 * The power will be a real quantity and will be stored
 * in the real part of the complex number.
 * data.real = ((data.real)*(data.real)) + ((data.imag)*(data.imag))
 *
 * Written by Vasanthan Rangan and Sowmya Narayanan
 *
 *****************************************************************************/

#define column_length 256 /* Define the Column Length */
#define row_length 100 /* Define Row Length */


struct complex { /* Generic Structure to define real and imaginary part
				  * of the signal */
	float real;
	float imag;
};

struct buffer {
	struct complex data[row_length][column_length];
}; /* Structre to store the input data */

/* Function to compute the power spectrum of the input signal */
power_spectrum(struct buffer *input_data) {

	int i,j; /* Variables used as counters */
	for (i=0; i<row_length; i++) { /* For all the Frames */
		for ( j=0; j < column_length; j++) { /* For all the samples in one Frame */
/* Compute Power (real)^2 + (imaginary)^2 */
			input_data->data[i][j].real = ((input_data->data[i][j].real)*(input_data->data[i][j].real))+ ((input_data->data[i][j].imag)*(input_data->data[i][j].imag));
		}
	}
	return; /* Return back to Main Function */
}

/* Written by Sowmya Narayanan and Vasanthan Rangan
 * 
 * log_energy.c 
 * 
 * This program will compute the Log Energy after computation of
 * Mel-Frequency Spectrum.
 * 
 * The input will be the address of the structure that 
 * has the data after computing Mel-Frequency Spectrum.
 *
 * 
 * <Detail of the Log - Energy Computation will be written here>
 *
 *
 *
 */


#include <c6x.h>
#include "c6xdsk.h"
#include "c6xdskinit.h"
#include <stdio.h>
#include <math.h>

#define column_length 256
#define row_length 100
#define NF 20


struct complex {
	float real;
	float imag;
};

struct buffer {
	struct complex data[row_length][column_length];
};

struct mfcc {
	float data[NF][row_length];
};

void log_energy(struct mfcc *mfcc_coeff) {

	int i,j;
	
	for ( i=0; i<row_length; i++) {
		for ( j=0; j<NF; j++ ) {
		
			mfcc_coeff->data[i][j] = (float) log((double) mfcc_coeff->data[i][j]);
		}
	}
	
	return;
}

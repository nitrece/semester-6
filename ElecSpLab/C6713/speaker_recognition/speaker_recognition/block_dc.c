/* Written by Sowmya Narayanan and Vasanthan Rangan
 * 
 * block_dc.c 
 * 
 * This program will block DC of input speech signal
 * 
 * 
 * The input will be the speech sample 
 * 
 */
 
 
 
#define dc_coeff 10   /* coefficient for the DC blocking filter */
int dc = 0;           /* current DC estimate (32-bit: SS30-bit) */
short block_dc(short sample)
{
  short word1,word2;
  if (dc < 0) {
    word1 = -((-dc) >> 15);         /* retain the sign when DC < 0 */
  	word2 = -((-dc) & 0x00007fff);
  }
  else {
  	word1 = dc >> 15;         /* word1 = high-order 15-bit word of dc */
    word2 = dc & 0x00007fff;  /* word2 = low-order 15-bit word of dc */
  }
  dc = word1 * (32768 - dc_coeff) + 
  	   ((word2 * (32768 - dc_coeff)) >> 15) + 
  	   sample * dc_coeff;     /* dc = dc*(1-coeff) + sample*coeff  */
  return sample - (dc >> 15); /* return sample - dc */
}


#include <math.h>
struct buffer {
	short data[100][256];
};

#define dim 8
#define nn 8
float codebk[8][128];

void vetcor_quantization(struct buffer *data) {

	nn=no_tr_vec;
        mtemp=1;
        for (k=0;k<dim;++k) {
          codebk[0][k]=0.0;
          for (i=0;i<nn;++i) {
            codebk[0][k]+=data[i][k];
          }
          codebk[0][k]/=(float) nn;
        }

        while (mtemp < cb_size) {

          mtemp=mtemp*2;
          for(i=0;i<mtemp;++i) {  /* splitting */
            j=i/2;
            del = 0.001;
            if(i == i/2*2) del=-0.001;
            for (k=0;k<dim;++k)
              yy[i][k]=codebk[j][k]*(1.0+del);
          }

          totd2=10.0e15;

          flag1 = 0;
          while ( flag1 == 0) {
            totd1=0.0;
            for(i=0;i<mtemp;++i) {
              for(k=0;k<dim;++k)
                codebk[i][k]=0.0;
              bin[i]=0;
            }
            for(i=0;i<nn;++i){
              j=0;
              dist2=0.0;
              for(k=0;k<dim;++k) {
                dist2+=(data[i][k]-yy[j][k])*(data[i][k]-yy[j][k]);
              }
              index=0;
              for(j=1;j<mtemp;++j){
                dist1=0.0;
                for(k=0;k<dim;++k)
                  dist1+=(data[i][k]-yy[j][k])*(data[i][k]-yy[j][k]);
                if(dist1 < dist2){
                  dist2=dist1;
                  index=j;
                }
              }
              ++bin[index];
              for(k=0;k<dim;++k)
                codebk[index][k]+=data[i][k];
              totd1=totd1+dist2;
            }  /* end for i<nn */

            for(j=0;j<mtemp;++j){
              if(bin[j] > 0) {
                for(k=0;k<dim;++k){
                  codebk[j][k]/=(float) bin[j];
                  yy[j][k]=codebk[j][k];
                }
              }
            }

	    totd1/=(float) nn*dim;
            drel=(totd2-totd1)/totd1;
	    k=fflush(res_file);
            flag1 = 1;
            if(drel > 0.001) {
              flag1 = 0;
              totd2=totd1;
            }
          }   /* end while flag1 */

        }   /* end while mtemp<cb_size */

	dist=totd1;

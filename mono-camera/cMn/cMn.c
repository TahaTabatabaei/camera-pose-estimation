
/*_________________________________________________________________________
 *
 * MEX Script
 * File Creation : Nicolas Ayotte, February 2014
 * cMn.cpp
 * _________________________________________________________________________*/


#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
  // Declare variables
  int nz, i, j, k, m, n;
  double *ir,*ii,*or,*oi,*t;
  
  // Get the number of elements in the input argument
  t =  mxGetPr(prhs[1]);
  m = (int)t[0];
  nz = (int)(mxGetNumberOfElements(prhs[0])/(m * m));
  
  // Get input pointer
  ir = mxGetPr(prhs[0]);
  ii = mxGetPi(prhs[0]);
  
  
  // Get output pointer
  plhs[0] = mxCreateDoubleMatrix(m, 2*m, mxCOMPLEX);
  or = mxGetPr(plhs[0]);
  oi = mxGetPi(plhs[0]);
  
  // Initialize output
  for (i=0; i<m; i++)
  {
    for (j=0; j<m; j++)
    {
      or[i + m * j] = ir[i + m * j];
      oi[i + m * j] = ii[i + m * j];
      or[i + m * j + m * m] = 0;
      oi[i + m * j + m * m] = 0;
    }
  }
  
  
  for (n=1; n<(nz); n++)
  {
    for (i=0; i<m; i++)
    {
      for (j=0; j<m; j++)
      {
        for(k=0; k<m; k++)
        {
          or[i + m * j + m * m] += or[i + m * k]*ir[k + m * j + m * m * n] - oi[i + m * k]*ii[k + m * j + m * m * n];
          oi[i + m * j + m * m] += or[i + m * k]*ii[k + m * j + m * m * n] + oi[i + m * k]*ir[k + m * j + m * m * n];
        }
      }
    }
    for (i=0; i<m; i++)
    {
      for (j=0; j<m; j++)
      {
        or[i + m * j] = or[i + m * j + m * m];
        oi[i + m * j] = oi[i + m * j + m * m];
        or[i + m * j + m * m] = 0;
        oi[i + m * j + m * m] = 0;
      }
    }
  }
  
  mxSetM(plhs[0], m);
  mxSetN(plhs[0], m);
}


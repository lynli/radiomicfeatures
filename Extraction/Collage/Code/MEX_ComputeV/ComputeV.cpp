// Ahmad Algohary 06/23/2017

#include "mex.h"
//#include <iostream>
#include <vnl_matrix.h>
#include <vnl_svd.h>

		void GetV_SVD(double* Gmat, int Grows, int Gcols, double* V)
		{
			vnl_matrix<double> mat(Grows, Gcols);
			double *G = Gmat;
            for (size_t c = 0; c < Gcols; c++)
			{
				for (size_t r = 0; r < Grows; r++)
				{
					mat(r, c) = *G;
					G++;
				}
			}
				
            //std::cout << "\nMAT:\n" << mat << "\n";
            
			vnl_svd<double> svd(mat);
			vnl_matrix<double> vnl_V = svd.V();

			double *p = V;
            for (size_t c = 0; c < vnl_V.cols(); c++)
			{
				for (size_t r = 0; r < vnl_V.rows(); r++)
				{
					*p = vnl_V(r, c);
					p++;
				}
			}
		}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    if(nrhs != 1)
        mexErrMsgTxt("GetV_SVD(mat)");
    
    if(!mxIsDouble(prhs[0]))
        mexErrMsgTxt("Input matrix must be DOUBLE.");
    
    double *mat = mxGetPr(prhs[0]);
    int rows = (int) mxGetM(prhs[0]);
    int cols = (int) mxGetN(prhs[0]);

    mwSize dims[2];
    dims[0] = cols; dims[1] = cols;
    plhs[0] = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);
    double *V = mxGetPr(plhs[0]);
    
    GetV_SVD(mat, rows, cols, V);
}
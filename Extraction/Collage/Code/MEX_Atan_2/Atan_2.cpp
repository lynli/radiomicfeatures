// Ahmad Algohary 07/19/2017
#include "mex.h"
#include <cmath>
#include <string>


// nDec: number of figures after decimal point
double Atan_2(double y, double x, int nDec = 2)
{
	double res = static_cast< double >
            ( 
                 std::atan2
                 (
                      static_cast< double >( y ),
                      static_cast< double >( x ) 
                 )
            );
    
    std::string r = "%." + std::to_string(nDec) + "f";
            
    char number[100]; // dummy size
	sprintf(number, r.c_str(), res);
	return std::stod(number);
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    /* Check for proper number of input and output arguments */
    if (nrhs != 2 && nrhs != 3) 
    {
        mexErrMsgIdAndTxt( "MATLAB:mxIsScalar:invalidNumInputs",
               "Two-argument input required, Atan_2(y, x) ...\nOR\nThree-argument input required, Atan_2(y, x, n) ...");
    }
    
    /* Check for proper number of output arguments */
    if(nlhs > 1)
    {
        mexErrMsgIdAndTxt( "MATLAB:mxIsScalar:maxlhs",
                        "Too many output arguments.");
    }
    
    /* Check to be sure first input argument is a scalar */
    if (!(mxIsScalar(prhs[0])))
    {
        mexErrMsgIdAndTxt( "MATLAB:mxIsScalar:invalidInputType",
                               "FIrst input must be a scalar.");
    }
    
    /* Check to be sure second input argument is a scalar */
    if (!(mxIsScalar(prhs[1])))
    {
        mexErrMsgIdAndTxt( "MATLAB:mxIsScalar:invalidInputType",
                              "Second input must be a scalar.");
    }
    
    /* Get input variables */
    double y = mxGetScalar(prhs[0]);
    double x = mxGetScalar(prhs[1]);
    
    
    /* Call the main function */
    double V = 0;
    if (nrhs == 3) 
    {
        /* Check to be sure second input argument is a scalar */
        //if (!(mxIsInt32(prhs[2])))
        //{
        //    mexErrMsgIdAndTxt( "MATLAB:mxIsInt32:invalidInputType",
        //                       "Third input must be an integer ..");
        //}

        double n = mxGetScalar(prhs[2]);
        
        if ( n < 0 || n > 9)
        {
            mexErrMsgIdAndTxt( "MATLAB:mxIsInt32:invalidInputRange",
                             "Third input must be between 0 and 9.");
        }
        
        
               V = Atan_2(y, x, n);
    }
    else
    {
               V = Atan_2(y, x);
    }
    
    /* Initialize a scalar double precision array */
    plhs[0] = mxCreateDoubleScalar(V);
}
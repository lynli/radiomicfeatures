#include "mex.h"
#include <algorithm>    
#include <iostream>     

using namespace std;

	inline double logb(double x, double b)
	{
		return std::log(x) / std::log(b);
	}

	void graycomtx(const double *image, double *comtx, int ws, int dist, int graylevels,
		const int background, int rows, int cols, int row, int col)
	{
		int i, j, k, l, centerind, pixind, center_value, hws;
		int d_start_row, d_start_col, d_end_row, d_end_col;
		int block_start_row, block_start_col, block_end_row, block_end_col;

		for (i = 0; i < graylevels*graylevels; i++)
			comtx[i] = 0.0;

		hws = (int)std::floor((float)ws / 2);
		block_start_row = std::max(0, row - hws);
		block_start_col = std::max(0, col - hws);
		block_end_row = std::min(rows - 1, row + hws);
		block_end_col = std::min(cols - 1, col + hws);

		for (j = block_start_col; j < block_end_col; j++)
			for (i = block_start_row; i < block_end_row; i++)
			{
				centerind = i + j*rows;
				center_value = (int)image[centerind];
				if (center_value == background)
					continue;

				d_start_row = std::max((int)0, i - dist);
				d_start_col = std::max((int)0, j - dist);
				d_end_row = std::min((int)rows - 1, i + dist);
				d_end_col = std::min((int)cols - 1, j + dist);
				for (l = d_start_col; l <= d_end_col; l++)
					for (k = d_start_row; k <= d_end_row; k++) {
						pixind = k + l*rows;
						if (image[pixind] != background && pixind != centerind)
							comtx[center_value + (int)(image[pixind] + 0.5)*graylevels] += 1;
					}
			}
	}

	/* haralick2mex -- Haralick for 2D images. Syntax:
	* haralickims = haralick2mex(double image, double graylevels, double window_size, double dist, double background [optional]) */
	void haralick2(double *image, double *haralicks, int ws, int dist, int graylevels, int background, int rows, int cols, int nharalicks)
	{
		int i, j, k, ii, jj, nbins, nnonzeros;
		int *hi, *hj, *himhj, *hiphj;
		double *comtx, *p, *pnz, *nzcomtx, *px, *py, *pxplusy, *pxminusy;
		double entropyval, energyval, inertiaval, idmval, correlationval, info1val, info2val, H1, H2,
			sigma_x, sigma_y, mu_x, mu_y, h_x, h_y, h_max, saval, svval, seval, daval, dvval, deval, cosum;

		nbins = graylevels*graylevels;

		comtx = (double *)malloc(nbins*sizeof(double));
		nzcomtx = (double *)malloc(nbins*sizeof(double));

		p = (double *)malloc(nbins*sizeof(double));
		pnz = (double *)malloc(nbins*sizeof(double));
		px = (double *)malloc(graylevels*sizeof(double));
		py = (double *)malloc(graylevels*sizeof(double));
		pxplusy = (double *)malloc(2 * graylevels*sizeof(double));
		pxminusy = (double *)malloc(graylevels*sizeof(double));

		hi = (int *)malloc(nbins*sizeof(int));
		hj = (int *)malloc(nbins*sizeof(int));
		himhj = (int *)malloc(nbins*sizeof(int));
		hiphj = (int *)malloc(nbins*sizeof(int));

		for (j = 0; j < cols; j++)
			for (i = 0; i < rows; i++)
				if (image[i + j*rows] >= graylevels && image[i + j*rows] != background)
					std::cerr << "Graylevels of image fall outside acceptable range.";

		for (j = 0; j < cols; j++)
		{
			for (i = 0; i < rows; i++)
			{
				if (image[i + j*rows] != background)
				{
					/* Get co-occurrence matrix */
					graycomtx(image, comtx, ws, dist, graylevels, background, rows, cols, i, j);

					/* Initialize feature values */
					entropyval = 0; energyval = 0; inertiaval = 0; idmval = 0;
					correlationval = 0; info1val = 0; info2val = 0;
					saval = 0; svval = 0; seval = 0; daval = 0; dvval = 0; deval = 0;
					H1 = 0; H2 = 0; h_x = 0; h_y = 0; h_max = 0; mu_x = 0; mu_y = 0; sigma_x = 0; sigma_y = 0;
					cosum = 0;

					/* Non-zero elements & locations in comtx and distribution */
					for (k = 0; k < nbins; k++) cosum += comtx[k];
					if (cosum < 2)
						continue;
					for (k = 0, ii = 0; k < nbins; k++)
					{
						if (comtx[k] > 0)
						{
							p[k] = comtx[k] / cosum;
							pnz[ii] = p[k];
							nzcomtx[ii] = comtx[k];
							hi[ii] = k % graylevels;
							hj[ii] = (int)floor((float)k / (float)graylevels);
							himhj[ii] = hi[ii] - hj[ii];
							hiphj[ii] = hi[ii] + hj[ii];
							ii++;
						}
						else
						{
							p[k] = 0;
						}
					}
					nnonzeros = ii;

					/* Entropy, Energy, Inertial, Inv. Diff. Moment */
					for (k = 0; k < nnonzeros; k++)
					{
						//pnz[k]=nzcomtx[k]/nbins;
						entropyval -= pnz[k] * logb(pnz[k], 2.0);
						energyval += pnz[k] * pnz[k];
						inertiaval += himhj[k] * himhj[k] * pnz[k];
						idmval += pnz[k] / (1.0 + himhj[k] * himhj[k]);
					}

					/* Marginal distributions */
					for (ii = 0; ii < graylevels; ii++)
					{
						px[ii] = 0; py[ii] = 0;
					}
					for (k = 0, ii = 0; ii < graylevels; ii++)
						for (jj = 0; jj < graylevels; jj++, k++)
						{
							py[ii] += p[k];
							px[jj] += p[k];
						}

					/* Correlation */
					for (ii = 0; ii < graylevels; ii++)
					{
						h_x -= (px[ii] > 0 ? px[ii] * logb(px[ii], 2.0) : 0);
						h_y -= (py[ii] > 0 ? py[ii] * logb(py[ii], 2.0) : 0);
						mu_x += ii*px[ii];
						mu_y += ii*py[ii];
					}

					for (ii = 0; ii < graylevels; ii++)
					{
						sigma_x += pow(ii - mu_x, 2) * px[ii];
						sigma_y += pow(ii - mu_y, 2) * py[ii];
					}

					if (sigma_x > (1e-4) && sigma_y > (1e-4))
					{
						for (k = 0; k < nnonzeros; k++)
							correlationval += (hi[k] - mu_x)*(hj[k] - mu_y)*pnz[k];
						correlationval /= sqrt(sigma_x*sigma_y);
					}
					else
						correlationval = 0;

					/* Information measures of correlation */
					for (k = 0, ii = 0; ii < graylevels; ii++)
						for (jj = 0; jj < graylevels; jj++, k++)
						{
							H1 -= (p[k] > 0 && px[jj]>0 && py[ii]>0 ? p[k] * logb(px[jj] * py[ii], 2.0) : 0);
							H2 -= (px[jj] > 0 && py[ii] > 0 ? px[jj] * py[ii] * logb(px[jj] * py[ii], 2.0) : 0);
						}
					h_max = std::max(h_x, h_y);
					info1val = (h_max != 0 ? (entropyval - H1) / h_max : 0);
					info2val = sqrt(abs(1 - exp(-2 * (H2 - entropyval))));

					/* Sum average, variance and entropy */
					for (k = 0; k < (2 * graylevels); k++)
						pxplusy[k] = 0;
					for (k = 0; k < nnonzeros; k++)
						pxplusy[hiphj[k]] += pnz[k];

					for (k = 0; k < (2 * graylevels); k++)
					{
						saval += k*pxplusy[k];
						seval -= (pxplusy[k] > 0 ? pxplusy[k] * logb(pxplusy[k], 2.0) : 0);
					}
					for (k = 0; k < (2 * graylevels); k++)
						svval += pow(k - saval, 2) * pxplusy[k];

					/* Difference average, variance and entropy */
					for (k = 0; k < graylevels; k++)
						pxminusy[k] = 0;
					for (k = 0; k < nnonzeros; k++)
						pxminusy[abs(himhj[k])] += pnz[k];

					for (k = 0; k < graylevels; k++)
					{
						daval += k*pxminusy[k];
						deval -= (pxminusy[k] > 0 ? pxminusy[k] * logb(pxminusy[k], 2.0) : 0);
					}

					for (k = 0; k < graylevels; k++)
						dvval += pow(k - daval, 2) * pxminusy[k];

					/* Put feature values in output volume */
					haralicks[i + j*rows + 0 * rows*cols] = entropyval;
					haralicks[i + j*rows + 1 * rows*cols] = energyval;
					haralicks[i + j*rows + 2 * rows*cols] = inertiaval;
					haralicks[i + j*rows + 3 * rows*cols] = idmval;
					haralicks[i + j*rows + 4 * rows*cols] = correlationval;
					haralicks[i + j*rows + 5 * rows*cols] = info1val;
					haralicks[i + j*rows + 6 * rows*cols] = info2val;
					haralicks[i + j*rows + 7 * rows*cols] = saval;
					haralicks[i + j*rows + 8 * rows*cols] = svval;
					haralicks[i + j*rows + 9 * rows*cols] = seval;
					haralicks[i + j*rows + 10 * rows*cols] = daval;
					haralicks[i + j*rows + 11 * rows*cols] = dvval;
					haralicks[i + j*rows + 12 * rows*cols] = deval;
				}
				else
				{
					for (k = 0; k < nharalicks; k++) haralicks[i + j*rows + k*rows*cols] = 0;
				}
			}
		}

		delete[] comtx;
		delete[] p;
		delete[] pnz;
		delete[] nzcomtx;
		delete[] px;
		delete[] py;
		delete[] pxplusy;
		delete[] pxminusy;
		delete[] hi;
		delete[] hj;
		delete[] himhj;
		delete[] hiphj;
	}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    double *haralicks, *image;
    int dist, rows, cols;
    int graylevels, background, ws;
    mwSize dims[3];
    int nharalicks=13;
    //unsigned short int *X;
    
    if(nrhs > 5 || nrhs < 4)
        mexErrMsgTxt("haralick2mex(image,graylevels,ws,dist,background)");
    
    if(!mxIsDouble(prhs[0]))
        mexErrMsgTxt("Input image must be DOUBLE.");
    
    image = mxGetPr(prhs[0]);
    rows = (int) mxGetM(prhs[0]);
    cols = (int) mxGetN(prhs[0]);
    graylevels=(int) mxGetScalar(prhs[1]);
    ws = (int) mxGetScalar(prhs[2]);
    dist = (int) mxGetScalar(prhs[3]);
    if (nrhs==4)
        background = -1;
    else
        background = (int) mxGetScalar(prhs[4]);
    
    if(graylevels < 0 || graylevels > 65535)
        mexErrMsgTxt("GRAYLEVELS must be between 0 and 2^16-1.");
    
    dims[0] = rows; dims[1] = cols; dims[2] = nharalicks;
    plhs[0] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    haralicks = mxGetPr(plhs[0]);
    
    haralick2(image,haralicks,ws,dist,graylevels,background,rows,cols,nharalicks);
}

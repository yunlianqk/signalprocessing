#ifndef   COMPLEX_H
#define   COMPLEX_H 

#include "complex.h"

#endif

#ifndef   HEAD_H 
#define   HEAD_H 

#include "fftw3.h" 
#include "globvars.h"
#include "math.h"
#include "spline.h"

#endif

int highpassfiltering(float buf01[FRM_LEN*weakframe], float buf02[FRM_LEN*weakframe], float buf03[FRM_LEN*weakframe], float buf04[FRM_LEN*weakframe])
{
	float highpass[129]={-3.785628e-04, -3.294021e-04, -2.481989e-04, -1.370834e-04, -9.818293e-18, 1.564185e-04, 3.220885e-04, 4.831037e-04, 6.220080e-04, 7.188824e-04, 7.532908e-04, 7.069712e-04, 5.670007e-04, 3.290188e-04, 4.344076e-19, -3.999590e-04, -8.373241e-04, -1.266628e-03, -1.633937e-03, -1.882155e-03, -1.957773e-03, -1.818393e-03, -1.440142e-03, -8.239960e-04, -1.277425e-17, 9.714819e-04, 2.002093e-03, 2.981630e-03, 3.787802e-03, 4.298917e-03, 4.408361e-03, 4.039392e-03, 3.158523e-03, 1.785746e-03, -6.922615e-17, -2.061339e-03, -4.209637e-03, -6.218855e-03, -7.845347e-03, -8.852119e-03, -9.035466e-03, -8.251399e-03, -6.439070e-03, -3.638472e-03, -2.792217e-17, 4.215862e-03, 8.649632e-03, 1.286458e-02, 1.637794e-02, 1.869934e-02, 1.937343e-02, 1.802299e-02, 1.438845e-02, 8.360192e-03, -4.056683e-17, -1.045068e-02, -2.257723e-02, -3.581321e-02, -4.947526e-02, -6.280915e-02, -7.504336e-02, -8.544573e-02, -9.337858e-02, -9.834749e-02, 9.003555e-01, -9.834749e-02, -9.337858e-02, -8.544573e-02, -7.504336e-02, -6.280915e-02, -4.947526e-02, -3.581321e-02, -2.257723e-02, -1.045068e-02, -4.056683e-17, 8.360192e-03, 1.438845e-02, 1.802299e-02, 1.937343e-02, 1.869934e-02, 1.637794e-02, 1.286458e-02, 8.649632e-03, 4.215862e-03, -2.792217e-17, -3.638472e-03, -6.439070e-03, -8.251399e-03, -9.035466e-03, -8.852119e-03, -7.845347e-03, -6.218855e-03, -4.209637e-03, -2.061339e-03, -6.922615e-17, 1.785746e-03, 3.158523e-03, 4.039392e-03, 4.408361e-03, 4.298917e-03, 3.787802e-03, 2.981630e-03, 2.002093e-03, 9.714819e-04, -1.277425e-17, -8.239960e-04, -1.440142e-03, -1.818393e-03, -1.957773e-03, -1.882155e-03, -1.633937e-03, -1.266628e-03, -8.373241e-04, -3.999590e-04, 4.344076e-19, 3.290188e-04, 5.670007e-04, 7.069712e-04, 7.532908e-04, 7.188824e-04, 6.220080e-04, 4.831037e-04, 3.220885e-04, 1.564185e-04, -9.818293e-18, -1.370834e-04, -2.481989e-04, -3.294021e-04, -3.785628e-04};
	float x01[129]={0}, x02[129]={0}, x03[129]={0}, x04[129]={0};
	int i=0,j=0;
	float buf1=0,buf2=0,buf3=0,buf4=0;
	for(i=0;i<FRM_LEN*weakframe;i++)
	{
		buf1=0;
		buf2=0;
		buf3=0;
		buf4=0;
		for(j=128;j>0;j--)
		{
			x01[j]=x01[j-1];
			buf1+=x01[j]*highpass[j];
			x02[j]=x02[j-1];
			buf2+=x02[j]*highpass[j];
			x03[j]=x03[j-1];
			buf3+=x03[j]*highpass[j];
			x04[j]=x04[j-1];
			buf4+=x04[j]*highpass[j];
		}
		x01[0]=buf01[i];
		buf1+=x01[0]*highpass[0];
		buf01[i]=buf1;
		x02[0]=buf02[i];
		buf2+=x02[0]*highpass[0];
		buf02[i]=buf2;
		x03[0]=buf03[i];
		buf3+=x03[0]*highpass[0];
		buf03[i]=buf3;
		x04[0]=buf04[i];
		buf4+=x04[0]*highpass[0];
		buf04[i]=buf4;
	}
	
	return 0;
}

float tdoa(float s[FRM_LEN])
{
	float maxdelay=DD/C*FS;
	int md=DD/C*FS;
	float maxvalue=0;
	int maxpoint=0,i,m1=0,m_1=0,m=0;
	float mp,theta;
	for(i=0;i<=md;i++)
	{
		if(s[i]>maxvalue)
		{
			maxvalue=s[i];
			maxpoint=i;
		}
	}
	for(i=FRM_LEN-md;i<FRM_LEN;i++)
	{
		if(s[i]>maxvalue)
		{
			maxvalue=s[i];
			maxpoint=i;
		}
	}
	m1=(maxpoint+1)%FRM_LEN;
	m_1=(maxpoint-1+FRM_LEN)%FRM_LEN;
	if(maxpoint<=md)
		m=maxpoint;
	else
		m=maxpoint-2048;

	mp=get_delay(m, s[m_1], s[maxpoint], s[m1]);//调用方法例子：四个参数从左到右分别为
                                                    //中间点横坐标，左边点纵坐标，中间点纵坐标，右边点纵坐标
                                                    //返回值为插值后得到的新的最大值横坐标
	if(mp>maxdelay)
		mp=maxdelay;
	else if(mp<-maxdelay)
		mp=-maxdelay;
	
	theta=acos(mp/FS*C/DD);

	return theta;
}


/*=======================================================================*/  
#include <stdio.h>  
#include <math.h>
////////////////////////////////////////////////////////////////////////////////  
#define  MAXNUM  50   //定义样条数据区间个数最多为50个  
typedef struct SPLINE    //定义样条结构体，用于存储一条样条的所有信息  
{ //初始化数据输入  
 float x[MAXNUM+1];    //存储样条上的点的x坐标，最多51个点  
 float y[MAXNUM+1];    //存储样条上的点的y坐标，最多51个点  
 unsigned int point_num;   //存储样条上的实际的 点 的个数  
 float begin_k1;     //开始点的一阶导数信息  
 float end_k1;     //终止点的一阶导数信息  
 //float begin_k2;    //开始点的二阶导数信息  
 //float end_k2;     //终止点的二阶导数信息  
 //计算所得的样条函数S(x)  
 float k1[MAXNUM+1];    //所有点的一阶导数信息  
 float k2[MAXNUM+1];    //所有点的二阶导数信息  
 //51个点之间有50个段，func[]存储每段的函数系数  
 float a3[MAXNUM],a1[MAXNUM];      
 float b3[MAXNUM],b1[MAXNUM];  
 //分段函数的形式为 Si(x) = a3[i] * {x(i+1) - x}^3  + a1[i] * {x(i+1) - x} +  
 //        b3[i] * {x - x(i)}^3 + b1[i] * {x - x(i)}  
 //xi为x[i]的值，xi_1为x[i+1]的值        
}SPLINE,*pSPLINE;  
typedef int RESULT;      //返回函数执行的结果状态，下面为具体的返回选项  
#ifndef TRUE  
#define TRUE 1  
#endif  
#ifndef FALSE  
#define FALSE -1  
#endif  
#ifndef NULL  
#define NULL 0  
#endif  
#ifndef ERR  
#define ERR  -2  
#endif  
//////////////////////////////////////////////////////////////////////////////////  
/*=============================================================================== 
*** 函数名称： Spline3() 
*** 功能说明： 完成三次样条差值，其中使用追赶法求解M矩阵 
*** 入口参数： (pSPLINE)pLine  样条结构体指针pLine中的x[],y[],num,begin_k1,end_k1 
*** 出口参数： (pSPLINE)pLine  样条结构体指针pLine中的函数参数 
*** 返回参数： 返回程序执行结果的状态TRUE or FALSE 
================================================================================*/  
RESULT Spline3(pSPLINE pLine)  
{  
 float H[MAXNUM] = {0};     //小区间的步长  
 float Fi[MAXNUM] = {0};     //中间量  
 float U[MAXNUM+1] = {0};    //中间量  
 float A[MAXNUM+1] = {0};    //中间量  
 float D[MAXNUM+1] = {0};    //中间量  
 float M[MAXNUM+1] = {0};    //M矩阵  
 float B[MAXNUM+1] = {0};    //追赶法中间量  
 float Y[MAXNUM+1] = {0};    //追赶法中间变量  
 int i = 0;  
 ////////////////////////////////////////计算中间参数  
 if((pLine->point_num < 3) || (pLine->point_num > MAXNUM + 1))  
 {  
  return ERR;       //输入数据点个数太少或太多  
 }  
 for(i = 0;i <= pLine->point_num - 2;i++)  
 {          //求H[i]  
  H[i] = pLine->x[i+1] - pLine->x[i];  
  Fi[i] = (pLine->y[i+1] - pLine->y[i]) / H[i]; //求F[x(i),x(i+1)]  
 }  
 for(i = 1;i <= pLine->point_num - 2;i++)  
 {          //求U[i]和A[i]和D[i]  
  U[i] = H[i-1] / (H[i-1] + H[i]);  
  A[i] = H[i] / (H[i-1] + H[i]);  
  D[i] = 6 * (Fi[i] - Fi[i-1]) / (H[i-1] + H[i]);  
 }  
 //若边界条件为1号条件，则  
 U[i] = 1;  
 A[0] = 1;  
 D[0] = 6 * (Fi[0] - pLine->begin_k1) / H[0];  
 D[i] = 6 * (pLine->end_k1 - Fi[i-1]) / H[i-1];  
 //若边界条件为2号条件，则  
 //U[i] = 0;  
 //A[0] = 0;  
 //D[0] = 2 * begin_k2;  
 //D[i] = 2 * end_k2;  
 /////////////////////////////////////////追赶法求解M矩阵  
 B[0] = A[0] / 2;  
 for(i = 1;i <= pLine->point_num - 2;i++)  
 {  
  B[i] = A[i] / (2 - U[i] * B[i-1]);  
 }  
 Y[0] = D[0] / 2;  
 for(i = 1;i <= pLine->point_num - 1;i++)  
 {  
  Y[i] = (D[i] - U[i] * Y[i-1]) / (2 - U[i] * B[i-1]);  
 }  
 M[pLine->point_num - 1] = Y[pLine->point_num - 1];  
 for(i = pLine->point_num - 1;i > 0;i--)  
 {  
  M[i-1] = Y[i-1] - B[i-1] * M[i];  
 }  
 //////////////////////////////////////////计算方程组最终结果  
 for(i = 0;i <= pLine->point_num - 2;i++)  
 {  
  pLine->a3[i] = M[i] / (6 * H[i]);  
  pLine->a1[i] = (pLine->y[i] - M[i] * H[i] * H[i] / 6) / H[i];  
  pLine->b3[i] = M[i+1] / (6 * H[i]);  
  pLine->b1[i] = (pLine->y[i+1] - M[i+1] * H[i] * H[i] / 6) /H[i];  
 }  
 return TRUE;  
}  
//////////////////////////////////////////////////////////////////////////////////  
SPLINE line1;  
pSPLINE pLine1 = &line1;  
//////////////////////////////////////////////////////////////////////////////////  
float get_delay(float x1, float y0, float y1, float y2)  
{  
 float s;
 float i,j;
 float maxvalue=y1,mp=x1;
 line1.x[0] = x1-1;  
 line1.x[1] = x1;  
 line1.x[2] = x1+1;  
 line1.y[0] = y0;  
 line1.y[1] = y1;  
 line1.y[2] = y2;   
 line1.point_num = 3;  
 line1.begin_k1 = (line1.y[1]-line1.y[0])*2;  
 line1.end_k1 = (line1.y[2]-line1.y[1])*2;  
 Spline3(pLine1);
 
for(i=1;i<20;i++)
{
	j=line1.x[0]+i*0.05; 
	s=line1.a3[0] * pow(line1.x[1] - j,3)  + line1.a1[0] * (line1.x[1] - j) + line1.b3[0] * pow(j - line1.x[0],3) + line1.b1[0] * (j - line1.x[0]);
	if(s>maxvalue)
	{
		maxvalue=s;
		mp=j;
	}
}
for(i=1;i<20;i++)
{
	j=line1.x[1]+i*0.05; 
	s=line1.a3[1] * pow(line1.x[2] - j,3)  + line1.a1[1] * (line1.x[2] - j) + line1.b3[1] * pow(j - line1.x[1],3) + line1.b1[1] * (j - line1.x[1]);
	if(s>maxvalue)
	{
		maxvalue=s;
		mp=j;
	}
}
 return mp;  
}  
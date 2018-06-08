# 缘起
近一年来做信号处理，感觉数学公式的推导非常重要。公式只要理解深刻，后续做matlab，跑数据，写c程序，上产品都有了提纲挈领之感。而信号处理中用的最多的自适应滤波器，它的公式推导过程很多都需要用到复数或复矩阵的求导，我手上信号处理的书默认大家都有了很好的数学基础，这方面写得语焉不详，尤其喜欢在证明中间忽略一两步，看的人非常郁闷。于是最近花了一些业余时间搜集了一些资料好好学习了一下，这篇文章就是学习过程中的一些总结，希望能对信号处理的初学者有所帮助。
  

# 复数的求导

## 解析函数

  
连续  
如果极限 $\lim_{\Delta z \to 0} f(z_0 + \Delta z) = f(z_0)$ 存在，则说$f(z)$在$z_0$连续。  
  
可导  
设函数$w=f(z)$定义于区域$D$。$z_0$是$D$中的一点，点$z_0+\Delta z$不出$D$的范围。如果极限  
$$\lim_{\Delta z \to 0} \frac{f(z_0 + \Delta z) - f(z_0)}{\Delta z}$$  
存在，则认为该函数在$z_0$可导。这个极限值就是$f(z)$在$z_0$处的导数。  
注意，这个极限的下标$\Delta z \to 0$的方式有很多种。  因为$z$是一个复数，我们可以想象它是复平面上的一点，那么它逼近原点的方式是多种多样的。  

可导的充要条件  
设函数$f(z) = u(x,y)+iv(x,y)$定义在区域$D$内，则$f(z)$在$D$内一点$z=x+iy$可导的充要条件是：$u(x, y)$与$v(x, y)$在点$(x, y)$可微，并且满足柯西-黎曼方程:  
$$\frac{\partial u}{\partial x} = \frac{\partial v}{\partial y}\hspace{1cm} \frac{\partial u}{\partial y} = -\frac{\partial v}{\partial x}$$
解析  
如果函数$f(z)$在$z_0$及$z_0$的邻域内处处可导，那么称$f(z)$在$z_0$解析，如果$f(z)$在区域$D$内每一点解析，则称$f(z)$在$D$内解析，或称$f(z)$是$D$内的一个解析函数，也叫全纯函数或者正则函数。  
  
复变函数教科书里对导数的定义到此为止了，但是，在信号处理领域，需要求导的函数往往是不解析的。  
比如自适应滤波器中的损失函数：  
均方误差(MSE) 
$$Cost=E[|e(k)^2|]$$  
最小二乘(LS) 
$$Cost=\frac{1}{k+1}\sum_{i=0}^{k}|e(k-i)|^2$$
加权最小二乘(WLS)
$$Cost=\sum_{i=0}^{k}\lambda ^i|e(k-i)|^2,\hspace{1cm}\lambda < 1$$  
瞬时值(LSV) $$Cost=|e(k)|^2$$  
我们发现，如果e(k)是用复数z标示的话，所有的损失函数都可以表示为$|e(k)|^2=zz^*$的形式。  
对于最优化问题，需要对损失函数求导，但从严格的数学角度来看，这个函数是不可导的。证明如下：
$zz^*=x^2+y^2$
$\frac {\partial u}{\partial x}=2x$
$\frac {\partial v}{\partial x}=0$  
显然不满足柯西黎曼方程，因此不可导。  
那如何对这种函数求导呢？  

形式导数  
假设$f(z)$解析，则$f(z)$可以展开为$z$的泰勒级数的形式，在这个展开式中没有$z^*$的身影，说明f(z)和$z^*$没有任何关系。换句话说，一个解析的复变函数只跟$z$有关，和$z^*$无关。

实际上，$f(z)$解析可以等价为$\frac{\partial f}{\partial z^*}=0$。  

那么，不解析的函数就同时依赖于$z$和$z^*$。可以轻松推出一个事实：实函数f(z)都是不解析的，因为它必须同时依赖于z和$z^*$，否则它的虚部无法被消掉。因此$f(z)=zz^*$作为一个实函数，也印证了上面用柯西-黎曼方程推导出不解析的结果。  
所以，一个不解析的复变函数由于同时跟$z, z^*$以及$x, y$有关，可以写成： 
$$f(z)=f(z, z^*),\hspace{1cm}f(z)=f(x, y)$$
这两种形式。根据全微分公式：
$$df=\frac{\partial f}{\partial x}dx+\frac{\partial f}{\partial y}dy$$  
因此：  
$$df=\frac{\partial f}{\partial x}\frac{dz+dz^*}{2}+\frac{\partial f}{\partial y}\frac{dz-dz^*}{2i}$$
$$=\frac{1}{2}(\frac{\partial f}{\partial x}-i\frac{\partial f}{\partial y})dz+\frac{1}{2}(\frac{\partial f}{\partial x}+i\frac{\partial f}{\partial y})dz^*$$  
而根据全微分公式又同样可得：
$$df=\frac{\partial f}{\partial z}dz+\frac{\partial f}{\partial z^*}dz^*$$  
因此：  
$$\frac{\partial f}{\partial z}=\frac{1}{2}(\frac{\partial f}{\partial x}-i\frac{\partial f}{\partial y})$$
$$\frac{\partial f}{\partial z^*}=\frac{1}{2}(\frac{\partial f}{\partial x}+i\frac{\partial f}{\partial y})$$ 
同样的方式又易得：  
$$\frac{\partial f}{\partial x}=\frac{\partial f}{\partial z}+\frac{\partial f}{\partial z^*}$$  
$$\frac{\partial f(z_0)}{\partial y}=i(\frac{\partial f(z_0)}{\partial z}-\frac{\partial f(z_0)}{\partial z^*})$$  
根据上面的公式，得到推论：  
$$\frac{\partial z}{\partial z}=1$$
$$\frac{\partial z^*}{\partial z^*}=1$$
$$\frac{\partial z}{\partial z^*}=0$$
$$\frac{\partial z^*}{\partial z}=0$$  
$$\frac{\partial (zz^*)}{\partial z}=z^*$$  
$$\frac{\partial (zz^*)}{\partial z^*}=z$$
   
# 向量和矩阵的求导

当一个函数有很多变量，需要对多变量求导时，为了简化运算，把变量组成向量或者矩阵，作为一个实体来看待，这就是对向量和矩阵的求导。  
可能存在的求导有标量，向量，矩阵分别对各自求导，根据排列组合一共有9种情况，比如“标量对标量的求导，向量对标量的求导”等等。要想详细了解可参考
[https://en.wikipedia.org/wiki/Matrix_calculus](https://en.wikipedia.org/wiki/Matrix_calculus)

这里我们只看最常用的标量对矢量的求导。  
假设f(x)是一个标量，$\bold x$是一个矢量，$\bold x$可表示为
$$\begin{bmatrix} {x_1}  
\\ \cr {x_2} \\ \cr \vdots \\ \cr {x_N} \end{bmatrix}$$  

则:
$$\frac{\partial f(x)}{\partial \bold x}=\begin{bmatrix} \frac{f(x)}{x_1}  
\\ \cr \frac{f(x)}{x_2} \\ \cr \vdots \\ \cr \frac{f(x)}{x_N} \end{bmatrix}$$
为什么是这样呢？答案是全微分公式：
$$df=\frac{f(x)}{x_1}d{x_1}+\frac{f(x)}{x_2}d{x_2}+\cdots+\frac{f(x)}{x_N}d{x_N}$$
写成向量的乘法就是$$df=(\begin{bmatrix} \frac{f(x)}{x_1}  
\\ \cr \frac{f(x)}{x_2} \\ \cr \vdots \\ \cr \frac{f(x)}{x_N} \end{bmatrix})^Td\bold x$$

根据这个定义，易得  
$$\frac{\partial \bold x^T \bold b}{\partial \bold x}=\bold b$$  
$$\frac{\partial \bold b^T \bold x}{\partial \bold x}=\bold b$$  
  

复数向量和矩阵求导

标量和向量都可以认为是一种简化的矩阵，所以一个函数对标量，向量和矩阵的求导都可以统一写为复数对矩阵求导的形式。
假设函数F的参数是一个Q行，N列的复数矩阵，则可以认为F是Q*N个复数参数的函数，而每一个复数又包含x，y或者$z$，$z^*$两个变量，因此根据全微分公式：
$$df=\sum_{k=0}^{Q-1}\sum_{l=0}^{N-1}\frac{\partial f}{\partial x_{k,l}}dx_{k,l}+\sum_{k=0}^{Q-1}\sum_{l=0}^{N-1}\frac{\partial f}{\partial y_{k,l}}dy_{k,l}$$
$$=\sum_{k=0}^{Q-1}\sum_{l=0}^{N-1}\frac{\partial f}{\partial z_{k,l}}dz_{k,l}+\sum_{k=0}^{Q-1}\sum_{l=0}^{N-1}\frac{\partial f}{\partial z^*_{k,l}}dz^*_{k,l}$$

所以，复数导数F可以看成是矩阵$Z$和矩阵$Z^*$的函数，即$F(\bold Z,\bold Z^*)$。

我们回忆一下微分的基本原理，对一个函数$f(x)$微分：
$f(x+dx)-f(x)=FirstOrder(dx)+HighOrder(dx)$
FirstOrder指的是一阶的dx，HighOrder指的是高阶的dx，微分的计算通常是扔掉高阶的dx，保留一阶的dx，即：
$df=FirstOrder(dx)$

对$F(\bold Z,\bold Z^*)$求导是一样的道理：
$F(Z+dZ_0, Z^*+dZ^*_0)-F(Z,Z^*)$
$=FirstOrder(dZ_0,dZ^*_0)+HighOrder(dZ_0,dZ^*_0)$
$dF(Z,Z^*)=FirstOrder(dZ_0,dZ^*_0)$
 
由此推导出一些结论：  
$d(\bold A \bold Z \bold B)=\bold A(d\bold Z)\bold B$  
$d(a\bold Z)=ad\bold Z$  
$d{\bold Z_0 \bold Z_1}=(d\bold Z_0)\bold Z_1+\bold Z_0d\bold Z_1$  
$d\bold Z^{-1}=-\bold Z^{-1}(d\bold Z)\bold Z^{-1}$  
$d\bold Z^*=(d\bold Z)^*$  
$d\bold Z^H=(d\bold Z)^H$

还有对信号处理非常重要的一些结论，均是标量函数对复向量的求导，为了看起来比较清楚，就不写成矩阵的形式了。

$dF(\bold a^T \bold z)=\bold a d\bold z$
$dF(\bold z^T \bold a)=\bold a d\bold z$
注意$\bold a^T \bold z = \bold z^T \bold a$
$dF(\bold a^T \bold z^*)=\bold a d\bold z^*$
$dF(\bold z^H \bold a)=\bold a d\bold z^*$
注意$\bold a^T \bold z^* = \bold z^H \bold a$

$dF(\bold z^T \bold A \bold z)=(\bold A + \bold A^T)\bold z d\bold z$
$dF(\bold z^H \bold A \bold z)=\bold A^T\bold z^*d\bold z +\bold A\bold zd\bold z^*$
$dF(\bold z^H \bold A \bold z^*)=(\bold A + \bold A^T)\bold z^* d\bold z^*$


# 应用  
  

  
1. 维纳滤波
维纳滤波以 $MSE=E(|e(k)^2|)$ 为损失函数。
$e(k)=d(k)-\bold w^H\bold x$  
$|e(k)|^2=(d(k)-\bold w^H\bold x)^H(d(k)-\bold w^H\bold x)$  
$=(d^H(k)-\bold x^H\bold w)(d(k)-\bold w^H\bold x)$  
$=|d(k)|^2-d^H(k)\bold w^H \bold x -d(k)\bold x^H\bold w+\bold x^H\bold w\bold w^H\bold x$  
因为$\bold x^H\bold w$和$\bold w^H\bold x$都是标量，所以：
$=|d(k)|^2-d^H(k)\bold w^H \bold x -d(k)\bold x^H\bold w+\bold w^H\bold x\bold x^H\bold w$
根据公式
$\frac{\partial {|e(k)|^2}}{\partial w^*}=-d^H\bold x+\bold x\bold x^H\bold w$
加上期望符号E
$\frac{\partial {E(|e(k)|^2)}}{\partial w^*}=-E(d^H\bold x)+E(\bold x\bold x^H)\bold w$ 
而$E[xx^H]=R_{xx}$  
设$-E(d^H\bold x)=P$，  
则$E(|e(k)|^2)$最小时，$\frac{\partial {E(|e(k)|^2)}}{\partial w^*}=0$,  
可得
$-\bold P+\bold R \bold w=0$
$\bold w=\bold R^{-1} \bold P$  
  
3. LMS  
MSE这种损失函数实际上是无法求得的，因为它要求对信号进行无限次测量。为了能获得维纳解，人们设计了一些方式来进行迭代求解，也就是在维纳的解空间内进行搜索，逐渐逼近维纳解。比如最陡梯度下降法。
意思就是：
$\bold w(k+1)=\bold w(k) -\mu \bold {\hat g(k)}$  
$\hat g(k)$就是第k次迭代的梯度。   
我们利用维纳对$|e(k)|^2$求导的结果，可得梯度为$-d^H\bold x+\bold x\bold x^H\bold w$  
利用最近一次的$\bold x(k) \bold x^H(k)$替换掉$E[xx^H]$，注意，$\bold x$也是向量。
可得
$\bold w(k+1)=\bold w(k) -\mu (-d^H(k)\bold x(k)+\bold x(k)\bold x(k)^H\bold w(k))$  
$=\bold w(k)+\mu \bold x(k)(d^H(k)-\bold x(k)^H\bold w(k))$  
注意 $e(k)=d(k)-\bold w(k)^H\bold x(k)$，两边取共轭转置，可得$e(k)^H=d^H(k)-\bold x^H(k)\bold w(k)$  
代入上式，可得$\bold w(k+1)=\bold w(k) -\mu \bold x(k){e(k)^*}$，  
注意$e(k)$是个标量，共轭转置等于共轭。
  
4. APA  
APA是LMS的一种变形。  
首先定义  
$\bold e_{ap}(k)=\bold d_{ap}(k)-\bold X^T_{ap}\bold w^*(k)$
迭代用的是滤波器系数的共轭，这就意味着我们需要对滤波器系数的共轭求导。其实这也是一个trick，因为对一个复数的共轭求导会得到关于这个复数的方程。
注意，这些全是向量和矩阵，没有标量。  
APA依然是一个带约束的最优化问题，  
约束条件是后验误差是0，即$\bold d_{ap}(k)-\bold X^T_{ap}(k)\bold w^*(k+1)=\bold 0$，$\bold w^*(k+1)$是更新后的滤波器系数。  
最优化目标是使得这个值$\frac{1}{2}||\bold w(k+1)-w(k)||^2$最小化，这被称为最小距离原理。
采用拉格朗日乘子法：  
$\frac{1}{2}(\bold w(k+1)-\bold w(k))^H(\bold w(k+1)-\bold w(k)) + \bold \lambda^T(\bold d_{ap}(k)-\bold X^T_{ap}(k)\bold w^*(k+1))$  
注意，$\bold \lambda$是一个实数的列向量，转置是为了相乘后得到一个标量。
上面的式子是一个标量，为了得到关于$\bold w(k)$的式子，对向量$\bold w^*(k+1)$求导，求导可得：
$\frac{1}{2}(\bold w(k+1)-\bold w(k))-(\bold \lambda^T\bold X^T_{ap}(k))^T$  
最优解是上式为0，则$\bold w(k+1)=\bold w(k)+2\bold X_{ap}(k)\bold \lambda$  （3.1）
对约束条件两边取共轭，可得  
$\bold d^*_{ap}(k)-\bold X^H_{ap}(k)\bold w(k+1)=0$  
把$\bold w(k+1)=\bold w(k)+2\bold X_{ap}(k)\bold \lambda$  代入上式，可得
$\bold d^*_{ap}(k)-\bold X^H_{ap}(k)\bold w(k)-2\bold X^H_{ap}(k)\bold X_{ap}(k)\bold \lambda=\bold 0$  
$\bold d^*_{ap}(k)-\bold X^H_{ap}(k)\bold w(k)=2\bold X^H_{ap}(k)\bold X_{ap}(k)\bold \lambda$ （3.2）
由于
$\bold e_{ap}(k)=\bold d_{ap}(k)-\bold X^T_{ap}\bold w^*(k)$
两边取共轭
$\bold e^*_{ap}(k)=\bold d^*_{ap}(k)-\bold X^H_{ap}\bold w(k)$
带入（3.2）
则$\bold e^*_{ap}(k)=2\bold X^H_{ap}(k)\bold X_{ap}(k)\bold \lambda$  
$\bold \lambda=\frac{1}{2}(\bold X^H_{ap}(k)\bold X_{ap}(k))^{-1}\bold e^*_{ap}(k)$  
带入(3.1)  
$\bold w(k+1)=\bold w(k)+\mu \bold X_{ap}(k)(\bold X^H_{ap}(k)\bold X_{ap}(k))^{-1}\bold e^*_{ap}(k)$  
  
5. LCMV  
线性约束最小方差的意思是：在满足约束条件的情况下，让输出信号的功率最小。这个约束条件就是某一方向的信号不衰减。
信号不衰减可以表示为
$\bold w^H\bold c=f$，推导如下：
整个推导都是在频域，输出是输入信号和滤波器的点乘，假设$\bold y =\bold w^*\cdot\bold x$是滤波器的输出，
则$\sum_{i=0}^Ny_i=\bold w^H\bold x$。  
$x_i(k)=x_0(t_0+i\frac{dcos\theta}{c})$  
当$\bold w^H\bold x=\bold {x_0}$  
${\bold x_0}=[x_0 x_0 \cdots x_0]^T$  
而$\bold x=x_0\cdot[1, e^{-jw\frac{dcons\theta}{c}}, e^{-j2w\frac{dcons\theta}{c}}, \cdots, e^{-j(N-1)w\frac{dcons\theta}{c}}]^T$  
这个可以当做约束条件。
从而又变成了带约束条件的最优化问题，可得式子为：
$E[\bold w^H\bold x\bold x^H\bold w]+\lambda(\bold w^H\bold c-f)$  
注意，$\bold c$就是steering vector，而$\lambda$是一个实数标量。
在约束情况下求最优化问题，还是用拉尔朗日乘子法。  
 $E[\bold w^H\bold x\bold x^H\bold w]+\lambda(\bold w^H\bold c-f)$
 上式对$\bold w^*$求导，可得
$\bold R_{xx}\bold w+\lambda \bold c$  
令上式为0，则$\bold w=-\lambda \bold R^{-1}\bold c$ （4.1）  
代入$\bold w^H \bold c=f$，因为是标量，两边取转置不变，这个式子可以写成$\bold c^H \bold w=f$，  代入 （4.1）
$-\lambda \bold c^H \bold R^{-1} \bold c=f$， 则
$\lambda=-(\bold c^H \bold R^{-1} \bold c)^{-1}f$  
最后代入式子 (4.1)  
$\bold w= \bold R^{-1}\bold c(\bold c^H \bold R^{-1} \bold c)^{-1}f$  
  
6. MVDR  
输入信号是  
$\bold x= \bold s +\bold i +\bold n$  
其中$\bold s$是纯净语音信号，$\bold i$是干扰信号，$\bold n$是噪音信号。  
目标是要求得一个滤波器系数$\bold w$，在约束条件$\bold w^H \bold a=1$下，使得SINR（信干燥比）最大。  
$SINR=E[\frac{|\bold w^H\bold s|^2}{|\bold w^H(\bold i + \bold n)|^2}]$  
E是求期望。  
我们希望分母最小，当然还是选择拉格朗日乘子法：  
$E[\bold w^H\bold R_{i+n}\bold w]+\lambda (\bold w^H \bold a -1)$，$\lambda$是一个实数标量。
对$\bold w^*$求导，则$\bold g_w=\bold R_{i+n}\bold w+\lambda \bold a$  
类似LCMV，代入$\bold a^H \bold w=1$  
$-\lambda \bold a^H{\bold R^{-1}_{i+n}}\bold a=1$  
$\bold w=\frac{\bold R^{-1}_{i+n}\bold a}{\bold a^H{\bold R^{-1}_{i+n}}\bold a}$
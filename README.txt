SGTF toolbox: MATLAB toolbox for trilateral filter on graph spectral domain
(c) Masaki Onuki, 2016

Author: Masaki Onuki (masaki.o@msp-lab.org)

These MATLAB codes are the examples of spectral graph trilateral filter (SGTF). When you use this toolbox, please cite the paper below:
M. Onuki, S. Ono, M. Yamagishi, and Y. Tanaka, ``Graph Signal Denoising via Trilateral Filter on Graph Spectral Domain,'' IEEE Transactions on Signal and Information Processing over Networks, vol. 2, no. 2, pp. 137-148, June 2016.
This paper includes theoretical and practical details of SGTF.

Instruction:
We prepared two demonstrations: SGTF_Demo1.m and SGTF_Demo2.m. These demos can run when you only set graphs that you want to use and sigma (noise variance). The differences between two demos are described as follows:

SGTF_ Demo1.m:
The SGTF without parameter optimization: The parameter rho in Eq. (29) was determined in advance.
			
SGTF_Demo2.m:
The SGTF with parameter optimization: The parameter rho is optimized by minimizing Eq. (36) in this demo.
		      
When you just want to see the results immediately, please run SGTF_ Demo1.m. In contrast, when you want to verify the parameter optimization, please run SGTF_ Demo2.m. 

Update history:
	May. 31, 2016: v0.1 - (original release)
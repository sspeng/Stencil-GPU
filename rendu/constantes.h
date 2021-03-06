
#ifndef CONSTANTE_H__
#define CONSTANTE_H__

#define XDIM      8192
#define YDIM      4096
#define BORDER    1
#define PADDING   ( 64/sizeof(float) - 2*BORDER )
#define LINESIZE  ( XDIM + PADDING + 2*BORDER )
#define OFFSET    (LINESIZE + 16)
#define TOTALSIZE ( LINESIZE*( YDIM + 2*BORDER ) )

#define YDIM_GPU ydim_gpu
#define YDIM_CPU (YDIM-YDIM_GPU)

#define SIZE_GPU ((2*BORDER + YDIM_GPU) * LINESIZE)

struct double_matrice {
  float* in;
  float* out;
  unsigned int ydim_cpu;
};


#define NB_ITER 500

#endif

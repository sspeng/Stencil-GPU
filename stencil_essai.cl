__kernel void
stencil(__global float *B,
        __global float *A,
        unsigned int line_size)
{

    __local float tile[18][18];

    const unsigned int x = get_global_id(0);
    const unsigned int y = get_global_id(1);

    const unsigned int xloc = get_local_id(0);
    const unsigned int yloc = get_local_id(1);

    //x = get_group_id * 16 + xloc
    //y = get_group_id * 16 + yloc

    //on copie dans la tile les valeurs du milieu

    for(int i=0; i<4; i++)
    {
        tile[xloc+1][yloc*4+i+1] = A[(y*4+k)*line_size + x];
    }

    //reste à copier les bords.
    //on sépare les threads

    const int cbx = xloc;
    const int cby = (yloc & 1) ? -1 : 16;
    const int bx = (yloc & 2) ? cbx : cby;
    const int by = (yloc & 2) ? cby : cbx;

    /*  (xloc,yloc)->(cbx,cby),(bx,by)
    (0,0)->(0,16),(16,0)
    (0,1)->(0,-1),(-1,0)
    (0,2)->(0,16),(0,16)
    (0,3)->(0,-1),(0,-1)
    (0,4)->(0,16),(16,0)
    (0,5)->(0,-1),(-1,0)
    (0,6)->(0,16),(0,16)
    (0,7)->(0,-1),(0,-1)
    (0,8)->(0,16),(16,0)
    (0,9)->(0,-1),(-1,0)
    (0,10)->(0,16),(0,16)
    (0,11)->(0,-1),(0,-1)
    (0,12)->(0,16),(16,0)
    (0,13)->(0,-1),(-1,0)
    (0,14)->(0,16),(0,16)
    (0,15)->(0,-1),(0,-1)
    (1,0)->(1,16),(16,1)
    (1,1)->(1,-1),(-1,1)
    (1,2)->(1,16),(1,16)
    (1,3)->(1,-1),(1,-1)
    (1,4)->(1,16),(16,1)
    (1,5)->(1,-1),(-1,1)
    (1,6)->(1,16),(1,16)
    (1,7)->(1,-1),(1,-1)
    (1,8)->(1,16),(16,1)
    (1,9)->(1,-1),(-1,1)
    (1,10)->(1,16),(1,16)
    (1,11)->(1,-1),(1,-1)
    (1,12)->(1,16),(16,1)
    (1,13)->(1,-1),(-1,1)
    (1,14)->(1,16),(1,16)
    (1,15)->(1,-1),(1,-1)
    (2,0)->(2,16),(16,2)
    (2,1)->(2,-1),(-1,2)
    (2,2)->(2,16),(2,16)
    (2,3)->(2,-1),(2,-1)
    (2,4)->(2,16),(16,2)
    (2,5)->(2,-1),(-1,2)
    (2,6)->(2,16),(2,16)
    (2,7)->(2,-1),(2,-1)
    (2,8)->(2,16),(16,2)
    (2,9)->(2,-1),(-1,2)
    (2,10)->(2,16),(2,16)
    (2,11)->(2,-1),(2,-1)
    (2,12)->(2,16),(16,2)
    (2,13)->(2,-1),(-1,2)
    (2,14)->(2,16),(2,16)
    (2,15)->(2,-1),(2,-1)
    (3,0)->(3,16),(16,3)
    (3,1)->(3,-1),(-1,3)
    (3,2)->(3,16),(3,16)
    (3,3)->(3,-1),(3,-1)
    (3,4)->(3,16),(16,3)
    (3,5)->(3,-1),(-1,3)
    (3,6)->(3,16),(3,16)
    (3,7)->(3,-1),(3,-1)
    (3,8)->(3,16),(16,3)
    (3,9)->(3,-1),(-1,3)
    (3,10)->(3,16),(3,16)
    (3,11)->(3,-1),(3,-1)
    (3,12)->(3,16),(16,3)
    (3,13)->(3,-1),(-1,3)
    (3,14)->(3,16),(3,16)
    (3,15)->(3,-1),(3,-1)
    (4,0)->(4,16),(16,4)
    (4,1)->(4,-1),(-1,4)
    (4,2)->(4,16),(4,16)
    (4,3)->(4,-1),(4,-1)
    (4,4)->(4,16),(16,4)
    (4,5)->(4,-1),(-1,4)
    (4,6)->(4,16),(4,16)
    (4,7)->(4,-1),(4,-1)
    (4,8)->(4,16),(16,4)
    (4,9)->(4,-1),(-1,4)
    (4,10)->(4,16),(4,16)
    (4,11)->(4,-1),(4,-1)
    (4,12)->(4,16),(16,4)
    (4,13)->(4,-1),(-1,4)
    (4,14)->(4,16),(4,16)
    (4,15)->(4,-1),(4,-1)
    (5,0)->(5,16),(16,5)
    (5,1)->(5,-1),(-1,5)
    (5,2)->(5,16),(5,16)
    (5,3)->(5,-1),(5,-1)
    (5,4)->(5,16),(16,5)
    (5,5)->(5,-1),(-1,5)
    (5,6)->(5,16),(5,16)
    (5,7)->(5,-1),(5,-1)
    (5,8)->(5,16),(16,5)
    (5,9)->(5,-1),(-1,5)
    (5,10)->(5,16),(5,16)
    (5,11)->(5,-1),(5,-1)
    (5,12)->(5,16),(16,5)
    (5,13)->(5,-1),(-1,5)
    (5,14)->(5,16),(5,16)
    (5,15)->(5,-1),(5,-1)
    (6,0)->(6,16),(16,6)
    (6,1)->(6,-1),(-1,6)
    (6,2)->(6,16),(6,16)
    (6,3)->(6,-1),(6,-1)
    (6,4)->(6,16),(16,6)
    (6,5)->(6,-1),(-1,6)
    (6,6)->(6,16),(6,16)
    (6,7)->(6,-1),(6,-1)
    (6,8)->(6,16),(16,6)
    (6,9)->(6,-1),(-1,6)
    (6,10)->(6,16),(6,16)
    (6,11)->(6,-1),(6,-1)
    (6,12)->(6,16),(16,6)
    (6,13)->(6,-1),(-1,6)
    (6,14)->(6,16),(6,16)
    (6,15)->(6,-1),(6,-1)
    (7,0)->(7,16),(16,7)
    (7,1)->(7,-1),(-1,7)
    (7,2)->(7,16),(7,16)
    (7,3)->(7,-1),(7,-1)
    (7,4)->(7,16),(16,7)
    (7,5)->(7,-1),(-1,7)
    (7,6)->(7,16),(7,16)
    (7,7)->(7,-1),(7,-1)
    (7,8)->(7,16),(16,7)
    (7,9)->(7,-1),(-1,7)
    (7,10)->(7,16),(7,16)
    (7,11)->(7,-1),(7,-1)
    (7,12)->(7,16),(16,7)
    (7,13)->(7,-1),(-1,7)
    (7,14)->(7,16),(7,16)
    (7,15)->(7,-1),(7,-1)
    (8,0)->(8,16),(16,8)
    (8,1)->(8,-1),(-1,8)
    (8,2)->(8,16),(8,16)
    (8,3)->(8,-1),(8,-1)
    (8,4)->(8,16),(16,8)
    (8,5)->(8,-1),(-1,8)
    (8,6)->(8,16),(8,16)
    (8,7)->(8,-1),(8,-1)
    (8,8)->(8,16),(16,8)
    (8,9)->(8,-1),(-1,8)
    (8,10)->(8,16),(8,16)
    (8,11)->(8,-1),(8,-1)
    (8,12)->(8,16),(16,8)
    (8,13)->(8,-1),(-1,8)
    (8,14)->(8,16),(8,16)
    (8,15)->(8,-1),(8,-1)
    (9,0)->(9,16),(16,9)
    (9,1)->(9,-1),(-1,9)
    (9,2)->(9,16),(9,16)
    (9,3)->(9,-1),(9,-1)
    (9,4)->(9,16),(16,9)
    (9,5)->(9,-1),(-1,9)
    (9,6)->(9,16),(9,16)
    (9,7)->(9,-1),(9,-1)
    (9,8)->(9,16),(16,9)
    (9,9)->(9,-1),(-1,9)
    (9,10)->(9,16),(9,16)
    (9,11)->(9,-1),(9,-1)
    (9,12)->(9,16),(16,9)
    (9,13)->(9,-1),(-1,9)
    (9,14)->(9,16),(9,16)
    (9,15)->(9,-1),(9,-1)
    (10,0)->(10,16),(16,10)
    (10,1)->(10,-1),(-1,10)
    (10,2)->(10,16),(10,16)
    (10,3)->(10,-1),(10,-1)
    (10,4)->(10,16),(16,10)
    (10,5)->(10,-1),(-1,10)
    (10,6)->(10,16),(10,16)
    (10,7)->(10,-1),(10,-1)
    (10,8)->(10,16),(16,10)
    (10,9)->(10,-1),(-1,10)
    (10,10)->(10,16),(10,16)
    (10,11)->(10,-1),(10,-1)
    (10,12)->(10,16),(16,10)
    (10,13)->(10,-1),(-1,10)
    (10,14)->(10,16),(10,16)
    (10,15)->(10,-1),(10,-1)
    (11,0)->(11,16),(16,11)
    (11,1)->(11,-1),(-1,11)
    (11,2)->(11,16),(11,16)
    (11,3)->(11,-1),(11,-1)
    (11,4)->(11,16),(16,11)
    (11,5)->(11,-1),(-1,11)
    (11,6)->(11,16),(11,16)
    (11,7)->(11,-1),(11,-1)
    (11,8)->(11,16),(16,11)
    (11,9)->(11,-1),(-1,11)
    (11,10)->(11,16),(11,16)
    (11,11)->(11,-1),(11,-1)
    (11,12)->(11,16),(16,11)
    (11,13)->(11,-1),(-1,11)
    (11,14)->(11,16),(11,16)
    (11,15)->(11,-1),(11,-1)
    (12,0)->(12,16),(16,12)
    (12,1)->(12,-1),(-1,12)
    (12,2)->(12,16),(12,16)
    (12,3)->(12,-1),(12,-1)
    (12,4)->(12,16),(16,12)
    (12,5)->(12,-1),(-1,12)
    (12,6)->(12,16),(12,16)
    (12,7)->(12,-1),(12,-1)
    (12,8)->(12,16),(16,12)
    (12,9)->(12,-1),(-1,12)
    (12,10)->(12,16),(12,16)
    (12,11)->(12,-1),(12,-1)
    (12,12)->(12,16),(16,12)
    (12,13)->(12,-1),(-1,12)
    (12,14)->(12,16),(12,16)
    (12,15)->(12,-1),(12,-1)
    (13,0)->(13,16),(16,13)
    (13,1)->(13,-1),(-1,13)
    (13,2)->(13,16),(13,16)
    (13,3)->(13,-1),(13,-1)
    (13,4)->(13,16),(16,13)
    (13,5)->(13,-1),(-1,13)
    (13,6)->(13,16),(13,16)
    (13,7)->(13,-1),(13,-1)
    (13,8)->(13,16),(16,13)
    (13,9)->(13,-1),(-1,13)
    (13,10)->(13,16),(13,16)
    (13,11)->(13,-1),(13,-1)
    (13,12)->(13,16),(16,13)
    (13,13)->(13,-1),(-1,13)
    (13,14)->(13,16),(13,16)
    (13,15)->(13,-1),(13,-1)
    (14,0)->(14,16),(16,14)
    (14,1)->(14,-1),(-1,14)
    (14,2)->(14,16),(14,16)
    (14,3)->(14,-1),(14,-1)
    (14,4)->(14,16),(16,14)
    (14,5)->(14,-1),(-1,14)
    (14,6)->(14,16),(14,16)
    (14,7)->(14,-1),(14,-1)
    (14,8)->(14,16),(16,14)
    (14,9)->(14,-1),(-1,14)
    (14,10)->(14,16),(14,16)
    (14,11)->(14,-1),(14,-1)
    (14,12)->(14,16),(16,14)
    (14,13)->(14,-1),(-1,14)
    (14,14)->(14,16),(14,16)
    (14,15)->(14,-1),(14,-1)
    (15,0)->(15,16),(16,15)
    (15,1)->(15,-1),(-1,15)
    (15,2)->(15,16),(15,16)
    (15,3)->(15,-1),(15,-1)
    (15,4)->(15,16),(16,15)
    (15,5)->(15,-1),(-1,15)
    (15,6)->(15,16),(15,16)
    (15,7)->(15,-1),(15,-1)
    (15,8)->(15,16),(16,15)
    (15,9)->(15,-1),(-1,15)
    (15,10)->(15,16),(15,16)
    (15,11)->(15,-1),(15,-1)
    (15,12)->(15,16),(16,15)
    (15,13)->(15,-1),(-1,15)
    (15,14)->(15,16),(15,16)
    (15,15)->(15,-1),(15,-1)
    */
 //on copie les bords...

    tile[cbx][cby+1] = A[((y-yloc+cby)*4)*line_size + x];
    tile[bx+1][by+1] = A[];



}

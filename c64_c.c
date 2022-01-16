/* Sierpinski challenge */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <conio.h>
#include <tgi.h>
#include <cc65.h>

#define MAXPOINTS 10000

void main(void) {
    static const unsigned char palette[2] = {TGI_COLOR_WHITE, TGI_COLOR_BLACK}; 
    unsigned char err;
    unsigned short x = 160;
    unsigned short y = 0;
    unsigned short count;
    clock_t t;
    unsigned long sec;

    /* Get clock */
    t = clock();

    _randomize();

    /* Install the graphics driver */
    tgi_install(tgi_static_stddrv);

    err = tgi_geterror();
    if (err != TGI_ERR_OK)
    {
        cprintf("Error #%d initializing graphics.\r\n%s\r\n",
                err, tgi_geterrormsg(err));
        if (doesclrscrafterexit())
        {
            cgetc();
        }
    };

    /* Initialize graphics */
    tgi_init();
    tgi_clear();
    tgi_setpalette(palette); 
    tgi_setcolor(TGI_COLOR_WHITE);
    
    /* Plot 3000 points */

    for (count=0; count<MAXPOINTS; count++) {
        switch(rand() % 3) {
            case 0:
                x = (x+160)>>1;
                y = y>>1;
                tgi_setpixel(x,y);
                break;
            case 1:
                x = x>>1;
                y = (y+199)>>1;
                tgi_setpixel(x,y);
                break;                
            case 2:
                x = (x+319)>>1;
                y = (y+199)>>1;
                tgi_setpixel(x,y);
                break;                
            default:
                break;                
        }
    }

    /* Shut down gfx mode and return to textmode */
    tgi_done();
    tgi_uninstall ();

    /* Use PETSCII font */
    cbm_k_bsout(CH_FONT_UPPER);

    /* Get clock */
    t = clock() - t;
    
    /* Stats */
    sec = t / CLOCKS_PER_SEC;
    
    printf("elapsed time = %lu sec\n\n", sec);
    printf("number of plotted points = %u\n", count);
    
}


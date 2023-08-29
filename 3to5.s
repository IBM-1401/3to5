               job  Convert three-character address to five digits
               ctl  6611
     from      equ  205
     start     lca  @999@,from         First address to convert
     outer     mcw  from,to
               b    c3to5              Convert it
               mcw  to,215
               mcw  from,to
               b    c3to5s             Convert it
               mcw  to,225
               mcw  from,to
               b    c3to5f             Convert it
               mcw  to,235
               mcw  from,to
               b    c3to5x             Convert it
               mcw  to,245
               w
               ma   a1k,from           Bump it by 1k
               c    from,@999@         Q. Wrapped around
               bu   outer              No
     done      h    done
     a1k       dsa  1000
               ltorg*
     *
     * Fast routine to convert the three-character address at
     * ,,to,, to a five-digit address, in place.
     *
     c3to5     sbr  exit&3
               s    to-3               Clear thousands digits
               mz   to,to-4            Low zone to accumulate
     loop1     bwz  loop1x,to-4,2      Q. low zone remaining
               a    @?4@,to-3          Yes, add 4k per low zone
               b    loop1
     loop1x    mz   to-2,to-4          High zone to accumulate
     loop2     bwz  loop2x,to-4,2      Q. high zone remaining
               a    @?1@,to-3          Yes, add 1k per high zone
               b    loop2
     loop2x    za   to&1               Clear zones
     exit      b    0-0
     to        dcw  #5
               dc   #1
               ltorg*
     *
     * Smallest routine to convert the three-character address at
     * ,,to,, to a five-digit address, in place.
     *
     c3to5s    sbr  exits&3
               mcw  k00,to-3           Zero high digits, leave no zone
     loop1s    za   to&1,test&1        Copy digits only
               c    to,test            Q. Address all digits
     exits     be   0-0                Yes, zones all gone
               ma   am1000,to          MA -1000 from address
               a    k1,to-3            Bump thousands
               b    loop1s
     test      dcw  #3
               dc   #1
     k00       dcw  00
     am1000    dsa  16000-1000         -1000
     k1        dcw  1
     *
     * Faster routine to covert the three-character address at
     * ,,to,, to a five-digit address, in place.
     *
     c3to5f    sbr  exitf&3
               mcw  k00,to-3
               bwz  lowf,to-2,2
               bwz  high2,to-2,k
               bwz  high1,to-2,s
               a    *-6,to-3
     high2     a    *-6,to-3
     high1     a    *-6,to-3
     lowf      bwz  donef,to,2
               bwz  low2,to,k
               bwz  low1,to,s
               a    &4,to-3
     low2      a    &4,to-3
     low1      a    &4,to-3
     donef     za   to&1             Clear zones
     exitf     b    0-0
               ltorg*
     *
     * Fastest routine to covert the three-character address at ,,to,,
     * to a five-digit address, in place, but it uses all three index
     * registers.
     *
     c3to5x    sbr  exitx&3
               lca  @0020000400006@,99
               mz   to-2,*&3         Set index register for thousands
               mcw  thou,to-3
               mz   to,*&3           Index register for 4-thousands
               a    thou4,to-3
               za   to&1             Clear zones
     exitx     b    0-0
     thou      dcw  00
               dcw  01
               dcw  02
               dcw  03
     thou4     dcw  00
               dcw  04
               dcw  08
               dcw  12
               end  start

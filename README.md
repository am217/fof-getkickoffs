# fof-getkickoffs
Get kickoffs statistics for a Front Office Football Seven player from game-generated HTML log files, using R.

## Requirements
1. Front Office Football Seven
2. R
3. R's XML package (`install.packages("XML")`)

## Sample usage

    > getKickoffs("Harvey Soward", user="windowsusername", league="OSFL2007", year=2036:2038)
    List of 7
     $ count: int 346
     $ mean : num 66.8
     $ sd   : num 7.02
     $ ge60 : num [1:2] 278 0.803
     $ ge65 : num [1:2] 220 0.636
     $ le55 : num [1:2] 28 0.0809
     $ le50 : num [1:2] 7 0.0202

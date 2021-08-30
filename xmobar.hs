Config {

   -- appearance
     font =         "xft:JetBrains Mono:size=14:regular:antialias=true"
       , additionalFonts = [ "xft:Noto Color Emoji:pixelsize=10"
                           ]

   , bgColor =      "#191a22"
   , fgColor =      "#f5f5ff"
   , position = Static { xpos = 0 , ypos = 0, width = 1920, height = 32}
   , border =       BottomB
   , borderColor =  "#191a22"
   , iconRoot = "/home/naeem/.xmonad/xpm/"
   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "             %cpu%  %multicoretemp% | %memory% | %dynnetwork% }{ | %date% "
   --, template = " %cpu%  %multicoretemp% | %memory% | %dynnetwork% }{ | %date% "
   -- general behavior
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)
   , commands =

        -- Network monitor
        [ Run DynNetwork     [ "--template" , "<dev>: <rx> down  <tx> up"
                             , "--Low"      , "12345670"       -- units: B/s
                             , "--High"     , "50000000"       -- units: B/s
                             , "--low"      , "#93ff41"
                             , "--normal"   , "orange"
                             , "--high"     , "#cc0000"
                             , "-S"         , "true"
                             ] 10

        -- CPU usage
        , Run Cpu            [ "--template" , "CPU: <total>%"
                             , "--Low"      , "65"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#93ff41"
                             , "--normal"   , "orange"
                             , "--high"     , "#cc0000"
                             ] 10

        -- CPU temperature
        , Run MultiCoreTemp  [ "--template" , "<avg>°C"
                             , "--Low"      , "40"        -- units: °C
                             , "--High"     , "55"        -- units: °C
                             , "--low"      , "#93ff41"
                             , "--normal"   , "orange"
                             , "--high"     , "#cc0000"
                             ] 50

        -- RAM usage
        , Run Memory         [ "--template" , "MEM: <used> MB"
                             , "--Low"      , "5500"        -- units: MB
                             , "--High"     , "6875"        -- units: MB
                             , "--low"      , "#93ff41"
                             , "--normal"   , "orange"
                             , "--high"     , "#cc0000"
                             ] 10

        -- Clock
        , Run Date           "%a, %d/%m/%Y %T" "date" 10

        ]
   }

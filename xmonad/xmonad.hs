-- XMONAD CONFIG
-- This is my configuration file for the Xmonad window manager, a fast and very configurable tiling window manager for X11.

-----------------------------------------------------------------------------------------------
-- Haskell modules that are imported for functions in the config.

import XMonad
import Data.Monoid
import System.Exit
import Control.Monad
import Graphics.X11.ExtraTypes.XF86

import XMonad.Util.SpawnOnce
import XMonad.Util.Dmenu
import XMonad.Util.Run

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Layout.ShowWName
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

------------------------------------------------------------------------
--  Default terminal emulator, used in keyboard shortcuts and by some contrib modules.
myTerminal       = "alacritty"
-- myTerminal       = "tabbed -c st -w"

------------------------------------------------------------------------
-- Which mod key to use for keyboard shortcuts:
-- mod1Mask = Left Alt
-- mod3Mask = Right Alt
-- mod4Mask = Left Super

myModMask       = mod4Mask

------------------------------------------------------------------------
-- The names of workspaces/virtual desktops/virtual screens

myWorkspaces    = ["   1   ","   2   ","   3   ","   4   "] -- NOTE: Some of the spaces in this one are not real spaces, they are different unicode symbols. The code is "U+0020"

------------------------------------------------------------------------
-- Key bindings

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- Volume keys
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -2%")
    , ((controlMask, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +2%")
    , ((controlMask, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")

    -- Other media keys
    , ((0, xF86XK_Calculator), spawn "qalculate-gtk")
    , ((0, xF86XK_Explorer), spawn "pcmanfm")
    , ((0, xF86XK_HomePage), spawn "firefox")

    , ((shiftMask, xF86XK_Calculator), spawn "gnome-calculator")
    , ((shiftMask, xF86XK_Explorer), spawn "nautilus")
    , ((shiftMask, xF86XK_HomePage), spawn "chromium")

    , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause")
    , ((0, xF86XK_AudioNext), spawn $ "playerctl next")
    , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")

    -- Launch dmenu
    , ((modm, xK_d), spawn "~/.dmenurc")

    -- Edit configs
    , ((modm, xK_Escape), spawn "~/.scripts/dmconf.sh")

    -- Launch nwggrid (an app launcher)
    , ((modm, xK_space), spawn "nwggrid")

    -- Launch rofi
    , ((modm .|. mod1Mask, xK_space), spawn "rofi -show drun -modi window,drun -display-drun ' Run: '") -- use "-columns 4" with fullscreen rofi theme

    -- Open Firefox
    , ((modm, xK_b), spawn "firefox")

    -- Open Pcmanfm
    , ((modm, xK_f), spawn "pcmanfm")

    -- Open Htop
    , ((modm, xK_Delete), spawn "st -f 'JetBrains Mono-14' -e htop")

    -- Swap the focused window and the master window
    , ((modm, xK_Return), windows W.swapMaster)

    -- Lock the screen
    , ((modm .|. controlMask, xK_l), spawn "~/.scripts/lock.sh")

    -- Open neovide
    , ((modm, xK_v), spawn "neovide ~")

    -- Close the focused window
    , ((modm .|. shiftMask, xK_c), kill)

    -- Cycle through all of the available layouts
    , ((modm .|. shiftMask, xK_Tab), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm, xK_BackSpace), setLayout $ XMonad.layoutHook conf)

    -- Move focus to the next window
    , ((modm, xK_Tab), windows W.focusDown)
    , ((modm, xK_j), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm, xK_k), windows W.focusUp)

    -- Move a window down
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)

    -- Move a window up
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)

    -- Shrink the master area
    , ((modm, xK_h), sendMessage Shrink)

    -- Expand the master area
    , ((modm, xK_l), sendMessage Expand)

    -- Put focused window back into tiling
    , ((modm, xK_t), withFocused $ windows . W.sink)

    -- Increase the number of windows in the master area
    , ((modm, xK_comma ), sendMessage (IncMasterN 1))

    -- Decrease the number of windows in the master area
    , ((modm , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the panel/status bar(s)
    , ((modm .|. mod1Mask, xK_b), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q), spawn "nwgbar")
    , ((controlMask .|. mod1Mask, xK_Delete), spawn "nwgbar")

    -- Restart xmonad and load new configurations
    , ((modm ,xK_q), spawn "uxterm -e xmonad --recompile; xmonad --restart")
    ]
    ++

    -- Mod+(1-4), Switch to workspace (number)
    -- Mod+Shift+(1-4), Move window to workspace (number)

      [((m .|. modm, k), windows $ f i)
          | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_4]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
      ++

    -- Mod+Left/Right arrow, Move workspace to screen 1 or 2
    -- Mod+Shift+Left/Right arrow, Move window to screen 1 or 2
    
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_Left, xK_Right] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings

-- These are the names of each of the buttons:

--  Button1      Button2        Button3       Button4     Button5
--  Left click   Middle click   Right click   Scroll up   Scroll down

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Make the window float and move it
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- Raise the window to top
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- Make the window float and resize it
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))]

------------------------------------------------------------------------
-- Theme for showWName and tabbed layout
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font            = "xft:Noto Sans Display:bold:size=60"
    , swn_fade            = 1.0
    , swn_bgcolor         = "#151515"
    , swn_color           = "#ffffff"
    }

myTabTheme = def 
    { fontName            = "xft:Noto Sans Display:regular:size=10:antialias=true:hinting=true"
    , activeColor         = "#1b9aff"
    , inactiveColor       = "#25272f"
    , activeBorderColor   = "#1b9aff"
    , inactiveBorderColor = "#222a2f"
    , activeTextColor     = "#eeeeee"
    , inactiveTextColor   = "#dedede"
    }

------------------------------------------------------------------------
-- Layout hook

tabs     = renamed [Replace "tabs"]
           $ tabbed shrinkText myTabTheme

myLayout = avoidStruts (tiled ||| tabs ||| Mirror tiled ||| Full )
  where
     -- Default tiling layout splits the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Size of the master pane
     ratio   = 11/20

     -- Percent of screen to increment when resizing panes
     delta   = 1/40

------------------------------------------------------------------------
-- Window rules to make a window always float, always fullscreen, etc.

-- To find the window class name of a window, run this command:
-- $ xprop | grep "WM_CLASS"

myManageHook = composeAll
    [ className =? "Glimpse-0.2"      --> doFloat
    , className =? "Glimpse"          --> doFloat
    , className =? "zoom"             --> doFloat
    , className =? "Gnome-calculator" --> doFloat
    , className =? "Badlion Client"   --> doFloat
    , className =? "Qalculate-gtk"    --> doFloat
    , className =? "Sgtk-bar"         --> doFullFloat
    , className =? "Sgtk-grid"        --> doFullFloat
    , className =? "Nwggrid"          --> doFullFloat
    , className =? "Nwgbar"           --> doFullFloat
    , resource  =? "desktop_window"   --> doIgnore
    , resource  =? "kdesktop"         --> doIgnore ]

------------------------------------------------------------------------
-- Confusing things

myEventHook = ewmhDesktopsEventHook
myLogHook = ewmhDesktopsLogHook

------------------------------------------------------------------------
-- Misc commands to run when xmonad is started

myStartupHook = do
        spawnOnce "echo >>~/.xmonad/log && date >>~/.xmonad/log && ~/.xmonad/autostart.sh >>~/.xmonad/log 2>&1"

------------------------------------------------------------------------
-- The final part is what to do when xmonad starts up, which is:
--    * Start xmonad
--    * Load all settings from the config file
--    * Run all commands that were specified earlier in myStartupHook

-- These can also be modified here.

main = do
    xmonad $ docks defaults
    xmonad $ ewmh def { handleEventHook =
           handleEventHook def <+> fullscreenEventHook }

defaults = def {
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        clickJustFocuses   = False,
        borderWidth        = 1,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = "#23252d",
        focusedBorderColor = "#51afff",
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        --layoutHook         = showWName' myShowWNameTheme $ smartBorders $ myLayout,
        layoutHook         = smartBorders $ myLayout,
        --manageHook         = myManageHook,
        manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

--
-- Xmonad configuration file
--   overrides some defaults and adds a few more functionalities
import Data.Char

import XMonad hiding ( (|||) )
import XMonad.Core
 
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Man

import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPane
import XMonad.Layout.LimitWindows
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Reflect
  
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName -- java workaround http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-SetWMName.html
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ICCCMFocus -- java workaround http://www.eng.uwaterloo.ca/~aavogt/xmonad/docs/xmonad-contrib/XMonad-Hooks-ICCCMFocus.html
-- http://code.google.com/p/xmonad/issues/detail?id=177
import XMonad.Hooks.EwmhDesktops -- chrome/firefox F11 (enabled with handleEventHook = fullscreenEventHook)
  

  
  
import XMonad.Actions.RotSlaves
import XMonad.Actions.CopyWindow
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWindows
import XMonad.Actions.GroupNavigation
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.SpawnOn

import XMonad.Util.Scratchpad
import XMonad.Util.EZConfig
import XMonad.Util.Run
import Graphics.X11.Xlib
import qualified Data.Map as M
import System.IO

my_term = "gnome-terminal"
-- find out using xprop
my_term_class = "Gnome-terminal"
my_emacs ="emacsclient -c -n"
                
myMM=mod4Mask
                
main = do
   myStatusBarPipe <- spawnPipe myStatusBar
   conkyBar <- spawnPipe myConkyBar
   xmonad $ myUrgencyHook $ defaultConfig
      { terminal = my_term
      , normalBorderColor  = myInactiveBorderColor
      , focusedBorderColor = myActiveBorderColor
      , manageHook = scratchpadManageHookDefault <+> manageSpawn <+>  manageDocks <+> myManageHook <+>  manageHook defaultConfig
      , layoutHook = avoidStruts myLayoutHook
      , startupHook =   takeTopFocus >> setWMName "LG3D"  >> myStartupHook 
      , logHook = myDzenPP2 myStatusBarPipe  >> historyHook
      , modMask = myMM
      , keys = myKeys
      , workspaces = myWorkspaces
      , handleEventHook = fullscreenEventHook
      , borderWidth = myBorderWidth                          
     }   
 
-- Paths
myBitmapsPath = "/home/johannes/cbi/desktop-artwork/icons/"
 
-- Font
myFont="xft:DejaVu Sans Mono:size=9" -- dzen only uses the size. fontname seems to be ignored
 
-- Colors
myBgBgColor="black"
myFgColor="gray80"
myBgColor="gray20"
myHighlightedFgColor="white"
myHighlightedBgColor="gray40"
 
myActiveBorderColor = "white"
myInactiveBorderColor = "black"
myBorderWidth = 1
 
myCurrentWsFgColor = "white"
myCurrentWsBgColor = "gray40"
myVisibleWsFgColor = "gray80"
myVisibleWsBgColor = "gray20"
myHiddenWsWithCopyBg = "gray30"
myHiddenWsFgColor = "gray80"
myHiddenEmptyWsFgColor = "gray50"
myUrgentWsBgColor = "brown"
myTitleFgColor = "white"
 
myUrgencyHintFgColor = "white"
myUrgencyHintBgColor = "brown"
 
-- dzen general options
myDzenGenOpts = " -fg '" ++ myFgColor ++ "' -bg '" ++ myBgColor ++ "' -fn '" ++ myFont ++ "' -h '15'"
 
-- Status Bar
myStatusBarWidth = "900"
myStatusBar = "dzen2 -w " ++ myStatusBarWidth ++ " -ta l " ++ myDzenGenOpts
 
-- Conky Bar
myConkyBar = "conky -c ~/cbi/config/.conky_bar | dzen2 -e 'button1=exec:dmenu_session' -x " ++ myStatusBarWidth ++ " -w $(($(xrandr -q | sed -n -re 's/.*current ([0-9]+) x.*/\\1/p') - " ++ myStatusBarWidth ++ " )) -ta r" ++ myDzenGenOpts

-- Layouts
fc (x,l) (xs,ls) = ( kb:xs, l ||| ls)
                       where ([kb],_)=ff (x,l)
ff (x,l) = ( [ ((myMM.|.controlMask,x), sendMessage $ JumpToLayout $ description l ) ], l)
infixr 5 `fc`
-- define layout that can be jumped to using modm+ctrl
myLayouts =(xK_r, ResizableTall nmaster delta ratio [] )
           `fc`
           (xK_t, TwoPane delta ratio                  )
           -- `fc`
           -- (xK_f, Full                                 )
           `fc` ff
           (xK_g, Grid                                 )
  where
    nmaster = 1
    delta = 3/100
    ratio = 1/2
              
myLayoutHook = id
               $ smartBorders
               $ mkToggle1 MIRROR
               $ mkToggle1 REFLECTX
               $ mkToggle1 REFLECTY
               $ mkToggle1 FULL
               $ onWorkspace " 9 " Grid
               $ limitWindows 6
               $ snd myLayouts


-- this spawnOn looks at PIDs and if these change during run, it does not work
-- e.g. firefox, wenn alread running, emacsclient (at least on first startup)
myStartupHook = do 
  spawnOn " 1 " my_emacs
  spawnOn " 2 " "firefox"
  spawnOn " 3 " my_term
  spawnOn " 8 " "thunderbird"
  spawnOn " 9 " "gnome-terminal /home/data2/music"
  
-- Workspaces
myWorkspaces = map ( pad . show ) ( [1..9] ++ [0] ) 
   -- [
   --    wrapBitmap "sm4tik/arch_10x10.xbm",
   --    wrapBitmap "sm4tik/fox.xbm",
   --    wrapBitmap "sm4tik/dish.xbm",
   --    wrapBitmap "sm4tik/cat.xbm",
   --    wrapBitmap "sm4tik/empty.xbm",
   --    wrapBitmap "sm4tik/shroom.xbm",
   --    wrapBitmap "sm4tik/bug_02.xbm",
   --    wrapBitmap "sm4tik/eye_l.xbm",
   --    wrapBitmap "sm4tik/eye_r.xbm"
   -- ]
 
-- Urgency hint configuration
myUrgencyHook = withUrgencyHook dzenUrgencyHook
    {
      args = [
         "-x", "0", "-y", "576", "-h", "15", "-w", "1024",
         "-ta", "r",
         "-fg", "" ++ myUrgencyHintFgColor ++ "",
         "-bg", "" ++ myUrgencyHintBgColor ++ ""
         ]
    }

-- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#I_need_to_find_the_class_title_or_some_other_X_property_of_my_program
-- find out using xprop
myManageHook = composeAll $
   [ isFullscreen --> doFullFloat  ]
   ++
   composeAll [[ c =? t  --> doFloat | t <- ts ]
      | (c,ts) <- [
                  -- problem: xmonad hängt wenn Ediff floating
                   --(title    ,["Ediff"]        ),
                   --(resource ,["Ediff"]        ),
                   (className,["Gimp","Zenity","Xdialog"]  )  -- feh
                  ]]

-- Prompt config
myXPConfig = defaultXPConfig {
  position = Bottom,
  font = myFont,
  promptBorderWidth = 0,
  height = 15,
  bgColor = myBgColor,
  fgColor = myFgColor,
  fgHLight = myHighlightedFgColor,
  bgHLight = myHighlightedBgColor
  }
 
-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

-- defaults: http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html      
-- Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
  -- Use shellPrompt instead of default dmenu
  ((modm                 , xK_p    ), shellPrompt myXPConfig),
  -- Do not leave useless conky and dzen after restart
  ((modm, xK_q), spawn "killall conky dzen2; xmonad --recompile; xmonad --restart")
  , ((modm               , xK_c     ), kill1) -- @@ remove from current workspace or close if single
  , ((modm .|. shiftMask , xK_Tab   ), rotSlavesUp)
  , ((modm, xK_minus )   , decreaseLimit )
  , ((modm, xK_plus )    , increaseLimit )
  -- , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
  --, ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
  , ((modm                , xK_b    ), sendMessage ToggleStruts)
  , ((modm                , xK_s    ), cycleRecentWindows [xK_Super_L] xK_s xK_w)
  , ((modm                , xK_z    ), rotOpposite)
  , ((modm                , xK_i    ), rotUnfocusedUp)
  , ((modm                , xK_u    ), rotUnfocusedDown)
  , ((modm .|. shiftMask  , xK_i    ), rotFocusedUp)
  , ((modm .|. shiftMask  , xK_u    ), rotFocusedDown)
  , ((modm                , xK_Tab  ), nextMatch History (return True))
  , ((modm                , xK_r    ), nextMatchOrDo Forward  (className =? my_term_class) (spawnHere my_term))
  , ((modm .|. shiftMask  , xK_r    ), nextMatchOrDo Backward (className =? my_term_class) (spawnHere my_term))
  , ((modm,                 xK_d    ), viewEmptyWorkspace)
  , ((modm .|. shiftMask  , xK_d    ), tagToEmptyWorkspace)
  , ((modm                , xK_e    ), (spawnHere my_emacs))
  , ((modm .|. shiftMask  , xK_e    ), nextMatchOrDo Forward (className =? "Emacs") (spawnHere my_emacs))
  , ((modm .|. shiftMask  , xK_f    ), (spawnHere "firefox"))
  , ((modm                , xK_f    ), nextMatchOrDo Forward (className =? "Firefox") (spawnHere "firefox"))
  , ((modm                , xK_a    ), (spawnHere my_term))
  , ((modm .|. controlMask, xK_x    ), sendMessage $ Toggle REFLECTX)
  , ((modm .|. controlMask, xK_y    ), sendMessage $ Toggle REFLECTY)
  , ((modm .|. controlMask, xK_f    ), sendMessage $ Toggle FULL)
  , ((modm .|. controlMask, xK_m    ), sendMessage $ Toggle MIRROR)
  , ((modm .|. controlMask, xK_p    ), scratchpadSpawnActionCustom "gnome-terminal --disable-factory --name scratchpad" )
  ]
   ++
-- the following is s slightly modified version of: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CopyWindow.html
-- mod-control-[1..9] @@ Copy client to workspace N
  [((m .|. modm, k), windows $ f i)
     | (i, k) <- zip (workspaces conf) $ [xK_1..xK_9] ++ [xK_0]
     , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, controlMask)]]
   ++
-- get layout jumper bindings
  fst myLayouts
  
myDzenPP2 h = do
    copies <- wsContainingCopies
    let color ws | ws `elem` copies = wrapBg myHiddenWsWithCopyBg ws
                 | otherwise = ws
    (dynamicLogWithPP $ (myDzenPP h) {ppHidden = wrapFg myHiddenWsFgColor . color })

 
-- Dzen config
myDzenPP h = defaultPP {
  -- alternative sorts: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-WorkspaceCompare.html
  ppSort =   fmap (. scratchpadFilterOutWorkspace) $ ppSort defaultPP,
  ppOutput = hPutStrLn h,
  ppSep = "^bg(" ++ myBgBgColor ++ ")^r(1,15)^bg()",
  ppWsSep = "",
  ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor,
  ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor,
  ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor,
  ppUrgent = wrapBg myUrgentWsBgColor,
  ppTitle = (\x -> " " ++ wrapFg myTitleFgColor x),
  ppLayout  = dzenColor myFgColor"" .  pad . filter f . map m
  }
            where f x = isUpper x || x=='/'
                  m x | x==' ' = '/' | True = x
                -- (\x -> case x of
                --     "ResizableTall" -> wrapBitmap "rob/tall.xbm"
                --     "Mirror ResizableTall" -> wrapBitmap "rob/mtall.xbm"
                --     "Full" -> wrapBitmap "rob/full.xbm"
                --     otherwise -> x
                -- )

wrapFgBg fgColor bgColor content= wrap ("^fg(" ++ fgColor ++ ")^bg(" ++ bgColor ++ ")") "^fg()^bg()" content
wrapFg color = wrap ("^fg(" ++ color ++ ")") "^fg()"
wrapBg color = wrap ("^bg(" ++ color ++ ")") "^bg()"

wrapBitmap bitmap = "^p(5)^i(" ++ myBitmapsPath ++ bitmap ++ ")^p(5)"

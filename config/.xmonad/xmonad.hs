--
-- Xmonad configuration file
--   overrides some defaults and adds a few more functionalities
 
import XMonad
import XMonad.Core
 
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Man

import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
 
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
 
import XMonad.Actions.CopyWindow
import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Util.Run
import Graphics.X11.Xlib
import qualified Data.Map as M
import System.IO
 
main = do
   myStatusBarPipe <- spawnPipe myStatusBar
   conkyBar <- spawnPipe myConkyBar
   xmonad $ myUrgencyHook $ defaultConfig
      { terminal = "gnome-terminal"
      , normalBorderColor  = myInactiveBorderColor
      , focusedBorderColor = myActiveBorderColor
      , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
      , layoutHook = avoidStruts $ myLayoutHook
      , startupHook = setWMName "LG3D"
      , logHook = myDzenPP2 myStatusBarPipe
      , modMask = mod4Mask
      , keys = myKeys
      , workspaces = myWorkspaces
     }   
 
-- Paths
myBitmapsPath = "/home/johannes/cbi/desktop-artwork/icons/"
 
-- Font
myFont = "-*-*-*-*-*-*-12-*-*-*-*-*-iso8859-*"
 
-- Colors
myBgBgColor = "black"
myFgColor = "gray80"
myBgColor = "gray20"
myHighlightedFgColor = "white"
myHighlightedBgColor = "gray40"
 
myActiveBorderColor = "gray80"
myInactiveBorderColor = "gray20"
 
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
myDzenGenOpts = " -fg '" ++ myFgColor ++ "' -bg '" ++ myBgColor ++ "' -fn '" ++ myFont ++ "' -h '16'"
 
-- Status Bar
myStatusBar = "dzen2 -w 465 -ta l " ++ myDzenGenOpts
 
-- Conky Bar
myConkyBar = "conky -c ~/cbi/config/.conky_bar | dzen2 -x 460 -w $(($(xrandr -q | sed -n -re 's/.*current ([0-9]+) x.*/\\1/p') - 460 )) -ta r" ++ myDzenGenOpts
 
-- Layouts
myLayoutHook = smartBorders $ (tiled ||| Mirror tiled ||| Full)
  where
    tiled = ResizableTall nmaster delta ratio []
    nmaster = 1
    delta = 3/100
    ratio = 1/2
 
-- Workspaces
myWorkspaces = map ( pad . show ) [1..9]
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
 
myManageHook = composeAll $
   [ className =? "Gimp" --> doFloat
   , isFullscreen --> doFullFloat
   ]
   ++
   [ title =? c  --> doFloat | c <- myFloatsT ]
   where myFloatsT = ["Ediff"]
 
-- Prompt config
myXPConfig = defaultXPConfig {
  position = Bottom,
  promptBorderWidth = 0,
  height = 15,
  bgColor = myBgColor,
  fgColor = myFgColor,
  fgHLight = myHighlightedFgColor,
  bgHLight = myHighlightedBgColor
  }
 
-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)
 
-- Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
  -- Use shellPrompt instead of default dmenu
  ((modm, xK_p), shellPrompt myXPConfig),
  -- Do not leave useless conky and dzen after restart
  ((modm, xK_q), spawn "killall conky dzen2; xmonad --recompile; xmonad --restart")
  , ((modm, xK_c     ), kill1) -- @@ remove from current workspace or close if single
   ]
   ++
-- the following is s slightly modified version of: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CopyWindow.html
-- mod-control-[1..9] @@ Copy client to workspace N
  [((m .|. modm, k), windows $ f i)
     | (i, k) <- zip (workspaces conf) [xK_1 ..]
     , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, controlMask)]]

myDzenPP2 h = do
    copies <- wsContainingCopies
    let color ws | ws `elem` copies = wrapBg myHiddenWsWithCopyBg ws
                 | otherwise = ws
    dynamicLogWithPP $ (myDzenPP h) {ppHidden = wrapFg myHiddenWsFgColor . color }

 
-- Dzen config
myDzenPP h = defaultPP {
  ppOutput = hPutStrLn h,
  ppSep = "^bg(" ++ myBgBgColor ++ ")^r(1,15)^bg()",
  ppWsSep = "",
  ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor,
  ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor,
  ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor,
  ppUrgent = wrapBg myUrgentWsBgColor,
  ppTitle = (\x -> " " ++ wrapFg myTitleFgColor x),
  ppLayout  = dzenColor myFgColor"" .
                (\x -> case x of
                    "ResizableTall" -> wrapBitmap "rob/tall.xbm"
                    "Mirror ResizableTall" -> wrapBitmap "rob/mtall.xbm"
                    "Full" -> wrapBitmap "rob/full.xbm"
                )
  }

wrapFgBg fgColor bgColor content= wrap ("^fg(" ++ fgColor ++ ")^bg(" ++ bgColor ++ ")") "^fg()^bg()" content
wrapFg color = wrap ("^fg(" ++ color ++ ")") "^fg()"
wrapBg color = wrap ("^bg(" ++ color ++ ")") "^bg()"

wrapBitmap bitmap = "^p(5)^i(" ++ myBitmapsPath ++ bitmap ++ ")^p(5)"

-- other imports
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
 
main = xmonad defaultConfig {
    -- skipped
    layoutHook = smartBorders $ layoutHook defaultConfig
    , manageHook =  myManageHooks
    }
 
myManageHooks = composeAll
-- Allows focusing other monitors without killing the fullscreen
--  [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
 
-- Single monitor setups, or if the previous hook doesn't work
    [ isFullscreen --> doFullFloat
    -- skipped
    ]
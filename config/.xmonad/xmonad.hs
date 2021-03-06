
import           Control.Applicative
import           Control.Monad
import           Data.Char
import           Text.Read
import           Data.Function
import           Data.Maybe
import           Data.List
import qualified Data.Map as M
import           Graphics.X11.Xlib
import           Network.HostName
import           System.IO
import           Codec.Binary.UTF8.String
import           System.FilePath
import           System.Process
import           XMonad hiding ( (|||) )
import           XMonad.Actions.WindowBringer
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.CycleRecentWS
import           XMonad.Layout.IndependentScreens hiding (unmarshall, unmarshallS)
import           XMonad.Actions.CycleWindows
-- import           XMonad.Actions.FindEmptyWorkspace -- imcompatible with IndependentScreens
import           XMonad.Actions.GroupNavigation
import           XMonad.Actions.RotSlaves
import           XMonad.Actions.SpawnOn
import           XMonad.Core
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops -- chrome/firefox F11 (enabled with handleEventHook = fullscreenEventHook)
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers -- import XMonad.Hooks.ICCCMFocus -- java workaround http://www.eng.uwaterloo.ca/~aavogt/xmonad/docs/xmonad-contrib/XMonad-Hooks-ICCCMFocus.html (angeblich deprecated und nicht mehr benötigt:       , startupHook =  takeTopFocus >> ) -- http://code.google.com/p/xmonad/issues/detail?id=177
import           XMonad.Hooks.SetWMName -- java workaround http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-SetWMName.html
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout hiding ( (|||) )
import           XMonad.Layout.Gaps
import           XMonad.Layout.Grid
import           XMonad.Layout.LayoutCombinators
import           XMonad.Layout.LimitWindows
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Reflect
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.TwoPane
import           XMonad.Prompt
import           XMonad.Prompt.Man
import           XMonad.Prompt.Shell
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run

cbi = "/home/johannes/cbi/"

my_term_new = "terminator -x tmux -2"
my_term_without_tmux = "terminator"
my_term_attach = "terminator -x tmux-detached-or-new"
-- find out using xprop
my_term_class = "Terminator"
my_emacs ="emacsclient -c -n"
                
myMM=mod4Mask --Windows key

myNumberOfScreens = 4 -- only used to form twp groups of workspaces using XMonad.Layout.IndependentScreens

main = do
   myStatusBarPipe <- spawnPipe myStatusBar
   conkyBar <- spawnPipe myConkyBar
   host <- getHostName
   xmonad $ myEwmh $ myUrgencyHook $ defaultConfig
      { terminal = my_term_attach
      , normalBorderColor  = myInactiveBorderColor
      , logHook = myDynLog myStatusBarPipe  >> historyHook
      , focusedBorderColor = myActiveBorderColor
      , manageHook = namedScratchpadManageHook scratchpads <+> manageSpawn <+>  manageDocks <+> myManageHook <+>  manageHook defaultConfig
      , layoutHook = gaps (myGap host)  $ avoidStruts myLayoutHook
      , startupHook = myStartupHook -- checkKeymap myConfig myKeys (needs mkKeymap http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:mkKeymap
      , modMask = myMM
      , keys = myKeys
      , workspaces = withScreens myNumberOfScreens $ toName <$> fst myWorkspaces
      , handleEventHook = docksEventHook -- >> ewmhDesktopsEventHook -- führt dazu, dass xmonad beim start auf pidgin wechselt (wg. spawnOn " 0 " "pidgin", um wmctrl -l benutzen zu können,  benötigt man das aber eh nicht
      , borderWidth = myBorderWidth
     }   

myGap "scriabin" = [(L,154)]
myGap _          = []
 
-- Paths
myBitmapsPath = cbi ++ "desktop-artwork/icons/"
 
-- Font
myFont = "xft:DejaVu Sans Mono:size=8" -- dzen only uses the size. fontname seems to be ignored
 
-- Colors
myBgBgColor="black"
myFgColor="gray80"
myBgColor="gray20"
myHighlightedFgColor="white"
myHighlightedBgColor="gray40"
 
myActiveBorderColor = "red"
myInactiveBorderColor = "black"
myBorderWidth = 1
 
myCurrentWsFgColor = "red"
myCurrentWsBgColor = "white"
myVisibleWsFgColor = "gray80"
myVisibleWsBgColor = "gray20"
myHiddenWsWithCopyBg = "gray30"
myHiddenWsFgColor = "black"
myHiddenWsBgColor = "gray60"
myHiddenEmptyWsFgColor = "gray50"
myUrgentWsBgColor = "red"
myUrgentWsFgColor = "black"
myTitleFgColor = "white"
 
myUrgencyHintFgColor = "white"
myUrgencyHintBgColor = "brown"

dzenHeight = "13"
-- dzen general options
myDzenGenOpts = " -fg '" ++ myFgColor ++ "' -bg '" ++ myBgColor ++ "' -fn '" ++ myFont ++ "' -h '"++ dzenHeight ++"'"
 
-- Status Bar
myStatusBar = "dzen2 -ta l " ++ myDzenGenOpts
 
-- Conky Bar
-- with needs to start delayed, or otherwise will be behind the status bar.
myConkyBar = "sleep 1; conky -c " ++ cbi ++
             "config/.conky_bar | dzen2 -e 'button1=exec:dmenu_session' -ta l -expand l"
             ++ myDzenGenOpts

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
               $ gr 0 $ gr 1 $ gr 2 $ gr 3
               -- $ limitWindows 6
               $ snd myLayouts
  where gr i  = onWorkspace (marshall i $ toName '9') Grid

-- this spawnOn looks at PIDs and if these change during run, it does not work
-- e.g. firefox, wenn alread running, emacsclient (at least on first startup)
myStartupHook = do 
  -- spawnOn " 1 " my_emacs
  -- spawnOn " 2 " "firefox"
  -- spawnOn " 3 " my_term_attach
  spawnOn (marshall 0 $ toName '8') $ my_term_new ++ " new-session -s mutt \"sleep 10; mutt\""
  -- spawnOn " 9 " my_term_attach
  -- spawnOn " 0 " "pidgin -c /home/data/personal/misc/pidgin"
  
-- Workspaces
toName = pad . return
myWorkspaces = (['`'] ++ shift ['0'..'9'] ++ ['-','=']
                , [xK_quoteleft,xK_KP_Delete] : shift numkeys  ++
                  [[xK_minus,xK_KP_Subtract]
                  ,[xK_equal,xK_KP_Add]]
                )

shift (h:t) = t ++ [h]

numkeys = zipWith (\a b -> [a,b]) [xK_0..xK_9] numKP
  where numKP =[ xK_KP_Insert                            -- 0
               ,xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
               , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
               , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
               ]
  
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

niceRect x y = W.RationalRect x y (1-2*x) (1-2*y)

scratchpads = [

  -- run scratchpad in tmux in terminator
  NS "scratch" "terminator --title scratchpad -x tmux -2 new-session -As Scratchpad"
  (title =? "scratchpad")
  (customFloating $ niceRect (1/5) (1/4)) ,
  
  -- run htop in xterm, find it by title, use default floating window placement
  NS "htop" "xterm -e htop" (title =? "htop") defaultFloating ,
  
  -- run htop in xterm, find it by title, use default floating window placement
  NS "sympy" "terminator --title sympy -x tmux -2 new-session -As Sympy isympy-py3"
  (title =? "sympy")
  (customFloating $ niceRect (1/5) (1/4)) ,

  -- run stardict, find it by class name, place it in the floating window
  -- 1/6 of screen width from the left, 1/6 of screen height
  -- from the top, 2/3 of screen width by 2/3 of screen height
  NS "stardict" "stardict" (className =? "Stardict")
  (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ,

  -- run gvim, find by role, don't float
  NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
  ] where role = stringProperty "WM_WINDOW_ROLE"  
               
-- Urgency hint configuration
myUrgencyHook = withUrgencyHook NoUrgencyHook
--  dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }
  -- withUrgencyHook dzenUrgencyHook
  --   {
  --     args = [
  --        "-x", "0", "-y", "576", "-h", "15", "-w", "1024",
  --        "-ta", "r",
  --        "-fg", "" ++ myUrgencyHintFgColor ++ "",
  --        "-bg", "" ++ myUrgencyHintBgColor ++ ""
  --        ]
  --   }

-- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#I_need_to_find_the_class_title_or_some_other_X_property_of_my_program
-- find out using xprop
myManageHook = composeAll $
   [ isFullscreen --> doFullFloat
   -- , className =? "mpv" --> doFloat -- needs mpv --x11-netwm=no
   ]
   -- this works for mathematica 9
   ++
   [ stringProperty "WM_CLASS" =? "XMathematica"
     <&&> fmap (\x -> (isInfixOf "Find and Replace" x))
     title --> doFloat ]
   -- this works for mathematica 9  ++
   -- [ stringProperty "WM_CLASS" =? "XMathematica"
   --   <&&> fmap (\x -> not (isInfixOf "- Wolfram Mathematica" x
   --                         && not (isInfixOf "Find and Replace" x)))
   --   title --> doFloat ]
   ++
   [ c =? t  --> doFloat |  (c,ts) <- [
        -- problem: xmonad hängt wenn Ediff floating
        -- (title    ,["Find and Replace"]        ),
        --(resource ,["Ediff"]        ),
        (className,["Gimp","Zenity","Xdialog"]  )  -- feh
        ], t <- ts]

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
-- FOR CONSTANTS see http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html
-- http://hackage.haskell.org/packages/archive/X11/1.6.1.1/doc/html/Graphics-X11-Types.html
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

-- MORE?
-- navigate in 2D (up down left right): http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-WindowNavigation.html
-- update on mouse move within unfocused window: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-UpdateFocus.html
-- defaults: http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html      
-- Add new and/or redefine key bindings
newKeys conf = [
  -- Use shellPrompt instead of default dmenu
  ((myMM                 , xK_p    ), shellPrompt myXPConfig),
  -- ((myMM                 , xK_p    ), shell "terminator --title Launcher -x tmux -2 new-session -As Launcher zshlauncher),
  -- Do not leave useless conky and dzen after restart
  ((myMM .|. controlMask, xK_q), spawn "killall conky dzen2; xmonad --recompile; xmonad --restart")
  , ((myMM               , xK_c     ), kill1) -- @@ remove from current workspace or close if single
  , ((myMM .|. shiftMask , xK_Tab   ), rotSlavesUp)
  -- , ((myMM, xK_minus )   , decreaseLimit )
  -- , ((myMM, xK_plus )    , increaseLimit )
  -- , ((myMM, xK_equal )    , increaseLimit )
  , ((myMM .|. shiftMask, xK_g), sendMessage $ ToggleGaps)  
  -- , ((myMMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
  --, ((myMMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
  , ((myMM                , xK_b    ), sendMessage ToggleStruts)
    -- open background image
  , ((myMM .|. shiftMask  , xK_b    ), spawn $ "/usr/bin/feh \"`cat "++x11bgfile++"`\"" )
  , ((myMM .|. controlMask, xK_s    ), cycleRecentWindows [xK_Super_L] xK_s xK_w)
  , ((myMM .|. shiftMask  , xK_s    ), bringMenu)
  , ((myMM                , xK_s    ), gotoMenu)
  , ((myMM                , xK_z    ), rotOpposite)
  -- , ((myMM                , xK_i    ), rotUnfocusedUp)
  -- , ((myMM                , xK_u    ), rotUnfocusedDown)
  , ((myMM .|. shiftMask  , xK_i    ), rotFocusedUp)
  -- , ((myMM .|. shiftMask  , xK_u    ), rotFocusedDown)
    -- switch back and forth between last two workspaces:
  , ((myMM, xK_q), cycleRecentWS [xK_Super_L] xK_q xK_w)
  , ((myMM, xK_w), cycleRecentWS [xK_w] 0 0)
  , ((myMM .|. shiftMask  , xK_w    ), shiftToRecentWS)
--    start cycling amoung all workspaces until super_l is released with key combination 1, stop cycling by pressing one of [keys], swith to next prev by key2 key3
  , ((myMM                , xK_Tab  ), nextMatch History (return True))
  , ((myMM                , xK_r    ), nextMatchOrDo Forward  (className =? my_term_class) $ spawnHere my_term_attach)
  , ((myMM .|. shiftMask  , xK_r    ), nextMatchOrDo Backward (className =? my_term_class) $ spawnHere my_term_attach)
  , ((myMM,                 xK_d    ), viewEmptyWorkspace)
  , ((myMM .|. shiftMask  , xK_d    ), tagToEmptyWorkspace)
  , ((myMM                , xK_e    ), spawnHere my_emacs)
  , ((myMM .|. shiftMask  , xK_e    ), nextMatchOrDo Forward (className =? "Emacs") $ spawnHere my_emacs)
  , ((myMM .|. shiftMask  , xK_f    ), spawnHere "firefox")
  , ((myMM                , xK_f    ), nextMatchOrDo Forward (className =? "Firefox") $ spawnHere "firefox")
  , ((myMM .|. shiftMask  , xK_a    ), spawnHere my_term_new)
  , ((myMM                , xK_a    ), spawnHere my_term_attach)
  , ((myMM .|. controlMask, xK_a    ), spawnHere my_term_without_tmux)
  , ((myMM .|. controlMask, xK_x    ), sendMessage $ Toggle REFLECTX)
  , ((myMM .|. controlMask, xK_y    ), sendMessage $ Toggle REFLECTY)
  , ((myMM .|. controlMask, xK_f    ), sendMessage $ Toggle FULL)
  , ((myMM .|. controlMask, xK_m    ), sendMessage $ Toggle MIRROR)
  , ((myMM .|. controlMask, xK_p    ), namedScratchpadAction scratchpads "scratch" )
  , ((myMM .|. controlMask, xK_c    ), namedScratchpadAction scratchpads "sympy" )

  , ((myMM                , xK_u    ), rotScreen2 False    1 )
  , ((myMM                , xK_i    ), rotScreen2 False $ -1 )
  , ((myMM .|. shiftMask  , xK_u    ), rotScreen2 True     1 ) 
  , ((myMM .|. shiftMask  , xK_i    ), rotScreen2 True  $ -1 )
  ]
   ++
-- the following is s slightly modified version of: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Actions-CopyWindow.html
-- mod-control-[1..9] @@ Copy client to workspace N
  [((m .|. myMM, k), windows $ onCurrentScreen2 f i)
     | (i, ks) <- zip (workspaces' conf) $ snd myWorkspaces
     , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, controlMask)]
     , k <- ks]
   ++
-- get layout jumper bindings
  fst myLayouts

shiftToRecentWS = windows f
  where f w = let new = W.tag $ W.workspaces w !! 1 in
               W.view new $ W.shift new w
  
onCurrentScreen2 :: (PhysicalWorkspace -> WindowSet -> WindowSet) -> VirtualWorkspace -> WindowSet -> WindowSet
onCurrentScreen2 f vws = currentPWS >>= onlyWithScreen2 (f . flip marshall vws) . unmarshallS

currentPWS = W.tag . W.workspace . W.current
                         
onlyWithScreen2 f = maybe id f
             
rotScreen2 :: Bool -- ^ shift window
              -> Int -- ^ to screen
              -> X ()
rotScreen2 shift i = windows $ onlyWithScreen2 f . unmarshall =<< currentPWS
   where f (sid,vws) = a $ marshall ((sid + S i) `mod` myNumberOfScreens) vws
         a = case shift of True -> W.shift; False -> W.view

myMarshallPP :: Maybe ScreenId -> PP -> PP
myMarshallPP Nothing pp  = pp
myMarshallPP (Just s) pp  = (marshallPP undefined pp)
    -- the upstream marshallPP messes up getSortByIndex
     { ppSort = (. filter (onScreen s)) <$> ppSort pp }
                            
onScreen s = maybe False (s==) . unmarshallS . W.tag


unmarshall t = do let (l,r) = break (=='_') t
                  s <- readMaybe l
                  return (S s,drop 1 r)

unmarshallS = fmap fst . unmarshall

    
myDynLog h = do
    copies <- wsContainingCopies
    let color ws | ws `elem` copies = wrapBg myHiddenWsWithCopyBg ws
                 | otherwise = ws
    wset <- gets windowset
    let s = unmarshallS $ currentPWS wset
    ls <- dynamicLogString $ myMarshallPP s $
          myDzenPP {ppHidden = ppHidden myDzenPP . color }
    a <- maybe (io currentFehBg) (const $ return "") $ W.stack $ W.workspace $ W.current wset
    io . hPutStrLn h $ screenIdColor s ++ ls ++ encodeString a 


screenIdColor (Just (S s1)) = wrapBg (["#57D300","#D8003A","#0057CF","#EF8D00"] !! s1) ("  ")
screenIdColor Nothing = "  "                         

x11bgfile = "/home/johannes/.x11bg"
currentFehBg = takeBaseName <$> readFile x11bgfile
-- somehow does not work in logHook: readProcess (cbi ++ "bin/feh_bg") ["f"] ""
    
-- Dzen config
myDzenPP = defaultPP {
  -- alternative sorts: http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-WorkspaceCompare.html
  ppSort =   fmap (. namedScratchpadFilterOutWorkspace) $ ppSort defaultPP
  ,ppSep = "^bg(" ++ myBgBgColor ++ ")^r(1,15)^bg()"
  ,ppWsSep = ""
  ,ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor
  ,ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor
  ,ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor
  ,ppHidden = wrapFgBg myHiddenWsFgColor myHiddenWsBgColor
  ,ppUrgent = wrapFgBg myUrgentWsFgColor myUrgentWsBgColor
  ,ppTitle = (" " ++) . wrapFg myTitleFgColor
  ,ppLayout  = dzenColor myFgColor "" .  pad . filter f . map m
  -- ,ppExtras = 
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



-- from ./XMonad/Hooks/EwmhDesktops.hs 
-- needed for mpv fullscreen
setSupported :: X ()
setSupported = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN" -- the patch
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)
    setWMName "LG3D" --required for JAVA (e.g. jdownloader). without
                     --it menues and clicks and window drawing
                     --according to window size do not work

    
myEwmh :: XConfig a -> XConfig a
myEwmh c = c { startupHook     = startupHook c >> setSupported
             , handleEventHook = handleEventHook c >>
                                 ewmhDesktopsEventHook >> fullscreenEventHook  -- this order is important!
             , logHook         = logHook c >> ewmhDesktopsLogHook }



-- executes action on first empty work space on the current screen
withEmptyWorkspace :: (WorkspaceId -> X ()) -> X ()
withEmptyWorkspace f = do
    ws <- gets windowset
    ppsort <- ppSort $ myMarshallPP (unmarshallS $ currentPWS ws) $ myDzenPP
    let allWorkspaces = ppsort $ fmap W.workspace (W.current ws : W.visible ws)
                        ++ W.hidden ws
    whenJust (find (isNothing . W.stack) allWorkspaces) (f . W.tag)

viewEmptyWorkspace = withEmptyWorkspace (windows . W.view)
tagToEmptyWorkspace = withEmptyWorkspace $ \w -> windows $ W.view w . W.shift w
sendToEmptyWorkspace = withEmptyWorkspace $ windows . W.shift

-- ~/.xmonad/xmonad.hs

-- Imports {{{
import XMonad
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
-- Hooks
import XMonad.Operations

import System.IO
import System.Exit
import System.Environment (getEnv)
import System.IO.Unsafe


import XMonad.Util.Run

import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace))
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Fullscreen
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import qualified XMonad.StackSet as W
import qualified Data.Map as M
-- }}}

-- Config {{{
myUser = "alex"
--myFont = "6x10"
--myFont = "-*-terminus-medium-*-*-*-*-120-72-72-*-*-iso10646-*"
--myFont = "-misc-tamsyn-medium-r-normal--12-87-100-100-c-60-iso8859-1"
myFont = "-misc-tamsyn-bold-r-normal--14-101-100-100-c-70-iso8859-1"

myModMask = mod4Mask
altMask = mod1Mask

myWorkspaces = [work1, work2, work3, work4, work5, work6, work7, work8, work9]

work1 = "1:Main"
work2 = "2:Web"
work3 = "3:"
work4 = "4"
work5 = "5"
work6 = "6"
work7 = "7"
work8 = "8"
work9 = "9"
-- }}}

-- dzen/conky {{{
myXmonadBar = "dzen2 -x '0' -y '0' -h '16' -w '512' -ta 'l' -fg '"++colorWhite++"' -bg '"++myColorBG++"' -fn '"++myFont++"'"
myStatusBar = "~/.xmonad/dzen2/scripts/statusbar.sh | dzen2 -e - -x '512' -y '0' -h '16' -w '960' -ta r -fg '"++colorWhite++"' -bg '"++myColorBG++"' -fn '"++myFont++"'"
-- }}}

-- Colors {{{
myColorBG       = colorDarkGray

colorCore       = unsafePerformIO $ getEnv "COLOR6"  
colorYellow     = "#f7e7ad"
colorWhite      = "#ffffff"
colorDarkGray   = "#1b1d1e"
colorDeepGray   = "#161616"
colorGray       = "#666666"
colorBlack      = "#000000"
colorRed        = "#ff0000"
-- }}}

-- Hooks {{{

-- StartupHooks {{{
startupHook' :: X ()
startupHook' = do
    return ()
-- }}}

-- ManageHooks {{{
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    --, [className    =? c            --> doShift  work2      |   c   <- myWebs   ] -- move web to 2
    , [icon         =? i            --> doShift work3       |   i   <- myChat   ] -- move chat to 3
    , [className    =? c            --> doShift  work4      |   c   <- myMedia  ] -- move pictures to 4
    , [className    =? c            --> doShift  work4      |   c   <- myMedia  ] -- move pictures to 4
    , [name         =? n            --> doCenterFloat       |   n   <- myCenters] -- float my names
    , [name         =? n            --> doSideFloat CE      |   n   <- myFloatCE] -- float my names
    --, [isFullscreen                 --> myDoFullFloat                           ]
    , [icon         =? "float me" --> doRectFloat (W.RationalRect 0.64 0.633 0.35 0.35)] 
    ]) 

    where
 
        icon        = stringProperty "WM_ICON_NAME"
        name        = stringProperty "WM_NAME"
 
        -- classnames
        myWebs      = ["Google-chrome-stable"]
        myMedia     = ["feh","feh","Vlc","rdesktop"]
 
        -- resources
        myIgnores   = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myCenters   = ["xfontsel","Downloads","Preferences","float me"]
        myFloatCE   = ["vifm","Execute program feat. completion"]
        myChat      = ["irssi","weechat"]

        --

        -- a trick for fullscreen but stil allow focusing of other WSs
        myDoFullFloat :: ManageHook
        myDoFullFloat = doF W.focusDown <+> doFullFloat

-- }}}

-- LayoutHooks {{{
sfloat  = renamed [Replace "Float"] $ simplestFloat 
tiled   = renamed [Replace "Tiled"] $ spacing 10 $ Tall nmaster delta ratio
    where
        nmaster = 1
        ratio   = 3/5
        delta   = 5/100
wtiled  = renamed [Replace "Tiled"] $ Tall nmaster delta ratio
    where
        nmaster = 1
        ratio   = 1/2
        delta   = 5/100
mtiled  = renamed [Replace "Mirror Tiled"]      $ Mirror tiled
tricol  = renamed [Replace "Equal ThreeCol"]    $ ThreeCol nmaster delta ratio
    where
        nmaster = 1
        ratio   = 1/3
        delta   = 3/100
tricolmid  = renamed [Replace "Center ThreeCol"]   $ ThreeColMid nmaster delta ratio
    where
        nmaster = 1
        ratio   = 4/9
        delta   = 3/100

layoutHook'  =  onWorkspaces [work1] mainLayout  $ 
                onWorkspaces [work2] webLayout   $
                onWorkspaces [work5] codeLayout0 $
                onWorkspaces [work6, work7, work8, work9] codeLayout1$
                defaultLayout

mainLayout      = avoidStruts $ tiled ||| mtiled ||| sfloat ||| Full
webLayout       = avoidStruts $ wtiled ||| Full
defaultLayout   = avoidStruts $ tiled ||| Full ||| mtiled 
codeLayout0     = avoidStruts $ tricolmid ||| tricol ||| wtiled
codeLayout1     = avoidStruts $ tricol ||| tricolmid ||| wtiled
-- }}}

-- Bar {{{
myBitmapsDir = "/home/"++myUser++"/.xmonad/dzen2/icons"

firstWord :: String -> String
firstWord s 
    | null $ words $ s = ""
    | otherwise = head $ words $ s

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP 
    { ppCurrent           = dzenColor colorWhite  colorGray . pad
    , ppVisible           = dzenColor colorWhite  myColorBG . pad
    , ppHidden            = dzenColor colorWhite  myColorBG . pad
    , ppHiddenNoWindows   = dzenColor colorGray   myColorBG . pad
    , ppUrgent            = dzenColor colorRed    myColorBG . pad
    --, ppTitle             = dzenColor colorGray   myColorBG . trim . firstWord . shorten 50 
    , ppOrder             = \(ws:l:_:_) -> [l,ws]
    , ppWsSep             = ""
    , ppSep               = "^fg(" ++ colorDeepGray ++ ")|"
    , ppLayout            = dzenColor colorGray myColorBG .
                            (\x -> case x of
                                "Tiled"             ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_tile.xbm) "
                                "Mirror Tiled"      ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_nbstack.xbm) "
                                "Float"             ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_float.xbm) "
                                "Full"              ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_full.xbm) "
                                "Equal ThreeCol"    ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_tricol.xbm) "
                                "Center ThreeCol"   ->      " ^i(" ++ myBitmapsDir ++ "/xmonad_tricolmid.xbm) "
                                _                   ->      x
                            )
    , ppOutput            = hPutStrLn h
    }
-- }}}

-- }}}

-- Key Binds {{{
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- Util
    [ ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask,      xK_c        ), kill)
    , ((modMask .|. shiftMask,      xK_l        ), spawn "slock")
    , ((modMask,                    xK_r        ), spawn "urxvtc -n 'float me'")
    , ((modMask,                    xK_f        ), spawn "urxvtc -e vifm")
    , ((altMask .|. controlMask,    xK_2        ), do
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&")
    , ((altMask .|. controlMask,    xK_3        ), do
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&")
    , ((altMask .|. controlMask,    xK_4        ), do
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&"
                                                    spawn "urxvtc&")
    -- Programs
    , ((0,                          xK_Print    ), spawn "scrot -e 'mv $f ~/screenshots/'")
    , ((modMask,                    xK_o        ), spawn "google-chrome --incognito")
    , ((modMask .|. shiftMask,      xK_o        ), spawn "firefox -private-window")
    , ((modMask,                    xK_i        ), spawn "urxvtc -n 'weechat' -e weechat-curses")
    -- Media Keys
    , ((0,                          0x1008ff12  ), spawn "amixer -q sset Master toggle")     -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -q sset Master 5%-")        -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -q sset Master 5%+")        -- XF86AudioRaiseVolume
--    , ((0,                          0x1008ff14  ), spawn "rhythmbox-client --play-pause")
--    , ((0,                          0x1008ff17  ), spawn "rhythmbox-client --next")
--    , ((0,                          0x1008ff16  ), spawn "rhythmbox-client --previous")

    -- Power management
    , ((modMask,                    xK_p        ), spawn "sudo pm-suspend")
    , ((modMask .|.shiftMask,       xK_p        ), spawn "sudo pm-hibernate")
    -- Brightness
    , ((modMask,                    0xff52      ), spawn "xbacklight -inc 20")
    , ((modMask,                    0xff54      ), spawn "xbacklight -dec 20")
 
    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_n        ), refresh)
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask,                    xK_j        ), windows W.focusDown)
    , ((modMask .|. shiftMask,      xK_Tab      ), windows W.focusUp  )                         -- move focus to next window
    , ((modMask,                    xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))
 
 
    -- workspaces
    , ((modMask .|. controlMask,   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)
 
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "killall dzen2; xmonad --recompile && xmonad --restart")
    , ((modMask .|. shiftMask,      xK_z        ), spawn "killall urxvtd; zsh ~/.startup")

    -- misc.
    , ((modMask .|. shiftMask,      xK_w        ), spawn "~/.xmonad/wp/wp change")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++

    -- -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    -- --
    -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    --
-- }}}
 
-- Main {{{
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ defaultConfig
        { terminal              = "urxvtc"
        , borderWidth           = 2
        , normalBorderColor     = myColorBG
        , focusedBorderColor    = colorGray
        , workspaces            = myWorkspaces
        , modMask               = myModMask
        , manageHook            = manageHook'
        , layoutHook            = layoutHook'
        , startupHook           = startupHook'
        , logHook               = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
        , keys                  = keys'
        }

-- Import statements
import XMonad
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Config.Gnome
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWS
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Grid
import XMonad.Layout.FixedColumn
import XMonad.Layout.Magnifier
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.Dishes
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.LimitWindows
import XMonad.Layout.NoBorders
import XMonad.Util.Themes
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Actions.RotSlaves
import XMonad.Actions.PerWorkspaceKeys
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Util.Scratchpad
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Control.Monad
import Data.Ratio ((%))
import Data.Maybe
import Data.List

myMod = mod4Mask --Windows button

myTerminal = "urxvtc"

myWorkspaces = ["1:main","2:web","3:chat","4:code","5:book","6:browse","7","8","9:logs"]

-- Define the workspace an application has to go to
myManageHook = composeAll [
  -- comes first to partially override default gimp floating behavior
    gimp "toolbox" --> (ask >>= doF . W.sink)
  , gimp "image-window" --> (ask >>= doF . W.sink)
  , scratchpadManageHook (W.RationalRect 0.25 0.25 0.5 0.5)
  , resource =? "floatterm" --> doFloat
  , className =? "Gnome-mplayer" --> doFullFloat
  -- workaround for <http://code.google.com/p/xmonad/issues/detail?id=228>
  , composeOne [ isFullscreen -?> doFullFloat ]
  -- Shift Applications to appropriate workspace
  , className =? "Namoroka" --> doShift "2:web"
  , className =? "Firefox" --> doShift "2:web"
  , className =? "Pidgin" --> doShift "3:chat"
  ]
    where gimp win = (className =? "Gimp" <&&> (fmap (win `isSuffixOf`) role))
          role = stringProperty "WM_WINDOW_ROLE"

myXPConfig = defaultXPConfig {
    fgColor  = "#efecca"
  , bgColor  = "#2a2c2b"
  , promptBorderWidth = 1
  , position = Bottom
  , height   = 25
  , font     = "-*-dina-medium-r-normal-*-*-*-*-*-*-*-*-*"
  }

myLayout = smartBorders $ toggleLayouts Full perWS
  where
    -- Per workspace layout selection.
    perWS = onWorkspace "9:logs" (myLogs dishFirst) $
            onWorkspace "2:web"  (noBorders $ (mySplit ||| myWide)) $
            onWorkspace "3:chat" (myChat gridFirst) $
            onWorkspace "5:book" (myBook) $
            onWorkspace "4:code" (codeFirst)
                               (normFirst)

    -- Modifies a layout to be desktop friendly with title bars
    -- and avoid the panel.
    -- withTitles l = noFrillsDeco shrinkText myTheme (desktopLayoutModifiers l)
    -- Modifies a layout to be desktop friendly, but with no title bars
    -- and avoid the panel.
    -- noTitles l = desktopLayoutModifiers l

    -- Each of these allows toggling through a set of layouts
    -- in the same logical order, but from a different starting point.
    normFirst  = myNorm  ||| myWide  ||| myGrid  ||| myDish
    codeFirst  = myCode  ||| myWide  ||| myGrid  ||| myDish
    dishFirst  = myDish  ||| myCode  ||| myWide  ||| myGrid
    gridFirst  = myGrid  ||| myDish  ||| myCode  ||| myWide

    -- This is a tall-like layout with magnification.
    -- The master window is fixed at 80 columns wide, making this good
    -- for coding. Limited to 3 visible windows at a time to ensure all
    -- are a good size.
    myCode = limitWindows 3 $ Tall nmaster delta ratio
      where
        nmaster = 1
        delta = 3/100
        ratio = 1/2

    myNorm = limitWindows 3 $ Tall nmaster delta ratio
      where
        nmaster = 1
        delta = 3/100
        ratio = 1/2

    -- Stack with one large master window.
    -- It's easy to overflow a stack to the point that windows are too
    -- small, so only show first 5.
    myDish = limitWindows 5 $ Dishes nmaster ratio
      where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by other panes
        ratio = 1/5

    -- Wide layout with subwindows at the bottom.
    myWide = Mirror $ Tall nmaster delta ratio
      where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 80/100

    -- Split screen, optimized for web browsing.
    mySplit = magnifiercz' 1.4 $ Tall nmaster delta ratio
      where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 60/100

    -- Standard grid.
    myGrid = Grid

    -- The chat workspace has a roster on the right.
    myChat base = reflectHoriz $ withIM size roster $ reflectHoriz $ base
      where
        -- Ratio of screen roster will occupy
        size = 1%5
        -- Match roster window
        roster = Title "Buddy List"

    -- The logs workspace has space for procmeter.
    myLogs base = reflectHoriz $ withIM procmeterSize procmeter $
                    reflectHoriz $ base
      where
        -- Ratio of screen procmeter will occupy
        procmeterSize = 1%7
        -- Match procmeter
        procmeter = ClassName "ProcMeter3"

    -- For reading books, I typically want borders on
    -- the margin of the screen.
    myBook = ThreeColMid nmaster delta ratio
       where
         -- The default number of windows in the master pane
         nmaster = 1
         -- Percent of screen to increment by when resizing panes
         delta   = 3/100
         -- Default proportion of screen occupied by master pane
         ratio   = 2/3

myNormalBorderColor = "#484A47"
myFocusedBorderColor = "#C1CE96"

myKeys = [
    ((myMod, xK_p), shellPrompt myXPConfig)
  , ((myMod, xK_Tab), bindOn [("chat", rotSlavesDown), ("", rotAllDown)])
  , ((myMod .|. shiftMask, xK_Tab), bindOn [("chat", rotSlavesUp), ("", rotAllUp)])
  , ((myMod, xK_d), sendMessage $ NextLayout)
  , ((myMod, xK_space), sendMessage $ ToggleLayout)
  ]

-- Run XMonad
main = do
    xmonad $ defaultConfig {
    terminal           = myTerminal
  , workspaces         = myWorkspaces
  , manageHook         = myManageHook
  , layoutHook         = myLayout
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , modMask            = myMod
} `additionalKeys` myKeys


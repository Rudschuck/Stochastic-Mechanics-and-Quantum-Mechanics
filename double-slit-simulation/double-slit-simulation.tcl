
#!/usr/bin/env wish


# Two-slit simulation in Tcl/Tk
# ----------------------------------------
# A simulation of the "two-slit process," demonstrating 
# Ed Nelson's theory of Stochastic Mechanics.
#
# Ported from:  http://www.cs.cmuy.edu/afs/cs/usr/lafferty/www/QF/  
# 
# This program is a Tcl/Tk port of John Lafferty’s Java Applet (1998),
# originally written as a simulation of Ed Nelson’s "Stochastic Mechanics".
#
# The code simulates the passage of quantum-like particles through a
# two-slit barrier and displays their diffusion, drift, and eventual
# detection on a screen placed to the right of the slits.
#
# Core principles of the simulation:
#
# 1. Particles are initialized at two slits (upper/lower).
# 2. Their motion is modeled as a combination of:
#    - Drift (deterministic, derived from Nelson’s formula 17.5).
#    - Random stochastic increments (a discretized Brownian step).
# 3. Once a particle reaches the right-hand side of the canvas (the "screen"),
#    it is reset to a slit and its impact is registered in a vertical bin
#    corresponding to its y-coordinate. Over time, this builds a histogram
#    resembling the interference pattern.
#

#
# Implementation notes:
# - The original Java Applet used threads and AWT rendering.
# - In this Tcl/Tk version, animation is achieved by repeatedly scheduling
#   the `step` procedure with `after 5`, which updates the physics and redraws.
# - The drawing is done using a Tk `canvas`. Separate canvas tags are used
#   for points, bins, slits, and background to allow selective deletion.
#
# Most parts of the code are structured around a namespace (::TwoSlit) to encapsulate all
# simulation parameters, state variables, and helper procedures.
# ----------------------------------------
#
# Licence: GPL 2 or higher
#
# (c) Dr. Michael Rudschuck
# michael.rudschuck@vde.com    
#
# rev:
# 0.1: First release.
#
#






package require Tk
package require itk

namespace eval ::TwoSlit {

    # --- Window and geometry parameters ---
    variable W           900  ;# Canvas width in pixels. 
    variable H           900  ;# Canvas height in pixels (original: 600).
    variable binsPercent 0.80 ;# Fraction of the canvas width reserved for bins on the right.                        
    variable screenWidth      ;# Effective width of "free space" before the detection screen. 
    variable wallWidth   100  ;# Thickness of the bins (change from 3 to 100).
 
   # --- Simulation parameters (also set by setParameters gesetzt) ---
    variable a           30.0  ;# a = half the distance between the two slit centers.                              
    variable lambda      0.10  ;# lambda = relative slit half-width, expressed as fraction of a.                         
    variable m_hbar      40.0  ;# m_hbar = (m / hbar) parameter, controls the scale of diffusion (original 40).  
    variable sqrt_dt           ;# sqrt_dt = discrete step size.
    variable m_over_hbar  [expr {1.0/$::TwoSlit::m_hbar }]  
    variable dt

    # --- Simulation control ---
    variable numPoints 400     ;# Number of simultaneously simulated particles (original 100).
    variable numBins   400     ;# Number of vertical bins in the histogram (original 35).
    variable ticks       0     ;# Counter for simulation steps (time-like variable).
    variable running     1     ;# Boolean: whether the simulation is active.


    # --- Data structures ---
    
    # Particles: list of dicts with keys {x y active}.
    #   - x, y = position on canvas
    #   - active = whether particle has already passed through a slit
    variable points
    

    # Bins: list of dicts with keys {y1 y2 count}.
    #   - y1,y2 = vertical bounds of the bin
    #   - count = number of particles that have impacted inside this bin
    variable bins

     # --- Canvas handles and drawing tags ---
    variable CAN
    variable TAG_POINTS "points"
    variable TAG_BINS   "bins"
    variable TAG_SLITS  "slits"
    variable TAG_BG     "bg"
}



proc ::TwoSlit::drift {x t} {
# DO:        Computes the deterministic drift velocity according to Nelson's formula (17.5).
#            This term represents the "guiding" influence of the quantum potential.
#            If the hyperbolic argument is very large (to avoid overflow), a linear
#            approximation is used instead, which is numerically stable.
# REV:       0.1: First version.  
# PARAMETER: x,t
# RETURNS: 
    variable lambda
    set l44     [expr {4*pow($lambda,4)}]
    set l22     [expr {2*pow($lambda,2)}]
    set t2      [expr {$t*$t}]
    set linterm [expr {($t+$l22)/($l44+$t2)}]
    set argh    [expr {2*$l22*$x*$::TwoSlit::a/($l44+$t2)}]

          if {$argh >  100} {return [expr {+($::TwoSlit::a - $x)*$linterm}]
    } elseif {$argh < -100} {return [expr {-($::TwoSlit::a + $x)*$linterm}]
    } else {
        set sinhterm [expr {sinh($argh)*($t+$l22)/($l44+$t2)}]
        set sinterm  [expr {sin(2*$t*$x*$::TwoSlit::a/($l44+$t2))*($t-$l22)/($l44+$t2)}]
        set coshterm [expr {cosh($argh)}]
        set costerm  [expr {cos(2*$t*$x*$::TwoSlit::a/($l44+$t2))}]
        return [expr {- $x*$linterm + $::TwoSlit::a*($sinhterm - $sinterm)/($coshterm + $costerm)}]
    }
}



proc ::TwoSlit::randSign {} { 
# DO:         Returns either +1 or -1, mimicking the sign of a Gaussian random step.
#             In the original Java version, Random.nextGaussian() was used to determine
#             the sign. Here we simplify it to a coin flip (uniform ±1), which is sufficient.    
# REV:      0.1: First version.  
# PARAMETER: 
# RETURNS:
expr {rand() < 0.5 ? -1.0 : 1.0}}



proc ::TwoSlit::randomSlitY {} {
# DO:         Returns a y-coordinate corresponding to a random slit.
#             Particles are initialized either at the upper or lower slit. 
# REV:      0.1: First version.  
# PARAMETER: 
# RETURNS
    variable H
    variable a
    expr {rand() < 0.5 ? int($H/2 - $a) : int($H/2 + $a)}
}



proc ::TwoSlit::binOfHeight {y} {
# DO:     
# REV:      
# PARAMETER: 
# RETURNS: 
    variable bins
    set i 0
    foreach b $bins {
        dict with b { ;# y1 y2 count
            if {$y1 <= $y && $y < $y2} { return $i }
        }
        incr i
    }
    return -1
}




proc ::TwoSlit::setDefault {} {
# DO:        Sets default values.
# REV:       0.1: First version.  
# PARAMETER: 
# RETURNS:   
    # --- Window and geometry parameters ---
    variable W           900  ;# Canvas width in pixels. 
    variable H           900  ;# Canvas height in pixels (original: 600).
    variable binsPercent 0.80 ;# Fraction of the canvas width reserved for bins on the right.                        
    variable screenWidth      ;# Effective width of "free space" before the detection screen. 
    variable wallWidth   100  ;# Thickness of the bins (change from 3 to 100).
 
   # --- Simulation parameters (also set by setParameters gesetzt) ---
    variable a           30.0  ;# a = half the distance between the two slit centers.                              
    variable lambda      0.10  ;# lambda = relative slit half-width, expressed as fraction of a.                         
    variable m_hbar      40.0  ;# m_hbar = (m / hbar) parameter, controls the scale of diffusion (original 40).  
    variable sqrt_dt           ;# sqrt_dt = discrete step size.
    variable m_over_hbar  [expr {1.0/$::TwoSlit::m_hbar }]  
    variable dt

    # --- Simulation control ---
    variable numPoints 400     ;# Number of simultaneously simulated particles (original 100).
    variable numBins   400     ;# Number of vertical bins in the histogram (original 35).
    variable ticks       0     ;# Counter for simulation steps (time-like variable).
    variable running     1     ;# Boolean: whether the simulation is active.
}





proc ::TwoSlit::setParameters {} {
# DO:        Computes derived parameters sqrt_dt and dt based on the screen width
#            and chosen values of a and m_over_hbar.
# REV:       0.1: First version.  
# PARAMETER: 
# RETURNS:   
    variable screenWidth
    variable a
    variable m_over_hbar
    variable sqrt_dt
    variable dt
    set sqrt_dt [expr {$a/sqrt(double($screenWidth))}]
    set dt      [expr {$m_over_hbar*$a*$a/double($screenWidth)}]
    set m_over_hbar  [expr {1.0/$::TwoSlit::m_hbar }]   
}



proc ::TwoSlit::makePoints {} {
# DO:          Initializes the particle list.
#              Each particle is placed at a random x (up to the screen width) and at a
#              random slit y-coordinate. All particles start "inactive" until they pass
#              the slit at least o
# REV:      0.1: First version.  
# PARAMETER: 
# RETURNS:  
    variable numPoints
    variable screenWidth
    variable points
    variable H
    set points {}
    for {set i 0} {$i < $numPoints} {incr i} {
        set x [expr {int(rand()*$screenWidth)}]
        set y [randomSlitY]
        lappend points [dict create x $x y $y active 0]
    }
}


proc ::TwoSlit::makeBins {} {
# DO:       Initializes the bins (histogram strips).
#           The canvas height is divided into `numBins` segments, each storing
#           a counter for the number of hits.
# REV:      0.1: First version.  
# PARAMETER: 
# RETURNS: 
    variable bins
    variable numBins
    variable H

   # variable screenWidth 
   # variable W
   # variable binsPercent
   # set screenWidth [expr {int($W*(1.0 - $binsPercent))}]

    set bins {}
    set width [expr {int($H/$numBins)+1}]
    set prevy 0
    for {set i 0} {$i < $numBins} {incr i} {
        set y1 $prevy
        set y2 [expr {$prevy+$width}]
        lappend bins [dict create y1 $y1 y2 $y2 count 0]
        set prevy $y2
    }
    # last bin
    set lastIdx [expr {[llength $bins]-1}]
    set last [lindex $bins $lastIdx]
    dict set last y2 [expr {$H-1}]
    set bins [lreplace $bins $lastIdx $lastIdx $last]
}




proc ::TwoSlit::drawSlits {} {
# DO:        Draws the slit wall on the left side of the canvas.
#            White rectangles = solid wall; black rectangles = open slits.
# REV:       0.1: First version.  
# PARAMETER: 
# RETURNS:   
    variable CAN
    variable TAG_SLITS
   
    variable H
    variable a
    variable lambda

   #  variable wallWidth
   set wallWidth 3
   set wallColor tan
   set slitColor black

    $CAN delete $TAG_SLITS
    # Upper wall above top slit
    $CAN create rectangle 0 0 $wallWidth [expr {$H/2 - $a - $lambda*$a}] -fill $wallColor -width 0 -tags $TAG_SLITS
    $CAN create rectangle 0 [expr {$H/2 - $a + $lambda*$a}] $wallWidth [expr {$H/2 - 1}] -fill $wallColor -width 0 -tags $TAG_SLITS
    $CAN create rectangle 0 [expr {$H/2}] $wallWidth [expr {$H/2 + $a - $lambda*$a}] -fill $wallColor -width 0 -tags $TAG_SLITS
    $CAN create rectangle 0 [expr {$H/2 + $a + $lambda*$a}] $wallWidth $H -fill $wallColor -width 0 -tags $TAG_SLITS
    # slits (black)
    $CAN create rectangle 0 [expr {$H/2 - $a - $lambda*$a}] $wallWidth [expr {$H/2 - $a + $lambda*$a}] -fill $slitColor -width 0 -tags $TAG_SLITS
    $CAN create rectangle 0 [expr {$H/2 + $a - $lambda*$a}] $wallWidth [expr {$H/2 + $a + $lambda*$a}] -fill $slitColor -width 0 -tags $TAG_SLITS
}




proc ::TwoSlit::drawBins {} {
# DO:       Draws the histogram bins on the right screen.
#           Every ~10 ticks, the accumulated counts are displayed as horizontal bars.
#           Bin heights are normalized to fit inside the available screen width.  
# REV:      0.1: First version.  
# PARAMETER: 
# RETURNS:   

    variable ticks
    if {[expr {$ticks % 10}] != 0} { return }

    variable CAN
    variable TAG_BINS
    variable bins
    variable screenWidth
    variable W
    variable H
    variable wallWidth
    set binColor seashell3
 

    # Delete right area and draw background
    $CAN delete $TAG_BINS
    # Trennlinie
    $CAN create rectangle $screenWidth 0 [expr {$screenWidth+$wallWidth}] $H -fill $binColor -width 0 -tags $TAG_BINS

    # Max. height
    set increment 2
    set maxH 0
    foreach b $bins {
        set h [expr {$increment*[dict get $b count]}]
        if {$h > $maxH} { set maxH $h }
    }

    set displayW [expr {$W - $screenWidth - 1}]
    foreach b $bins {
        dict with b {
            if {$maxH > 0} {
                if {$maxH > $displayW} {
                    set x [expr {$displayW * (double($count*$increment)/$maxH)}]
                    set w [expr {int($screenWidth + $x)}]
                } else {
                    set w [expr {$screenWidth + $increment*$count}]
                }
                # Draw frame around bin-area
                $CAN create line $screenWidth $y1 $w $y1 -tags $TAG_BINS
                $CAN create line $screenWidth $y2 $w $y2 -tags $TAG_BINS
                $CAN create line $w $y1 $w $y2 -tags $TAG_BINS
            }
        }
    }
}



proc ::TwoSlit::drawPoints {} {
# DO:           Draws all currently active particles.
#               Each particle is rendered as a small white 2x2 rectangle on the canva
# REV:          0.1: First version.  
# PARAMETER: 
# RETURNS:   

    variable CAN
    variable TAG_POINTS
    variable points
    set pixelSize 2

    $CAN delete $TAG_POINTS
    foreach p $points {
        dict with p {
            if {$active} {
                $CAN create rectangle $x $y [expr {$x+$pixelSize}] [expr {$y+$pixelSize}] -fill white -outline "" -tags $TAG_POINTS
            }
        }
    }
}


proc ::TwoSlit::step {} {
    variable running
    if {!$running} { return }

    variable points
    variable bins
    variable screenWidth
    variable H
    variable a
    variable lambda
    variable sqrt_dt
    variable dt
    variable ticks

    set newPoints {}
    set i 0
    foreach p $points {
        dict with p {
            # Arrival on the right side
            if {$x >= $screenWidth} {
                if {$active} {
                    set b [binOfHeight $y]
                    if {$b >= 0} {
                        # Increase bin counter
                        set bdict [lindex $bins $b]
                        dict incr bdict count
                        set bins [lreplace $bins $b $b $bdict]
                    }
                } else {
                    set active 1
                }
                set x 0
                set y [randomSlitY]
            }
            # forward in x-direction
            incr x

            if {$active} {
                # Discrete diffusion with drift
                set dw [expr {[randSign]*$sqrt_dt}]
                set X [expr {$H/2.0 - $y}]
                set ::TwoSlit::m_over_hbar  [expr {1.0/$::TwoSlit::m_hbar }]   ;# 40.0
                set t [expr {(double($x)/$screenWidth) * $a*$a*$::TwoSlit::m_over_hbar*10.0*$lambda}]
                set b [drift $X $t]
                set y [expr {round($y + ($b*$dt + $dw))}]
                # Clipping
                if {$y < 0} { set y 0 }
                if {$y >= $H} { set y [expr {$H-1}] }
            }
        }
        lappend newPoints [dict create x $x y $y active $active]
        incr i
    }
    set points $newPoints
    incr ticks

    # Rendering
    drawSlits
    drawBins
    drawPoints

    # Next step
    after 1 ::TwoSlit::step

}




# --- Start ---


    wm title . "Stochastic Mechanics Two-Slit Simulation"
    frame .buttons -padx 8 -pady 8
    pack .buttons -side top -fill x


 # Buttons
   
    set resetBtn [button .buttons.reset -text "reset" -command {
        ::TwoSlit::makePoints
        ::TwoSlit::makeBins
        ::TwoSlit::drawSlits
        ::TwoSlit::drawBins
        ::TwoSlit::drawPoints
    }]

    set pauseBtn [button .buttons.pause -text "START" -command {
        if {$::TwoSlit::running} {
            set ::TwoSlit::running 0
            .buttons.pause configure -text "resume"
        } else {
            set ::TwoSlit::running 1
            .buttons.pause configure -text "pause"
            ::TwoSlit::step
        }
    }]

    set defaultBtn [button .buttons.default -text "default" -command { ::TwoSlit::setDefault}]

    pack  .buttons.pause  .buttons.reset   .buttons.default -side left -padx 4


   frame .sliders -padx 8 -pady 8
    pack .sliders -side top -fill x



 # Sliders
      set l1 [label .sliders.la1  -text "Detector Distance:"]
      set s1 [ scale .sliders.sl1  -from 0.05 -to 0.95 -resolution 0.01  -variable  ::TwoSlit::binsPercent  -relief ridge -orien horizontal]
      grid $l1 $s1  -padx 4 -pady 4
      grid $l1 -sticky w
      grid $s1 -sticky ew
    
      set l2 [label .sliders.la2  -text "a:"]
      set s2 [ scale .sliders.sl2  -from 5.0 -to 50.0 -resolution 0.1  -variable  ::TwoSlit::a -relief ridge -orien horizontal]
      grid $l2 $s2  -padx 4 -pady 4
      grid $l2 -sticky w
      grid $s2 -sticky ew

      set l3 [label .sliders.la3  -text "lambda:"]
      set s3 [ scale .sliders.sl3  -from 0.01 -to 0.5  -resolution 0.001   -variable ::TwoSlit::lambda -relief ridge -orien horizontal]
      grid $l3 $s3  -padx 4 -pady 4
      grid $l3 -sticky w
      grid $s3 -sticky ew

      set l4 [label .sliders.la4  -text "m/hbar:"]
      set s4 [ scale .sliders.sl4  -from 1 -to 100.0  -resolution 0.1  -variable ::TwoSlit::m_hbar -relief ridge -orien horizontal]
      grid $l4 $s4  -padx 4 -pady 4
      grid $l4 -sticky w
      grid $s4 -sticky ew





     set frc [frame .frc -padx 8 -pady 8]

     set ::TwoSlit::CAN [canvas $frc.c -width $::TwoSlit::W -height $::TwoSlit::H -background black -highlightthickness 0]
    
     pack $frc -side top -fill both -expand 1
     pack $::TwoSlit::CAN

     set ::TwoSlit::screenWidth [expr {int($::TwoSlit::W*(1.0 - $::TwoSlit::binsPercent))}]

   

    ::TwoSlit::setDefault 
    ::TwoSlit::setParameters
    ::TwoSlit::makePoints
    ::TwoSlit::makeBins

    # Redraw full/all
    ::TwoSlit::drawSlits
    ::TwoSlit::drawBins
    ::TwoSlit::drawPoints

set ::TwoSlit::running 0






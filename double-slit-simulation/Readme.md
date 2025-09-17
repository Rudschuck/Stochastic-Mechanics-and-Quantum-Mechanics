# Two-Slit Experiment Simulation (Tcl/Tk)

This repository contains a Tcl/Tk port of John Lafferty’s Java Applet (1998), which itself was inspired by Edward Nelson’s famous book  *Stochastic Mechanics*.  

The program simulates the **two-slit experiment** by letting particles diffuse and drift according to Nelson’s formula (17.5). Over time, the simulation produces an **interference-like histogram** on the detection screen.



* [>>> Visit GitHub-Repository <<<](https://github.com/Rudschuck/Stochastic-Mechanics-and-Quantum-Mechanics/tree/main/double-slit-simulation)



---

## ✨ Features

- **Two-slit barrier** with adjustable slit width and separation.  
- **Stochastic mechanics simulation** combining drift + Brownian motion.  
- **Histogram visualization** of particle impacts on the screen.  
- **Interactive controls**:
  - Toggle between *zoom in* and *zoom out* (changes resolution and slit separation).  
  - Pause and resume the animation.  
  - Reset the simulation.  



---

## ⚙️ Installation & Usage

You need a Tcl/Tk interpreter (`wish`) installed on your system.

Clone this repository and run the script with `wish`:

```bash
git clone https://github.com/Rudschuck/Stochastic-Mechanics-and-Quantum-Mechanics.git
cd ./Stochastic-Mechanics-and-Quantum-Mechanics/double-slit-simulation
wish ./double-slit-simulation.tcl
```

---

## 🎮 Controls


* **Reset**
  Clears all counters and particles and restarts the simulation.

* **Pause / Resume**
  Stops or resumes the animation loop.

---

## 📖 Background

This simulation illustrates Nelson’s *stochastic mechanics* approach to quantum theory.
Instead of treating wave functions directly, particle motion is modeled as **classical diffusion** with additional **drift terms** derived from Nelson’s equations.

The resulting particle distribution on the screen resembles the **interference pattern** known from quantum mechanics, but emerges from a purely stochastic process.

---

## 🙏 Credits

* Original Java Applet: John Lafferty (1998)
  see: http://www.cs.cmu.edu/afs/cs/usr/lafferty/www/QF/TwoSlit.java
* Theoretical background: 
  1. Edward Nelson, *Quantum Fluctuations* (1985), Princeton Series in Physics
  2. Lothar Fritsche, *A new look at the derivation of the Schrödinger equation from Newtonian mechanics*, Annalen der Physik (2003), **12**, pp. 371-403, https://www.researchgate.net/publication/227605133
 
An comprehensive bibliography regarding Nelson's Stochastic Mechanics can be found at 
* [>>>Stochastic Mechanics and Quantum Mechanics (German language)<<<](https://github.com/Rudschuck/Stochastic-Mechanics-and-Quantum-Mechanics/raw/main/Stochastische_Mechanik_und_Quantenmechanik_latest.pdf)


---


## 📜 License & Copyright

This project is released under the **GPL 2 or higher**.
Feel free to use, modify, and distribute it.

(c) Dr. Michael Rudschuck
 michael.rudschuck@vde.com    

---

## Rev:
* 0.1: First release.




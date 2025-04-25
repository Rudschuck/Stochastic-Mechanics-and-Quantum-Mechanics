## GFortran

   

|                |                                          |
|:---------------|:-----------------------------------------|
| Language:      | fortran                                  |
| Constructor:   | HERETIC-CONSTRUCT-FORTRAN                |
| Compiler:      | Gnu Fortran Compiler                     |
|                | gfortran                                 |
| Version:       | ./.                                      |
| Comment:       | `! ....`                                 |
| Block Comment: |                                          |
| Tested         | cygwin                                   |
| platforms:     | Suse 12.1                                |
|                |                                          |
| Web-Page:      | [(link)](http://gcc.gnu.org/fortran/)    |
| Manual:        | [(link)](http://gcc.gnu.org/onlinedocs/) |

p7 cmp2.5 cmp2.5 cm Title & Descrption & Link  
Standardized Mixed Language Programming for Fortran and C & Manual &
[(link)](http://www.roguewave.com/DesktopModules/Bring2mind/DMX/Download.aspx?entryid=751&command=core_download&PortalId=0&TabId=607)  
Calling the IMSL Fortran Library from CNN. & Manual &
[(link)](http://www.roguewave.com/DesktopModules/Bring2mind/DMX/Download.aspx?entryid=725&command=core_download&PortalId=0&TabId=607)  
Howto call the IMSL Fortran libraries from C & Manual &
[(link)](http://micro.ustc.edu.cn/Fortran/How%20to%20call%20Fortran%20from%20C.pdf)  
Mixed language programming using C++ and FORTRAN 77 & Webpage &
[(link)](http://arnholm.org/software/cppf77/cppf77.htm)  
Standard intrinsic module ISO C_BINDING & Manual &
[(link)](http://geco.mines.edu/software/nagfor/pdf/iso_c_binding.pdf)  
Intel Fortran: Interoperability with C & Webpage &
[(link)](http://software.intel.com/sites/products/documentation/hpc/composerxe/en-us/2011Update/fortran/win/bldaps_for/common/bldaps_interopc.htm)  
Introduction to Modern Fortran: External Names, Make and Linking &
Lecture &
[(link)](http://people.ds.cam.ac.uk/nmm1/Fortran/paper_13.pdf)  
NN. & Webpage & [(link)](http://gcc.gnu.org/onlinedocs/gfortran/)  
NN. & Webpage &
[(link)](http://gcc.gnu.org/onlinedocs/gfortran/Mixed_002dLanguage-Programming.html)  
NN. & Webpage &
[(link)](http://gcc.gnu.org/onlinedocs/gfortran/ISO_005fC_005fBINDING.html)  
NN. & important&
[(link)](http://www.cs.mtu.edu/~shene/COURSES/cs201/NOTES/F90-Subprograms.pdf)  
NN. & Mixing Fortran & C &
[(link)](http://owen.sj.ca.us/~rk/howto/FandC/FandC.call.html)  
NN. & (\*) Mixing Fortran & C &
[(link)](http://www.yolinux.com/TUTORIALS/LinuxTutorialMixingFortranAndC.html)  
NN. & Mixing Fortran & C &
[(link)](http://www.cats.rwth-aachen.de/Members/schlauch/mixedprogramming)  
NN. & Mixing Fortran & C &
[(link)](http://www.ncsa.illinois.edu/UserInfo/Resources/Software/Intel/Compilers/8.1/f_ug1/pgwusmod.htm)  
NN. & Mixing Fortran & C &
[(link)](http://www-mipl.jpl.nasa.gov/portguide/section3.11.html)  
NN. & Mixing Fortran & C &
[(link)](http://www.gnu.org/software/automake/manual/html_node/Mixing-Fortran-77-With-C-and-C_002b_002b.html)  
NN. & Mixing Fortran & C &
[(link)](http://www.neurophys.wisc.edu/comp/docs/notes/not017.html)  
NN. & Mixing Fortran & C &
[(link)](http://www.roguewave.com/DesktopModules/Bring2mind/DMX/Download.aspx?entryid=751&command=core_download&PortalId=0&TabId=607)  

### GFortran Types

| Fortran          | C           | CLisp | Size (bytes) |     |
|:-----------------|:------------|:------|:-------------|:----|
| INTEGER\*1       | signed char |       |              |     |
| INTEGER\*2       | short       |       | 2            |     |
| INTEGER          | int         |       | 4            |     |
| REAL             | float       |       | 8            |     |
| DOUBLE PRECISION | double      |       | 8            |     |
| DOUBLE PRECISION | long double |       | 16           |     |
| COMPLEX          | ./.         | ./.   |              |     |
| DOUBLE COMPLEX   | ./.         | ./.   |              |     |

Comparison of GFortran, C and Clisp data types

### Common Pitfalls

For common Fortran pitfalls see
[here](http://www.cs.rpi.edu/~szymansk/OOF90/bugs.html).

#### Buffering output:

 

GCC may be configured where the output buffering defaults for GFortran
and C may be configured the same or differently. C output may be
buffered buffered while GFortran may not. If so, execute a function
initialization task to unbuffer C otherwise print statements for C will
be output out of order and at the end.  

``` c
#include <stdio.h>
void ersetb(void){
          setbuf(stdout,NULL); /* set output to unbuffered */
          }
```

#### Function return types:

  Fortran can define a ` SUBROUTINE`, which does not return a value, and
must be invoked by a ` CALL` statement, and ` FUNCTION`, which returns a
scalar value, and must be invoked by function-like notation in an
expression. Fortran functions can return only scalar values, not arrays.
C and Clisp have only functions, but those *functions* may or may not
return a value. Good programming practice declares non-value-returning
functions to be of type ` void`, and value-returning ones to be of any
non-`void` scalar type. C functions can return only scalar values. For
anything else a pointer is given back.

### Fortran Variants

Heretic is optimised for the latest Fortran dialect
<span class="roman">Fortran 2003</span>. Further restrictions:

- Heretic *<u>d</u>oes not* support Fortran 77.

- <a
  href="#http://gcc.gnu.org/onlinedocs/gcc-3.4.3/g77/Source-Form.html#Source-Form"
  data-reference-type="ref"
  data-reference="http://gcc.gnu.org/onlinedocs/gcc-3.4.3/g77/Source-Form.html#Source-Form">[http://gcc.gnu.org/onlinedocs/gcc-3.4.3/g77/Source-Form.html#Source-Form]</a>*Free-form*
  source code is mandatory!

- The compiler switch ` -fno-underscoring` is not recommended

Exempt you now what you are doing it is not recommended to alter the
default compiler switches [(link)](http://linux.die.net/man/1/GFortran).

#### Fortran Initialization Routines

  Additional initialisation routines like ` f77_init` or ` f90_init` are
not used by GFortran. [Initialisation
routines](http://docs.oracle.com/cd/E19205-01/819-5262/aeulk/index.html)
should be removed form the source code.

#### Classical or New Calling Convention

  GFortran routines can be called from C or Clisp in two ways:

- the *classical* way or

- using the C-binding capabilities of GFortran.

The following sections will show a brief introduction to both methods.
But newer way using C-bindings should be prefered.

### Classical Calling – Without C-Bindings

 

[^1]

#### Case Sensitivity:

  In general it is easy to call functions and procedures written in
GFortran from a C program. First of all, symbol created by GFortran
without C-Bindings are case sensitive. C and also Clisps FFI calls are a
case sensitive, wherease Fortran is not by default. All reference to
Fortran symbols may be specified in lowercase in C calls. GFortran has
various (66!) command line switches to adjust the case senitivity
behavior
[(link)](http://gcc.gnu.org/onlinedocs/gcc-3.4.3/g77/Case-Sensitivity.html)
Instead of using these command line switches it is recommended to use
C-bindings (cp. <a href="#doc-sec-cbind" data-reference-type="ref"
data-reference="doc-sec-cbind">[doc-sec-cbind]</a>).

#### The underscore \_ :

  The GFortran compiler addas an underscore (`_`) by default at the end
of definitions and references to externally visible symbols
(subroutines, functions, etc.). C or Clisp calling GFortran subroutines
or functions without C-Bindings must be specified with an appended
underscore. Underscoring can be suppressed by using the compiler switch
` -fno-underscoring` [(link)](http://linux.die.net/man/1/GFortran). But
as stated in the GFortran manuel this procedure is not recommended
because the linking of external fortran libraries might fail.

#### Examples:

 

### Passing parameters:

  By default In GFortran, all routine arguments, without exception, are
passed *by address* (*by reference*). This means that within a
` FUNCTION` or ` SUBROUTINE`, assignment to an argument variable will
change its value in the calling program.

An important thing to remember is that C passes scalar objects *by
value*, and arrays and structures *by address* of the first (index zero)
element. In both C and Fortran, arguments that are themselves routine
names are passed *by address*.

It is therefore necessary to specify in the C and Clisp function
prototypes that the GFortran subroutines and functions expect
call-by-reference arguments using the address-of (&, :in-out) operator.

> In summary then, a Fortran argument list of the form ` (A,B,C)` must
> always be declared in C in the form
> ` (typename *a, typename *b, typename *c)`, and used in the form
> ` (&a, &b, &c)`.

#### Example:

  To resume the previous points with an example, consider the Fortran
function:

``` objectivec
integer function fortranfuntion( a, b ) 
double precision a, b 
... 
end 
```

It must be called from C as:

``` objectivec
// external Fortran function prototype 
 extern int fortranfuntion_( double&, double& );} 

int main() { 
   double a, b; 
   ... 
   int i = fortranfunction_( a, b ); 
   ... 
   } 
```

#### Example Calling routines and functions:

 

### Arrays:

  C and Clisp stores arrays in row-major order, whereas GFortran stores
arrays in column-major order. The lower bound for C is 0, for Fortran
is 1. This mean that the Fortran array element ` myarray(1,1)`
corresponds to the C-array element ` myarray[0][0]`; whereas
` myarray(6,8)` corresponds to ` myarray[7][5]`.

- The indices in C and GFortran have to be reversed.

- The indices in C have to be decreased with 1.

- Since GFortran transfers parameters by reference, pointers have to be
  used in C.

#### Passing arrays to a GFortran routine:

 

### Fortran Subroutines

[^2] The word *function* has different meanings in C, Clisp and
GFortran. Depending on the situation, the choice is important:

- In C, all subprograms are functions; however, some may return a null
  (void) value.

- In Fortran, a function passes a return value, but a subroutine does
  not.

When a Fortran routine calls a C, Clisp function:

- If the called C function returns a value, call it from GFortran as a
  function.

- If the called C function does not return a value (returns ` void`),
  call it as a subroutine.

When a C, Clisp function calls a GFortran subprogram:

- If the called GFortran subprogram is a *function*, call it from C as a
  function that returns a compatible data type.

- if the called Fortran subprogram is a *subroutine*, call it from C as
  a function that returns ` void` [^3].

As mentioned above C and Clisp do not distinguish between subroutines
and functions. All subprograms are treated as functions. Fortran
subroutines can be seen as functions not returning a value: Fortran code

``` fortran
subroutine fortransubr( i ) 
integer i 
... 
end 
```

C code

``` c
// external Fortran function prototype 
extern void fortransubr_( int& ); 
... 
int main() { 
int i; 
... 
fortransubr_( i ); 
... 
} 
```

### Order of multi dimensional arrays in Fortran

The order of native Fortran arrays is different from Clisp and C/C++.

For example the array ` INTEGER A(2,3)` has a collumn-major order:

    a(1,1)   a(2,1)	
    a(1,2)   a(2,2)	
    a(1,3)   a(2,3)

Or for an 3-dimesional array laike ` INTEGER A(2,2,2)`:

    a(1,1,1)   a(2,1,1)   a(1,2,1)	
    a(2,2,1)   a(2,2,1)   a(1,1,2)	
    a(2,1,2)   a(1,2,2)   a(2,2,2)

Thus the native C/C++ and Clisp layout is a row-major order, which is
*not* equivalent to the Fortran layout. ` int a[2][3]` corresponds to:

    a[0][0]   a[0][1]	
    a[0][2]   a[1][0]	
    a[1][1]   a[1][2]

The FORTRAN 90 command ` RESHAPE` should be avoided. If a reszied array
mus be passed via then it should be declared like *x*\[*n*\]\[\] with an
additional parameter containung the dimension.

#### Calling C, Clisp routines from GFortran:

### GFortran common areas

GFortran common areas can be accessed by C by defining a structure type
and a variable of this type to be defined extern (also in this case an
underscore must be added at the end of C variable related to the Fortran
common area): Fortran code

``` fortran
subroutine mysubr( a ); 
integer a 
integer b(20), c(10) 
common /mycommon/ b, c 
... 
end 
```

C++ code

``` c
typedef struct { int b[20]; int c[10]; } mycommonF77; 
... 
int main() { 
int a; 
extern mycommonF77 mycommon_; 
... 
mycommon_.b[3] = 10; 
... 
} 
```

### Alternate Returns

Alternative returns are not tested.

### Fortran strings

Fortran character parameters are generally passed by descriptor. C char
defines simply a byte; in this language, strings are arrays of bytes
terminating with a null byte (’  
0’). Without using C-bindings ist is not possible to exchange strings
between GFortran and Clisp.

> It is *<u>n</u>ot recommended* to pass GFortran strings to Heretic
> without using C-Bindings.

#### Passing C char string to a GFortran routine:

  Passing characters and strings between Fortran and C is not
straightforward. When GFortran passes a ` CHARACTER` string, it passes
(by value) an extra argument that contains the length of the string. In
addition, C strings are usually null-terminated, while GFortran
character strings are not. To pass a Fortran ` CHARACTER` to a C routine
that accepts a char, the string must be null terminated.

#### Example:

  *<u>N</u>o working example yet!*[^4] All given examples given in
Fortran manuals did not work. If you must interchange strings use the
C-bindings (see section
<a href="#???" data-reference-type="ref" data-reference="???">[???]</a>).

## Fortran Files

Fortran I/O routines require a logical unit number to access a file, C
accesses files using UNIX I/O routines and intrinsics and requires a
stream pointer.

> A Fortran logical unit *<u>c</u>annot* be passed to a C++ routine to
> perform I/O on the associate file, *<u>n</u>or can* a C file pointer
> be used by a Fortran routine.

#### Solution:

  Pass data to a function (pick one language: GFortran or Heretic) which
does the I/O for you. Use this function by both languages.

#### Mixed language file I/O example:

 

### Using GFortran Global Variables

to do

#### Example:

  to do

## c-bindings

<span id="doc-sec-cbind" label="doc-sec-cbind"></span>

| Title | Descrption | Link |
|:---|:---|:---|
| Fortran C bindings | Webpage | [(link)](http://de.wikibooks.org/wiki/Fortran:_Fortran_und_C) |
| Fortran C bindings | Webpage | [(link)](http://de.wikibooks.org/wiki/Fortran:_Fortran_und_C:_Interface) |
| Fortran C bindings | Webpage | [(link)](http://de.wikibooks.org/wiki/Fortran:_Fortran_und_C:_Fortran_90/95) |
| Fortran C bindings | Webpage | [(link)](http://publib.boulder.ibm.com/infocenter/comphelp/v101v121/index.jsp?topic=/com.ibm.xlf121.aix.doc/language_ref/interop-iso-c-binding-module.html) |
| Fortran C bindings | Webpage | [(link)](http://www.fortran.bcs.org/2002/interop.htm) |

Additional Readings

#### Case Sensitivity:

  The case sensitivity of GFortran is not touched when using C-bindings.

But using ` bind( c[, name="c_func"] ` any name which is a valid name in
C can be passed to the linker. If C-bindings are used *<u>no</u>*
further underscores are added by GFortran

#### Example:

### Passing parameters:

 

#### Example Calling routines and functions:

 

## Arrays:

 

#### Passing arrays to a GFortran routine:

 

### Fortran Subroutines

#### Calling C, Clisp routines from GFortran:

### GFortran common areas

### Alternate Returns

### Fortran strings

### Using GFortran Global Variables

#### Example:

 

[^1]: This section is based on the article "Calling Fortran routines
    from a C++ program in Unix" by Benigno Gobbo
    ([Link](http://wwwcompass.cern.ch/compass/software/offline/software/fandc/fandc.html)).

[^2]: Parts taken from
    [here](http://docs.oracle.com/cd/E19205-01/819-5262/aeuku/index.html)

[^3]: On compilers others than GFortran might return an integer

[^4]: Sorry, I found no way to pass a string between GFortran and Clisp
    using the classical way. Working examples are gratefully requested!

# Lead-Rubber Isolator Material

## Description

Lead-rubber (LR) isolator consists of laminated rubber and steel shims alternately with two steel
plates at the ends. Continuum modelling approach of LR bearings is computationally expensive and
impractical for application to large structures. A discrete two node model for LR bearing developed by
[citet:manishkumarmceer2015] is adopted here. The bearing element has six degrees of freedom (3 translations
and 3 rotations) at each node. This discrete two node model is capable to simulate nonlinear behavior of LR
isolator element in both horizontal and vertical directions. The physical model of the two node bearing
element is shown in [fig:physicalmodelofbearing] (reprinted from [citet:manishkumarEESD2014]).

!media media/LR_Isolator/physicalmodel.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:physicalmodelofbearing
       caption=Physical model of LR bearing.(a) Degrees of freedom and (b) discrete spring model.

<br/>
Some of the important physics captured by the numerical model are:

 `Axial Direction`<br/>
  * Buckling in compression<br/>
  * Buckling load variation due to horizontal Displacement<br/>  
  * Cavitation and post-cavitation behavior in tension<br/>

 `Shear Direction`<br/>
  * Viscoelastic behavior of Rubber<br/>
  * Hysteritic behavior of leads<br/>
  * Heating of lead core<br/>

 `Coupled Response`<br/>
  * Horizontal stiffness variation<br/>
  * Vertical stffness variation<br/>

### Axial direction (x_direction)

The composite unit of rubber and steel shims exhibits large axial stiffness. The bearing buckles in
compression when the axial load exceeds critical buckling capacity. The behavior of LR bearing in tension is
characterized by formation of cavities in the rubber material. The post cavitation phase
behavior is governed by a very small axial stiffness. The numerical model also captures the degradation in
cavitation strength under cyclic loading. [fig:axialformulation] shows the typical response of the LR bearing element under axial loading.  

!media media/LR_Isolator/axialformulation.png
       style=width:70%;margin-left:150px;float:center;
       id=fig:axialformulation
       caption=Mathematical model of LR beaing in axial direction.

where;

K<sub>v</sub> = axial stiffness of the bearing<br/>
F<sub>c</sub> =initial cavitation strength of LR bearing<br/>
u<sub>c</sub> = initial cavitation deformation<br/>
F<sub>cn</sub> and u<sub>cn</sub> are current cavitation force and deformation respectively<br/>
phi =  damage parameter<br/>
u<sub>h</sub> = horizontal displacement<br/>
A, E<sub>c</sub>, k, phi<sub>max</sub>, r and T<sub>r</sub> are the material properties of bearing<br/>

### Shear direction (y and z direction)

The LR bearing has a cylindrical lead plug at the central hole that helps in dissipating energy in horizontal
direction. The elasto-plastic behavior of the lead core and visco-elastic behavior of the rubber governs the
horizontal response of the LR isolator element as shown in [fig:shearformulation] (reprinted from [citet:manishkumarmceer2015] ). The nonlinear hysteretic behavior of the lead core is modeled using an evolution parameters z2 and z3 in shear in y and z directions respectively.

!media media/LR_Isolator/shearformulation.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:shearformulation
       caption=Modelling of LR bearing in shear direction.

### Heating of lead core

The characteristic yield strength of lead core is not constant and depends on the lead core temperature which
is a function time. At every analysis step, the temperature of lead core is calculated and the characteristic
yield strength of the lead is adjusted.

### Coupled horizontal and vertical response

When the axial load on the bearing is close to the critical buckling load, the horizontal stiffness is reduced
substantially. This reduction in horizontal stiffness is approximated as shown in equation 1

\begin{equation}
K_H = \frac{GA}{T_r}[1-(\frac{P}{P_cr})^{2}],
\end{equation}

The vertical stiffness is a function of the overlap area of the bonded rubber which further depends horizontal
deformation in the bearing. The relation is expressed in equation 2

\begin{equation}
K_H = \frac{AE_c}{T_r}[1+(\frac{3}{\pi^{2}})(\frac{u_h}{r})^{2}],
\end{equation}


## Usage

The typical material definition for isolator element is created using the following input:

In the ComputeIsolatorDeformation block;

`sd_ratio = '0.5'` specifies that the shear distance ratio is at mid height of bearing

`y_orientation = '0.0 1.0 0.0'` specifies the local y vector of the bearing

In the ComputeLRIsolatorElasticity block:

`alpha = '0.0381'` specifies the ratio of post elastic stiffness to elastic stiffness in horizontal
direction

`G_rubber  = '0.87e6'` specifies the shear modulus of the rubber

`K_rubber = '2e9'` specifies the bulk modulus of the rubber

`D1 = '0.1397'` specifies the inner diameter of the bearing

`D2 = '0.508'` specifies the outer diameter of the bearing

`ts = '0.00476'` specifies thickness of each steel shim

`tr = '0.009525'` specifies thickness of each rubber layer

`n = '16'` specifies number of rubber layers

`tc = '0.0127'` specifies cover thickness

`kc = '20'` specifies cavitation parameter

`phi_m = '0.75'` specifies maximum damage parameter

`ac = '1'` specifies strength degradation parameter

`cd = '128000'` specifies viscous damping parameter

`gamma = '0.5'` specifies gamma parameter in newmark direct integration scheme

`beta = '0.25'` specifies beta parameter in newmark direct integration scheme

`k_steel = '50'` specifies thermal conductivity of steel

`a_steel = '1.41e-5'` specifies thermal diffusivity of steel

`rho_lead = '11200'` specifies density of lead

`c_lead = '130'` specifies specific heat of lead

Also, the material provides options for the user to ignore or consider the following behaviors when
running the analysis. It is a Boolean switch using which the user can specify the phenomenon to
captures.

`cavitation = 'True'` specifies that cavitation and post cavitation behavior be included in analysis.
If it is set to `'False'` the isolator behaves as linear element in tension

`horizontal_stiffness_variation = 'True'` specifies that horizontal stiffness varies with axial load on
the isolator. This switch is essential when the higher axial loads are expected.

`vertical_stiffness_variation = 'True'` specifies that vertical stiffness varies as a function of
horizontal deformation of bearing. It is recommended to use this option in all analysis.

`strength_degradation = 'True'` specifies that characteristic yield strength of bearing is calculated
at every analysis step as a function of lead core temperature

`buckling_load_variation = 'True'` specifies that critical buckling load varies as a function of
horizontal deformation in the bearing. Recommended to use this always.


### Example 1 :

Below is the input file for a sample test case in axial direction. A cyclic displacement profile
is applied at top node of the isolator in axial (x_direction) while the bottom is restrained in
all 6 directions. The rotational degree of freedom of the top node are constrained. In order to
simulate the couple response in horizontal and vertical direction, a ramp displacement is applied
at the top node in shear (y_direction)

!listing test/tests/materials/lr_isolator/lr_isolator_axial_ct.i

The axial response of the lead rubber bearing for cyclic loading in axial direction is shown in [fig:axialresponse]

!media media/LR_Isolator/axialresponse.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:axialresponse
       caption=Axial response of lead rubber bearing under cyclic loading.

### Example 2:

Below is the input file for a sample test case in shear direction. A sinusoidal displacement
profile is applied at top node of the isolator in shear (y_direction) while the bottom is
restrained in all 6 directions. The rotational degree of freedom of the top node are constrained.
In order to simulate the couple response in horizontal and vertical direction, a constant load is
applied on the isolator in axial (x_direction) to simulate the weight of the superstructure.

!listing test/tests/materials/lr_isolator/lr_isolator_shear.i
          start=BCs
          end=Preconditioning

The shear response of the lead rubber bearing for cyclic loading in axial direction is shown in
[fig:shearresponse]

!media media/LR_Isolator/shearresponse.png
      style=width:80%;margin-left:150px;float:center;
      id=fig:shearresponse
      caption=Shear response of lead rubber bearing under cyclic loading.

### Example 3:

The following input file demonstrates the behavior of lead rubber bearing for seismic loading.
The inertial of the superstructure is simulated using nodalkernel of type
`NodalTranslationalInertia`. A mass of 146890 kg is assumed in this example and is defined at top
node. The three components of groundmotion are applied at the bottom node as input acceleration. A smaller
time increment in range of (0.0005-0.0001 sec) is required for accuracy in the results under seismic
loadings. However, it is recommended to reduce the time step further until the result are within the desired
tolerance limit.

!listing test/tests/materials/lr_isolator/lr_isolator_seismic.i
          start=BCs
          end=Preconditioning

### Associated actions

<!-- To be written by CB. LRIsolator action and Common LRIsolator action -->

## Limitations

Currently this formulation is limited to small deformations in the isolator, namely, it is
assumed that there are no rigid body rotations in the isolator, and that the total rotation
matrix from global to local coordinates (calculated below) remains the same as the one at t
= 0 throughout the duration of the simulation.

The post buckling behavior is governed by a very small axial stiffness (1/1000)th of
initial stiffness. This has been done to avoid numerical convergence problems.

The mass of the LR bearing is very small compared to superstructure mass and has been
ignored in the modeling

!syntax parameters

!bibtex bibliography

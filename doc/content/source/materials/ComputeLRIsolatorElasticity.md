# ComputeLRIsolatorElasticity

!syntax description /Materials/ComputeLRIsolatorElasticity

## Description

A lead-rubber (LR) isolator is composed of alternately laminated rubber and steel shims with two steel
plates at the ends, and a cylindrical lead core in the center. Continuum modeling approach of LR bearings
is computationally expensive and impractical for application to large structures with several isolators.
A discrete two node model for LR bearing developed by [citet:manishkumarmceer2015] is adopted here.
For a detailed description of the implementation, please refer to [citet:manishkumarmceer2015]. The bearing
element has six degrees of freedom (3 translations and 3 rotations) at each node. This discrete two node model
is capable of simulating nonlinear behavior of the LR isolator element in both horizontal and vertical directions.
The physical model of the two node bearing element is shown in [fig:physicalmodelofbearing] (reprinted from [citet:manishkumarEESD2014]).

!media media/materials/lr_isolator/physicalmodel.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:physicalmodelofbearing
       caption=Physical model of LR bearing.(a) Degrees of freedom and (b) discrete spring model.

The important behaviors captured by this numerical model are as follows:

##### Axial direction

- Buckling in compression
- Buckling load variation with shear displacement
- Cavitation and post-cavitation behavior in tension

##### Shear direction

- Viscoelastic behavior of rubber
- Hysteretic behavior of lead
- Strength degradation due to the heating of lead core

##### Coupling between axial and shear

- Shear stiffness variation with axial load
- Axial stiffness variation with shear load

### Axial behavior (local X direction)

The composite unit of rubber and steel shims results in a large axial stiffness for the isolator,
and the the isolator buckles in compression when the axial load exceeds critical buckling capacity.
In tension, the rubber layers of the LR isolator undergoes cavitation, which is the formation of
cavities in the rubber material and a resultant drop in the axial stiffness. The post cavitation
behavior in the LR isolator is therefore simulated using a very small axial stiffness. The
numerical model also captures the degradation in cavitation force (tensile force at which,
cavitation begins) under cyclic loading. [fig:axialformulation] [citep:manishkumarEESD2014]
shows the typical response of the LR bearing element under cyclic axial loading.

!media media/materials/lr_isolator/axialformulation.png
       style=width:70%;margin-left:150px;float:center;
       id=fig:axialformulation
       caption=Axial response of the LR isolator.

In this figure,

K<sub>v</sub> is the axial stiffness of the bearing<br/>
F<sub>c</sub> is the initial cavitation strength of LR bearing<br/>
u<sub>c</sub> is the initial cavitation deformation<br/>
F<sub>cn</sub> and u<sub>cn</sub> are the current cavitation force and deformation respectively<br/>
phi is the  damage parameter<br/>
u<sub>h</sub> is the horizontal displacement<br/>
A, E<sub>c</sub>, k, phi<sub>max</sub>, r and T<sub>r</sub> are the input material properties of bearing<br/>

### Shear behavior (local Y and Z directions)

The shear stiffness of the LR bearing is a combination of the viscoelastic behavior of the
rubber layers and the hysteretic behavior of the lead core as shown in [fig:shearformulation]
[citep:manishkumarmceer2015]. The shear behavior of the rubber layers are modeled using the
elastic stiffness of rubber and the shear behavior of the lead core is modeled using
Bouc-Wen hysteresis.

!media media/materials/lr_isolator/shearformulation.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:shearformulation
       caption=Shear behavior of the LR isolator.

### Heating of lead core

This numerical model also simulates the strength degradation in the lead core under
cyclic loading due to heating. The characteristic yield strength of the lead core
therefore depends on the temperature of the lead core, which is a function time.
At each time step in the analysis, the temperature of lead core is calculated and
the characteristic yield strength of the lead is adjusted.

### Coupled horizontal and vertical response

When the axial load on the bearing is close to the critical buckling load, the horizontal stiffness is reduced
substantially. This reduction in horizontal stiffness is approximated as shown in equation 1 below.

\begin{equation}
K_H = \frac{GA}{T_r}[1-(\frac{P}{P_cr})^{2}],
\end{equation}

The vertical stiffness is a function of the overlap area of the bonded rubber which further depends horizontal
deformation in the bearing. The relation is expressed in equation 2 below.

\begin{equation}
K_H = \frac{AE_c}{T_r}[1+(\frac{3}{\pi^{2}})(\frac{u_h}{r})^{2}],
\end{equation}


## Usage

The LR isolator material is meant to be used with two-noded beam or link type elements.
For each subdomain (which may contain multiple link elements), the material properties are
defined by creating the material blocks, `ComputeIsolatorDeformation` and `ComputeLRIsolatorElasticity`,
and the kernel block, `StressDivergenceIsolator`. A sample definition of the kernel and material
blocks is shown in the input file below. A description of each of the input parameters is provided
in the syntax below. A few examples are also described below along with the results of the analysis.

!listing test/tests/materials/lr_isolator/lr_isolator_axial_ct.i start=[Kernels] end=[Postprocessors]


### Example 1

Below is an input file for a test case in axial direction. This input file simulates a
cyclic displacement applied at top node of the isolator in axial (local X direction) while the
bottom is constrained in all 6 directions. Additionally, the rotational degrees of freedom of
the top node are constrained. In order to simulate the coupled response in horizontal and
vertical direction, a ramp displacement is applied at the top node in shear (local Y direction).

!listing test/tests/materials/lr_isolator/lr_isolator_axial_ct.i

The axial response of the lead rubber bearing for cyclic loading in axial direction is shown in [fig:axialresponse]

!media media/materials/lr_isolator/axialresponse.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:axialresponse
       caption=Axial response of lead rubber bearing under cyclic loading.

### Example 2

Below is the input file for a test case in shear direction. A sinusoidal displacement
is applied at top node of the isolator in shear (local Y direction). The isolator element
has the same set of constraints as in Example 1. In order to simulate the coupling between
the shear and axial responses, a constant load is applied on the isolator in axial
(local X direction) to simulate the weight of the superstructure.

!listing test/tests/materials/lr_isolator/lr_isolator_shear.i start=[BCs] end=[Preconditioning]

The shear response of the lead rubber bearing for cyclic loading in axial direction is shown in
[fig:shearresponse]

!media media/materials/lr_isolator/shearresponse.png
      style=width:80%;margin-left:150px;float:center;
      id=fig:shearresponse
      caption=Shear response of lead rubber bearing under cyclic loading.

### Example 3

The following input file simulates the behavior of the LR isolator under seismic loading.
The inertia of the superstructure is modeled using a NodalKernel of type,
`NodalTranslationalInertia`. A superstructure mass of 146890 kg is assumed in this example,
and is defined at top node of the isolator. The three components of ground motion are applied
at the bottom node as input acceleration using the `PresetAcceleration` BC. A small
time step in range of (0.0005-0.0001 sec) is required for seismic analyses, especially for accuracy
in the axial direction. It is recommended to iteratively reduce the time step until the change
in the results is within a desired tolerance.

!listing test/tests/materials/lr_isolator/lr_isolator_seismic.i start=[BCs] end=[Preconditioning]

## Limitations

- Currently, this formulation is limited to small rigid deformations in the isolator. This is because
  the isolator deformations are transformed from the global to local coordinate systems using a
  transformation matrix that is calculated from the initial position of the isolator. However,
  seismic isolators are typically placed between two large concrete slabs (which are essentially
  rigid) and therefore the rigid body rotations in the isolators are usually negligible.
- The post buckling behavior of the isolator is modeled by a very small axial stiffness (1/1000)th of
  initial stiffness, in order to avoid numerical convergence issues.
- The mass of the LR bearing is not modeled in this material model. The user can model the mass of
  the isolators using NodalKernels and following a procedure similar to that shown in modeling the
  superstructure mass in the examples above.

!syntax parameters /Materials/ComputeLRIsolatorElasticity

!syntax inputs /Materials/ComputeLRIsolatorElasticity

!syntax children /Materials/ComputeLRIsolatorElasticity

!bibtex bibliography

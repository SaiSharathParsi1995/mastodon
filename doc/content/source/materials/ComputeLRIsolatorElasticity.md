# ComputeLRIsolatorElasticity

!syntax description /Materials/ComputeLRIsolatorElasticity

## Description

A lead-rubber (LR) isolator is composed of alternate layers of laminated rubber and steel shims with two steel
plates at the ends, and a cylindrical lead core in the center. Beacuse of such complex arrangement, continuum modeling
approach of LR bearings is computationally expensive and impractical for application to large structures with several
isolators. Hence a discrete two node model for LR bearing developed by [citet:manishkumarmceer2015] is adapted here.
For a detailed description on the implementation of numerical model, please refer to [citet:manishkumarmceer2015]. The
discrete isolator model has has six degrees of freedom (3 translations and 3 rotations) at each node and is capable of
simulating nonlinear behavior of the LR bearing in both axial and shear directions. The physical model of the two node
isolatror element is shown in [fig:physicalmodelofbearing] ([citet:manishkumarEESD2014]).

!media media/materials/lr_isolator/physicalmodel.png
       style=width:70%;margin-left:150px;float:center;
       id=fig:physicalmodelofbearing
       caption=Physical model of LR bearing.(a) Degrees of freedom and (b) discrete spring model.

The important behaviors captured by this numerical model are:

!row!
!col! class=s12 m4 l4
#### Axial  class=center style=font-weight:400;

- Buckling in compression
- Buckling load variation
- Cavitation and post-cavitation behavior in tension
!col-end!

!col! class=s12 m4 l4
#### Shear class=center style=font-weight:400;

- Viscoelastic behavior of rubber
- Hysteretic behavior of lead
- Strength degradation due to the heating of lead core
!col-end!

!col! class=s12 m4 l4
#### Coupled axial and shear class=center style=font-weight:400;

- Shear stiffness variation with axial load
- Axial stiffness variation with shear displacement
!col-end!
!row-end!

### Axial (local X direction)

#### Compression style=font-weight:500;

The composite action of rubber and steel shims results in a large axial stiffness of the bearing. The LR bearing buckles
under high axial loads and the expression for critical buckling load in compression is derived from two spring model
proposed by [citet:kohandkelly1987]

\begin{equation}
\begin{aligned}
P_{cr}=\sqrt{P_SP_E} \; \; \; \; \text{where} \\
P_E=\frac{{\pi}^2EI_s}{h}^2 \; \;\;\; \text{and}\;\;\;\; P_S=GA_S
\end{aligned}
\end{equation}

The expressions for $A_s$ and $I_s$ are given as follows

\begin{equation}
A_s=A\frac{h}{T_r} \; \; \; \; and \; \; \; \; I_s=I\frac{h}{T_r}
\end{equation}

Equation (1) provides critical buckling load value at zero horizontal displacement. Experimental investigations have
shown that the critical buckling load is a function of the horizontal deformation in the bearing.
[citet:warnandwhittaker2006] proposed a simplified expression for critical buckling load as a function of overlap bonded
rubber area. This value is updated at every analysis step based on the current horizontal deformation in the bearing.

\begin{equation}
P_{cr} = \begin{cases}
           P_{cro}\frac{A_r}{A}, & \text{if}\ \; \frac{A_r}{A} \ge 0.2 \\
           0.2P_{cro} & \text{if}\ \; \frac{A_r}{A} \le 0.2
           \end{cases}
\end{equation}

$E_r$ is the rotational modulus <br/>
$h$ is the height of isolator exluding end plates <br/>
$T_r$ is the total rubber thickness <br>
$G$ is the shear modulus of the rubber <br/>
$A$ is the initial bonded rubber area<br/>
$P_{cr}$ is the current value of critical buckling load <br/>
$P_{cro}$ is the critical buckling load at zero horizontal displacement<br/>
$A_r$ is the current overlap area of bonded rubber<br/>

Once the bearing buckles, it provides almost zero axial stiffness. Hence to avoid numerical problems, very small value of
axial stiffness is assmued for postbuckling phase.

#### Tension style=font-weight:500;

In tension, the LR bearing undergoes cavitation, which is the formation of cavities in the rubber
material. Cavitation results in inelastic deformation due to onset of permanent damage. The isolator exhibits linear elastic behvaior till point of cavitation ($F_cn$ and $u_cn$). After cavitation, the expression for stiffness of lR bearing is given by [citet:constantinouwhittaker2007]

\begin{equation}
K_{postcavitation}=\frac{EA_o}{T_r}e^{-k(u-u_c)}\;\; = \frac{dF}{du}
\end{equation}

Intergrating the above equation results in an expression for tensile force as shown below
\begin{equation}
F=F_c\left[1+\frac{1}{kT_r}\left(1-e^{-k(u-u_c)}\right)\right]
\end{equation}

$Fc$ is the initial cavitation force
$k$ is the cavitation parameter
$u_c$ is the inital cavitation deformation
$u$ is tensile deformation in bearings
$E$ is the Young's modulus of rubber

When the bearing is loaded, beyond the cavitation force and unloaded, it does not trace back with initial elastic
stiffness. The unloading slope is reduced because of the permanent damage induced in the material. Thus, cavitation
strength of the bearing is reduced after every cycle. To capture this effect, a damage parameter $\phi$ which varies from
(0 to 1) is introduced as given below

\begin{equation}
\phi=\phi_{max}\left[1-e^{-a\left(\frac{u-u_c}{u_c}\right)}\right]
\end{equation}

$a$ is the damage constant <br/>
$\phi is the current value of damage parameter <br/>
$\phi_{max}$ is the upper bound of damage value <br/>

From above equation when $u=u_c$ i.e. at the cavitation point $\phi$ is 0 implying no damage. As the tensile deformation
increases, the damage parameter converges to a maximum values of $\phi_{max}$. Finally, the reduced cavitation strength
as a function of damage parameter $\phi$ is written as

\begin{equation}
F_{cn}=F_c(1-\phi)
\end{equation}

[fig:axialformulation] [citep:manishkumarEESD2014] shows the typical response of the LR isolator element under cyclic
axial loading (both compression and tension)

!media media/materials/lr_isolator/axialformulation.png
       style=width:70%;margin-left:150px;float:center;
       id=fig:axialformulation
       caption=Axial response of the LR isolator.

In this figure,

$K_v$ is the axial stiffness of the bearing<br/>
$F_{cn}$ and $u_{cn}$ are the current force and deformation at which cavitation is initiated respectively<br/>
$u_h$ is the horizontal displacement<br/>
$r$ is the radius of gyration of bearing <br/>

### Shear behavior (local Y and Z directions)

A smooth hysteric model proposed by [citet:park1986] and extended by [citet:nagarajaiah1989] is used to model the
behavior of lead-rubber bearings in shear. The shear resistance of the LR bearing is a combination of the
viscoelastic behavior of the rubber layers and the hysteretic behavior of the lead core as shown in
[fig:shearformulation] [citep:manishkumarmceer2015]. The behavior of rubber is characterized by elastic stiffness and
viscous damping terms and the nonlinear hysteretic contribution of lead core is modelled using a Bouc-Wen formulation as
shown in $Equation\ 8$.

!media media/materials/lr_isolator/shearformulation.png
       style=width:60%;margin-left:150px;float:center;
       id=fig:shearformulation
       caption=Shear behavior of the LR isolator.


\begin{equation}
  \begin{Bmatrix}
           F_y \\
           F_z
  \end{Bmatrix}
= C_d
  \begin{Bmatrix}
           \dot{U_y} \\
           \dot{U_z}
  \end{Bmatrix}
+ k_d
  \begin{Bmatrix}
          U_y \\
          U_z
  \end{Bmatrix}
+ (\sigma _{yl}A_l)
  \begin{Bmatrix}
          Z_y \\
          Z_z
  \end{Bmatrix}
\end{equation}

$C_d$ is the visocus damping co-efficient of rubber</br>
$k_d$ is the stiffness of the rubber material </br>
$\sigma_{yl}$ is the characteristic yield strength of lead core </br>
$A_l$ is the cross sectional area of lead core<br/>

 Bouc-Wen formulation introduces two evolution hysteritic parameters $Z_y$ and $Z_z$ as functions of shear displacements
 $U_y$and $U_z$in in local y and z directions respectively as

\begin{equation}
  u_y
  \begin{Bmatrix}
           \dot{Z_y} \\
           \dot{Z_z}
  \end{Bmatrix}
  =([I]-[\Omega])
  \begin{Bmatrix}
           \dot{U_y} \\
           \dot{U_z}
  \end{Bmatrix}
\end{equation}

where the matrix

\begin{equation}
  \Omega =
  \begin{Bmatrix}
  (Z_y)^2((\gamma Sign(\dot{U_y}Z_y))+\beta) & Z_yZ_z((\gamma Sign(\dot{U_z}Z_z))+\beta) \\
  Z_yZ_z((\gamma Sign(\dot{U_z}Z_y))+\beta) & (Z_z)^2((\gamma Sign(\dot{U_z}Z_z))+\beta)
  \end{Bmatrix}
\end{equation}

The above $Equation\ 9$ is iteratively solved using Newton Raphson method to calculate the values of $Z_y$ and $Z_z$ at
every analysis step.

### Heating of lead core

When the isolator is subjected to cyclic loads in shear, the temperature of the lead core increases due to release of
heat. The effective yield stress of the lead core used in $Equation\ 8$ is not constant, but varies with the temperature
of the lead core which is further a function of time. At each time step in the analysis, the temperature of lead core is
calculated and the characteristic yield strength of the lead is adjusted.The dependency of the charateristic yield
strength of the lead core as a function of instantaneous temperature is given by [citet: kalpakidiandconstantinou2009a]

\begin{equation}
\sigma _{yl}(T_L)=\sigma _{yl0}e^{-0.0069T_L}
\end{equation}

$\sigma _{yl}(T_L)$ is the characteristic yield strength of lead core at current temperature<br/>
$\sigma _{yl0}$ is the effective yield strength of lead core at reference temperature <br/>
$T_L$ is the instantaneous temperature of lead core <br/>

### Coupled horizontal and vertical response

When the axial load on the bearing is close to the critical buckling load, the shear stiffness of the rubber is reduced
substantially. This reduction in shear stiffness as a function of axial load is approximated as shown in equation below
[citet:kelly1993].

\begin{equation}
K_H = \frac{GA}{T_r}\left[1-\left(\frac{P}{P_{cr}}\right)^{2}\right],
\end{equation}

The axial stiffness of the isolator is also a function of the overlap bonded rubber area which further depends
horizontal deformation in the bearing. A simplified expression formulated by [citet:kohandkelly1987] and
[citet:warnwhittaker2007] is adapeted here
\begin{equation}
K_V = \frac{AE_c}{T_r}\left[1+\frac{3}{\pi^{2}}\left(\frac{u_h}{r}\right)^{2}\right],
\end{equation}

## Usage

The LR isolator material is meant to be used with two-noded beam or link type elements.
For each subdomain (which may contain multiple link elements), the material properties are
defined by creating the material blocks, `ComputeIsolatorDeformation` and `ComputeLRIsolatorElasticity`,
and the kernel block, `StressDivergenceIsolator`. A sample definition of the kernel and material
blocks is shown in the input file below.

!listing test/tests/materials/lr_isolator/lr_isolator_axial_ct.i start=[Kernels] end=[Postprocessors]

A description of each of the input parameters is provided in the syntax below. A few examples are also described below to
demonstrate the behavior of the element in axial and shear directions. The analysis results are compared with verified
and validated numerical models implemented in ABAQUS.

### Example 1: Response to axial loading

Below is an input file for a test case in axial direction. This input file simulates a
cyclic displacement applied at top node of the isolator in axial (local X direction) while the
bottom is constrained in all 6 directions. Additionally, the rotational degrees of freedom at
the top node are also onstrained. In order to simulate the coupled response in horizontal and
vertical direction, a ramp displacement is applied at the top node in shear (local Y direction).

!listing test/tests/materials/lr_isolator/lr_isolator_axial_ct.i

The axial response of the lead rubber bearing for cyclic loading in axial direction is shown in [fig:axialresponse]

!media media/materials/lr_isolator/axialresponse.png
       style=width:50%;margin-left:150px;float:center;
       id=fig:axialresponse
       caption=Axial response of lead rubber bearing under cyclic loading.

### Example 2: Response to Shear loading

Below is the input file for a test case in shear direction. A sinusoidal displacement
is applied at top node of the isolator in shear (local Y direction). The isolator element
has the same set of constraints as in Example 1. In order to simulate the coupling between
the shear and axial responses, a constant load is applied on the isolator in axial
(local X direction) to simulate the weight of the superstructure.

!listing test/tests/materials/lr_isolator/lr_isolator_shear.i start=[BCs] end=[Preconditioning]

The response of the lead rubber bearing for cyclic loading in shear direction is shown in
[fig:shearresponse]

!media media/materials/lr_isolator/shearresponse.png
      style=width:70%;margin-left:100px;float:center;
      id=fig:shearresponse
      caption=Shear response of lead rubber bearing under cyclic loading.

### Example 3: Response to seismic loading

The following input file simulates the behavior of the LR isolator under seismic loading. A superstructure
mass of 146890 kg is assumed in this example, and is defined at top node of the isolator using a Nodalkernel
of type, `NodalTranslationInertia`. The three components of ground motion are applied at the bottom node as
input acceleration using the `PresetAcceleration` BC. It is to be noted that a small time step in range of
(0.0005-0.0001 sec) is required for seismic analyses, especially for accuracy in the axial direction. It is
recommended to iteratively reduce the time step until the change in the results is within a desired
tolerance.

!listing test/tests/materials/lr_isolator/lr_isolator_seismic.i start=[BCs] end=[Preconditioning]

The following figures shows the response of LR isolator under seismic loading.

!media media/materials/lr_isolator/SeismicAxial.png
      style=width:50%;margin-left:200px;float:center;
      id=fig:SeismicAxial
      caption=Axial response of lead rubber bearing under seismic loading.

!media media/materials/lr_isolator/SeismicShearY.png
      style=width:50%;margin-left:200px;float:center;
      id=fig:SeismicShearY
      caption=Response of lead rubber bearing in shear (local y) direction under seismic loading.

!media media/materials/lr_isolator/SeismicShearZ.png
      style=width:50%;margin-left:200px;float:center;
      id=fig:SeismicShearZ
      caption=Response of lead rubber bearing in shear (local z) direction under seismic loading.

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

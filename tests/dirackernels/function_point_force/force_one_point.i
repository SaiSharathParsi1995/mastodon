# Test for function point force for force applied at one point.

# This test consists of one quad4 element of size 1x1.
# Node 0 - (0.5,0.5)
# Node 1 - (-0.5, 0.5)
# Node 2 - (-0.5, -0.5)
# Node 3 - (0.5, -0.5)

# A linearly increasing force time history (F) in applied in the y direction at 0.25,0.25.
# This force is applied through dirackernels. DiracKernels distribute this force to the
# four nodes weighted by closeness of the node to the point at which the force is applied.
# The force distributed to node 0 is 0.75*0.75*F, node 1 is 0.25*0.75*F, node 2 is 0.25*0.25*F
# node 4 is 0.75*0.25*F.
#
# To check if forces are distributed as expected, we apply negative of these nodal forces to the
# nodal points using nodalkernels.
# Result: Net force on the element is zero. So element should be in equilibrium with zero displacements.

[Mesh]
  file = test_element.e
[]


[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[Kernels]
  [./DynamicTensorMechanics]
    displacements = 'disp_x disp_y'
  [../]
[]

[DiracKernels]
  [./force_y]
    type = FunctionPointForce
    variable = disp_y
    point = '0.25 0.25'
    function = y_force
  [../]
[]

[NodalKernels]
  [./force_1]
    type = UserForcingFunctionNodalKernel
    variable = disp_y
    boundary = 1 # node 2
    function = force_1
  [../]
  [./force_2]
    type = UserForcingFunctionNodalKernel
    variable = disp_y
    boundary = 2 # node 3
    function = force_2
  [../]
  [./force_3]
    type = UserForcingFunctionNodalKernel
    variable = disp_y
    boundary = 3 # node 0
    function = force_3
  [../]
  [./force_4]
    type = UserForcingFunctionNodalKernel
    variable = disp_y
    boundary = 4 # node 1
    function = force_4
  [../]
[]

[Materials]
  [./Elasticity_tensor_1]
    type = ComputeIsotropicElasticityTensor
    block = 1
    youngs_modulus = 2.e+2
    poissons_ratio = 0.4
  [../]

  [./strain_1]
    type = ComputeSmallStrain
    block = 1
    displacements = 'disp_x disp_y'
  [../]

  [./stress_1]
    type = ComputeLinearElasticStress
    store_stress_old = true
    block = 1
  [../]

  [./density_1]
    type = GenericConstantMaterial
    block = 1
    prop_names = 'density'
    prop_values = '1.'
  [../]

[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  start_time = 0
  end_time = 5.0
  l_tol = 1e-10
  nl_abs_tol = 1e-12
  dt = 1.0
  timestep_tolerance = 1e-12
[]

[Functions]
  [./y_force]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
  [../]
  [./force_1]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
    scale_factor = -0.0625
  [../]
  [./force_2]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
    scale_factor = -0.1875
  [../]
  [./force_3]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
    scale_factor = -0.5625
  [../]
  [./force_4]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
    scale_factor = -0.1875
  [../]
[]

[Postprocessors]
  [./_dt]
    type = TimestepSize
  [../]
  [./disp_1]
    type = NodalVariableValue
    nodeid = 0
    variable = disp_x
  [../]
  [./disp_2]
    type = NodalVariableValue
    nodeid = 0
    variable = disp_y
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = true
  print_perf_log = true
  [./console]
    type = Console
    perf_log = true
    output_linear = true
  [../]
[]

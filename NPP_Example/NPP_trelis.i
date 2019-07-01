# Test for a 3D protal frame installed with a diagonal seismic isolators
# The mesh for the geometry is imported from exodus file "NPP Example.e"
# Beam-column elements are modeled as Euler-Bernouli beam elements

# Dimesnions
# columns
# E = 20e9, G = 100e9, A = 9e-2, Iy = Iz = 6.75e-4

# Beams (rigid)
# E = 20e9, G = 100e9, A = 9e-2, Iy = Iz = 6.75e-1 (I_beam = 1000*I_Column to simulate rigid beam)

[Mesh]
  type = FileMesh
  file = 'NPPexample.e'
[]

[Controls]
  [./C1]
    type = TimePeriod
    disable_objects = '*::x_inertial1 *::y_inertial1 *::z_inertial1 *::vel_x *::vel_y *::vel_z *::accel_x *::accel_y *::accel_z'
    start_time = '0'
    end_time = '0.10'
  [../]
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./vel_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./vel_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./vel_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./accel_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./accel_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./accel_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./reaction_x]
  [../]
  [./reaction_y]
  [../]
  [./reaction_z]
  [../]
  [./reaction_xx]
  [../]
  [./reaction_yy]
  [../]
  [./reaction_zz]
  [../]
[]

[Kernels]
  [./lr_disp_x]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
    save_in = reaction_x
  [../]
  [./lr_disp_y]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
    save_in = reaction_y
  [../]
  [./lr_disp_z]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
    save_in = reaction_z
  [../]
  [./lr_rot_x]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
    save_in = reaction_xx
  [../]
  [./lr_rot_y]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
    save_in = reaction_yy
  [../]
  [./lr_rot_z]
    type = StressDivergenceIsolator
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
    save_in = reaction_zz
  [../]
  [./gravity_y]
    type = Gravity
    variable = disp_y
    value = -9.81
  [../]
[]

[AuxKernels]
  [./accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = timestep_end
  [../]
[]

[NodalKernels]
  [./x_inertial]
    type = NodalTranslationalInertia
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    boundary = '1'
    beta = 0.25
    gamma = 0.5
    mass = 1000000
    alpha = 0
    eta = 0
  [../]
  [./y_inertial]
    type = NodalTranslationalInertia
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    boundary = '1'
    beta = 0.25
    gamma = 0.5
    mass = 1000000
    alpha = 0
    eta = 0
  [../]
  [./z_inertial]
    type = NodalTranslationalInertia
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    boundary = '1'
    beta = 0.25
    gamma = 0.5
    mass = 1000000
    alpha = 0
    eta = 0
  [../]
[]

[Modules/TensorMechanics/LineElementMaster]
  displacements = 'disp_x disp_y disp_z'
  rotations = 'rot_x rot_y rot_z'
  velocities = 'vel_x vel_y vel_z'
  accelerations = 'accel_x accel_y accel_z'
  rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
  rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
  save_in = 'reaction_x reaction_y reaction_z'

  beta = 0.25 # Newmark time integration parameter
  gamma = 0.5 # Newmark time integration parameter

  # parameters for 5% Rayleigh damping
  zeta = 0  # stiffness proportional damping
  eta = 0   # Mass proportional Rayleigh damping

  [./block_1]
    block = 2
    area = 9e-2
    Iy = 6.75e-4
    Iz = 6.75e-4
    y_orientation = '0.0 0.0 1.0'
  [../]
  [./block_2]
    block = 3
    area = 9e-2
    Iy = 6.75e-1
    Iz = 6.75e-1
    y_orientation = '0.0 1.0 0.0'
  [../]
[]

[Materials]
  [./elasticity_beamcolumn]
    type = ComputeElasticityBeam
    youngs_modulus = 20e9
    poissons_ratio = -0.9
    shear_coefficient = 1
    block = '2 3'
  [../]
  [./stress_beam]
    type = ComputeBeamResultants
    block = '2 3'
  [../]
  [./deformation]
    type = ComputeIsolatorDeformation
    block = '0'
    sd_ratio = 0.5
    y_orientation = '0.0 0.0 1.0'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
  [../]
  [./elasticity]
    type = ComputeLRIsolatorElasticity
    block = '0'
    fy = 207155
    alpha = 0.0381
    G_rubber = 0.87e6
    K_rubber = 2e9
    D1 = 0.1397
    D2 = 0.508
    ts = 0.00476
    tr = 0.009525
    n = 16
    tc = 0.0127
    kc = 20
    phi_m = 0.75
    ac = 1
    cd = 0
    gamma = 0.5
    beta = 0.25
    k_steel = 50
    a_steel = 1.41e-5
    rho_lead = 11200
    c_lead = 130
    cavitation = true
    horizontal_stiffness_variation = true
    vertical_stiffness_variation = true
    strength_degradation = true
    buckling_load_variation = true
  [../]
[]

[BCs]
  [./base_accel_x]
    type = PresetAcceleration
    boundary = 3
    function = acceleration_x
    variable = disp_x
    beta = 0.25
    acceleration = 'accel_x'
    velocity = 'vel_x'
  [../]
  [./fix_y]
    type = DirichletBC
    variable = disp_y
    boundary = 3
    value = 0.0
  [../]
  [./fix_z]
    type = DirichletBC
    variable = disp_z
    boundary = 3
    value = 0.0
  [../]
  [./fix_rot_x]
    type = DirichletBC
    variable = rot_x
    boundary = 3
    value = 0.0
  [../]
  [./fix_rot_y]
    type = DirichletBC
    variable = rot_y
    boundary = 3
    value = 0.0
  [../]
  [./fix_rot_z]
    type = DirichletBC
    variable = rot_z
    boundary = 3
    value = 0.0
  [../]
[]

[Functions]
  [./acceleration_x]
    type = PiecewiseLinear
    data_file = accel_x.csv
    format = columns
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = none
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  start_time = 0
  end_time = 50.1
  dt = 0.001
  dtmin = 0.000001
  timestep_tolerance = 1e-6
[]

[Postprocessors]
  [.disp_x_0]
    type = NodalVariableValue
    nodeid = 1
    variable = disp_x
  [../]
  [./disp_x_0.3]
    type = NodalVariableValue
    nodeid = 2
    variable = disp_x
  [../]
  [./disp_x_10.3]
    type = NodalVariableValue
    nodeid = 10
    variable = disp_x
  [../]
  [./accel_x_0]
    type = NodalVariableValue
    nodeid = 1
    variable = accel_x
  [../]
  [./accel_x_0.3]
    type = NodalVariableValue
    nodeid = 2
    variable = accel_x
  [../]
  [./accel_x_10.3]
    type = NodalVariableValue
    nodeid = 10
    variable = accel_x
  [../]
  [./reaction_x]
    type = NodalSum
    variable = reaction_x
    boundary = 4
  [../]
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
  interval = 1
[]

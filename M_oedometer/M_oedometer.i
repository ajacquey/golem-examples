[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
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
[]

[Kernels]
  [./MKernel_x]
    type = GolemKernelM
    variable = disp_x
    component = 0
  [../]
  [./MKernel_y]
    type = GolemKernelM
    variable = disp_y
    component = 1
  [../]
  [./MKernel_z]
    type = GolemKernelM
    variable = disp_z
    component = 2
  [../]
[]

[AuxVariables]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./strain_xx]
    type = GolemStrain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./plastic_strain_xx]
    type = GolemStrain
    strain_type = plastic
    variable = plastic_strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xx]
    type = GolemStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./yield]
    type = MaterialRealAux
    variable = yield
    property = plastic_yield_function
  [../]
[]

[BCs]
  [./no_x_left]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
    preset = true
  [../]
  [./load_x_right]
    type = GolemVelocityBC
    variable = disp_x
    boundary = right
    velocity = -1.0e-05
  [../]
  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom top'
    value = 0.0
    preset = true
  [../]
  [./no_z_back]
    type = DirichletBC
    variable = disp_z
    boundary = 'back front'
    value = 0.0
    preset = true
  [../]
[]

[Materials]
  [./DP]
    type = GolemDruckerPrager
    MC_cohesion = DP_cohesion
    MC_friction = DP_friction
    MC_dilation = DP_dilation
    yield_function_tol = 1.0e-08
  [../]
  [./MMaterial]
    type = GolemMaterialMInelastic
    block = 0
    strain_model = incr_small_strain
    bulk_modulus = 2.0e+03
    shear_modulus = 2.0e+03
    inelastic_models = 'DP'
    porosity_uo = porosity
    fluid_density_uo = fluid_density
  [../]
[]

[UserObjects]
  [./porosity]
    type = GolemPorosityConstant
  [../]
  [./fluid_density]
    type = GolemFluidDensityConstant
  [../]
  [./DP_cohesion]
    type = GolemHardeningConstant
    value = 1.0
  [../]
  [./DP_friction]
    type = GolemHardeningConstant
    value = 10.0
    convert_to_radians = true
  [../]
  [./DP_dilation]
    type = GolemHardeningConstant
    value = 10.0
    convert_to_radians = true
  [../]
[]

[Postprocessors]
  [./u_x]
    type = SideAverageValue
    variable = disp_x
    boundary = right
    outputs = csv
  [../]
  [./S_xx]
    type = ElementAverageValue
    variable = stress_xx
    outputs = csv
  [../]
  [./E_xx]
    type = ElementAverageValue
    variable = strain_xx
    outputs = csv
  [../]
  [./Ep_xx]
    type = ElementAverageValue
    variable = plastic_strain_xx
    outputs = csv
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  end_time = 200.0
  dt = 4.0
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
  csv = true
[]

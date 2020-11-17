[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 10000
  xmin = 0
  xmax = 100
[]

[GlobalParams]
  pore_pressure = pore_pressure
  temperature = temperature
  has_lumped_mass_matrix = true
[]

[Variables]
  [./pore_pressure]
   order = FIRST
   family = LAGRANGE
   initial_condition = 1e5
  [../]
  [./temperature]
   order = FIRST
   family = LAGRANGE
   initial_condition = 0.0
  [../]
[]

[Kernels]
  [./HKernel]
    type = GolemKernelH
    variable = pore_pressure
  [../]
  [./temp_time]
    type = GolemKernelTimeT
    variable = temperature
  [../]
  [./TKernel]
    type = GolemKernelT
    variable = temperature
  [../]
  [./THKernel]
    type = GolemKernelTH
    variable = temperature
  [../]
[]

[AuxVariables]
  [./vf_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vf_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vf_z]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./vf_x]
    type = GolemFluidVelocity
    variable = vf_x
    component = 0
  [../]
  [./vf_y]
    type = GolemFluidVelocity
    variable = vf_y
    component = 1
  [../]
  [./vf_z]
    type = GolemFluidVelocity
    variable = vf_z
    component = 2
  [../]
[]

[BCs]
  [./p0_left]
    type = DirichletBC
    variable = pore_pressure
    boundary = left
    value = 1.03e5
    preset = true
  [../]
  [./p_right]
    type = DirichletBC
    variable = pore_pressure
    boundary = right
    value = 1e5
    preset = true
  [../]
  [./T_left]
    type = DirichletBC
    variable = temperature
    boundary = left
    value = 1
    preset = true
  [../]
[]

[Materials]
  [./THMaterial]
    type = GolemMaterialTH
    block = 0
    porosity_initial = 1.0
    permeability_initial = 1.0e-11
    fluid_viscosity_initial = 1.0e-03
    fluid_density_initial = 1000
    solid_density_initial = 2000
    fluid_thermal_conductivity_initial = 0.6
    solid_thermal_conductivity_initial = 3
    fluid_heat_capacity_initial = 4000
    solid_heat_capacity_initial = 250
    fluid_density_uo = FLUID_DENSITY
    fluid_viscosity_uo = FLUID_VISCOSITY
    porosity_uo = POROSITY
    permeability_uo = PERMEABILITY
    supg_uo = SUPG
  [../]
[]

[UserObjects]
  [./FLUID_DENSITY]
    type = GolemFluidDensityConstant
  [../]
  [./FLUID_VISCOSITY]
    type = GolemFluidViscosityConstant
  [../]
  [./POROSITY]
    type = GolemPorosityConstant
  [../]
  [./PERMEABILITY]
    type = GolemPermeabilityConstant
  [../]
  [./SUPG]
    type = GolemSUPG
	  effective_length = min
	  method = full
  [../]
[]

[Preconditioning]
  [./fieldsplit]
    type = FSP
    topsplit = pT
    [./pT]
      splitting = 'p T'
      splitting_type = multiplicative
      petsc_options_iname = '-ksp_type
                             -ksp_rtol -ksp_max_it
                             -snes_type -snes_linesearch_type
                             -snes_atol -snes_stol -snes_rtol -snes_max_it'
      petsc_options_value = 'fgmres
                             1.0e-10 50
                             newtonls basic
                             1.0e-09 0 1.0e-10 50'
    [../]
    [./p]
     vars = 'pore_pressure'
     petsc_options_iname = '-ksp_type
                            -pc_type -sub_pc_type -sub_pc_factor_levels
                            -ksp_rtol -ksp_max_it'
     petsc_options_value = 'fgmres
                            asm ilu 1
                            1e-04 500'
    [../]
    [./T]
     vars = 'temperature'
     petsc_options_iname = '-ksp_type
                            -pc_type -pc_hypre_type
                            -ksp_rtol -ksp_max_it'
     petsc_options_value = 'preonly
                            hypre boomeramg
                            1e-04 500'
    [../]
  [../]
[]

[Postprocessors]
  [./Point_25]
    type = PointValue
    outputs = 'csv'
    point = '25 0 0'
    variable = temperature
  [../]
  [./Point_50]
    type = PointValue
    outputs = 'csv'
    point = '50 0 0'
    variable = temperature
  [../]
  [./Point_75]
    type = PointValue
    outputs = 'csv'
    point = '75 0 0'
    variable = temperature
  [../]
  [./Point_100]
    type = PointValue
    outputs = 'csv'
    point = '100 0 0'
    variable = temperature
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  dt = 4e5
  num_steps = 1300
[]

[Outputs]
  interval = 10
  print_linear_residuals = true
  perf_graph = true
  exodus = true
  [./csv]
    type = CSV
  [../]
[]

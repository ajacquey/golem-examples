[Mesh]
  [./file_mesh]
    type = FileMeshGenerator
    file = THM_doublet_mesh.e
  [../]
  [./frac_inj]
    type = ExtraNodesetGenerator
    input = file_mesh
    coord = '-100 0 -1000'
    new_boundary = frac_inj
  [../]
  boundary_id = '1 2 3 4 5 6'
  boundary_name = 'top bottom back front left right'
  block_id = '0 1 2'
  block_name = 'rock frac_left frac_right'
[]

# [MeshModifiers]
#   [./frac_inj]
#     type = AddExtraNodeset
#     coord = '-100 0 -1000'
#     new_boundary = frac_inj
#   [../]
# []

[GlobalParams]
  # Coupling
  has_lumped_mass_matrix = true
  displacements = 'disp_x disp_y disp_z'
  pore_pressure = pore_pressure
  temperature = temperature
  # Properties
  fluid_density_initial = 1.0e+03
  solid_density_initial = 2.6e+03
  fluid_heat_capacity_initial = 4200
  solid_heat_capacity_initial = 950
  fluid_thermal_conductivity_initial = 0.65
  solid_thermal_conductivity_initial = 3.0
  solid_thermal_expansion = 3.0e-05
  fluid_thermal_expansion = 9.1e-05
  scaling_uo = scaling
  supg_uo = supg
  porosity_uo = porosity
  fluid_density_uo = fluid_density
  fluid_viscosity_uo = fluid_viscosity
  permeability_uo = permeability
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
  [./pore_pressure]
    order = FIRST
    family = LAGRANGE
    initial_condition = 40.0
  [../]
  [./temperature]
    order = FIRST
    family = LAGRANGE
    initial_condition = 150
  [../]
[]

[Kernels]
  [./KernelTTime]
    type = GolemKernelTimeT
    variable = temperature
  [../]
  [./KernelT]
    type = GolemKernelT
    variable = temperature
  [../]
  [./KernelTH]
    type = GolemKernelTH
    variable = temperature
  [../]
  [./KernelHTime]
    type = GolemKernelTimeH
    variable = pore_pressure
  [../]
  [./KernelHPoro_rock]
    type = GolemKernelHPoroElastic
    variable = pore_pressure
    block = rock
  [../]
  [./KernelH]
    type = GolemKernelH
    variable = pore_pressure
  [../]
  [./KernelM_x_rock]
    type = GolemKernelM
    variable = disp_x
    component = 0
    block = rock
  [../]
  [./KernelM_y_rock]
    type = GolemKernelM
    variable = disp_y
    component = 1
    block = rock
  [../]
  [./KernelM_z_rock]
    type = GolemKernelM
    variable = disp_z
    component = 2
    block = rock
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
  [./strain_zz]
    order = CONSTANT
    family = MONOMIAL
    block = rock
  [../]
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
  [./porosity]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fluid_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./fluid_viscosity]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./permeability]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = GolemStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_yy]
    type = GolemStress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_zz]
    type = GolemStress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./strain_xx]
    type = GolemStrain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_yy]
    type = GolemStrain
    variable = strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./strain_zz]
    type = GolemStrain
    variable = strain_zz
    index_i = 2
    index_j = 2
  [../]
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
  [./porosity]
    type = MaterialRealAux
    variable = porosity
    property = porosity
  [../]
  [./fluid_density]
    type = MaterialRealAux
    variable = fluid_density
    property = fluid_density
  [../]
  [./fluid_viscosity]
    type = MaterialRealAux
    variable = fluid_viscosity
    property = fluid_viscosity
  [../]
  [./permeability]
    type = MaterialStdVectorAux
    variable = permeability
    property = permeability
    index = 0
  [../]
[]

[DiracKernels]
  [./HInjection]
    type = GolemDiracKernelTH
    variable = pore_pressure
    source_point = '-100 0 -1000'
    source_type = injection
    in_out_rate = 5.0 # 5 L/s
    start_time = 0.0
    end_time = 720
  [../]
  [./HProduction]
    type = GolemDiracKernelTH
    variable = pore_pressure
    source_point = '100 0 -1000'
    source_type = extraction
    in_out_rate = 5.0 # 5 L/s
    start_time = 0.0
    end_time = 720
  [../]
[]

[Functions]
  [./Se_xx]
    type = ConstantFunction
    value = -25.87301587 # 50 MPa
  [../]
  [./Se_yy]
    type = ConstantFunction
    value = -65.873015870 # 90 MPa
  [../]
  [./Se_zz]
    type = ConstantFunction
    value = -75.873015870 # 100 MPa
  [../]
  [./time_step_fct]
    type = PiecewiseConstant
    x = '0 10 30 50 100'
    y = '1 2  5  10 20'
  [../]
[]

[BCs]
  [./T_sides]
    type = DirichletBC
    variable = temperature
    boundary = 'left front right back bottom top'
    value = 150
    preset = false
  [../]
  [./pf_sides]
    type = DirichletBC
    variable = pore_pressure
    boundary = 'left front right back bottom top'
    value = 40.0
    preset = false
  [../]
  [./Tinj]
    type = DirichletBC
    variable = temperature
    boundary = frac_inj
    value = 70
    preset = true
  [../]
  [./no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right'
    value = 0.0
    preset = true
  [../]
  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'front back'
    value = 0.0
    preset = true
  [../]
  [./no_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom top'
    value = 0.0
    preset = true
  [../]
[]

[Materials]
  [./rock_HM]
    type = GolemMaterialMElastic
    block = rock
    strain_model = incr_small_strain
    young_modulus = 50.0e+09
    poisson_ratio = 0.2
    background_stress = 'Se_xx Se_yy Se_zz'
    solid_bulk_modulus = 70.0e+09
    permeability_initial = 1.0e-15
    fluid_viscosity_initial = 1.0e-03
    fluid_modulus = 1.00e+08
    porosity_initial = 0.1
  [../]
  [./frac_H]
    type = GolemMaterialTH
    block = 'frac_left frac_right'
    material_type = frac
    scaling_factor_initial = 1.0e-02
    permeability_initial = 8.333e-10
    fluid_viscosity_initial = 1.0e-03
    fluid_modulus = 2.5e+09
    porosity_initial = 1.0
  [../]
[]

[UserObjects]
  [./scaling]
    type = GolemScaling
    characteristic_time = 2.592e+06 # approx. 1 month
    characteristic_length = 1.0
    characteristic_temperature = 1.0
    characteristic_stress = 1.0e+06 # 1 MPa
  [../]
  [./supg]
    type = GolemSUPG
  [../]
  [./porosity]
    type = GolemPorosityTHM
  [../]
  [./fluid_density]
    type = GolemFluidDensityConstant
  [../]
  [./fluid_viscosity]
    type = GolemFluidViscosityConstant
  [../]
  [./permeability]
    type = GolemPermeabilityKC
  [../]
[]

[Postprocessors]
  [./pf0]
    type = PointValue
    variable = pore_pressure
    point = '-100 0 -1000'
    outputs = csv_p0
  [../]
  [./T0]
    type = PointValue
    variable = temperature
    point = '-100 0 -1000'
    outputs = csv_p0
  [../]
  [./pf1]
    type = PointValue
    variable = pore_pressure
    point = '100 0 -1000'
    outputs = csv_p1
  [../]
  [./T1]
    type = PointValue
    variable = temperature
    point = '100 0 -1000'
    outputs = csv_p1
  [../]
[]

[VectorPostprocessors]
  [./line_sample]
    type = LineValueSampler
    variable = 'pore_pressure temperature porosity stress_xx strain_xx disp_x'
    start_point = '-100 0 -1000'
    end_point = '100 0 -1000'
    num_points = 100
    sort_by = x
    outputs = csv
  [../]
[]

[Preconditioning]
  [./fieldsplit]
    type = FSP
    full = true
    topsplit = 'pTe'
    [./pTe]
      splitting = 'p T e'
      splitting_type = multiplicative
      petsc_options = '-snes_ksp_ew
                       -snes_monitor
                       -snes_linesearch_monitor
                       -snes_converged_reason'
      petsc_options_iname = '-ksp_type
                             -ksp_rtol -ksp_max_it
                             -snes_type -snes_linesearch_type
                             -snes_atol -snes-stol -snes_rtol -snes_max_it'
      petsc_options_value = 'fgmres
                             1.0e-12 50
                             newtonls basic
                             1.0e-05 0 1.0e-12 25'
    [../]
    [./p]
      vars = 'pore_pressure'
      # petsc_options = '-ksp_converged_reason'
      petsc_options_iname = '-ksp_type
                             -pc_type -pc_hypre_type
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             hypre boomeramg
                             1e-04 500'
    [../]
    [./T]
      vars = 'temperature'
      # petsc_options = '-ksp_converged_reason'
      petsc_options_iname = '-ksp_type
                             -pc_type
                             -sub_pc_type -sub_pc_factor_levels
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             asm
                             ilu 1
                             1e-04 500'
    [../]
    [./e]
      vars = 'disp_x disp_y disp_z'
      # petsc_options = '-ksp_converged_reason'
      petsc_options_iname = '-ksp_type
                             -pc_type
                             -sub_pc_type -sub_pc_factor_levels
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             asm
                             ilu 1
                             1e-04 500'
    [../]
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  # compute_scaling_once = false
  start_time = 0
  end_time = 720
  dt = 2
  [./TimeStepper]
    type = FunctionDT
    function = 'time_step_fct'
  [../]
[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  [./exodus]
    type = Exodus
    # Sync times 1 - 5 - 10 - 15 - 20 - 25 - 30 - 40 - 50 - 60 years
    sync_times = '1 12 60 120 180 240 300 360 480 600 720'
    sync_only = true
  [../]
  [./csv_p0]
    type = CSV
    file_base = doublet_THM_p0
    # Sync times 1 - 5 - 10 - 15 - 20 - 25 - 30 - 40 - 50 - 60 years
    # sync_times = '1 12 60 120 180 240 300 360 480 600 720'
    # sync_only = true
  [../]
  [./csv_p1]
    type = CSV
    file_base = doublet_THM_p1
    # Sync times 1 - 5 - 10 - 15 - 20 - 25 - 30 - 40 - 50 - 60 years
    # sync_times = '1 12 60 120 180 240 300 360 480 600 720'
    # sync_only = true
  [../]
  [./csv]
    type = CSV
    file_base = doublet_THM_line
    time_data = true
    # Sync times 1 - 5 - 10 - 15 - 20 - 25 - 30 - 40 - 50 - 60 years
    sync_times = '1 12 60 120 180 240 300 360 480 600 720'
    sync_only = true
  [../]
[]

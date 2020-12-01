[Mesh]
  [./input_mesh]
    type = FileMeshGenerator
    file = TH_multi_frac_mesh.e
  [../]
  [./source_in]
    type = ExtraNodesetGenerator
    input = input_mesh
    new_boundary = 'source_in'
    coord = '5527.09521484 5000 -4640'
  [../]
  boundary_id = '1 2 3 4 5 6'
  boundary_name = 'top bottom left front right back'
[]

[Variables]
  [./pore_pressure]
    [./InitialCondition]
      type = FunctionIC
      function = pressure_fc
    [../]
  [../]
  [./temperature]
    [./InitialCondition]
      type = FunctionIC
      function = temperature_fc
    [../]
  [../]
[]

[Functions]
  [./pressure_fc]
    type = ParsedFunction
    value = rho*g*z+p
    vars = 'rho g p'
    vals = '1148e-06 -9.8065 0.0'
  [../]
  [./temperature_fc]
    type = ParsedFunction
    value = grad*z+temp
    vars = 'grad temp'
    vals = '-0.028 0.0'
  [../]
[]

[GlobalParams]
  pore_pressure = pore_pressure
  temperature = temperature
  has_gravity = true
  gravity_acceleration = 9.8065
  fluid_density_initial = 1148
  fluid_thermal_conductivity_initial = 0.65
  fluid_heat_capacity_initial = 4193.5
  fluid_viscosity_initial = 3.0e-4
  solid_density_initial = 2650.0
  fluid_density_uo = fluid_density
  fluid_viscosity_uo = fluid_viscosity
  porosity_uo = porosity
  permeability_uo = permeability
  scaling_uo = scaling
[]

[BCs]
  [./p_top]
    type = FunctionDirichletBC
    variable = pore_pressure
    boundary = 'top'
    function = pressure_fc
  [../]
  [./T_top]
    type = DirichletBC
    variable = temperature
    boundary = 'top'
    value = 137.5
  [../]
  [./T_bottom]
    type = GolemHeatFlowBC
    variable = temperature
    boundary = 'bottom'
    value = 0.072
  [../]
[]

[Kernels]
  [./darcy]
    type = GolemKernelH
    variable = pore_pressure
    block = '0 1 2 3 4 5 6 7 8 9 10 11 12 13 14'
  [../]
  [./T_dif]
    type = GolemKernelT
    variable = temperature
  [../]
[]

[Materials]
  [./unit_1]
    type = GolemMaterialTH
    block = 0
    porosity_initial = 0.01
    permeability_type = 'orthotropic'
    permeability_initial = '1e-20 1e-20 0.25e-20'
    fluid_modulus = 0.1e+09
    solid_thermal_conductivity_initial = 4.0
    solid_heat_capacity_initial = 920
  [../]
  [./unit_2]
    type = GolemMaterialTH
    block = 1
    porosity_initial = 0.15
    permeability_type = 'orthotropic'
    permeability_initial = '1.28e-15 1.28e-15 3.2e-16'
    fluid_modulus = 1.5e+09
    solid_thermal_conductivity_initial = 3.18
    solid_heat_capacity_initial = 920
  [../]
  [./unit_3]
    type = GolemMaterialTH
    block = 2
    porosity_initial = 0.005
    permeability_type = 'orthotropic'
    permeability_initial = '9.87e-17 9.87e-17 2.4675e-17'
    fluid_modulus = 0.05e+09
    solid_thermal_conductivity_initial = 2.31
    solid_heat_capacity_initial = 1380
  [../]
  [./unit_4]
    type = GolemMaterialTH
    block = 3
    porosity_initial = 0.01
    permeability_type = 'orthotropic'
    permeability_initial = '1e-20 1e-20 0.25e-20'
    fluid_modulus = 0.1e+09
    solid_thermal_conductivity_initial = 2.31
    solid_heat_capacity_initial = 1380
  [../]
  [./fault]
    type = GolemMaterialTH
    block = 4
    material_type = 'frac'
    scaling_factor_initial = 1.0e-2
    porosity_initial = 1.0
    permeability_type = 'isotropic'
    permeability_initial = 1.00e-15
    fluid_modulus = 2.5e+09
    solid_thermal_conductivity_initial = 0.65
    solid_heat_capacity_initial = 920
  [../]
  [./fracs]
    type = GolemMaterialTH
    block = '5 6 7 8 9 10 11 12 13 14'
    material_type = 'frac'
    scaling_factor_initial = 2.28e-4
    porosity_initial = 1.0
    permeability_type = 'isotropic'
    permeability_initial = 4.33e-09
    fluid_modulus = 2.5e+09
    solid_thermal_conductivity_initial = 0.65
    solid_heat_capacity_initial = 920
  [../]
  [./wells]
    type = GolemMaterialTH
    block = '15 16'
    material_type = 'well'
    scaling_factor_initial = 0.05
    porosity_initial = 1.0
    permeability_type = 'isotropic'
    permeability_initial = 3.125e-4
    fluid_modulus = 2.5e+09
    solid_thermal_conductivity_initial = 0.65
    solid_heat_capacity_initial = 920
  [../]
[]

[UserObjects]
  [./scaling]
    type = GolemScaling
    characteristic_time = 1.0 # 2.59e+06 # approx. 1 month
    characteristic_length = 1.0
    characteristic_temperature = 1.0
    characteristic_stress = 1.0e+06
  [../]
  [./fluid_density]
    type = GolemFluidDensityConstant
    execute_on = 'INITIAL'
  [../]
  [./fluid_viscosity]
    type = GolemFluidViscosityConstant
    execute_on = 'INITIAL'
  [../]
  [./porosity]
    type = GolemPorosityConstant
    execute_on = 'INITIAL'
  [../]
  [./permeability]
    type = GolemPermeabilityConstant
    execute_on = 'INITIAL'
  [../]
[]

[Preconditioning]
  [./FSP]
    type = FSP
    topsplit = 'HT'
     [./HT]
       splitting = 'H T'
       splitting_type = multiplicative
       petsc_options = '-snes_linesearch_monitor -snes_converged_reason'
       petsc_options_iname = '-ksp_type
                              -ksp_rtol -ksp_max_it
                              -snes_type -snes_linesearch_type
                              -snes_atol -snes_stol -snes_max_it'
       petsc_options_value = 'fgmres
                              1.0e-12 100
                              newtonls cp
                              1 0 1000'
     [../]
     [./H]
       vars = 'pore_pressure'
       petsc_options = '-ksp_converged_reason'
       petsc_options_iname = '-ksp_type
                              -pc_type -pc_hypre_type
                              -ksp_rtol -ksp_max_it'
       petsc_options_value = 'fgmres
                              hypre boomeramg
                              1.0e-04 500'
     [../]
     [./T]
       vars = 'temperature'
       petsc_options = '-ksp_converged_reason'
       petsc_options_iname = '-ksp_type
                              -pc_type -sub_pc_type -sub_pc_factor_levels
                              -ksp_rtol -ksp_max_it'
       petsc_options_value = 'fgmres
                              asm ilu 1
                              1.0e-04 500'
     [../]
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  automatic_scaling = true
[]

[Outputs]
  print_linear_residuals = true
  perf_graph = true
  exodus = false
[]

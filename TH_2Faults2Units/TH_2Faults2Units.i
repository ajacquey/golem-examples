# Ideally, run this input file with 4 MPI processes
# mpiexec -n 4 golem-opt -i TH_2Fault2Units.i

[Mesh]
  type = FileMesh
  file = 'mesh/mesh.e'
  boundary_id = '1 2 3 4'
  boundary_name = 'front right back left'
[]

[Variables]
  [pore_pressure]
    order = FIRST
    family = LAGRANGE
  []
  [temperature]
    order = FIRST
    family = LAGRANGE
    initial_condition = 60
  []
[]

[AuxVariables]
  [vx]
    order = CONSTANT
    family = MONOMIAL
  []
  [vy]
    order = CONSTANT
    family = MONOMIAL
  []
  [vz]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[ICs]
  [pore_pressure_ic]
    type = FunctionIC
    variable = pore_pressure
    function = pressure_ic_func
  []
[]

[GlobalParams]
  pore_pressure = pore_pressure
  temperature = temperature
  has_gravity = true
  has_lumped_mass_matrix = true
  gravity_acceleration = 9.8065
  fluid_density_initial = 1.0e+03
  solid_density_initial = 2.6e+03
  fluid_thermal_conductivity_initial = 0.65
  solid_thermal_conductivity_initial = 3.0
  fluid_heat_capacity_initial = 4.18e+03
  solid_heat_capacity_initial = 1.0e+03
  fluid_viscosity_initial = 5.0e-04
  fluid_density_uo = FLUID_DENSITY
  fluid_viscosity_uo = FLUID_VISCOSITY
  porosity_uo = POROSITY
  permeability_uo = PERMEABILITY
  supg_uo = SUPG
  scaling_uo = SCALING
[]

[Functions]
  [pressure_ic_func]
    type = ParsedFunction
    value = rho*g*z+p
    vars = 'rho g p'
    vals = '1.0e-03 -9.8065 1.5'
  []
  [pressure_front]
    type = ParsedFunction
    value = rho*g*z+p
    vars = 'rho g p'
    vals = '1.0e-03 -9.8065 1.75'
  []
  [pressure_back]
    type = ParsedFunction
    value = rho*g*z+p
    vars = 'rho g p'
    vals = '1.0e-03 -9.8065 1.25'
  []
  [temp_front]
    type = ParsedFunction
    value = a*x+b
    vars = 'a b'
    vals = '0.2 60'
  []
[]

[BCs]
  [p_front]
    type = FunctionDirichletBC
    variable = pore_pressure
    boundary = front
    function = pressure_front
  []
  [p_back]
    type = FunctionDirichletBC
    variable = pore_pressure
    boundary = back
    function = pressure_back
  []
  [T_front]
    type = FunctionDirichletBC
    variable = temperature
    boundary = front
    function = temp_front
  []
  # [T_back]
  #   type = EnergyBC
  #   variable = temperature
  #   boundary = back
  #   darcy_velocity = vy
  #   component = 1
  # []
[]

[Kernels]
  [p_time]
    type = GolemKernelTimeH
    variable = pore_pressure
  []
  [darcy]
    type = GolemKernelH
    variable = pore_pressure
  []
  [T_time]
    type = GolemKernelTimeT
    variable = temperature
  []
  [T_dif]
    type = GolemKernelT
    variable = temperature
  []
  [T_adv]
    type = GolemKernelTH
    variable = temperature
	  is_conservative = false
  []
[]

[AuxKernels]
  [vel_kernel_x]
    type = GolemDarcyVelocity
    variable = vx
    component = 0
    execute_on = 'TIMESTEP_END'
  []
  [vel_kernel_y]
    type = GolemDarcyVelocity
    variable = vy
    component = 1
    execute_on = 'TIMESTEP_END'
  []
  [vel_kernel_z]
    type = GolemDarcyVelocity
    variable = vz
    component = 2
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [unit_top]
    type = GolemMaterialTH
    block = 0
    porosity_initial = 0.15
    permeability_initial = 2.0e-14
    fluid_modulus = 214.2857143e+06
  []
  [unit_bot]
    type = GolemMaterialTH
    block = 1
    porosity_initial = 0.08
    permeability_initial = 1.0e-14
	  fluid_modulus = 114.2857143e+06
  []
  [fault1]
    type = GolemMaterialTH
    block = 2
    material_type = 'frac'
	  porosity_initial = 1.0
    permeability_initial = 1.0e-08
  	fluid_modulus = 2173.913043e+06
	  scaling_factor_initial = 0.05
  []
  [fault2]
    type = GolemMaterialTH
    block = 3
    material_type = 'frac'
	  porosity_initial = 1.0
    permeability_initial = 5.0e-09
	  fluid_modulus = 2173.913043e+06
	  scaling_factor_initial = 0.05
  []
[]

[UserObjects]
  [SCALING]
    type = GolemScaling
    characteristic_stress = 1.0e+06 #MPa
    characteristic_length = 1.0
    characteristic_time = 1.0
    characteristic_temperature = 1.0
  []
  [FLUID_DENSITY]
    type = GolemFluidDensityConstant
  []
  [FLUID_VISCOSITY]
    type = GolemFluidViscosityConstant
  []
  [POROSITY]
    type = GolemPorosityConstant
  []
  [PERMEABILITY]
    type = GolemPermeabilityConstant
  []
  [SUPG]
    type = GolemSUPG
	  effective_length = min
	  method = full
  []
[]

[Postprocessors]
  [T_OP1]
    type = PointValue
    outputs = 'csv'
    point = '-79.173 -85.4135 5.37564'
    variable = temperature
  []
  [P_OP1]
    type = PointValue
    outputs = 'csv'
    point = '-79.173 -85.4135 5.37564'
    variable = pore_pressure
  []
  [vx_OP1]
    type = PointValue
    outputs = 'csv'
    point = '-79.173 -85.4135 5.37564'
    variable = vx
  []
  [vy_OP1]
    type = PointValue
    outputs = 'csv'
    point = '-79.173 -85.4135 5.37564'
    variable = vy
  []
  [vz_OP1]
    type = PointValue
    outputs = 'csv'
    point = '-79.173 -85.4135 5.37564'
    variable = vz
  []
  [T_OP2]
    type = PointValue
    outputs = 'csv'
    point = '63.5931 -66.4069 -3.65799'
    variable = temperature
  []
  [P_OP2]
    type = PointValue
    outputs = 'csv'
    point = '63.5931 -66.4069 -3.65799'
    variable = pore_pressure
  []
  [vx_OP2]
    type = PointValue
    outputs = 'csv'
    point = '63.5931 -66.4069 -3.65799'
    variable = vx
  []
  [vy_OP2]
    type = PointValue
    outputs = 'csv'
    point = '63.5931 -66.4069 -3.65799'
    variable = vy
  []
  [vz_OP2]
    type = PointValue
    outputs = 'csv'
    point = '63.5931 -66.4069 -3.65799'
    variable = vz
  []
  [T_OP3]
    type = PointValue
    outputs = 'csv'
    point = '-0.00263716 -0.00150695 -0.00538734'
    variable = temperature
  []
  [P_OP3]
    type = PointValue
    outputs = 'csv'
    point = '-0.00263716 -0.00150695 -0.00538734'
    variable = pore_pressure
  []
  [vx_OP3]
    type = PointValue
    outputs = 'csv'
    point = '-0.00263716 -0.00150695 -0.00538734'
    variable = vx
  []
  [vy_OP3]
    type = PointValue
    outputs = 'csv'
    point = '-0.00263716 -0.00150695 -0.00538734'
    variable = vy
  []
  [vz_OP3]
    type = PointValue
    outputs = 'csv'
    point = '-0.00263716 -0.00150695 -0.00538734'
    variable = vz
  []
[]

[Preconditioning]
  active = 'FSP'
  [fieldsplit]
    type = FSP
    topsplit = 'tp'
    [tp]
      petsc_options_iname = '-pc_fieldsplit_schur_fact_type -pc_fieldsplit_schur_precondition -snes_rtol -snes_atol -snes_max_it'
      petsc_options_value = 'full selfp 1.0e-10 1.0e-08 20'
      splitting = 'temp pf'
      splitting_type = multiplicative
    []
    [temp]
      # PETSc options for this subsolver
      # A prefix will be applied, so just put the options for this subsolver only
      vars = temperature
      # petsc_options = '-ksp_converged_reason'
      petsc_options_iname = '-ksp_type 
 						                 -pc_type -sub_pc_type -sub_pc_factor_shift_type'
      petsc_options_value = 'gmres
 						                 asm ilu NONZERO'
    []
    [pf]
      # PETSc options for this subsolver
      vars = pore_pressure
      # petsc_options = '-ksp_converged_reason'
      petsc_options_iname = '-ksp_type 
                    				 -pc_type -pc_hypre_type'
      petsc_options_value = 'preonly
 						                 hypre boomeramg'
    []
  []
  [FSP]
    type = FSP
    topsplit = 'pT'
     [pT]
       splitting = 'p T'
       splitting_type = multiplicative
       petsc_options = '-snes_ksp_ew
                        -snes_monitor -snes_linesearch_monitor -snes_converged_reason
                        -ksp_converged_reason -ksp_monitor_short'
       petsc_options_iname = '-ksp_type
                              -ksp_rtol -ksp_max_it
                              -snes_type -snes_linesearch_type
                              -snes_atol -snes_stol -snes_max_it'
       petsc_options_value = 'fgmres
                              1.0e-12 100
                              newtonls cp
                              1.0e-08 0 1000'
     []
     [p]
       vars = 'pore_pressure'
       petsc_options = '-ksp_converged_reason'
       petsc_options_iname = '-ksp_type
                              -pc_type -pc_hypre_type
                              -ksp_rtol -ksp_max_it'
       petsc_options_value = 'preonly
                              hypre boomeramg
                              1.0e-04 500'
     []
     [T]
       vars = 'temperature'
       petsc_options = '-ksp_converged_reason'
       petsc_options_iname = '-ksp_type
                              -pc_type -sub_pc_type -sub_pc_factor_levels
                              -ksp_rtol -ksp_max_it'
       petsc_options_value = 'fgmres
                              asm ilu 1
                              1.0e-04 500'
     []
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  start_time = 0.0
  end_time = 4858629050
  [TimeStepper]
    type = TimeSequenceStepper
	  time_sequence = '0.864 1.220432832 1.723907232 2.435083776 3.439647936
                     4.858629696 6.862997376 9.694238976 13.69347898 19.3425529
                     27.32208538 38.59348378 54.51475738 77.00415898 108.7711926
                     153.6433782 217.027023 306.5587638 433.025727 611.6651574
                     863.9999862 1220.432386 1723.906613 2435.082812 3439.645935
                     4858.628991 6862.995893 9694.239394 13693.47715 19342.55064
                     27322.07897 38593.46234 54514.71451 77004.08103 108771.1556
                     153643.341 217026.9876 306558.7682 433025.7698 611665.1577
                     864000 1220432.439 1723906.64 2435082.853 3439645.954
                     4858629.05 6862995.948 9694239.445 13693477.18 19342550.64
                     27322078.98 38593462.36 54514714.56 77004081.06 108771155.6
                     153643341 217026987.7 306558768.3 433025769.9 611665157.8
                     864000000.1 1220432439 1723906640 2435082853 3439645954
                     4858629050'
  []
[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  execute_on = 'TIMESTEP_END'
  [out]
    type = Exodus
  []
  [csv]
    type = CSV
  []
[]

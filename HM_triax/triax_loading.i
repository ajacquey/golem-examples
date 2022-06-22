# This is an example of a triaxial loading simulation
# Initial conditions represent the confinement
# Loading is performed at a constant axial strain rate
# Fluid pressure under draiend conditions

[Mesh]
  type = FileMesh
  file = triax.msh
[]

[Variables]
  [disp_x]
    order = FIRST
    family = LAGRANGE
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
  []
  [disp_z]
    order = FIRST
    family = LAGRANGE
  []
  [pf]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.2
  []
[]

[Kernels]
  [mech_x]
    type = GolemKernelM
    variable = disp_x
    displacements = 'disp_x disp_y disp_z'
    pore_pressure = pf
    component = 0
  []
  [mech_y]
    type = GolemKernelM
    variable = disp_y
    displacements = 'disp_x disp_y disp_z'
    pore_pressure = pf
    component = 1
  []
  [mech_z]
    type = GolemKernelM
    variable = disp_z
    displacements = 'disp_x disp_y disp_z'
    pore_pressure = pf
    component = 2
  []
  [pf_time]
    type = GolemKernelTimeH
    variable = pf
    displacements = 'disp_x disp_y disp_z'
  []
  [pf_darcy]
    type = GolemKernelH
    variable = pf
    displacements = 'disp_x disp_y disp_z'
  []
[]

[BCs]
  [GolemPressure]
    [pressure_conf]
      boundary = 'outer top'
      displacements = 'disp_x disp_y disp_z'
      function = 1 # confining pressure (positive in compression)
    []
  []
  [no_disp_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'no_disp_x'
    value = 0.0
    preset = true
  []
  [no_disp_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'no_disp_y'
    value = 0.0
    preset = true
  []
  [no_disp_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
    preset = true
  []
  [axial_loading]
     type = FunctionDirichletBC
     variable = disp_z
     boundary = 'top'
     function = '-1e-05*t'
     preset = true
  []
  [drained_bc]
    type = DirichletBC
    variable = pf
    boundary = 'bottom top'
    value = 0.2
  []
[]

[Materials]
  [HMMaterial]
    type = GolemMaterialMElastic
    block = 0
    displacements = 'disp_x disp_y disp_z'
    pore_pressure = pf
    background_stress = '-0.8 -0.8 -0.8' # effective stress here! (negative in compression)
    strain_model = incr_small_strain
    bulk_modulus = 10
    shear_modulus = 10
    permeability_initial = 1.5
    fluid_viscosity_initial = 1.0
    porosity_initial = 0.1
    fluid_modulus = 8
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    permeability_uo = permeability
  []
[]

[UserObjects]
  [porosity]
    type = GolemPorosityConstant
  []
  [fluid_density]
    type = GolemFluidDensityConstant
  []
  [fluid_viscosity]
    type = GolemFluidViscosityConstant
  []
  [permeability]
    type = GolemPermeabilityConstant
  []
[]

[Preconditioning]
  active = 'hypre'
  [hypre]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_converged_reason'
    petsc_options_iname = '-pc_type -pc_hypre_type
                           -pc_hypre_boomeramg_strong_threshold -pc_hypre_boomeramg_agg_nl -pc_hypre_boomeramg_agg_num_paths -pc_hypre_boomeramg_max_levels
                           -pc_hypre_boomeramg_coarsen_type -pc_hypre_boomeramg_interp_type
                           -pc_hypre_boomeramg_P_max -pc_hypre_boomeramg_truncfactor -snes_atol'
    petsc_options_value = 'hypre boomeramg
                           0.7 4 5 25
                           HMIS ext+i
                           2 0.3 1.0e-06'
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  # automatic_scaling = true
  start_time = 0
  end_time = 10
  num_steps = 10
[]

[Outputs]
  execute_on = 'INITIAL TIMESTEP_END'
  print_linear_residuals = false
  perf_graph = true
  [out]
    type = Exodus
  []
[]
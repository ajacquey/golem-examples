[Mesh]
  type = FileMesh
  file = H_fracture_mesh.e
  boundary_id = '1 2 3 4 5 6'
  boundary_name = 'back bottom front left right top'
[]

[Variables]
  [./pore_pressure]
  [../]
[]

[AuxVariables]
  [./vx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[GlobalParams]
  pore_pressure = pore_pressure
  has_gravity = false
  gravity_acceleration = 9.8065
  fluid_density_initial = 1000
  solid_density_initial = 2600
[]

[BCs]
  [./pressure_left]
    type = DirichletBC
    variable = pore_pressure
    boundary = left
    value = 496465 #1.0e+06
    preset = false
  [../]
  [./pressure_right]
    type = DirichletBC
    variable = pore_pressure
    boundary = right
    value = -496465 #0
    preset = false
  [../]
[]

[Kernels]
  [./poro_darcy]
    type = GolemKernelH
    variable = pore_pressure
  [../]
[]

[AuxKernels]
  [./vx_kernel]
    type = GolemDarcyVelocity
    variable = vx
    component = 0
    execute_on = timestep_end
  [../]
  [./vy_kernel]
    type = GolemDarcyVelocity
    variable = vy
    component = 1
    execute_on = timestep_end
  [../]
  [./vz_kernel]
    type = GolemDarcyVelocity
    variable = vz
    component = 2
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./medium]
    type = GolemMaterialH
    block = 0
    material_type = unit
    porosity_initial = 0.15
    permeability_initial = 1.0e-12
    fluid_viscosity_initial = 1.0e-03
    fluid_density_uo = FLUID_DENSITY
    fluid_viscosity_uo = FLUID_VISCOSITY
    porosity_uo = POROSITY
    permeability_uo = PERMEABILITY
  [../]
  [./frac]
    type = GolemMaterialH
    block = 1
    material_type = frac
    scaling_factor_initial = 0.05
    porosity_initial = 1.0
    permeability_initial = 1.0e-10
    fluid_viscosity_initial = 1.0e-03
    fluid_density_uo = FLUID_DENSITY
    fluid_viscosity_uo = FLUID_VISCOSITY
    porosity_uo = POROSITY
    permeability_uo = PERMEABILITY
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
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_rel_tol -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1e-12 1e-12 1000 1e-12 500 lu NONZERO'
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
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

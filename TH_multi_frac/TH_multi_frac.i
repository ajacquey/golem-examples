[Mesh]
  [./input_mesh]
    type = FileMeshGenerator
    file = 'TH_multi_frac_mesh.e'
  [../]
  [./source_in]
    type = ExtraNodesetGenerator
    input = input_mesh
    new_boundary = 'source_in'
    coord = '5527.09521484 5000 -4640'
  [../]
  [./rename_boundary]
    type = RenameBoundaryGenerator
    input = source_in
    old_boundary_id = '1 2 3 4 5 6'
    new_boundary_name = 'top bottom left front right back'
  [../]
[]

[Variables]
  [./pore_pressure]
    # initial_from_file_var = pore_pressure
    # initial_from_file_timestep = 2
  [../]
  [./temperature]
    # initial_from_file_var = temperature
    # initial_from_file_timestep = 2
  [../]
[]

[AuxVariables]
  [./darcy_vx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./darcy_vy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./darcy_vz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./pressure_border]
    type = ParsedFunction
    value = rho*g*z+p
    vars = 'rho g p'
    vals = '1148e-06 -9.8065 0.0'
  [../]
  [./time_step]
    type = ParsedFunction
    value = 'if(t<=0.01,0.001,if(t>0.01&t<=0.1,0.01,if(t>0.1&t<=1,0.1,if(t<1&t<=10,1,if(t>10&t<=500,50,100)))))'
  [../]
[]


[GlobalParams]
  pore_pressure = pore_pressure
  temperature = temperature
  has_gravity = true
  has_lumped_mass_matrix = true
  gravity_acceleration = 9.8065
  fluid_density_initial = 1148
  fluid_thermal_conductivity_initial = 0.65
  fluid_heat_capacity_initial = 4193.5
  fluid_viscosity_initial = 3.0e-4
  solid_density_initial = 2650.0
  porosity_uo = porosity
  permeability_uo = permeability
  scaling_uo = scaling
  supg_uo = supg
[]

[BCs]
  [./T_top]
    type = DirichletBC
    variable = temperature
    boundary = 'top'
    value = 137.5
    preset = false
  [../]
  [./T_bottom]
    type = GolemHeatFlowBC
    variable = temperature
    boundary = 'bottom'
    value = 0.072
  [../]
  [./p_sides]
    type = GolemVelocityBC
    variable = pore_pressure
    boundary = 'front back left right'
    velocity = 0.0
  [../]
  [./T_in]
    type = DirichletBC
    variable = temperature
    boundary = 'source_in'
    value = 55
    preset = false
  [../]
[]

[Kernels]
  [./p_time_unit]
    type = GolemKernelTimeH
    variable = pore_pressure
    has_density_coupling = true
    block = '0 1 2 3 4'
  [../]
  [./darcy_unit]
    type = GolemKernelH
    variable = pore_pressure
    has_boussinesq = true
    block = '0 1 2 3 4'
  [../]
  [./p_time_frac]
    type = GolemKernelTimeH
    variable = pore_pressure
    block = '5 6 7 8 9 10 11 12 13 14 15 16'
  [../]
  [./darcy_frac]
    type = GolemKernelH
    variable = pore_pressure
    block = '5 6 7 8 9 10 11 12 13 14 15 16'
  [../]
  [./T_time_unit]
    type = GolemKernelTimeT
    variable = temperature
    has_boussinesq = true
    block = '0 1 2 3 4'
  [../]
  [./T_time_frac]
    type = GolemKernelTimeT
    variable = temperature
    # has_boussinesq = true
    block = '5 6 7 8 9 10 11 12 13 14 15 16'
  [../]
  [./T_dif]
    type = GolemKernelT
    variable = temperature
  [../]
  [./T_adv]
    type = GolemKernelTH
    variable = temperature
  [../]
[]

[DiracKernels]
  [./mass_in]
    type = GolemDiracKernelTH
    variable = pore_pressure
    source_point = '5527.09521484 5000 -4640'
    source_type = injection
    in_out_rate = 30 # in L/s
    start_time = 0.0
    end_time = 1200
    # end_time = 3.11040e+09
  [../]
  [./mass_out]
    type = GolemDiracKernelTH
    variable = pore_pressure
    source_point = '6410.96826172 5000 -4640'
    source_type = extraction
    in_out_rate = 30  # in L/s
    start_time = 0.0
    end_time = 1200
    # end_time = 3.11040e+09
  [../]
[]

[AuxKernels]
  [./darcy_vx_kernel]
    type = GolemDarcyVelocity
    variable = darcy_vx
    component = 0
    execute_on = timestep_end
  [../]
  [./darcy_vy_kernel]
    type = GolemDarcyVelocity
    variable = darcy_vy
    component = 1
    execute_on = timestep_end
  [../]
  [./darcy_vz_kernel]
    type = GolemDarcyVelocity
    variable = darcy_vz
    component = 2
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./unit_1]
    type = GolemMaterialTH
    block = 0
    has_boussinesq = true
    porosity_initial = 0.01
    permeability_type = 'orthotropic'
    permeability_initial = '1e-20 1e-20 0.25e-20'
    fluid_modulus = 0.1e+09
    solid_thermal_conductivity_initial = 4.0
    solid_heat_capacity_initial = 920
    fluid_density_uo = fluid_density_IAPWS
    fluid_viscosity_uo = fluid_viscosity_IAPWS
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
  [../]
  [./unit_2]
    type = GolemMaterialTH
    block = 1
    has_boussinesq = true
    porosity_initial = 0.15
    permeability_type = 'orthotropic'
    permeability_initial = '1.28e-15 1.28e-15 3.2e-16'
    fluid_modulus = 1.5e+09
    solid_thermal_conductivity_initial = 3.18
    solid_heat_capacity_initial = 920
    fluid_density_uo = fluid_density_IAPWS
    fluid_viscosity_uo = fluid_viscosity_IAPWS
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
  [../]
  [./unit_3]
    type = GolemMaterialTH
    block = 2
    has_boussinesq = true
    porosity_initial = 0.005
    permeability_type = 'orthotropic'
    permeability_initial = '9.87e-17 9.87e-17 2.4675e-17'
    fluid_modulus = 0.05e+09
    solid_thermal_conductivity_initial = 2.31
    solid_heat_capacity_initial = 1380
    fluid_density_uo = fluid_density_IAPWS
    fluid_viscosity_uo = fluid_viscosity_IAPWS
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
  [../]
  [./unit_4]
    type = GolemMaterialTH
    block = 3
    has_boussinesq = true
    porosity_initial = 0.01
    permeability_type = 'orthotropic'
    permeability_initial = '1e-20 1e-20 0.25e-20'
    fluid_modulus = 0.1e+09
    solid_thermal_conductivity_initial = 2.31
    solid_heat_capacity_initial = 1380
    fluid_density_uo = fluid_density_IAPWS
    fluid_viscosity_uo = fluid_viscosity_IAPWS
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
  [../]
  [./fault]
    type = GolemMaterialTH
    block = 4
    has_boussinesq = true
    material_type = 'frac'
    scaling_factor_initial = 1.0e-2
    porosity_initial = 1.0
    permeability_type = 'isotropic'
    permeability_initial = 1.00e-15
    fluid_modulus = 2.5e+09
    solid_thermal_conductivity_initial = 0.65
    solid_heat_capacity_initial = 920
    fluid_density_uo = fluid_density_IAPWS
    fluid_viscosity_uo = fluid_viscosity_IAPWS
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
    fluid_density_uo = fluid_density_constant
    fluid_viscosity_uo = fluid_viscosity_constant
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
    fluid_density_uo = fluid_density_constant
    fluid_viscosity_uo = fluid_viscosity_constant
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
  [../]
[]

[UserObjects]
  [./scaling]
    type = GolemScaling
    characteristic_time = 2.592e+06 # approx. 1 month
    # characteristic_time = 1.0
    characteristic_length = 1.0
    characteristic_temperature = 1.0
    characteristic_stress = 1.0e6
    execute_on = 'INITIAL'
  [../]
  [./supg]
    type = GolemSUPG
	  effective_length = 'min'
	  method = 'temporal'
    execute_on = 'INITIAL'
  [../]
  [./fluid_density_IAPWS]
	  type = GolemFluidDensityIAPWS
    execute_on = 'TIMESTEP_BEGIN NONLINEAR TIMESTEP_END'
  [../]
  [./fluid_density_constant]
    type = GolemFluidDensityConstant
    execute_on = 'INITIAL'
  [../]
  [./fluid_viscosity_IAPWS]
	  type = GolemFluidViscosityIAPWS
    execute_on = 'TIMESTEP_BEGIN NONLINEAR TIMESTEP_END'
  [../]
  [./fluid_viscosity_constant]
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

[Postprocessors]
  [./T_in]
    type = PointValue
    outputs = 'csv'
    point = '5527.09521484 5000 -4640'
    variable = temperature
  [../]
  [./P_in]
    type = PointValue
    outputs = 'csv'
    point = '5527.09521484 5000 -4640'
    variable = pore_pressure
  [../]
  [./T_out]
    type = PointValue
    outputs = 'csv'
    point = '6410.96826172 5000 -4640'
    variable = temperature
  [../]
  [./p_out]
    type = PointValue
    outputs = 'csv'
    point = '6410.96826172 5000 -4640'
    variable = pore_pressure
  [../]
[]

[Preconditioning]
  active = 'FSP'
  [./hypre]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_hypre_type -snes_atol -snes_rtol -snes_stol -snes_max_it'
    petsc_options_value = 'hypre boomeramg 1.0e-00 1.0e-10 0 50'
  [../]
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
                               newtonls basic
                               1.0e-06 0 50'
      [../]
      [./H]
        vars = 'pore_pressure'
        # petsc_options = '-ksp_converged_reason'
        petsc_options_iname = '-ksp_type
                               -pc_type -pc_hypre_type
                               -ksp_rtol -ksp_max_it'
        petsc_options_value = 'fgmres
                               hypre boomeramg
                               1.0e-04 100'
      [../]
      [./T]
        vars = 'temperature'
        # petsc_options = '-ksp_converged_reason'
        petsc_options_iname = '-ksp_type
                               -pc_type -sub_pc_type -sub_pc_factor_levels
                               -ksp_rtol -ksp_max_it'
        petsc_options_value = 'fgmres
                               asm ilu 1
                               1.0e-04 100'
    [../]
  [../]
  [./asm]
    type = SMP
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -ksp_rtol -ksp_max_it
                           -pc_type
                           -sub_pc_type
                           -snes_type -snes_atol -snes_rtol -snes_max_it
                           -ksp_gmres_restart'
    petsc_options_value = 'fgmres 1e-10 100
                           asm
                           ilu
                           newtonls 1e-00 1e-08 50
                           201'
  [../]
  [./andy]
    type = SMP
    full = true
    petsc_options = '-snes_monitor -snes_linesearch_monitor -snes_converged_reason'
    petsc_options_iname = '-ksp_type -ksp_rtol -ksp_max_it
                           -pc_type
                           -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs 1.0e-06 100
                           bjacobi
                           1e-00 1e-10 50'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  end_time = 1200
  # end_time = 3.11040e+09
  [./TimeStepper]
    type = FunctionDT
    function = time_step
    min_dt = 0.001
  [../]
  # [./TimeStepper]
  #   type = TimeSequenceStepper
  #   time_sequence = '4.0e-07	4.46358404182682e-07	4.98089562461277e-07
  #   5.55816155600666e-07	6.20233030582167e-07	6.92115564380112e-07
  #   7.72328997066758e-07	8.61838846586825e-07	9.61722530562847e-07
  #   1.07318233502141e-06	1.19755988614300e-06	1.33635229922996e-06
  #   1.49123019927536e-06	1.66405783004394e-06	1.85691549371527e-06
  #   2.07212459119212e-06	2.31227556448051e-06	2.58025907748034e-06
  #   2.87930081050501e-06	3.21300028734730e-06	3.58537420224710e-06
  #   4.00090476828193e-06	4.46459366914302e-06	4.98202226370697e-06
  #   5.55941876807709e-06	6.20373322375536e-06	6.92272115432633e-06
  #   7.72503691761699e-06	8.62033787699957e-06	9.61940064573266e-06
  #   1.07342508035577e-05	1.19783076469318e-05	1.33665457152342e-05
  #   1.49156750372170e-05	1.66443422672992e-05	1.85733551327551e-05
  #   2.07259328934370e-05	2.31279858287797e-05	2.58084271162345e-05
  #   2.87995208551688e-05	3.21372704253476e-05	3.58618518546136e-05
  #   4.00180974121528e-05	4.46560352482891e-05	4.98314915763799e-05
  #   5.56067626451893e-05	6.20513645901797e-05	6.92428701895760e-05
  #   7.72678425971195e-05	8.62228772907224e-05	9.62157647788152e-05
  #   0.000107366788059721	0.000119810170451393	0.000133695691218847
  #   0.000149190488446364	0.000166481070855384	0.000185775562784084
  #   0.000207306209351108	0.000231332171957805	0.000258142647777999
  #   0.000288060350784200	0.000321445396210848	0.000358699635211360
  #   0.000400271491884633	0.000446661360893615	0.000498427630646348
  #   0.000556193404539649	0.000620654001168127	0.000692585323777505
  #   0.000772853199704183	0.000862423802218599	0.000962375280218637
  #   0.00107391073575813	0.00119837270561912	0.00133725932124059
  #   0.00149224234151842	0.00166518727553498	0.00185817583743275
  #   0.00207353100371826	0.00231384497460749	0.00258201037597980
  #   0.00288125507751368	0.00321518104610564	0.00358780770224530
  #   0.00400362030122137	0.00446762392151640	0.00498540371024111
  #   0.00556319211077411	0.00620794388181705	0.00692741981085876
  #   0.00773028012969604	0.00862618875644057	0.00962592961875852
  #   0.0107415364585097	0.0119864376802262	0.0133756179869523	0.0149257987490331
  #   0.0166556392769257	0.0185859614207274	0.0207400001998920	0.0231436834799308
  #   0.0258259440625275	0.0288190679456525	0.0321590829456344	0.0358861923589797
  #   0.0400452588838674	0.0446863446262135	0.0498653136902851	0.0556445046071614
  #   0.0620934806949712	0.0692898673828889	0.0773202865776399	0.0862813993193576
  #   0.0962810692770931	0.107439661088814	0.119891489173828	0.133786434456788
  #   0.149291748463557	0.166594066504590	0.185901654178231	0.207446914234790
  #   0.231489183976157	0.258317856862872	0.288255865903005	0.321663570751907
  #   0.358943095311312	0.400543168038874	0.446964523230269	0.498765928288341
  #   0.556570909528695	0.621075257479332	0.693055402014558	0.773377758133513
  #   0.863009154877139	0.963028472915012	1.07463963088208	1.19918607677998
  #   1.33816695887401	1.49325517073249	1.66631748761423	1.85943703658296
  #   2.07493837081837	2.31541544993975	2.58376286313759	2.88321067094143
  #   3.21736328500974	3.59024285393226	4.00633767727370	4.47065623061211
  #   4.98878745186346	5.56696801455092	6.21215739777748	6.93212165650898
  #   7.73552690049892	8.63204360704725	9.63246302319236	10.7488270584521
  #   11.9945732316158	13.3846964162909	14.9359293321131	16.6669439541684
  #   18.5985762649620	20.7540770542458	23.1593917855440	25.8434728980924
  #   28.8386283033273	32.1809102707268	35.9105493839693	40.0724387908799
  #   44.7166745760133	49.8991587602641	55.6822721857244	62.1356253852144
  #   69.3368964745933	77.3727661534481	86.3399610686326	96.3464180994742
  #   107.512583578997	119.972863089696	133.877239284860	149.393077208934
  #   166.707138847300	186.027831154354	207.587714619058	231.646302563231
  #   258.493184867357	288.451513723731	321.881893374510	359.186720654866
  #   400.815028587792	447.267891332209	499.104455542994	556.948670741595
  #   621.496799709710	693.525799307677	773.902672596236	863.594904831920
  #   963.682108952680	1075.36902072880	1200'
  # [../]
[]

[MultiApps]
  [./ic]
    type = FullSolveMultiApp
    input_files = 'TH_multi_frac_IC.i'
    execute_on = 'INITIAL'
  [../]
[]

[Transfers]
  [./pore_pressure]
    type = MultiAppInterpolationTransfer
    variable = pore_pressure
    source_variable = pore_pressure
    direction = from_multiapp
    multi_app = ic
  [../]
  [./temperature]
    type = MultiAppInterpolationTransfer
    variable = temperature
    source_variable = temperature
    direction = from_multiapp
    multi_app = ic
  [../]
[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
  [./csv]
    type = CSV
  [../]
[]

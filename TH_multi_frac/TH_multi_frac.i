[Mesh]
  type = FileMesh
  file = TH_multi_frac_IC_out.e
[]

[Variables]
  [./pore_pressure]
    initial_from_file_var = pore_pressure
    initial_from_file_timestep = 2
  [../]
  [./temperature]
    initial_from_file_var = temperature
    initial_from_file_timestep = 2
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
  fluid_density_uo = fluid_density
  fluid_viscosity_uo = fluid_viscosity
  scaling_uo = scaling
  supg_uo = supg
[]

[BCs]
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
  [../]
[]

[Kernels]
  [./p_time]
    type = GolemKernelTimeH
    variable = pore_pressure
  [../]
  [./darcy]
    type = GolemKernelH
    variable = pore_pressure
  [../]
  [./T_time]
    type = GolemKernelTimeT
    variable = temperature
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
    porosity_initial = 0.01
    permeability_type = 'orthotropic'
    permeability_initial = '1e-20 1e-20 0.25e-20'
    fluid_modulus = 0.1e+09
    solid_thermal_conductivity_initial = 4.0
    solid_heat_capacity_initial = 920
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
    output_properties = 'fluid_density fluid_viscosity'
    outputs = out
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
  [../]
  [./supg]
    type = GolemSUPG
	  effective_length = 'min'
	  method = 'temporal'
  [../]
  [./fluid_density]
    type = GolemFluidDensityConstant
	  # type = GolemFluidDensityIAPWS
  [../]
  [./fluid_density_constant]
	  type = GolemFluidDensityConstant
  [../]
  [./fluid_viscosity]
    type = GolemFluidViscosityConstant
	  # type = GolemFluidViscosityIAPWS
    #Tc = 137.5
    #Tv = 62.1
  [../]
  [./fluid_viscosity_constant]
	  type = GolemFluidViscosityConstant
  [../]
  [./porosity]
    type = GolemPorosityConstant
  [../]
  [./permeability]
    type = GolemPermeabilityConstant
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
        petsc_options = '-snes_monitor -snes_linesearch_monitor -snes_converged_reason'
        petsc_options_iname = '-ksp_type
                               -ksp_rtol -ksp_max_it
                               -snes_type -snes_linesearch_type
                               -snes_atol -snes_stol -snes_max_it'
        petsc_options_value = 'fgmres
                               1.0e-12 100
                               newtonls basic
                               1.0e-10 0 50'
      [../]
      [./H]
        vars = 'pore_pressure'
        # petsc_options = '-ksp_converged_reason'
        petsc_options_iname = '-ksp_type
                               -pc_type -pc_hypre_type
                               -ksp_rtol -ksp_max_it'
        petsc_options_value = 'preonly
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
    type = TimeSequenceStepper
    time_sequence = '4.0e-07	4.46358404182682e-07	4.98089562461277e-07
    5.55816155600666e-07	6.20233030582167e-07	6.92115564380112e-07
    7.72328997066758e-07	8.61838846586825e-07	9.61722530562847e-07
    1.07318233502141e-06	1.19755988614300e-06	1.33635229922996e-06
    1.49123019927536e-06	1.66405783004394e-06	1.85691549371527e-06
    2.07212459119212e-06	2.31227556448051e-06	2.58025907748034e-06
    2.87930081050501e-06	3.21300028734730e-06	3.58537420224710e-06
    4.00090476828193e-06	4.46459366914302e-06	4.98202226370697e-06
    5.55941876807709e-06	6.20373322375536e-06	6.92272115432633e-06
    7.72503691761699e-06	8.62033787699957e-06	9.61940064573266e-06
    1.07342508035577e-05	1.19783076469318e-05	1.33665457152342e-05
    1.49156750372170e-05	1.66443422672992e-05	1.85733551327551e-05
    2.07259328934370e-05	2.31279858287797e-05	2.58084271162345e-05
    2.87995208551688e-05	3.21372704253476e-05	3.58618518546136e-05
    4.00180974121528e-05	4.46560352482891e-05	4.98314915763799e-05
    5.56067626451893e-05	6.20513645901797e-05	6.92428701895760e-05
    7.72678425971195e-05	8.62228772907224e-05	9.62157647788152e-05
    0.000107366788059721	0.000119810170451393	0.000133695691218847
    0.000149190488446364	0.000166481070855384	0.000185775562784084
    0.000207306209351108	0.000231332171957805	0.000258142647777999
    0.000288060350784200	0.000321445396210848	0.000358699635211360
    0.000400271491884633	0.000446661360893615	0.000498427630646348
    0.000556193404539649	0.000620654001168127	0.000692585323777505
    0.000772853199704183	0.000862423802218599	0.000962375280218637
    0.00107391073575813	0.00119837270561912	0.00133725932124059
    0.00149224234151842	0.00166518727553498	0.00185817583743275
    0.00207353100371826	0.00231384497460749	0.00258201037597980
    0.00288125507751368	0.00321518104610564	0.00358780770224530
    0.00400362030122137	0.00446762392151640	0.00498540371024111
    0.00556319211077411	0.00620794388181705	0.00692741981085876
    0.00773028012969604	0.00862618875644057	0.00962592961875852
    0.0107415364585097	0.0119864376802262	0.0133756179869523	0.0149257987490331
    0.0166556392769257	0.0185859614207274	0.0207400001998920	0.0231436834799308
    0.0258259440625275	0.0288190679456525	0.0321590829456344	0.0358861923589797
    0.0400452588838674	0.0446863446262135	0.0498653136902851	0.0556445046071614
    0.0620934806949712	0.0692898673828889	0.0773202865776399	0.0862813993193576
    0.0962810692770931	0.107439661088814	0.119891489173828	0.133786434456788
    0.149291748463557	0.166594066504590	0.185901654178231	0.207446914234790
    0.231489183976157	0.258317856862872	0.288255865903005	0.321663570751907
    0.358943095311312	0.400543168038874	0.446964523230269	0.498765928288341
    0.556570909528695	0.621075257479332	0.693055402014558	0.773377758133513
    0.863009154877139	0.963028472915012	1.07463963088208	1.19918607677998
    1.33816695887401	1.49325517073249	1.66631748761423	1.85943703658296
    2.07493837081837	2.31541544993975	2.58376286313759	2.88321067094143
    3.21736328500974	3.59024285393226	4.00633767727370	4.47065623061211
    4.98878745186346	5.56696801455092	6.21215739777748	6.93212165650898
    7.73552690049892	8.63204360704725	9.63246302319236	10.7488270584521
    11.9945732316158	13.3846964162909	14.9359293321131	16.6669439541684
    18.5985762649620	20.7540770542458	23.1593917855440	25.8434728980924
    28.8386283033273	32.1809102707268	35.9105493839693	40.0724387908799
    44.7166745760133	49.8991587602641	55.6822721857244	62.1356253852144
    69.3368964745933	77.3727661534481	86.3399610686326	96.3464180994742
    107.512583578997	119.972863089696	133.877239284860	149.393077208934
    166.707138847300	186.027831154354	207.587714619058	231.646302563231
    258.493184867357	288.451513723731	321.881893374510	359.186720654866
    400.815028587792	447.267891332209	499.104455542994	556.948670741595
    621.496799709710	693.525799307677	773.902672596236	863.594904831920
    963.682108952680	1075.36902072880	1200'
    # time_sequence = '1.24431e+00 1.54830e+00 1.92657e+00 2.39725e+00 2.98291e+00
    # 3.71167e+00 4.61846e+00 5.74679e+00 7.15078e+00 8.89778e+00 1.10716e+01
    # 1.37765e+01 1.71422e+01 2.13302e+01 2.65413e+01 3.30256e+01 4.10940e+01
    # 5.11337e+01 6.36261e+01 7.91705e+01 9.85125e+01 1.22580e+02 1.52527e+02
    # 1.89791e+02 2.36159e+02 2.93854e+02 3.65646e+02 4.54976e+02 5.66131e+02
    # 7.04441e+02 8.76543e+02 1.09069e+03 1.35715e+03 1.68872e+03 2.10129e+03
    # 2.61465e+03 3.25343e+03 4.04828e+03 5.03731e+03 6.26796e+03 7.79928e+03
    # 9.70472e+03 1.20757e+04 1.50259e+04 1.86968e+04 2.32646e+04 2.89483e+04
    # 3.60207e+04 4.48208e+04 5.57710e+04 6.93963e+04 8.63504e+04 1.07447e+05
    # 1.33697e+05 1.66360e+05 2.07003e+05 2.57576e+05 3.20504e+05 3.98806e+05
    # 4.96238e+05 6.17473e+05 7.68327e+05 9.56036e+05 1.18960e+06 1.48023e+06
    # 1.84187e+06 2.29185e+06 2.85177e+06 3.54849e+06 4.41541e+06 5.49414e+06
    # 6.83640e+06 8.50660e+06 1.05848e+07 1.31708e+07 1.63885e+07 2.03924e+07
    # 2.53745e+07 3.15737e+07 3.92874e+07 4.88856e+07 6.08288e+07 7.56898e+07
    # 9.41815e+07 1.17191e+08 1.45822e+08 1.81447e+08 2.25776e+08 2.80935e+08
    # 3.49570e+08 4.34973e+08 5.41241e+08 6.73471e+08 8.38006e+08 1.04274e+09
    # 1.29749e+09 1.61448e+09 2.00891e+09 2.49970e+09 3.11040e+09'
    # time_sequence = '1.24431e+00 2.98291e+00 7.15078e+00 1.71422e+01 3.30256e+01 7.91705e+01
    # 1.89791e+02 3.65646e+02 8.76543e+02 1.09069e+03 1.35715e+03 1.68872e+03 2.10129e+03
    # 2.61465e+03 3.25343e+03 4.04828e+03 5.03731e+03 6.26796e+03 7.79928e+03
    # 9.70472e+03 1.20757e+04 1.50259e+04 1.86968e+04 2.32646e+04 2.89483e+04
    # 3.60207e+04 4.48208e+04 5.57710e+04 6.93963e+04 8.63504e+04 1.07447e+05
    # 1.33697e+05 1.66360e+05 2.07003e+05 2.57576e+05 3.20504e+05 3.98806e+05
    # 4.96238e+05 6.17473e+05 7.68327e+05 9.56036e+05 1.18960e+06 1.48023e+06
    # 1.84187e+06 2.29185e+06 2.85177e+06 3.54849e+06 4.41541e+06 5.49414e+06
    # 6.83640e+06 8.50660e+06 1.05848e+07 1.31708e+07 1.63885e+07 2.03924e+07
    # 2.53745e+07 3.15737e+07 3.92874e+07 4.88856e+07 6.08288e+07 7.56898e+07
    # 9.41815e+07 1.17191e+08 1.45822e+08 1.81447e+08 2.25776e+08 2.80935e+08
    # 3.49570e+08 4.34973e+08 5.41241e+08 6.73471e+08 8.38006e+08 1.04274e+09
    # 1.29749e+09 1.61448e+09 2.00891e+09 2.49970e+09 3.11040e+09'
    # time_sequence = '1.00000e-03 1.07287e-03 1.15106e-03 1.23494e-03 1.32494e-03
    # 1.42149e-03 1.52508e-03 1.63622e-03 1.75545e-03 1.88338e-03 2.02063e-03
    # 2.16788e-03 2.32586e-03 2.49536e-03 2.67720e-03 2.87230e-03 3.08162e-03
    # 3.30618e-03 3.54712e-03 3.80561e-03 4.08294e-03 4.38048e-03 4.69970e-03
    # 5.04219e-03 5.40963e-03 5.80385e-03 6.22680e-03 6.68057e-03 7.16741e-03
    # 7.68973e-03 8.25011e-03 8.85132e-03 9.49635e-03 1.01884e-02 1.09309e-02
    # 1.17274e-02 1.25820e-02 1.34990e-02 1.44827e-02 1.55381e-02 1.66704e-02
    # 1.78852e-02 1.91886e-02 2.05869e-02 2.20872e-02 2.36968e-02 2.54236e-02
    # 2.72764e-02 2.92641e-02 3.13967e-02 3.36847e-02 3.61394e-02 3.87730e-02
    # 4.15986e-02 4.46300e-02 4.78824e-02 5.13718e-02 5.51154e-02 5.91319e-02
    # 6.34410e-02 6.80642e-02 7.30243e-02 7.83459e-02 8.40553e-02 9.01807e-02
    # 9.67525e-02 1.03803e-01 1.11368e-01 1.19484e-01 1.28191e-01 1.37533e-01
    # 1.47555e-01 1.58308e-01 1.69844e-01 1.82222e-01 1.95501e-01 2.09748e-01
    # 2.25033e-01 2.41432e-01 2.59026e-01 2.77902e-01 2.98154e-01 3.19882e-01
    # 3.43193e-01 3.68202e-01 3.95035e-01 4.23822e-01 4.54708e-01 4.87844e-01
    # 5.23395e-01 5.61537e-01 6.02458e-01 6.46362e-01 6.93465e-01 7.44000e-01
    # 7.98218e-01 8.56388e-01 9.18796e-01 9.85752e-01 1.05759e+00 1.13466e+00
    # 1.21734e+00 1.30606e+00 1.40123e+00 1.50335e+00 1.61290e+00 1.73044e+00
    # 1.85655e+00 1.99184e+00 2.13699e+00 2.29272e+00 2.45980e+00 2.63906e+00
    # 2.83137e+00 3.03771e+00 3.25908e+00 3.49658e+00 3.75139e+00 4.02477e+00
    # 4.31807e+00 4.63274e+00 4.97035e+00 5.33255e+00 5.72116e+00 6.13808e+00
    # 6.58539e+00 7.06529e+00 7.58016e+00 8.13256e+00 8.72521e+00 9.36105e+00
    # 1.00432e+01 1.07751e+01 1.15603e+01 1.24028e+01 1.33066e+01 1.42763e+01
    # 1.53167e+01 1.64329e+01 1.76304e+01 1.89152e+01 2.02936e+01 2.17725e+01
    # 2.33591e+01 2.50614e+01 2.68877e+01 2.88471e+01 3.09493e+01 3.32047e+01
    # 3.56245e+01 3.82206e+01 4.10059e+01 4.39941e+01 4.72001e+01 5.06398e+01
    # 5.43301e+01 5.82894e+01 6.25371e+01 6.70945e+01 7.19839e+01 7.72296e+01
    # 8.28576e+01 8.88958e+01 9.53740e+01 1.02324e+02 1.09781e+02 1.17781e+02
    # 1.26364e+02 1.35573e+02 1.45453e+02 1.56052e+02 1.67425e+02 1.79625e+02
    # 1.92715e+02 2.06759e+02 2.21827e+02 2.37992e+02 2.55335e+02 2.73943e+02
    # 2.93906e+02 3.15324e+02 3.38303e+02 3.62956e+02 3.89406e+02 4.17784e+02
    # 4.48229e+02 4.80893e+02 5.15938e+02 5.53536e+02 5.93875e+02 6.37153e+02
    # 6.83584e+02 7.33400e+02 7.86845e+02 8.44186e+02 9.05705e+02 9.71707e+02
    # 1.04252e+03 1.11849e+03 1.20000e+03'
    # time_sequence = '1.03609e+00 1.07347e+00 1.11221e+00 1.15235e+00 1.19393e+00 1.23702e+00
    # 1.28166e+00 1.32791e+00 1.37582e+00 1.42547e+00 1.47691e+00 1.53021e+00
    # 1.58543e+00 1.64264e+00 1.70192e+00 1.76333e+00 1.82697e+00 1.89289e+00
    # 1.96120e+00 2.03197e+00 2.10530e+00 2.18127e+00 2.25999e+00 2.34154e+00
    # 2.42604e+00 2.51358e+00 2.60429e+00 2.69827e+00 2.79564e+00 2.89652e+00
    # 3.00105e+00 3.10935e+00 3.22155e+00 3.33780e+00 3.45825e+00 3.58305e+00
    # 3.71235e+00 3.84631e+00 3.98511e+00 4.12892e+00 4.27792e+00 4.43229e+00
    # 4.59223e+00 4.75795e+00 4.92965e+00 5.10754e+00 5.29185e+00 5.48281e+00
    # 5.68067e+00 5.88566e+00 6.09805e+00 6.31811e+00 6.54611e+00 6.78233e+00
    # 7.02708e+00 7.28066e+00 7.54339e+00 7.81560e+00 8.09764e+00 8.38985e+00
    # 8.69261e+00 9.00630e+00 9.33130e+00 9.66803e+00 1.00169e+01 1.03784e+01
    # 1.07529e+01 1.11409e+01 1.15430e+01 1.19595e+01 1.23911e+01 1.28382e+01
    # 1.33015e+01 1.37815e+01 1.42788e+01 1.47941e+01 1.53280e+01 1.58811e+01
    # 1.64542e+01 1.70480e+01 1.76632e+01 1.83006e+01 1.89610e+01 1.96452e+01
    # 2.03541e+01 2.10886e+01 2.18496e+01 2.26381e+01 2.34550e+01 2.43014e+01
    # 2.51784e+01 2.60870e+01 2.70283e+01 2.80037e+01 2.90142e+01 3.00612e+01
    # 3.11460e+01 3.22700e+01 3.34345e+01 3.46410e+01 3.58911e+01 3.71863e+01
    # 3.85282e+01 3.99185e+01 4.13590e+01 4.28515e+01 4.43979e+01 4.60000e+01
    # 4.76600e+01 4.93798e+01 5.11618e+01 5.30080e+01 5.49209e+01 5.69028e+01
    # 5.89562e+01 6.10837e+01 6.32880e+01 6.55718e+01 6.79380e+01 7.03896e+01
    # 7.29297e+01 7.55615e+01 7.82882e+01 8.11134e+01 8.40404e+01 8.70731e+01
    # 9.02153e+01 9.34708e+01 9.68438e+01 1.00339e+02 1.03959e+02 1.07711e+02
    # 1.11598e+02 1.15625e+02 1.19797e+02 1.24120e+02 1.28599e+02 1.33240e+02
    # 1.38048e+02 1.43030e+02 1.48191e+02 1.53539e+02 1.59080e+02 1.64820e+02
    # 1.70768e+02 1.76930e+02 1.83315e+02 1.89930e+02 1.96784e+02 2.03885e+02
    # 2.11243e+02 2.18866e+02 2.26764e+02 2.34947e+02 2.43425e+02 2.52209e+02
    # 2.61311e+02 2.70740e+02 2.80510e+02 2.90633e+02 3.01121e+02 3.11987e+02
    # 3.23246e+02 3.34910e+02 3.46996e+02 3.59518e+02 3.72491e+02 3.85933e+02
    # 3.99860e+02 4.14290e+02 4.29240e+02 4.44729e+02 4.60778e+02 4.77406e+02
    # 4.94634e+02 5.12483e+02 5.30977e+02 5.50138e+02 5.69990e+02 5.90559e+02
    # 6.11870e+02 6.33950e+02 6.56827e+02 6.80529e+02 7.05087e+02 7.30531e+02
    # 7.56893e+02 7.84206e+02 8.12505e+02 8.41826e+02 8.72204e+02 9.03679e+02
    # 9.36289e+02 9.70076e+02 1.00508e+03 1.04135e+03 1.07893e+03 1.11787e+03
    # 1.15820e+03 1.20000e+03'
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

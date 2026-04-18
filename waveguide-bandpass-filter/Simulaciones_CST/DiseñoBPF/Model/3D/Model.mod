'# MWS Version: Version 2024.0 - Sep 01 2023 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 8 fmax = 12
'# created = '[VERSION]2024.0|33.0.1|20230901[/VERSION]


'@ define background

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Background 
     .ResetBackground 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
     .ApplyInAllDirections "False" 
End With 

With Material 
     .Reset 
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .UseEmissivity "True"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .Absorptance "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Pec"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "m"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "K"
     .Epsilon "1.0"
     .Mu "1.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.6", "0.6", "0.6" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeBackgroundMaterial
End With

'@ new component: component1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.New "component1"

'@ define brick: component1:entrada

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "entrada" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-a/2", "a/2" 
     .Yrange "0", "b" 
     .Zrange "0", "L" 
     .Create
End With

'@ delete shape: component1:entrada

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "component1:entrada"

'@ define brick: component1:entrada

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "entrada" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-a/2", "a/2" 
     .Yrange "0", "b" 
     .Zrange "0", "L" 
     .Create
End With

'@ define brick: component1:iris1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "iris1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-w1/2", "w1/2" 
     .Yrange "0", "b" 
     .Zrange "L", "L+t" 
     .Create
End With

'@ define brick: component1:cavidad1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "cavidad1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-a/2", "a/2" 
     .Yrange "0", "b" 
     .Zrange "L+t", "L+t+Lc1" 
     .Create
End With

'@ define brick: component1:iris2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "iris2" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-w2/2", "w2/2" 
     .Yrange "0", "b" 
     .Zrange "L+t+Lc1", "L+t+Lc1+t" 
     .Create
End With

'@ define brick: component1:cavidad2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "cavidad2" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-a/2", "a/2" 
     .Yrange "0", "b" 
     .Zrange "L+2*t+Lc1", "L+2*t+Lc1+Lc2" 
     .Create
End With

'@ define brick: component1:iris3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "iris3" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-w3/2", "w3/2" 
     .Yrange "0", "b" 
     .Zrange "L+2*t+Lc1+Lc2", "L+2*t+Lc1+Lc2+t" 
     .Create
End With

'@ transform: mirror component1:cavidad1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Transform 
     .Reset 
     .Name "component1:cavidad1" 
     .Origin "Free" 
     .Center "0", "0", "L+2*t+Lc1+Lc2+t/2" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:cavidad2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Transform 
     .Reset 
     .Name "component1:cavidad2" 
     .Origin "Free" 
     .Center "0", "0", "L+2*t+Lc1+Lc2+t/2" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:entrada

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Transform 
     .Reset 
     .Name "component1:entrada" 
     .Origin "Free" 
     .Center "0", "0", "L+2*t+Lc1+Lc2+t/2" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:iris1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Transform 
     .Reset 
     .Name "component1:iris1" 
     .Origin "Free" 
     .Center "0", "0", "L+2*t+Lc1+Lc2+t/2" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:iris2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Transform 
     .Reset 
     .Name "component1:iris2" 
     .Origin "Free" 
     .Center "0", "0", "L+2*t+Lc1+Lc2+t/2" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "component1:entrada", "2"

'@ define port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "-9.525", "9.525"
     .Yrange "0", "9.525"
     .Zrange "0", "0"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define frequency range

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solver.FrequencyRange "8", "12"

'@ define time domain solver parameters

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Discretizer.PBAVersion "2023090124"

'@ pick edge

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEdgeFromId "component1:cavidad1", "12", "2"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "17.367882"
    .SetViewVector "-0.839098", "-0.488710", "0.238907"
    .SetConnectedElement1 "component1:cavidad1"
    .SetConnectedElement2 "component1:cavidad1"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 0

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "0"
End With

'@ define boundaries

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ change solver type

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ define frequency domain solver parameters

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .SetKeepSolutionCoefficients "MonitorsAndMeshAdaptation" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "True" 
     .UseFastDirectFFCalc "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "component1:entrada_1", "2"

'@ define port: 2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-9.525", "9.525"
     .Yrange "0", "9.525"
     .Zrange "128.43447719971", "128.43447719971"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ set mesh properties (Tetrahedral)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Mesh 
     .MeshType "Tetrahedral" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "4" 
     .Set "StepsPerWaveFar", "4" 
     .Set "PhaseErrorNear", "0.02" 
     .Set "PhaseErrorFar", "0.02" 
     .Set "CellsPerWavelengthPolicy", "cellsperwavelength" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "20" 
     .Set "StepsPerBoxFar", "1" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     'MIN CELL 
     .Set "UseRatioLimit", "0" 
     .Set "RatioLimit", "100" 
     .Set "MinStep", "0" 
     'MESHING METHOD 
     .SetMeshType "Unstr" 
     .Set "Method", "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "CurvatureOrder", "1" 
     .Set "CurvatureOrderPolicy", "automatic" 
     .Set "CurvRefinementControl", "NormalTolerance" 
     .Set "NormalTolerance", "22.5" 
     .Set "SrfMeshGradation", "1.5" 
     .Set "SrfMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "UseMaterials",  "1" 
     .Set "MoveMesh", "0" 
End With 
With MeshSettings 
     .SetMeshType "All" 
     .Set "AutomaticEdgeRefinement",  "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "UseAnisoCurveRefinement", "1" 
     .Set "UseSameSrfAndVolMeshGradation", "1" 
     .Set "VolMeshGradation", "1.5" 
     .Set "VolMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "SmallFeatureSize", "0" 
     .Set "CoincidenceTolerance", "1e-06" 
     .Set "SelfIntersectionCheck", "1" 
     .Set "OptimizeForPlanarStructures", "0" 
End With 
With Mesh 
     .SetParallelMesherMode "Tet", "maximum" 
     .SetMaxParallelMesherThreads "Tet", "1" 
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "component1:entrada_1", "8"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "component1:entrada", "8"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "14.241298"
    .SetViewVector "-0.469845", "-0.342030", "-0.813794"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "1"
End With

'@ set mesh properties (Tetrahedral)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Mesh 
     .MeshType "Tetrahedral" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "4" 
     .Set "StepsPerWaveFar", "4" 
     .Set "PhaseErrorNear", "0.02" 
     .Set "PhaseErrorFar", "0.02" 
     .Set "CellsPerWavelengthPolicy", "cellsperwavelength" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "30" 
     .Set "StepsPerBoxFar", "1" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     'MIN CELL 
     .Set "UseRatioLimit", "0" 
     .Set "RatioLimit", "100" 
     .Set "MinStep", "0" 
     'MESHING METHOD 
     .SetMeshType "Unstr" 
     .Set "Method", "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "CurvatureOrder", "1" 
     .Set "CurvatureOrderPolicy", "automatic" 
     .Set "CurvRefinementControl", "NormalTolerance" 
     .Set "NormalTolerance", "22.5" 
     .Set "SrfMeshGradation", "1.5" 
     .Set "SrfMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "UseMaterials",  "1" 
     .Set "MoveMesh", "0" 
End With 
With MeshSettings 
     .SetMeshType "All" 
     .Set "AutomaticEdgeRefinement",  "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "UseAnisoCurveRefinement", "1" 
     .Set "UseSameSrfAndVolMeshGradation", "1" 
     .Set "VolMeshGradation", "1.5" 
     .Set "VolMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "SmallFeatureSize", "0" 
     .Set "CoincidenceTolerance", "1e-06" 
     .Set "SelfIntersectionCheck", "1" 
     .Set "OptimizeForPlanarStructures", "0" 
End With 
With Mesh 
     .SetParallelMesherMode "Tet", "maximum" 
     .SetMaxParallelMesherThreads "Tet", "1" 
End With


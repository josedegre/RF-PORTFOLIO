'# MWS Version: Version 2024.5 - Jun 14 2024 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4.2 fmax = 5.2
'# created = '[VERSION]2024.5|33.0.1|20240614[/VERSION]


'@ use template: Antenna - Planar_1.cfg

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "4.2", "5.2"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "4.2;4.7;5.2"
Dim sDefineAtName As String
sDefineAtName = "4.2;4.7;5.2"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: FR-4

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Material 
     .Reset 
     .Name "FR-4"
     .Folder ""
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
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "degC"
     .Epsilon "3.9"
     .Mu "1"
     .Sigma "0"
     .TanD "0.02"
     .TanDFreq "0.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ new component: component1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Component.New "component1"

'@ define brick: component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
     .Reset 
     .Name "SUSTRATO" 
     .Component "component1" 
     .Material "FR-4" 
     .Xrange "-Long_linea-L_parche_inf/2", "Long_linea+L_parche_inf/2" 
     .Yrange "-W_parche_inf/2-Long_linea", "W_parche_inf/2+Long_linea" 
     .Zrange "0", "h_sus" 
     .Create
End With

'@ define brick: component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
     .Reset 
     .Name "PARCHE_INF" 
     .Component "component1" 
     .Material "FR-4" 
     .Xrange "-L_parche_inf/2", "L_parche_inf/2" 
     .Yrange "-W_parche_inf/2", "W_parche_inf/2" 
     .Zrange "h_sus", "h_sus+h_cobre" 
     .Create
End With

'@ change material and color: component1:PARCHE_INF to: PEC

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.ChangeMaterial "component1:PARCHE_INF", "PEC" 
Solid.SetUseIndividualColor "component1:PARCHE_INF", 1
Solid.ChangeIndividualColor "component1:PARCHE_INF", "170", "170", "127"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ pick mid point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickMidpointFromId "component1:PARCHE_INF", "3"

'@ align wcs with point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: component1:Linea_microstrip

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
     .Reset 
     .Name "Linea_microstrip" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "0", "-Long_linea" 
     .Yrange "-W_linea/2", "W_linea/2" 
     .Zrange "-h_cobre", "0" 
     .Create
End With

'@ define boundaries

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "electric"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ pick face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:Linea_microstrip", "4"

'@ define port: 1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
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
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-26.9", "-26.9"
     .Yrange "-0.5", "0.5"
     .Zrange "1.58", "1.615"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*h_sus", "4*h_sus"
     .ZrangeAdd "h_sus", "3*h_sus"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
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

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Discretizer.PBAVersion "2024061424"

'@ transform: mirror component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO" 
     .Origin "Free" 
     .Center "0", "0", "h_0-h_sus" 
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

'@ define material colour: FR-4

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Material 
     .Name "FR-4"
     .Folder ""
     .Colour "0", "0.501961", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ transform: mirror component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:PARCHE_INF" 
     .Origin "Free" 
     .Center "0", "0", "h_0" 
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

'@ delete shape: component1:PARCHE_INF_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:PARCHE_INF_1"

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ pick center point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickCenterpointFromId "component1:SUSTRATO_1", "2"

'@ align wcs with point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Brick
     .Reset 
     .Name "Parche_superior" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-W_parche_sup/2", "W_parche_sup/2" 
     .Yrange "-L_parche_sup/2", "L_parche_sup/2" 
     .Zrange "0", "h_cobre" 
     .Create
End With

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ pick center point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickCenterpointFromId "component1:PARCHE_INF", "1"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ clear picks

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.ClearAllPicks

'@ transform: rotate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"


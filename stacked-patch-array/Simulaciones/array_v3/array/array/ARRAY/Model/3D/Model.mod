'# MWS Version: Version 2024.4 - Apr 30 2024 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 3.2 fmax = 6.2
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

'@ define frequency range

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solver.FrequencyRange "3.2", "6.2"

'@ farfield plot options

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Realized Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "directional_linear" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "ludwig3" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Slant" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ transform: translate component1:Linea_microstrip

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Linea_microstrip" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:PARCHE_INF" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ pick end point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickEndpointFromId "component1:PARCHE_INF", "1"

'@ pick mid point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickMidpointFromId "component1:SUSTRATO_2", "2"

'@ delete shape: component1:SUSTRATO_2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:SUSTRATO_2"

'@ delete shape: component1:PARCHE_INF_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:PARCHE_INF_1"

'@ delete shape: component1:Linea_microstrip_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:Linea_microstrip_1"

'@ transform: translate component1:Linea_microstrip

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Linea_microstrip" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:PARCHE_INF" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Linea_microstrip

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Linea_microstrip" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:PARCHE_INF" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Linea_microstrip

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Linea_microstrip" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:PARCHE_INF

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:PARCHE_INF" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ pick mid point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickMidpointFromId "component1:SUSTRATO", "2"

'@ pick mid point

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickMidpointFromId "component1:PARCHE_INF", "2"

'@ delete shapes

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Delete "component1:Parche_superior_1" 
Solid.Delete "component1:Parche_superior_2" 
Solid.Delete "component1:Parche_superior_3"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "local"

'@ pick face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:PARCHE_INF", "1"

'@ align wcs with face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
WCS.ActivateWCS "global"

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Parche_superior

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Parche_superior" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO_1" 
     .Vector "0", "-distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO_1" 
     .Vector "0", "-2*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:SUSTRATO_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Transform 
     .Reset 
     .Name "component1:SUSTRATO_1" 
     .Vector "0", "-3*distancia_entre_parches", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ boolean add shapes: component1:SUSTRATO, component1:SUSTRATO_2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO", "component1:SUSTRATO_2"

'@ boolean add shapes: component1:SUSTRATO_3, component1:SUSTRATO_4

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO_3", "component1:SUSTRATO_4"

'@ boolean add shapes: component1:SUSTRATO, component1:SUSTRATO_3

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO", "component1:SUSTRATO_3"

'@ boolean add shapes: component1:SUSTRATO_1, component1:SUSTRATO_1_1

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO_1", "component1:SUSTRATO_1_1"

'@ boolean add shapes: component1:SUSTRATO_1_2, component1:SUSTRATO_1_3

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO_1_2", "component1:SUSTRATO_1_3"

'@ boolean add shapes: component1:SUSTRATO_1, component1:SUSTRATO_1_2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Solid.Add "component1:SUSTRATO_1", "component1:SUSTRATO_1_2"

'@ pick face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:Linea_microstrip_1", "4"

'@ define port: 2

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
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
     .Xrange "-25.5176", "-25.5176"
     .Yrange "-32.664893617021", "-31.164893617021"
     .Zrange "1.58", "1.615"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*h_sus", "4*h_sus"
     .ZrangeAdd "h_sus", "3*h_sus"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:Linea_microstrip_2", "4"

'@ define port: 3

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
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
     .Xrange "-25.5176", "-25.5176"
     .Yrange "-64.579787234042", "-63.079787234042"
     .Zrange "1.58", "1.615"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*h_sus", "0.04*h_sus"
     .ZrangeAdd "h_sus", "3*h_sus"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 3

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "3" 
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
     .Xrange "-25.5176", "-25.5176"
     .Yrange "-64.579787", "-63.079787"
     .Zrange "1.58", "1.615"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*h_sus", "4*h_sus"
     .ZrangeAdd "h_sus", "3*h_sus"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ pick face

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Pick.PickFaceFromId "component1:Linea_microstrip_3", "4"

'@ define port: 4

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Port 
     .Reset 
     .PortNumber "4" 
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
     .Xrange "-25.5176", "-25.5176"
     .Yrange "-96.494680851064", "-94.994680851064"
     .Zrange "1.58", "1.615"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*h_sus", "4*h_sus"
     .ZrangeAdd "h_sus", "3*h_sus"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define solver excitation modes

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solver 
     .ResetExcitationModes 
     .SParameterPortExcitation "False" 
     .SimultaneousExcitation "True" 
     .SetSimultaneousExcitAutoLabel "True" 
     .SetSimultaneousExcitationLabel "1[1.0,0.0]+2[1.0,alpha]+3[1.0,2alpha]+4[1.0,3alpha],[4.7]" 
     .SetSimultaneousExcitationOffset "Phaseshift" 
     .PhaseRefFrequency "4.7" 
     .ExcitationSelectionShowAdditionalSettings "False" 
     .ExcitationPortMode "1", "1", "1.0", "0.0", "default", "True" 
     .ExcitationPortMode "2", "1", "1.0", "alpha", "default", "True" 
     .ExcitationPortMode "3", "1", "1.0", "2*alpha", "default", "True" 
     .ExcitationPortMode "4", "1", "1.0", "3*alpha", "default", "True" 
End With

'@ define time domain solver parameters

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "Selected"
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

'@ define solver excitation modes

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With Solver 
     .ResetExcitationModes 
     .SParameterPortExcitation "False" 
     .SimultaneousExcitation "True" 
     .SetSimultaneousExcitAutoLabel "True" 
     .SetSimultaneousExcitationLabel "1[1,0]+2[1,alpha]+3[1,2alpha]+4[1,3alpha],[4.7]" 
     .SetSimultaneousExcitationOffset "Phaseshift" 
     .PhaseRefFrequency "4.7" 
     .ExcitationSelectionShowAdditionalSettings "False" 
     .ExcitationPortMode "1", "1", "1.0", "0.0", "default", "True" 
     .ExcitationPortMode "2", "1", "1.0", "alpha", "default", "True" 
     .ExcitationPortMode "3", "1", "1.0", "2*alpha", "default", "True" 
     .ExcitationPortMode "4", "1", "1.0", "3*alpha", "default", "True" 
     .DefineExcitation "simultaneous", "1[1,0]+2[1,alpha]+3[1,2alpha]+4[1,3alpha],[4.7]", "1" , "1.0", "0.0", "default", "False" 
     .DefineExcitation "simultaneous", "1[1.0,0.0]+2[1.0,alpha]+3[1.0,2alpha]+4[1.0,3alpha],[4.7]", "1" , "1.0", "0.0", "default", "False" 
End With

'@ farfield plot options

'[VERSION]2024.5|33.0.1|20240614[/VERSION]
With FarfieldPlot 
     .Plottype "Polar" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
     .Step "1" 
     .Step2 "1" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "4.7" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .ShowStructureProfile "True" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "12.8242" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "True" 
     .SetAxesType "user" 
     .SetAntennaType "directional_linear" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "ludwig3" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Slant" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ define solver excitation modes

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Solver 
     .ResetExcitationModes 
     .SParameterPortExcitation "True" 
     .SimultaneousExcitation "False" 
     .SetSimultaneousExcitAutoLabel "True" 
     .SetSimultaneousExcitationLabel "1[1,0]+2[1,alpha]+3[1,2alpha]+4[1,3alpha],[4.7]" 
     .SetSimultaneousExcitationOffset "Phaseshift" 
     .PhaseRefFrequency "4.7" 
     .ExcitationSelectionShowAdditionalSettings "False" 
     .ExcitationPortMode "1", "1", "1.0", "0.0", "default", "True" 
     .ExcitationPortMode "2", "1", "1.0", "alpha", "default", "True" 
     .ExcitationPortMode "3", "1", "1.0", "2*alpha", "default", "True" 
     .ExcitationPortMode "4", "1", "1.0", "3*alpha", "default", "True" 
     .DefineExcitation "simultaneous", "1[1,0]+2[1,alpha]+3[1,2alpha]+4[1,3alpha],[4.7]", "1" , "1.0", "0.0", "default", "False" 
     .DefineExcitation "simultaneous", "1[1.0,0.0]+2[1.0,alpha]+3[1.0,2alpha]+4[1.0,3alpha],[4.7]", "1" , "1.0", "0.0", "default", "False" 
End With

'@ define time domain solver parameters

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
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

'@ pick center point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickCenterpointFromId "component1:SUSTRATO_1", "28"

'@ align wcs with point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ move wcs

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
WCS.MoveWCS "local", "0.0", "99.9/2", "0.0"

'@ pick center point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickCenterpointFromId "component1:SUSTRATO_1", "28"

'@ align wcs with point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define cylinder: component1:taladro_cabeza_m4

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Cylinder 
     .Reset 
     .Name "taladro_cabeza_m4" 
     .Component "component1" 
     .Material "Vacuum" 
     .OuterRadius "8/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-h_sus", "0" 
     .Xcenter "0" 
     .Ycenter "99.9/2" 
     .Segments "0" 
     .Create 
End With

'@ transform: translate component1:taladro_cabeza_m4

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Transform 
     .Reset 
     .Name "component1:taladro_cabeza_m4" 
     .Vector "0", "-99.9", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ clear picks

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.ClearAllPicks

'@ import dxf file: C:\Users\ATAT\Downloads\red_adaptacion.dxf

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With DXF
     .Reset 
     .FileName "*red_adaptacion.dxf" 
     .AddAllShapes "False" 
     .PreserveHoles "True" 
     .CloseShapes "True" 
     .AsCurves "False" 
     .HealSelfIntersections "False" 
     .Id "1" 
     .SetSimplifyActive "True" 
     .SetSimplifyAngle "5.0" 
     .SetSimplifyRadiusTol "2.0" 
     .SetSimplifyEdgeLength "0.0" 
     .ScaleToUnit "False" 
     .ImportFileUnits "m" 
     .UseModelTolerance "False" 
     .ModelTolerance "0.0001" 
     .ConsiderPolylineStartAndEndWidth "True" 
     .Version "11.3" 
     .DiscardElevationsReadFromDXFFile "True" 
     .AddLayer "cond", "PEC", "0", "h_cobre", "0" 
     .Read
End With

'@ transform: rotate cond:import_1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Transform 
     .Reset 
     .Name "cond:import_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "-90" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ pick mid point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickMidpointFromId "cond:import_1", "86"

'@ pick mid point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickMidpointFromId "component1:Linea_microstrip_3", "3"

'@ transform: translate cond:import_1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Transform 
     .Reset 
     .Name "cond:import_1" 
     .Vector "-40.0458", "5.4225234042555", "-7.16" 
     .UsePickedPoints "True" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ change component: cond:import_1 to: component1:import_1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.ChangeComponent "cond:import_1", "component1"

'@ rename block: component1:import_1 to: component1:red_adaptacion

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Rename "component1:import_1", "red_adaptacion"

'@ boolean add shapes: component1:Linea_microstrip, component1:Linea_microstrip_1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:Linea_microstrip", "component1:Linea_microstrip_1"

'@ boolean add shapes: component1:Linea_microstrip_2, component1:Linea_microstrip_3

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:Linea_microstrip_2", "component1:Linea_microstrip_3"

'@ boolean add shapes: component1:PARCHE_INF, component1:PARCHE_INF_1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:PARCHE_INF", "component1:PARCHE_INF_1"

'@ boolean add shapes: component1:PARCHE_INF_2, component1:PARCHE_INF_3

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:PARCHE_INF_2", "component1:PARCHE_INF_3"

'@ boolean add shapes: component1:PARCHE_INF_2, component1:red_adaptacion

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:PARCHE_INF_2", "component1:red_adaptacion"

'@ boolean add shapes: component1:Linea_microstrip, component1:Linea_microstrip_2

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:Linea_microstrip", "component1:Linea_microstrip_2"

'@ boolean add shapes: component1:PARCHE_INF, component1:PARCHE_INF_2

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:PARCHE_INF", "component1:PARCHE_INF_2"

'@ boolean add shapes: component1:Linea_microstrip, component1:PARCHE_INF

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:Linea_microstrip", "component1:PARCHE_INF"

'@ rename block: component1:Linea_microstrip to: component1:parchesinf_red

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Rename "component1:Linea_microstrip", "parchesinf_red"

'@ pick end point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickEndpointFromId "component1:SUSTRATO", "27"

'@ pick end point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickEndpointFromId "component1:SUSTRATO", "4"

'@ pick mid point

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickMidpointFromId "component1:parchesinf_red", "160"

'@ define brick: cond:solid1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "cond" 
     .Material "FR-4" 
     .Xrange "-57.5353", "-24.83" 
     .Yrange "-95.021276595744", "95.021276595744" 
     .Zrange "-7.16-h_sus", "-7.16" 
     .Create
End With

'@ change component: cond:solid1 to: component1:solid1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.ChangeComponent "cond:solid1", "component1"

'@ delete component: cond

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Component.Delete "cond"

'@ boolean add shapes: component1:SUSTRATO, component1:solid1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Solid.Add "component1:SUSTRATO", "component1:solid1"

'@ delete ports

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Port.Delete "1" 
Port.Delete "2" 
Port.Delete "3" 
Port.Delete "4"

'@ pick face

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
Pick.PickFaceFromId "component1:parchesinf_red", "53"

'@ define port:1

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0", "0"
  .YrangeAdd "1.58*5.93", "1.58*5.93"
  .ZrangeAdd "1.58", "1.58*5.93"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ farfield plot options

'[VERSION]2024.4|33.0.1|20240430[/VERSION]
With FarfieldPlot 
     .Plottype "Cartesian" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "1" 
     .Step2 "1" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "True" 
     .SymmetricRange "True" 
     .SetTimeDomainFF "False" 
     .SetFrequency "4.7" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .ShowStructureProfile "True" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "True" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With


'# MWS Version: Version 2022.0 - Aug 23 2021 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4.6 fmax = 5.1
'# created = '[VERSION]2022.5|31.0.1|20220603[/VERSION]


'@ use template: Antenna - Planar.cfg

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "4.6", "5.1"

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

'@ new component: component1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Component.New "component1"

'@ define brick: component1:parche

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Brick
     .Reset 
     .Name "parche" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-L/2", "L/2" 
     .Yrange "-W/2", "W/2" 
     .Zrange "0", "e" 
     .Create
End With

'@ define material: FR4

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Material 
     .Reset 
     .Name "FR4"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "4"
     .Mu "1"
     .Sigma "0.0"
     .TanD "0.025"
     .TanDFreq "4.85"
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
     .Colour "0.501961", "0", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define brick: component1:sustrato

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Brick
     .Reset 
     .Name "sustrato" 
     .Component "component1" 
     .Material "FR4" 
     .Xrange "-Lsus/2", "Lsus/2" 
     .Yrange "-Wsus/2", "Wsus/2" 
     .Zrange "-h", "0" 
     .Create
End With

'@ define material colour: FR4

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Material 
     .Name "FR4"
     .Folder ""
     .Colour "1", "1", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ define brick: component1:masa

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Brick
     .Reset 
     .Name "masa" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Lsus/2", "Lsus/2" 
     .Yrange "-Wsus/2", "Wsus/2" 
     .Zrange "-h-e", "-h" 
     .Create
End With

'@ define brick: component1:linea

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Brick
     .Reset 
     .Name "linea" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-Lsus/2", "-Lsus/2+Lstrip" 
     .Yrange "-Wstrip/2", "Wstrip/2" 
     .Zrange "0", "e" 
     .Create
End With

'@ define brick: component1:aire

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Brick
     .Reset 
     .Name "aire" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-L/2", "-L/2+x0" 
     .Yrange "-Wstrip/2-g", "Wstrip/2+g" 
     .Zrange "0", "e" 
     .Create
End With

'@ define material colour: Vacuum

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Material 
     .Name "Vacuum"
     .Folder ""
     .Colour "0.5", "0.8", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ boolean subtract shapes: component1:parche, component1:aire

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solid.Subtract "component1:parche", "component1:aire"

'@ pick face

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickFaceFromId "component1:linea", "4"

'@ define port: 1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
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
     .Xrange "-15.463917525773", "-15.463917525773"
     .Yrange "-0.825", "0.825"
     .Zrange "0", "0.035"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "4*Wstrip", "4*Wstrip"
     .ZrangeAdd "h", "4*h"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
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

'@ define farfield monitor: farfield (f=4.85)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=4.85)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "4.85" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-15.463917525773", "15.463917525773", "-15.463917525773", "15.463917525773", "-1.615", "6.355" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ define farfield monitor: farfield (f=4.754)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=4.754)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "4.753996" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-15.463917525773", "15.463917525773", "-15.463917525773", "15.463917525773", "-1.615", "6.355" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ define farfield monitor: farfield (f=4.9509)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=4.9509)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "4.95093" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-15.463917525773", "15.463917525773", "-15.463917525773", "15.463917525773", "-1.615", "6.355" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With FarfieldPlot 
     .Plottype "Polar" 
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
     .SetInverseAxialRatio "False" 
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

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:sustrato", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:sustrato", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "3.952334"
    .SetViewVector "-0.469839", "-0.342062", "-0.813785"
    .SetConnectedElement1 "component1:sustrato"
    .SetConnectedElement2 "component1:sustrato"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:sustrato", "3"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:sustrato", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "5.788343"
    .SetViewVector "-0.469839", "-0.342062", "-0.813785"
    .SetConnectedElement1 "component1:sustrato"
    .SetConnectedElement2 "component1:sustrato"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "11"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "10"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "2.623585"
    .SetViewVector "-0.469841", "-0.342047", "-0.813789"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:parche"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "9"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "10"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "2.610117"
    .SetViewVector "-0.469841", "-0.342047", "-0.813789"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:parche"
    .Create
End With

Pick.ClearAllPicks

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:linea", "2", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "3.026250"
    .SetViewVector "-0.469840", "-0.342056", "-0.813786"
    .SetConnectedElement1 "component1:linea"
    .SetConnectedElement2 "component1:linea"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:parche", "26", "19"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Smart Mode"
    .SetDistance "-10.133183"
    .SetViewVector "-0.469840", "-0.342056", "-0.813786"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:parche"
    .Create
End With

Pick.ClearAllPicks

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "19"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:linea", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Smart Mode"
    .SetDistance "9.412808"
    .SetViewVector "-0.469844", "-0.342034", "-0.813793"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:linea"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:linea", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:linea", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "7"
    .SetOrientation "Smart Mode"
    .SetDistance "2.439232"
    .SetViewVector "-0.469844", "-0.342034", "-0.813793"
    .SetConnectedElement1 "component1:linea"
    .SetConnectedElement2 "component1:linea"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "1"
End With

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:sustrato", "2", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "8"
    .SetOrientation "Smart Mode"
    .SetDistance "2.222874"
    .SetViewVector "-0.469843", "-0.342038", "-0.813792"
    .SetConnectedElement1 "component1:sustrato"
    .SetConnectedElement2 "component1:sustrato"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 6

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "6"
End With

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "19"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:linea", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "9"
    .SetOrientation "Smart Mode"
    .SetDistance "8.255154"
    .SetViewVector "-0.403489", "-0.063703", "-0.912764"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:linea"
    .Create
End With

Pick.ClearAllPicks

'@ change dimension 9

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .SetID "9"
    .SetDistance "8.255154"
    .SetOrientation "Force-Z"
    .Modify
End With

'@ delete dimension 9

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "9"
End With

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "19"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:linea", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "10"
    .SetOrientation "Z-Axis"
    .SetDistance "-8.368751"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:linea"
    .Create
End With

Pick.ClearAllPicks

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:parche", "18"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:parche", "16"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "11"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.089250"
    .SetViewVector "0.256999", "0.966361", "-0.009890"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 11

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "11"
End With

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:masa", "5"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:masa", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "12"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.433012"
    .SetViewVector "-0.976465", "-0.212031", "0.039486"
    .SetConnectedElement1 "component1:masa"
    .SetConnectedElement2 "component1:masa"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 12

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "12"
End With

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "10"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:parche", "13"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "13"
    .SetOrientation "Smart Mode"
    .SetDistance "0.130785"
    .SetViewVector "-0.999907", "0.005675", "-0.012427"
    .SetConnectedElement1 "component1:parche"
    .SetConnectedElement2 "component1:parche"
    .Create
End With

Pick.ClearAllPicks

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:masa", "5"

'@ unpick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.UnpickMidpointFromId "component1:masa", "5"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:masa", "5"

'@ unpick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.UnpickMidpointFromId "component1:masa", "5"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:masa", "5"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:sustrato", "5"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "14"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.822931"
    .SetViewVector "-0.999985", "0.005232", "0.001492"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 13

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "13"
End With

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:parche", "13"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:parche", "17"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "15"
    .SetOrientation "X-Axis"
    .SetDistance "-0.460216"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:sustrato", "1"

'@ pick mid point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickMidpointFromId "component1:sustrato", "5"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "16"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.421411"
    .SetViewVector "-0.999882", "-0.003715", "-0.014881"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ define time domain solver parameters

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "70"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ define farfield monitor: farfield (f=4.754)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=4.754)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "4.754" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-15.4639175257732", "15.4639175257732", "-15.4639175257732", "15.4639175257732", "-1.6150000000000002", "6.3550000000000004" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ delete monitor: farfield (f=4.9509)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Delete "farfield (f=4.9509)" 
End With

'@ define farfield monitor: farfield (f=4.953)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=4.953)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "4.953" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-15.4639175257732", "15.4639175257732", "-15.4639175257732", "15.4639175257732", "-1.6150000000000002", "6.3550000000000004" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
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
     .SetInverseAxialRatio "False" 
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


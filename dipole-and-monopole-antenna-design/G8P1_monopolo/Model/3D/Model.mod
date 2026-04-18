'# MWS Version: Version 2022.0 - Aug 23 2021 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2.1 fmax = 2.9
'# created = '[VERSION]2022.5|31.0.1|20220603[/VERSION]


'@ use template: Antenna - Wire.cfg

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
Solver.FrequencyRange "2.1", "2.9"

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

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"
Mesh.RatioLimit "20"
Mesh.AutomeshRefineAtPecLines "True", "10"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "10"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With MeshSettings
     .SetMeshType "Srf"
     .Set "Version", 1
End With
IESolver.SetCFIEAlpha "1.000000"

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

'@ define cylinder: component1:brazo_dipolo_1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Cylinder 
     .Reset 
     .Name "brazo_dipolo_1" 
     .Component "component1" 
     .Material "PEC" 
     .OuterRadius "D/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "G/2", "L/2" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:brazo_dipolo_2

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Cylinder 
     .Reset 
     .Name "brazo_dipolo_2" 
     .Component "component1" 
     .Material "PEC" 
     .OuterRadius "D/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-L/2", "-G/2" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ pick circle center point

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickCirclecenterFromId "component1:brazo_dipolo_2", "2"

'@ pick circle center point

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickCirclecenterFromId "component1:brazo_dipolo_1", "1"

'@ define discrete port: 1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "Zg"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "True", "0", "0", "-0.5"
     .SetP2 "True", "0", "0", "0.5"
     .InvertDirection "False"
     .LocalCoordinates "False"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "1"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Discretizer.PBAVersion "2022060322"

'@ define farfield monitor: farfield (f=2.5)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.5)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.5" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.2", "1.2", "-1.2", "1.2", "-27.09", "27.09" 
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

'@ define monitor: e-field (f=2.25)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=2.25)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "2.25" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.77", "1.77", "-1.77", "1.77", "-26.6664", "26.6664" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=2.25)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Monitor.Delete "e-field (f=2.25)"

'@ define farfield monitor: farfield (f=2.25)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.25)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.25" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.77", "1.77", "-1.77", "1.77", "-26.6664", "26.6664" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ define farfield monitor: farfield (f=2.85)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.85)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.85" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.77", "1.77", "-1.77", "1.77", "-26.6664", "26.6664" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
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
     .SetPlotMode "Efield" 
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

'@ delete shape: component1:brazo_dipolo_2

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solid.Delete "component1:brazo_dipolo_2"

'@ define boundaries

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
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

'@ delete monitor: farfield (f=2.25)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Monitor.Delete "farfield (f=2.25)"

'@ delete monitor: farfield (f=2.85)

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Monitor.Delete "farfield (f=2.85)"

'@ farfield plot options

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "0" 
     .Phi "0" 
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

'@ define farfield monitor: farfield (f=2.228)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.228)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.228" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-2.2", "2.2", "-2.2", "2.2", "-0.4", "25.587" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ define farfield monitor: farfield (f=2.9)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.9)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.9" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-2.2", "2.2", "-2.2", "2.2", "-0.4", "25.587" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
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
Pick.PickPointFromIdOn "port$port1", "EndPoint", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickPointFromIdOn "port$port1", "EndPoint", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "7.900558"
    .SetViewVector "-0.884836", "-0.424385", "0.192258"
    .SetConnectedElement1 "port$port1"
    .SetConnectedElement2 "port$port1"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "1"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:brazo_dipolo_1", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "-3.935246"
    .SetViewVector "-0.874374", "-0.179927", "-0.450662"
    .SetConnectedElement1 ""
    .SetConnectedElement2 "component1:brazo_dipolo_1"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "1"
End With

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "0"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "3.539684"
    .SetViewVector "-0.833419", "-0.352058", "-0.425991"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "1", "1", "0"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "-3.119748"
    .SetViewVector "-0.772764", "0.362054", "0.521298"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 3

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "3"
End With

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:brazo_dipolo_1", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEndpointFromId "component1:brazo_dipolo_1", "1"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "-3.828106"
    .SetViewVector "-0.689571", "-0.531915", "-0.491487"
    .SetConnectedElement1 "component1:brazo_dipolo_1"
    .SetConnectedElement2 "component1:brazo_dipolo_1"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 2

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "2"
End With

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "0"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "2"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Smart Mode"
    .SetDistance "-3.673235"
    .SetViewVector "-0.469845", "-0.342028", "-0.813795"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 5

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .RemoveDimension "5"
End With

'@ clear picks

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "2"

'@ pick end point

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickExtraCirclepointFromId "component1:brazo_dipolo_1", "2", "3", "0"

'@ define distance dimension

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Smart Mode"
    .SetDistance "1.826125"
    .SetViewVector "-0.807665", "-0.534708", "-0.248524"
    .SetConnectedElement1 ""
    .SetConnectedElement2 ""
    .Create
End With

Pick.ClearAllPicks

'@ change dimension 6

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Dimension
    .Reset
    .SetID "6"
    .SetDistance "2.463945"
    .SetOrientation "Smart Mode"
    .SetViewVector "-0.807665", "-0.534708", "-0.248524"
    .Modify
End With


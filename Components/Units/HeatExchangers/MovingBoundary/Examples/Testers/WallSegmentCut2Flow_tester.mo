within Components.Units.HeatExchangers.MovingBoundary.Examples.Testers;
model WallSegmentCut2Flow_tester

replaceable package Medium = ThermoCycle.Media.R245fa_CP (
ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph)
  constrainedby Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

  Modelica.Blocks.Sources.Sine lengthGenerator(
    freqHz=3,
    amplitude=0.1,
    phase=1.5707963267949,
    offset=0.5)
    annotation (Placement(transformation(extent={{-40,-54},{-20,-34}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Flow1DimCut flow1DimCut(
    length=lengthGenerator.y,
    redeclare package Medium = Medium,
    diameter=0.01,
    Mdotnom=1,
    Unom_l=200,
    Unom_tp=2000,
    Unom_v=120,
    pstart=200000,
    Tstart=473.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  WallSegmentCut wall(                         length=lengthGenerator.y,
    steadystate_T_wall=true,
    s_ab=0.002,
    width=1,
    Tstart_wall=373.15)
    annotation (Placement(transformation(extent={{-10,8},{10,28}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot(
    redeclare package Medium = Medium,
    Mdot_0=0.1,
    pstart=200000)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT(
    redeclare package Medium = Medium,
    T=473.15,
    p=200000)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  WallSegmentCut wall1(                        length=lengthGenerator.y,
    steadystate_T_wall=true,
    s_ab=0.002,
    width=1,
    Tstart_wall=373.15)
    annotation (Placement(transformation(extent={{-10,54},{10,74}})));
  Flow1DimCut flow1DimCut1(
    length=lengthGenerator.y,
    redeclare package Medium = Medium,
    diameter=0.01,
    Mdotnom=1,
    Unom_l=200,
    Unom_tp=2000,
    Unom_v=120,
    pstart=2000000,
    Tstart=293.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,86})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot1(
    redeclare package Medium = Medium,
    Mdot_0=0.2,
    pstart=2000000)
    annotation (Placement(transformation(extent={{-50,78},{-70,98}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT1(
    redeclare package Medium = Medium,
    T=293.15,
    p=2000000)
    annotation (Placement(transformation(extent={{72,74},{52,94}})));
equation

  connect(heatFlow.port_a, wall.port_a) annotation (Line(
      points={{-6.12323e-016,30},{0,30},{0,21}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.port_b, flow1DimCut.Wall_int) annotation (Line(
      points={{0,15},{0,12.6},{6.10623e-016,12.6},{6.10623e-016,10.2},{
          6.10623e-016,5.4},{0,5.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(source_pT.flangeB, flow1DimCut.inlet) annotation (Line(
      points={{-60.8,0},{-48.1,0},{-48.1,6.10623e-016},{-35.4,6.10623e-016},
          {-35.4,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(flow1DimCut.outlet, sinkMdot.flangeB) annotation (Line(
      points={{10,-0.2},{36,-0.2},{36,0},{60.2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wall1.port_b, heatFlow.port_b) annotation (Line(
      points={{0,61},{0,55.5},{6.12323e-016,55.5},{6.12323e-016,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(flow1DimCut1.Wall_int, wall1.port_a) annotation (Line(
      points={{-6.61309e-016,80.6},{-6.61309e-016,73.3},{0,73.3},{0,67}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sinkMdot1.flangeB, flow1DimCut1.outlet) annotation (Line(
      points={{-50.2,88},{-32,88},{-32,86},{-10,86},{-10,86.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_pT1.flangeB, flow1DimCut1.inlet) annotation (Line(
      points={{52.8,84},{32,84},{32,86},{10,86}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end WallSegmentCut2Flow_tester;

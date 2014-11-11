within Components.Units.HeatExchangers.MovingBoundary.Examples.Testers;
model WallSegmentCutFlow_tester

replaceable package Medium = ThermoCycle.Media.R245fa_CP (
ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph)
  constrainedby Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         cold
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=2,
    offset=350,
    amplitude=0.1)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine lengthGenerator(
    freqHz=3,
    offset=0.3,
    amplitude=0.05,
    phase=1.5707963267949)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
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
    Tstart_wall=373.15,
    steadystate_T_wall=true)
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
equation

  connect(heatFlow.port_b, cold.port) annotation (Line(
      points={{6.12323e-016,50},{-20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, cold.T) annotation (Line(
      points={{-59,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));

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
      points={{-60.8,0},{-35.4,0},{-35.4,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(flow1DimCut.outlet, sinkMdot.flangeB) annotation (Line(
      points={{10,-0.2},{36,-0.2},{36,0},{60.2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end WallSegmentCutFlow_tester;

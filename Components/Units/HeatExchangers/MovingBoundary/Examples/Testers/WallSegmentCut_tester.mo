within Components.Units.HeatExchangers.MovingBoundary.Examples.Testers;
model WallSegmentCut_tester

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T(displayUnit=
         "K") = 350)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hot
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=50,
    freqHz=2,
    offset=450)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  WallSegmentCut wall(length=sine1.y)
    annotation (Placement(transformation(extent={{-10,6},{10,26}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=0.1,
    freqHz=3,
    phase=1.5707963267949,
    offset=0.3)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-8})));
equation
  connect(sine.y, hot.T)                   annotation (Line(
      points={{-59,50},{-52,50},{-52,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hot.port, wall.port_a) annotation (Line(
      points={{-20,30},{6.10623e-16,30},{6.10623e-16,19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.port_b, heatFlow.port_a) annotation (Line(
      points={{6.10623e-16,13},{6.10623e-16,7.5},{2.44753e-15,7.5},{
          2.44753e-15,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlow.port_b, cold.port) annotation (Line(
      points={{-1.22629e-15,-18},{0,-18},{0,-30},{-20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end WallSegmentCut_tester;

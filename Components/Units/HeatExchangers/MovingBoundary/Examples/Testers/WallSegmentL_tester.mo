within Components.Units.HeatExchangers.MovingBoundary.Examples.Testers;
model WallSegmentL_tester
  WallSegmentL steel(redeclare
      Components.Units.HeatExchangers.MovingBoundary.Materials.DefaultWall
      wallProperties, s_ab=0.015)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T(displayUnit=
         "K") = 350)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  WallSegmentL alu(redeclare
      Components.Units.HeatExchangers.MovingBoundary.Materials.AluminumWall
      wallProperties, s_ab=0.015)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hot
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=50,
    freqHz=2,
    offset=450)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(steel.port_b, alu.port_a) annotation (Line(
      points={{6.10623e-16,17},{6.10623e-16,-17}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alu.port_b, cold.port) annotation (Line(
      points={{6.10623e-16,-23},{6.10623e-16,-30},{-20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hot.port, steel.port_a)                   annotation (Line(
      points={{-20,30},{0,30},{0,23},{6.10623e-16,23}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, hot.T)                   annotation (Line(
      points={{-59,50},{-52,50},{-52,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end WallSegmentL_tester;

within MovingBoundaryLibrary.Spline;
model Test

  SplineFunction SplineFunction1(table=[0,300; 0.5,350; 0.8,400; 1,420])
    annotation (Placement(transformation(extent={{-40,20},{-20,40}}, rotation=
           0)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    height=1,
    duration=0.9,
    offset=0,
    startTime=0.1)
              annotation (Placement(transformation(extent={{-80,22},{-60,42}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    PrescribedTemperature1
    annotation (Placement(transformation(extent={{20,0},{40,20}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor HeatCapacitor1(
                                                             C=1)
    annotation (Placement(transformation(extent={{52,10},{72,30}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    PrescribedTemperature2
    annotation (Placement(transformation(extent={{20,-40},{40,-20}}, rotation=
           0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor HeatCapacitor2(
                                                             C=1)
    annotation (Placement(transformation(extent={{52,-30},{72,-10}}, rotation=
           0)));
  SplineFunction SplineFunction2(table=[0,300; 1,350])
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}},
          rotation=0)));
equation
  connect(Ramp1.y, SplineFunction1.u)
    annotation (Line(points={{-59,32},{-42,32},{-42,30}}, color={0,0,127}));
  connect(SplineFunction1.y, PrescribedTemperature1.T)
    annotation (Line(points={{-19,30},{8,30},{8,10},{18,10}}, color={0,0,127}));
  connect(PrescribedTemperature1.port, HeatCapacitor1.port)
    annotation (Line(points={{40,10},{62,10}}, color={191,0,0}));
  connect(PrescribedTemperature2.port,HeatCapacitor2. port)
    annotation (Line(points={{40,-30},{62,-30}}, color={191,0,0}));
  connect(SplineFunction2.y, PrescribedTemperature2.T)
    annotation (Line(points={{-19,-30},{18,-30}}, color={0,0,127}));
  connect(Ramp1.y, SplineFunction2.u) annotation (Line(points={{-59,32},{-54,32},
          {-54,-30},{-42,-30}}, color={0,0,127}));
  annotation (Diagram(graphics));
end Test;

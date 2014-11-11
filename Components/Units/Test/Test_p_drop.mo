within Components.Units.Test;
model Test_p_drop
replaceable package Medium = ThermoCycle.Media.SES36_CP;
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
      package Medium =                                                              Medium,
    h=198807,
    p0=850000)
    annotation (Placement(transformation(extent={{42,24},{62,44}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    UseNom=true,
    redeclare package Medium = Medium,
    Mdot_nom=0.3388,
    p_nom=835000,
    T_nom=385.15,
    DELTAp_nom=20000)
    annotation (Placement(transformation(extent={{-6,-14},{14,6}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
      package Medium =                                                              Medium,
    Mdot_0=0.3388,
    p=835000,
    T_0=333.15)
    annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
equation
  connect(valve.OutFlow,SinkWater. flangeB) annotation (Line(
      points={{13,-4},{34,-4},{34,34},{43.6,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SourceWater.flangeB, valve.InFlow) annotation (Line(
      points={{-65,-2},{-10,-2},{-10,-4},{-5,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_p_drop;

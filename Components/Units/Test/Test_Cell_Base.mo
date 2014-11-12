within Components.Units.Test;
model Test_Cell_Base
replaceable package Medium = Components.Media.WaterCoolProp;
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=80000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0
      =100000)
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=250,
    duration=10)
    annotation (Placement(transformation(extent={{-124,44},{-104,64}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    redeclare package Medium = Medium,
    UseNom=true,
    Mdot_nom=1,
    p_nom=100000,
    DELTAp_nom=10000)
    annotation (Placement(transformation(extent={{38,-8},{58,12}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceP sourceP(
    redeclare package Medium = Medium,
    UseT=false,
    p0=150000)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(y_start=ramp.offset, T=100)
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
equation
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{57,2},{62,2},{62,-2},{67.6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, firstOrder.u) annotation (Line(
      points={{-103,54},{-100,54},{-100,28},{-96,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, sourceP.in_h) annotation (Line(
      points={{-73,28},{-78,28},{-78,-3},{-84,-3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_Cell_Base;

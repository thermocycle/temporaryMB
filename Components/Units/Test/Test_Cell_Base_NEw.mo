within Components.Units.Test;
model Test_Cell_Base_NEw
replaceable package Medium = Components.Media.WaterCoolProp;
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=80000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0=
       900000)
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=250,
    duration=10,
    offset=27.5e5)
    annotation (Placement(transformation(extent={{-124,44},{-104,64}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceP sourceP(
    redeclare package Medium = Medium,
    p0=1000000,
    UseT=false)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(y_start=ramp.offset, T=100)
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  HeatExchangers.MovingBoundary.Cell_SuperHeated cell_SuperHeated(
    redeclare package Medium = Medium,
    AA=0.005,
    pstart=1000000,
    hstart=27.5e5,
    lstart=2) annotation (Placement(transformation(extent={{-14,-8},{6,12}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    redeclare package Medium = Medium,
    UseNom=true,
    Mdot_nom=1,
    p_nom=900000,
    DELTAp_nom=200000)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, firstOrder.u) annotation (Line(
      points={{-103,54},{-100,54},{-100,28},{-96,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, sourceP.in_h) annotation (Line(
      points={{-73,28},{-78,28},{-78,-3},{-84,-3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceP.flange, cell_SuperHeated.inFlow) annotation (Line(
      points={{-80.6,-10},{-54,-10},{-54,-2},{-14,-2},{-14,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatSource_cell.thermalPort, cell_SuperHeated.thermalPortL)
    annotation (Line(
      points={{-10.1,51.9},{-10.1,29.95},{-4,29.95},{-4,7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(cell_SuperHeated.outFlow, valve.InFlow) annotation (Line(
      points={{6,2.1},{20,2.1},{20,0},{31,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{49,0},{58,0},{58,-2},{67.6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_Cell_Base_NEw;

within Components.Units.Test;
model Test_OnePhase_Base
replaceable package Medium = Components.Media.WaterCoolProp;
  HeatExchangers.MovingBoundary.Cell_OnePhase_Base
                                              cell_OnePhase( redeclare package
      Medium =                                                                          Medium,
    AA=0.5,
    Mdotnom=1,
    Unom=100,
    lstart=2,
    pstart=1000000)
    annotation (Placement(transformation(extent={{-30,-36},{20,24}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
      package Medium =                                                                          Medium,
    Mdot_0=1,
    UseT=false,
    p=2000000,
    T_0=323.15,
    h_0=700000)
    annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=80000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0
      =1000000)
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=250,
    duration=10,
    height=101000,
    offset=660000)
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
equation
  connect(heatSource_cell.thermalPort, cell_OnePhase.thermalPortL) annotation (
      Line(
      points={{-10.1,51.9},{-10.1,31.95},{-5,31.95},{-5,9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP.flangeB, cell_OnePhase.outFlow) annotation (Line(
      points={{67.6,-2},{44,-2},{44,-5.7},{20,-5.7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, cell_OnePhase.inFlow) annotation (Line(
      points={{-73,2},{-54,2},{-54,-6},{-30,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, sourceMdot.in_h) annotation (Line(
      points={{-99,30},{-76,30},{-76,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_OnePhase_Base;

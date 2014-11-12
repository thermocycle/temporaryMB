within Components.Units.Test;
model Test_OnePhase_SC
replaceable package Medium = Components.Media.WaterCoolProp;
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
      package Medium =                                                                          Medium,
    Mdot_0=1,
    p=2000000,
    T_0=323.15)
    annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=80000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0=
       1000000)
    annotation (Placement(transformation(extent={{66,-12},{86,8}})));
  HeatExchangers.MovingBoundary.MBCell_SC mBCell_SC(
    redeclare package Medium = Medium,
    AA=0.5,
    Mdotnom=1,
    Unom=100,
    pstart=1000000)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, mBCell_SC.inFlow) annotation (Line(
      points={{-73,2},{-42,2},{-42,0},{-12,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mBCell_SC.outFlow, sinkP.flangeB) annotation (Line(
      points={{8,0},{40,0},{40,-2},{67.6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatSource_cell.thermalPort, mBCell_SC.thermalPortL) annotation (Line(
      points={{-10.1,51.9},{-10.1,28.95},{-2,28.95},{-2,5}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_OnePhase_SC;

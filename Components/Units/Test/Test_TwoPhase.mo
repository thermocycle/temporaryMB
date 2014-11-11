within Components.Units.Test;
model Test_TwoPhase
replaceable package Medium = ThermoCycle.Media.Water;
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
      package Medium =                                                                          Medium,
    Mdot_0=1,
    p=100000,
    T_0=373.15)
    annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=1000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0=
       100000)
    annotation (Placement(transformation(extent={{76,-12},{96,8}})));
  HeatExchangers.MovingBoundary.Cell_TwoPhase cell_TwoPhase(redeclare package
      Medium =                                                                                  Medium,
    AA=0.5,
    Mdotnom=1,
    Unom=100,
    hstart=417500,
    pstart=100000)
              annotation (Placement(transformation(extent={{-14,-18},{24,24}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
      Medium =                                                                                  Medium,
    UseNom=true,
    Mdot_nom=1,
    p_nom=100000,
    T_nom=373.15,
    DELTAp_nom=20000)
    annotation (Placement(transformation(extent={{32,-6},{52,14}})));
equation
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, cell_TwoPhase.InFlow) annotation (Line(
      points={{-73,2},{-50,2},{-50,3},{-14,3}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatSource_cell.thermalPort, cell_TwoPhase.thermalPortL) annotation (
      Line(
      points={{-10.1,51.9},{-10.1,36},{-2,36},{-2,13.5},{5,13.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(cell_TwoPhase.OutFlow, valve.InFlow) annotation (Line(
      points={{24,3.21},{23,3.21},{23,4},{33,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{51,4},{64,4},{64,-2},{77.6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_TwoPhase;

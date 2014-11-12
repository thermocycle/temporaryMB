within Components.Units.Test;
model Test_TwoPhase_Base
replaceable package Medium = Components.Media.WaterCoolProp;
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot( redeclare
      package Medium =                                                                          Medium,
    Mdot_0=1,
    UseT=false,
    p=100000,
    T_0=373.15,
    h_0=763000)
    annotation (Placement(transformation(extent={{-92,-8},{-72,12}})));
  ThermoCycle.Components.HeatFlow.Sources.HeatSource_cell heatSource_cell
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
  Modelica.Blocks.Sources.Constant const(k=1000)
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                                  Medium, p0=
       1000000)
    annotation (Placement(transformation(extent={{76,-12},{96,8}})));
  HeatExchangers.MovingBoundary.Cell_TwoPhase_Base cell_TwoPhase_Base(
    redeclare package Medium = Medium,
    AA=0.005,
    Mdotnom=1,
    Unom=100,
    pstart=1000000)
    annotation (Placement(transformation(extent={{-32,-14},{16,20}})));
equation
  connect(const.y, heatSource_cell.Phi) annotation (Line(
      points={{-47,76},{-10,76},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, cell_TwoPhase_Base.InFlow) annotation (Line(
      points={{-73,2},{-58,2},{-58,3},{-32,3}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatSource_cell.thermalPort, cell_TwoPhase_Base.thermalPortL)
    annotation (Line(
      points={{-10.1,51.9},{-10.1,40},{-8,40},{-8,11.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(cell_TwoPhase_Base.OutFlow, sinkP.flangeB) annotation (Line(
      points={{16,3.17},{46,3.17},{46,-2},{77.6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_TwoPhase_Base;

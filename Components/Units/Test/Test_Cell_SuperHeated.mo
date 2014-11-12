within Components.Units.Test;
model Test_Cell_SuperHeated
  extends Test_Cell_Base(ramp(offset=2.69311e6, height=0));
  HeatExchangers.MovingBoundary.Cell_SuperHeated cell_OnePhase(
    redeclare package Medium = Medium,
    AA=0.005,
    lstart=2,
    hstart=ramp.offset,
    pstart=sourceP.p0,
    Mdotnom=2.5,
    l_in=sine.y)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.01,
    offset=2,
    startTime=150,
    amplitude=2.5)
    annotation (Placement(transformation(extent={{16,62},{36,82}})));
equation
  connect(cell_OnePhase.thermalPortL, heatSource_cell.thermalPort) annotation (
      Line(
      points={{-2,5},{-2,28.5},{-10.1,28.5},{-10.1,51.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceP.flange, cell_OnePhase.inFlow) annotation (Line(
      points={{-80.6,-10},{-44,-10},{-44,0},{-12,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cell_OnePhase.outFlow, valve.InFlow) annotation (Line(
      points={{8,0.1},{24,0.1},{24,2},{39,2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_Cell_SuperHeated;

within Components.Units.Test;
model Test_Cell_SubCooled
  extends Test_Cell_Base(ramp(offset=400000, height=67250));
  HeatExchangers.MovingBoundary.Cell_SubCooled cell_OnePhase(
    redeclare package Medium = Medium,
    AA=0.005,
    Mdotnom=1,
    lstart=2,
    pstart=sourceP.p0,
    hstart=ramp.offset)
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
equation
  connect(sourceP.flange, cell_OnePhase.inFlow) annotation (Line(
      points={{-80.6,-10},{-48,-10},{-48,0},{-16,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cell_OnePhase.outFlow, valve.InFlow) annotation (Line(
      points={{4,0.1},{21,0.1},{21,2},{39,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatSource_cell.thermalPort, cell_OnePhase.thermalPortL) annotation (
      Line(
      points={{-10.1,51.9},{-10.1,27.95},{-6,27.95},{-6,5}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_Cell_SubCooled;

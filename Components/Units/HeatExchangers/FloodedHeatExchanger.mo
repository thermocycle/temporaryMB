within Components.Units.HeatExchangers;
model FloodedHeatExchanger

  ThermoCycle.Interfaces.Fluid.FlangeA flangeA
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeA flangeA1
    annotation (Placement(transformation(extent={{82,-12},{102,8}})));
  MovingBoundary.Cell_OnePhase cell_OnePhase
    annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
  MovingBoundary.Cell_OnePhase cell_OnePhase1
    annotation (Placement(transformation(extent={{24,-14},{44,6}})));
equation

  connect(flangeA, cell_OnePhase.InFlow) annotation (Line(
      points={{-98,0},{-70,0},{-70,-4},{-48,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cell_OnePhase.OutFlow, cell_OnePhase1.InFlow) annotation (Line(
      points={{-28,-3.9},{24,-3.9},{24,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cell_OnePhase1.OutFlow, flangeA1) annotation (Line(
      points={{44,-3.9},{64,-3.9},{64,-2},{92,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end FloodedHeatExchanger;

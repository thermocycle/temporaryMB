within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
partial model BaseSection
  "One section of the moving boundary system, base class"
  BaseCell baseCell
    annotation (Placement(transformation(extent={{-10,-38},{10,-18}})));
  BaseCell baseCell1
    annotation (Placement(transformation(extent={{10,38},{-10,18}})));
  BaseWall baseWall
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Diagram(graphics));
end BaseSection;

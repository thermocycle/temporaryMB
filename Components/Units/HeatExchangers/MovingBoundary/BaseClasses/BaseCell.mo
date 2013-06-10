within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model BaseCell "Base model for fluid volume not discretized"
 extends Modelica.Fluid.Interfaces.PartialTwoPort;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  annotation (Diagram(graphics));
end BaseCell;

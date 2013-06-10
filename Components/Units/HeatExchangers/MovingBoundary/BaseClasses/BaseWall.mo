within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model BaseWall "Base model for a wall element of a given length"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialConditionalHeatPort;

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor2
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor3
    annotation (Placement(transformation(extent={{18,-62},{38,-42}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=4)
    annotation (Placement(transformation(extent={{-6,26},{14,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b
             port_b1
                    annotation (Placement(transformation(extent={{-10,88},{10,
            108}},    rotation=0)));
  annotation (Diagram(graphics));
end BaseWall;

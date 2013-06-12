within Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.HeatTransferLiquid;
model SimpleGinlieskiHeatTransfer
extends
    Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialConvectiveCorrelation;
import
    Units.HeatExchangers.MovingBoundary.HeatTransfer.HeatTransferLiquid.Gnielinski_Laminar_smooth;

Modelica.SIunits.CoefficientOfHeatTransfer[n] h;
Modelica.SIunits.ThermalConductivity[n] lambda;
Modelica.SIunits.SpecificHeatCapacity[n] cp;
Modelica.SIunits.DynamicViscosity[n] my;

equation
  for i in 1:n loop
    lambda[i] = Medium.thermalConductivity(states[i]);
    cp[i] = Medium.specificHeatCapacityCp(states[i]);
    my[i] = Medium.dynamicViscosity(states[i]);
  h[i] = Gnielisnki_Laminar_smooth(Dhyd=  diameter, m_flow=  M_dot_in, k=  lambda[i], cp=  cp[i], my=  my[i]);
  end for;
end SimpleGinlieskiHeatTransfer;

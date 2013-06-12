within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model PartialConvectiveCorrelation
extends
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer;
input Modelica.SIunits.MassFlowRate Mdotnom "Nomnial Mass flow rate";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient";
input Modelica.SIunits.MassFlowRate M_dot "Inlet massflow";
input Modelica.SIunits.Length diameter "Hydraulic diameter";

end PartialConvectiveCorrelation;

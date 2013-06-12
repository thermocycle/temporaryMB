within Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.HeatTransferLiquid;
model HeatTransfer_OffDesign
extends
    Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialConvectiveCorrelation;

Modelica.SIunits.CoefficientOfHeatTransfer[n] htc;

equation
  for i in 1:n loop
    htc[i] = Unom*(M_dot/Mdotnom)^0.8;
  /* Insert Qflow and T */
Q_flows = {htc[i]*surfaceAreas[i]*(heatPorts[i].T - Ts[i])};
 end for;
end HeatTransfer_OffDesign;

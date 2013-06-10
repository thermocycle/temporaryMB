within Components.Units.HeatExchangers.MovingBoundary.IdealHeatTransfer;
model ConstantHeatTransfer
  "ConstantHeatTransfer: Constant heat transfer coefficient"
  extends
    Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialHeatTransferCorrelation;
  parameter SI.CoefficientOfHeatTransfer alpha0 "heat transfer coefficient";
equation
  Q_flows = {alpha0*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:n};

  annotation(Documentation(info="<html>
<p>Simple heat transfer correlation with constant heat transfer coefficient. </p>
<p>Taken from: Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer</p>
</html>"));
end ConstantHeatTransfer;

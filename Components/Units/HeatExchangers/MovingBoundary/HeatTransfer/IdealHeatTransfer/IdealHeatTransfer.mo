within Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.IdealHeatTransfer;
model IdealHeatTransfer "Cylinder heat transfer without thermal resistance"
  extends
    Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialConvectiveCorrelation;
equation
  Ts = heatPorts.T;
  annotation(Documentation(info="<html>
<p>Ideal heat transfer without thermal resistance. </p>
<p><br/>This is taken from: Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer</p>
</html>"));
end IdealHeatTransfer;

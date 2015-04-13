within MovingBoundaryLibrary.HeatTransfer.Basic;
model Constant
  extends Partial.HeatTransfer;
 parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_cte;
equation
alpha  = alpha_cte;
Q_flow = alpha*g.Si*(Twi - state.T);
end Constant;

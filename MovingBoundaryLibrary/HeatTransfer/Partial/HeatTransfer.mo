within MovingBoundaryLibrary.HeatTransfer.Partial;
partial model HeatTransfer "Base class for heat transfer correlations"
import Modelica.SIunits;
import MBMs.Components.Geometry;
replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model"                        annotation (__Dymola_choicesAllMatching = true);
  SIunits.Temperature Twi "Inner Wall temperature";
  SIunits.MassFlowRate mdot "Mass flow rate";
  SIunits.HeatFlowRate Q_flow "fluid heat flow";
  Medium.ThermodynamicState state "Medium state";
  SIunits.CoefficientOfHeatTransfer alpha "Heat Transfer Coeficient";
 replaceable Geometry.cylindrical_Geometry g "Volume geometry" annotation(Dialog(enable=false,__Dymola_label="Geometry:"));

end HeatTransfer;

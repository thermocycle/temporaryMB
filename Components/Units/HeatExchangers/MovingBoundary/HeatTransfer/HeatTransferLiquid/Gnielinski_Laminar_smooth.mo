within Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.HeatTransferLiquid;
function Gnielinski_Laminar_smooth
// Made by Martin Kærn 25 september 2008
  import Modelica.Constants.pi;
  input Modelica.SIunits.Length Dhyd "Hydraulic diameter";
  input Real m_flow(unit="kg/(s.m.m)") "Mass flux";
  input Modelica.SIunits.ThermalConductivity k;
  input Modelica.SIunits.SpecificHeatCapacity cp;
  input Modelica.SIunits.DynamicViscosity my;

  output Modelica.SIunits.CoefficientOfHeatTransfer htc
    "Heat transfer coefficient";

protected
  Real Re;
  Real Pr;
  Real Nu;
  Real f "Moody's friction factor";

  parameter Real Nu_lam=3.66; //for Ts = constant
  Real f3000;
  Real htc2300;
  Real htc3000;

algorithm
  Re := abs(m_flow*Dhyd/(my*pi*Dhyd^2/4));
  Pr := abs(my*cp/k);

if Re > 3E3 then //Turbulent flow
  //Calculation of Moody's friction factor f and Gnielinski Nu
  f := (0.7904*ln(Re) - 1.64)^(-2);
  Nu := (f/8)*(Re - 1000)*Pr/(1 + 12.7*(f/8)^0.5*(Pr^(2/3) - 1));
  htc := Nu*k/Dhyd;
  //dummy variables
  htc3000 :=0;
  htc2300 :=0;
  f3000:=0;
elseif Re < 2300 then //Laminar flow
  htc :=Nu_lam*k/Dhyd;
  htc3000 :=0;
  htc2300 :=0;
  f3000:=0;
  f:=0;
  Nu:=Nu_lam;
else //Linear smooth
  f3000 :=(0.7904*ln(3000) - 1.64)^(-2);
  htc3000 :=k/Dhyd*(f3000/8)*(3000 - 1000)*Pr/(1 + 12.7*(f3000/8)^0.5*(Pr^(2/3)
       - 1));
  htc2300 :=Nu_lam*k/Dhyd;
  htc :=((Re - 2300)/(3000 - 2300))*(htc3000 - htc2300) + htc2300;
  f:=0;
  Nu:=htc*Dhyd/k;
end if;

end Gnielinski_Laminar_smooth;

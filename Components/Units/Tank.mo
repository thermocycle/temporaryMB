within Components.Units;
package Tank
  model MixedTank
  /*********** Medium **********/
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialMedium
  annotation (choicesAllMatching = true);

  /*********** Parameter *************/
  constant Real pi = Modelica.Constants.pi;
  parameter Modelica.SIunits.Volume V_tank "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_const "Constant value for the pressure";
  parameter Real H_D "Height to diameter ratio";

  /*********** Variables ************/

  Medium.ThermodynamicState fluidState;
  Modelica.SIunits.Pressure p;
  Medium.Density rho "Inlet density";
  Modelica.SIunits.Mass M "Total mass of the fluid stored [kg]";
  Modelica.SIunits.Volume Vl "Volume of the fluid in liquid phase [m3]";
  Modelica.SIunits.Length D_int "diameter";
  Modelica.SIunits.Length H "Height of the tank";
  Modelica.SIunits.Area A_cross "Cross section area of the tank";
  Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
  Modelica.SIunits.SpecificEnthalpy h "Enthalpy [kJ/kg] ";
  Modelica.SIunits.SpecificEnthalpy h_port "Enthalpy at the port";
  Real dM_dt;
  Real dE_dt;

  ThermoCycle.Interfaces.Fluid.FlangeB port( redeclare package Medium=Medium)
      annotation (Placement(transformation(extent={{-18,-98},{10,-72}})));

  equation
    D_int = (V_tank/H_D * 4/pi)^(1/3);
    A_cross = D_int^2*pi/4;
    H = D_int*H_D;

    M = rho * Vl;

    /* Medium */
    p = p_const;
    fluidState = Medium.setState_ph(p,h);
    rho = Medium.density(fluidState);
    drdh = Medium.density_derh_p(fluidState);

  /* Mass balance */
  dM_dt = port.m_flow;
  dM_dt = der(Vl)*rho + Vl*(drdh*der(h));

  /* Energy balance */
  dE_dt = port.m_flow*h_port - p*der(Vl);
  dE_dt = der(h)*M + h*dM_dt;

  h_port = actualStream(port.h_outflow);
  h_port = port.h_outflow;
  port.p = p;

  end MixedTank;
end Tank;

within MovingBoundaryLibrary.Obsolete;
model OnePhase "1-D lumped fluid flow model (Real fluid model)"
  import Components;
replaceable package Medium =
      Components.Media.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

import MovingBoundaryLibrary.Records;
import MovingBoundaryLibrary.Constants;

  /************ Thermal and fluid ports ***********/
 ThermoCycle.Interfaces.Fluid.FlangeA inFlow(redeclare final package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB outFlow(redeclare final package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
public
  Interfaces.MbOut mbOut
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  /************ Geometric characteristics **************/
  constant Real pi=Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Area AA "Channel cross section";
  parameter Modelica.SIunits.Length YY "Channel perimeter";
  parameter Real Ltotal = 40 "Hx total length";
  parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=250
    "Nominal heat transfer coefficient"                                                             annotation (Dialog(group = "Heat transfer"));
  parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));

 /************ INITIAL VALUES ***************/
  parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstart=1 "Start value of length"
    annotation (Dialog(tab="Initialization"));
final parameter Integer nXi = Medium.nXi "mass fraction";

/************* Control Volume ************************/
parameter Boolean alone = true annotation (choices(checkBox=true),Dialog( group="CV",__Dymola_label="Only 1CV?:"));

parameter Boolean subcooled = true "Set to true if cell is subcooled" annotation (Dialog(group = "CV"));

  /***************  VARIABLES ******************/
  /* Geometry */
  Modelica.SIunits.Length ll(start=lstart,min= Modelica.Constants.small)
    "Lenght of this segment";
  Modelica.SIunits.Length la "length at the inlet of the CV";
  Modelica.SIunits.Length lb "length at the outlet of the CV";
  Modelica.SIunits.Velocity dldt "Change of the length with time";
  Modelica.SIunits.Area SS "Lateral area of the cylinder";

  /* Balance variables */
  Modelica.SIunits.MassFlowRate M_dot_a(start=Mdotnom) "Mass flow at inlet";
  Modelica.SIunits.MassFlowRate M_dot_b(start=Mdotnom) "Mass flow at outlet";
  Modelica.SIunits.MassFlowRate dMdt(start=0)
    "Change in mass in control volume";
  Modelica.SIunits.HeatFlowRate H_dot_a(start=Mdotnom*hstart)
    "Enthalpy flow at inlet";
  Modelica.SIunits.HeatFlowRate H_dot_b(start=Mdotnom*hstart)
    "Enthalpy flow at outlet";
  Modelica.SIunits.HeatFlowRate dUdt(start=0)
    "Change in energy in control volume";

  /* Fluid property records, original states */
  Medium.ThermodynamicState fluidState =  Medium.setState_ph(pp,hh)
    "State, mean";
  Medium.SaturationProperties sat =  Medium.setSat_p(pp) "Saturation";

  /* Shorter notation for later access */
  Medium.AbsolutePressure pp(start=pstart) "Fluid pressure, mean";
  Medium.AbsolutePressure p_a(start=pstart) "Fluid pressure at inlet";
  Medium.AbsolutePressure p_b(start=pstart) "Fluid pressure at outlet";

  Medium.SpecificEnthalpy hh(start=hstart) "Fluid enthalpy, mean";
  Medium.SpecificEnthalpy h_a(start=hstart) "Fluid enthalpy at inlet";
  Medium.SpecificEnthalpy h_b(start=hstart) "Fluid enthalpy at outlet";
  Medium.SpecificEnthalpy h_l "Fluid enthalpy, saturated liquid";
  Medium.SpecificEnthalpy h_v "Fluid enthalpy, saturated vapour";

  Medium.Density rho "Fluid density, mean";
  Medium.Density rho_a "Fluid density at inlet";
  Medium.Density rho_b "Fluid density at outlet";
  Modelica.SIunits.Temperature Text "Temperature from the connection element";
  Medium.Temperature TT "Fluid temperature, mean";
  Modelica.SIunits.Temperature T_a "Fluid temperature at inlet";
  Modelica.SIunits.Temperature T_b "Fluid temperature at outlet";

/* Partial derivatives of fluid properties */
  Modelica.SIunits.DerDensityByEnthalpy drdh "Fluid state - rho deriv wrt h";
  Modelica.SIunits.DerDensityByPressure drdp "Fluid state - rho deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l "Fluid state - h_l deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v "Fluid state - h_v deriv wrt p";

  /* Total derivatives of fluid properties wrt time */
  Real drdt "Fluid state - rho deriv wrt time";
  Real dpdt "Fluid state - p deriv wrt time";
  Real dhdt "Fluid state - h deriv wrt time";
  Real dhdt_a "Inlet state - h deriv wrt time";
  Real dhdt_b "outlet state - h deriv wrt time";

  /* Additional variables for display purposes */
  Modelica.SIunits.Volume volume = AA*ll "Control volume";
  Modelica.SIunits.Mass mass = rho*volume "Mass in control volume";

 /* Heat transfer values */
  Real AU "AU value";
  Real C_dot;
  Real NTU;
  Real epsilon;
  Real q_dot;

  // CV Mode
  Records.Mode mode;
  Integer ka = mode.ka;
  Integer kb = mode.kb;
protected
  parameter Integer SH = if subcooled then Constants.OFF else Constants.ON;
  parameter Integer SC = if subcooled then Constants.ON else Constants.OFF;

equation
/* Inlet thermodynamic properties */
 T_a = Medium.temperature_ph(p_a,h_a);
 rho_a = Medium.density_ph(p_a,h_a);

/* Outlet thermodynamic properties */
 T_b = Medium.temperature_ph(p_b,h_b);
 rho_b = Medium.density_ph(p_b,h_b);

/*Equation to close the system */
if alone then
  la = 0;
  mode = Constants.ModeBasic;
//  h_l = 0;
//  h_v = 0;
end if;

  lb = ll + la;

/* Mean Thermodinamic properties */
  hh = 1/2*(h_a + h_b);
  pp = 1/2*(p_a + p_b);

  TT = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  drdh = Medium.density_derh_p(fluidState);
  drdp = Medium.density_derp_h(fluidState);
  dpdt = der(pp);
  drdt = drdp*dpdt + drdh*1/2*(dhdt_a+dhdt_b);
  dhdt = 1/2*(dhdt_a + dhdt_b);
  dldt   = der(ll);
  p_a = p_b;
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(sat);
  dhdp_v = Medium.dDewEnthalpy_dPressure(sat);
/* Two-phase properties */

/* MASS BALANCE */

/* Mass Balance when the cell is connected to another one */
  der(ll)*ka + der(lb)*kb = kb*((-dMdt + AA*(ll*drdt + rho*dldt + rho_a*der(la)))/(rho_b*AA)); // if alone kb = 0 and ka = 1; and der(ll) =0;
                                                                                             // else kb = 1 and ka=0 normal mass balance

if alone then
  /*Mass balance when the cell is alone */
 dhdt_b*SC + dhdt_a*SH =  ka*((dMdt +AA*(rho_b*der(lb)-rho_a*der(la))-
 rho*der(ll)*AA -AA*ll*drdp*dpdt -AA*ll*drdh*1/2*(dhdt_a*SC + dhdt_b*SH))/(1/2*drdh*AA*ll))  + kb*(SC*der(h_l)+SH*der(h_v));
  dhdt_a = der(h_a);
  dhdt_b = der(h_b);
  /* This further ifs are needed to avoid error due to DAE index reduction --> See annotation for further details*/
elseif not
(alone) and SC ==1 then
h_b = h_l;
dhdt_b = dhdp_l*der(pp);
dhdt_a = der(h_a);
elseif not
(alone) and SH ==1 then
h_a = h_v;
dhdt_b = der(h_b);
dhdt_a = dhdp_v*der(pp);
else
  h_b*SC + h_a*SH = h_l*SC + h_v*SH;
  dhdt_a = der(h_a);
  dhdt_b = der(h_b);
end if;

  dMdt = M_dot_a - M_dot_b;

  /* ENERGY BALANCE */
  dUdt = H_dot_a - H_dot_b + q_dot "No work is done";
  dUdt   = (rho*hh*dldt + rho*ll*dhdt + drdt*hh*ll - ll*dpdt + h_a*rho_a*der(la) - h_b*rho_b*der(lb)) * AA;

 /* HEAT TRANSFER */
  AU = YY*ll*Unom;
  C_dot = M_dot_a*Medium.specificHeatCapacityCp(fluidState);
  NTU = AU/C_dot;
  epsilon =  1 - exp(-NTU);

  SS = YY*ll;
if eps_NTU then
q_dot = C_dot*epsilon*(Text-TT*SC- T_b*SH);
else
q_dot = SS*Unom*(Text - TT*SC - T_b*SH);
end if;

  /* Energy boundaries */
  H_dot_a = M_dot_a*h_a;
  H_dot_b = M_dot_b*h_b;

q_dot = mbOut.Q_flow;
Text = mbOut.T;
mbOut.ll = ll;
mbOut.Cdot = C_dot;
/* Boundaries and connectors */
    h_a = inStream(inFlow.h_outflow);
    h_a = inFlow.h_outflow;
    h_b = outFlow.h_outflow;
    p_a = inFlow.p;
    p_b = outFlow.p;

  /* Mass and substance flows, no composition changes */
  M_dot_a = inFlow.m_flow;
  M_dot_b = -outFlow.m_flow;

  inFlow.Xi_outflow  = inStream(outFlow.Xi_outflow);
  outFlow.Xi_outflow = inStream(inFlow.Xi_outflow);
  inFlow.C_outflow  = inStream(outFlow.C_outflow);
  outFlow.C_outflow = inStream(inFlow.C_outflow);
initial equation
  if alone then
    ll = Ltotal;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={175,255,200}),       Text(
          extent={{-80,20},{80,-20}},
          lineColor={0,0,0},
          textString="1Phase")}),Documentation(info="<HTML>
          
          <p><big>Model <b>OnePhase</b> describes the flow of a fluid in <b>single phase</b> through a channel of variable length.
          When the model is simulated alone the length is fixed to the total length of the channel.
          <p><big><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. 
       <p><big>The assumptions for this model are:
         <ul><li> The tube is cylindrical with a constant cross sectional area.
         <li> Kinetic energy, gravitational forces and viscous stresses are neglected.
         <li> A static momentum balance is considered
         <li> Constant pressure is assumed in the region.
         <li> No work is done on or generated by the control volume.
         <li> Linear distribution of enthalpy is assumed in the region.
         <li> The rate of thermal energy addition due to heat conduction is neglected.
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

<p><big>The model is characterized by two flow connector and one special lumped thermal port connector which considered as an output the length of the zone.
<p><big> In order to have the model capable of working as a stand alone model or connected to a 
<a href=\"modelica://Components.Units.HeatExchangers.Attempts_AD.Components.Complete.Cells.TwoPhase\">TwoPhase</a> model, two mass balances are written.

<p><big>  In case of a <b>flooded evaporator</b> the derivative of the enthalpy at the outlet of the component h_b is expressed as a function of pressure in order to avoid a DAE index reduction problem when pressure changes:
<p>
<img src=\"modelica://Components/Resources/Images/dhdt_b.png\">
</p> 

<p><big>  In case of a <b>Dry evaporator</b> the derivative of the enthalpy at the inlet of the component h_a need is expressed as a function of pressure in order to avoid a DAE index reduction problem when pressure changes:
<p>
<img src=\"modelica://Components/Resources/Images/dhdt_a.png\">
</p> 

<p><big> where h_l and h_v are the saurated liquid and vapor enthalpy respectively.


<p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are availabe:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> eps_NTU: if true the epsilon-NTU method is used to solve the thermal energy transfer through the lateral surface.
        <li> Only1CV: Set to true if the model is simulated alone - to false if connected to a TwoPhase model.
        <li> subcooled: if true the fluid is considered subcooled - to false the fluid is considered superheated. </ul> 
          </HTML>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end OnePhase;

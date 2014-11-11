within Components.Units.HeatExchangers.MovingBoundary;
model Cell_TwoPhase "1-D lumped fluid flow model for two-phase flow"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

/************ Thermal and fluid ports ***********/
 ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));

/************ Geometric characteristics **************/
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Area AA "Cross sectional area";
  final parameter Modelica.SIunits.Length rr = sqrt(AA/pi) "radius of the tube";
  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";

 /************ FLUID INITIAL VALUES ***************/
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));

/***************  VARIABLES ******************/
  Modelica.SIunits.Length ll;
  Medium.SaturationProperties sat;
  Medium.AbsolutePressure pp(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_a(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_b(start=Mdotnom);
  Medium.Temperature TT "Fluid temperature";
  Medium.Density rho_a "Fluid cell density";
  Medium.Density rho_b "Fluid cell density";
  Medium.Density rho_l "Fluid cell density";
  Medium.Density rho_v "Fluid cell density";
  Modelica.SIunits.SpecificEnthalpy h_b(start=hstart)
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy h_a(start=hstart)
    "Enthalpy state variable at outlet node";
  Real dhdt_a;
  Real dhdt_b;
  Real Dz_a;
  Real Dz_b;
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l "TP:SatLiq - h deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v;
  Modelica.SIunits.DerDensityByPressure drdp_l "TP: SatLiq - D deriv wrt p ";
  Modelica.SIunits.DerDensityByPressure drdp_v "TP: SatVap - D deriv wrt p";
  Real q_dot;

 Real dVVdt;
 Real VV;
 Real Gamma_a;
 Real Gamma_b;
 Real GG;
 Real Dh_ab;
 Real Dh_lv;
 Real Dr_lv;
 Real Theta_a;
 Real Theta_b;
 Real Dh_ab_lv;
 Real dVVdp;
 Real dVVdha;
 Real dVVdhb;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL thermalPortL
    annotation (Placement(transformation(extent={{-20,40},{20,60}})));

equation
  /* Fluid Properties */
  sat = Medium.setSat_p(pp);
  TT = Medium.saturationTemperature_sat(sat);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  rho_v =  Medium.dewDensity(sat);
  rho_l = Medium.bubbleDensity(sat);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(sat);
  dhdp_v = Medium.dDewEnthalpy_dPressure(sat);
  drdp_l = Medium.dBubbleDensity_dPressure(sat);
  drdp_v = Medium.dDewDensity_dPressure(sat);

/* MASS BALANCE */
AA*(ll*der(ll)*(VV*rho_v + (1-VV)*rho_l) + ll*(dVVdt*(rho_v - rho_l)+VV*drdp_v*der(pp) + (1-VV)*drdp_l*der(pp)))
+ rho_a*AA*Dz_a - rho_b*AA*Dz_b = M_dot_a - M_dot_b;

/* ENERGY BALANCE */
AA*(der(ll)*(VV*rho_v*h_v + (1-VV)*rho_l*h_l) + ll*(dVVdt*(rho_v*h_v - rho_l*h_l)+VV*drdp_v*der(pp)*h_v
+VV*rho_v*dhdp_v*der(pp) +(1-VV)*drdp_l*der(pp)*h_l +(1-VV)*rho_l*dhdp_l*der(pp))) - AA*ll*der(pp) +AA*rho_a*h_a*Dz_a -
AA*rho_b*h_b*Dz_b = M_dot_a*h_a - M_dot_b*h_b +q_dot;

/* Void fraction */
Dh_ab = h_a - h_b;
Dh_lv = h_l - h_v;
Dr_lv = rho_l - rho_v;
Gamma_a = Components.Units.HeatExchangers.MovingBoundary.Functions.Gamma(hh=  h_a, rho_l= rho_l,rho_v=  rho_v, h_l=  h_l, h_v= h_v);
Gamma_b = Components.Units.HeatExchangers.MovingBoundary.Functions.Gamma(hh=  h_b, rho_l= rho_l,rho_v=  rho_v, h_l=  h_l, h_v= h_v);
GG = Gamma_a/Gamma_b;
Theta_a =Components.Units.HeatExchangers.MovingBoundary.Functions.Theta( hh=  h_a, h_l=  h_l,drdp_l=  drdp_l, rho_l=  rho_l,  dhdp_l= dhdp_l,h_v=  h_v, drdp_v=  drdp_v, rho_v=  rho_v, dhdp_v=  dhdp_v);
Theta_b =Components.Units.HeatExchangers.MovingBoundary.Functions.Theta(hh=  h_b, h_l=  h_l,drdp_l=  drdp_l, rho_l=  rho_l,  dhdp_l= dhdp_l,h_v=  h_v, drdp_v=  drdp_v, rho_v=  rho_v, dhdp_v=  dhdp_v);
Dh_ab_lv = - Dh_ab + Dh_lv*log(GG);

/* Void fraction */
VV = (rho_l^2*(h_a - h_b) +rho_l*rho_v*(h_b - h_a + (h_l -h_v)*log(GG)))/((h_a - h_b)*(rho_l - rho_v)^2);

/* Void fraction derivative wrt time */
dVVdt = dVVdp*der(pp) +dVVdha*dhdt_a + dVVdhb*dhdt_b;

/* Void fraction derivative wrt p */
dVVdp = drdp_l/(Dh_ab*Dr_lv^2)*(Dh_ab*rho_l + rho_v*Dh_ab_lv) -
 2*rho_l*(drdp_l -drdp_v)/(Dh_ab*Dr_lv^3)*(Dh_ab*rho_l + Dh_ab_lv*rho_v) +
rho_l/(Dh_ab*Dh_lv^2)*( Dh_ab*drdp_l +drdp_v*Dh_ab_lv +
rho_v*((dhdp_l -dhdp_v)*log(GG) +Dh_lv/Gamma_a*(Theta_a - GG*Theta_b)));

/* Void fraction derivative wrt h_a */
dVVdha = - rho_l/(Dh_ab^2*Dr_lv^2)*(Dh_ab*rho_l +rho_v*Dh_ab_lv) +
rho_l/(Dh_ab*Dr_lv^2)*(rho_l + rho_v*(-1 + Dh_lv*Dr_lv/Gamma_a));

/* Void fraction derivative wrt h_b */
dVVdhb = +rho_l/(Dh_ab^2*Dr_lv^2)*(Dh_ab*rho_l +rho_v*Dh_ab_lv) +
rho_l/(Dh_ab*Dr_lv^2)*(-rho_l +rho_v*(1 - Dh_lv*Dr_lv/Gamma_b));

q_dot = thermalPortL.phi*(2*pi*rr*ll);
TT = thermalPortL.T;

rho_a = Medium.density_ph(pp,h_a);
rho_b = Medium.density_ph(pp,h_b);
Dz_a = -der(ll);
Dz_b = +der(ll);
h_a = h_l;
//h_b = h_v;
dhdt_b = +der(h_b);
dhdt_a = +der(h_a);

//* BOUNDARY CONDITIONS *//
/* Enthalpies */
h_a = inStream(InFlow.h_outflow);
InFlow.h_outflow = h_a;
h_b = inStream(OutFlow.h_outflow);
OutFlow.h_outflow = h_b;

/* pressures */
 pp = OutFlow.p;
 InFlow.p = pp;
/*Mass Flow*/
 M_dot_a = InFlow.m_flow/Nt;
   OutFlow.m_flow/Nt = -M_dot_b;

InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-88,24},{92,-20}},
          lineColor={0,0,255},
          textString="%Cell1D")}),Documentation(info="<HTML>
          
         <p><big>Model <b>Cell1Dim</b> describes the flow of fluid through a single cell. An overall flow model can be obtained by interconnecting several cells in series 
         (see <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a></FONT></em>).
         
          <p><big><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. 
          <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. The relation between the cell and node values depends on the discretization scheme selected. 
 <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic mass and energy balances and on a static momentum balance
         <li> Constant pressure is assumed in the cell
         <li> Axial thermal energy transfer is neglected
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

 <p><big>The model is characterized by two flow connector and one lumped thermal port connector. During normal operation the fluid enters the model from the <em>InFlow</em> connector and exits from the <em>OutFlow</em> connector. In case of flow reversal the fluid direction is inversed.
 <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>Cell1Dim</em> model. 
        
        <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are availabe:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> HeatTransfer: the user can choose the thermal energy model he prefers </ul> 
        <p><big> In the <b>Initialization</b> tab the following options are availabe:
        <ul><li> steadystate: If it sets to true, the derivative of enthalpy is sets to zero during <em>Initialization</em> 
         </ul>
        <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method. The authors recommend the <em>UpWind Scheme - AllowsFlowReversal</em> in case flow reversal is expected.
<li> Mdotconst: assume constant mass flow rate at each node.
<li> max_der: if true the density derivative is truncated during phase change
<li> filter_dMdt: if true a first order filter is applied to the fast variations of the density with respect to time
<li> max_drhodt: it represents the maximum value of the density derivative. It activates when using max_der is set to true
<li> TT: it represents the integration time of the first order filter. It activates when filter_dMdt is set to true
<li> ComputeSat: if false saturation properties are not computed in the fluid model and they can be passed as a parameter.
 </ul>
 <p><big> 
        </HTML>"));
end Cell_TwoPhase;

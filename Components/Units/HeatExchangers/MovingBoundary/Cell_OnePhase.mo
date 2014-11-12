within Components.Units.HeatExchangers.MovingBoundary;
model Cell_OnePhase "1-D lumped fluid flow model (Real fluid model)"
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
parameter Modelica.SIunits.Length ll_start "Start value of length"
                                                                  annotation (Dialog(tab="Initialization"));
/****************** ControlVolume Options  ***********************/
import Components.Units.HeatExchangers.MovingBoundary.Enumerations.OnePhase;
parameter OnePhase PhaseSelection=OnePhase.SC;

output Modelica.SIunits.Length ll_output;
/***************  VARIABLES ******************/
  Modelica.SIunits.Length ll(start= ll_start);
  Medium.ThermodynamicState  fluidState;
  Medium.SaturationProperties sat;
  Medium.AbsolutePressure pp(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_a(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_b(start=Mdotnom);
  Medium.SpecificEnthalpy hh(start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature TT "Fluid temperature";
  Medium.Density rho "Fluid cell density";
  Medium.Density rho_a "Fluid cell density";
  Medium.Density rho_b "Fluid cell density";
  Medium.Density rho_l "Fluid cell density";
  Medium.Density rho_v "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy h_b(start=hstart)
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy h_a(start=hstart)
    "Enthalpy state variable at outlet node";
  Real  Drho_dt;
  Real Dh_dt;
  Real Dh_dt_a;
  Real Dh_dt_b;
  Real Dz_a;
  Real Dz_b;
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l "TP:SatLiq - h deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v;
 Real AU;
 Real C_dot;
 Real NTU;
 Real epsilon;
 Real q_dot;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL thermalPortL
    annotation (Placement(transformation(extent={{-20,40},{20,60}})));

equation
  ll_output = ll;
 if (h_a>h_l) then
 //ll = 0;
 rho_b = rho_a; /* Fictisus value not use in the equation */
 rho_a = Medium.density_ph(pp,h_a);
 Dz_a = 0;
 Dz_b = der(ll);
 Dh_dt_a = der(InFlow.h_outflow);
 Dh_dt_b = Dh_dt_a;
 h_b = h_a;
 else
if (PhaseSelection == OnePhase.SC) then
rho_b = rho_l;
rho_a = Medium.density_ph(pp,h_a);  /* Fictisus value not use in the equation */
Dz_a = 0;
Dz_b = der(ll);
Dh_dt_a = der(InFlow.h_outflow);
Dh_dt_b = dhdp_l*der(pp);
h_b = h_l;
else
 rho_b = Medium.density_ph(pp,h_b);  /* Fictisus value not use in the equation */
 rho_a = rho_v;
 Dz_a = 0;
 Dz_b = der(ll);
 Dh_dt_a = dhdp_v*der(pp);
 Dh_dt_b = der(OutFlow.h_outflow);
 h_a = h_v;
end if;
end if;

  /* Fluid Properties */
  sat = Medium.setSat_p(pp);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  rho_v =  Medium.dewDensity(sat);
  rho_l = Medium.bubbleDensity(sat);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(sat);
  dhdp_v = Medium.dDewEnthalpy_dPressure(sat);
  fluidState = Medium.setState_ph(pp,hh);
  drdh = Medium.density_derh_p(fluidState);
  drdp = Medium.density_derp_h(fluidState);
  TT = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);

hh = 1/2*(h_a+h_b);
/* MASS BALANCE */
AA*(ll*Drho_dt + rho*der(ll)) +rho_a*AA*Dz_a - rho_b*AA*Dz_b = M_dot_a - M_dot_b;

Drho_dt = drdp*der(pp) + 1/2*drdh*(Dh_dt_a+Dh_dt_b);

/* ENERGY BALANCE */
AA*(rho*hh*der(ll) + rho*ll*Dh_dt + Drho_dt*hh*ll) - AA*ll*der(pp) +AA*h_a*rho_a*Dz_a - AA*h_b*rho_b*Dz_b = M_dot_a*h_a - M_dot_b*h_b + q_dot;
Dh_dt = 1/2*(Dh_dt_a + Dh_dt_b);

  AU = 2*pi*rr*ll*Unom;
  C_dot = (M_dot_a+M_dot_b)/2*Medium.specificHeatCapacityCp(fluidState);
  NTU = AU/C_dot;
  epsilon =  1 - exp(-NTU);

  //q_dot = AU*(T_wall - TT);

q_dot = thermalPortL.phi*(2*pi*rr*ll);
TT = thermalPortL.T;

//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
 h_a = inStream(InFlow.h_outflow);
  InFlow.h_outflow = h_a;
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
end Cell_OnePhase;

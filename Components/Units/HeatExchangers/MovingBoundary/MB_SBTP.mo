within Components.Units.HeatExchangers.MovingBoundary;
model MB_SBTP
  "Moving Boundary model: Fluid enters subcooled and exits in two phase"

/**************** MEDIUM ***************************/
replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

/***************** PORTS ******************/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow
    annotation (Placement(transformation(extent={{-108,-12},{-88,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Components.Units.HeatExchangers.MovingBoundary.MB_SBTPport
         MB_port
    annotation (Placement(transformation(extent={{-74,8},{70,116}})));

/*********** GENERAL VARIABLES AND PARAMETER ***********/
parameter Modelica.SIunits.Area A "Cross-sectional area";
parameter Modelica.SIunits.Length L "Total length of the exchanger";
final parameter Modelica.SIunits.Length D = 2*sqrt(A/pi) "Diameter";
constant Real pi = Modelica.Constants.pi;

Modelica.SIunits.Pressure p(start=0)
    "Pressure in the heat-exchanger: No pressure drop considered";
Modelica.SIunits.SpecificEnthalpy h_SU
    "Enthalpy at the inlet of the heat exchanger";
Modelica.SIunits.SpecificEnthalpy h_EX(start= 0)
    "Enthalpy at the inlet of the heat exchanger";

/*************** Wall between the fluids *************************/
parameter Modelica.SIunits.Mass M_tot
    "Total mass of metal walll between the fluids";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall
    "Heat capacity of the wall - assumed constant in the whole heat exchanger";
parameter Modelica.SIunits.Density rho_wall
    "Density of the wall - assumed constant in the whole heat exchanger";

/********** MASS FLOWS *******************/
Modelica.SIunits.MassFlowRate M_dot_su
    "Mass flow at the inlet of the heat exchanger";
Modelica.SIunits.MassFlowRate M_dot_A
    "Mass flow at the interface between sub-cooled and two-phase";
Modelica.SIunits.MassFlowRate M_dot_ex
    "Mass flow at the outlet of the heat exchanger";

/*****************HEAT FLOW *************************/
Modelica.SIunits.Power Q_SB "Thermal energy transfer with the wall";
Modelica.SIunits.Power QwSB
    "Thermal energy transfer to the wall SUB-COOLED REGION";
Modelica.SIunits.Power QwTP
    "Thermal energy transfer to the wall TWO-PHASE REGION";
Modelica.SIunits.Power Q_TP
    "Thermal energy transfer with the wall in the two-phase region";

/************ SUB-COOLED REGION (SB) ****************/

parameter Modelica.SIunits.CoefficientOfHeatTransfer U_SB
    "Heat transfer coefficient sub-cooled side";
Modelica.SIunits.Length L_SB "Length of the subcooled region";
Medium.ThermodynamicState SubCooled "Subcooled thermodynamic state";
Modelica.SIunits.SpecificEnthalpy h_SB "Mean Enthalpy of the subcooled region";
//Modelica.SIunits.Pressure p_SB "pressure of the subcooled region";
Modelica.SIunits.Temperature T_SB "Mean Temperatue of the subcooled region";
Modelica.SIunits.Density rho_SB "Mean density of the subcooled region";
Modelica.SIunits.DerDensityByEnthalpy drdh_SB
    "Density derivative with respect to enthalpy at constant pressure in the subcooled region";
Modelica.SIunits.DerDensityByPressure drdp_SB
    "Density derivative with respect to pressure at constant enthalpy in the subcooled region";
Real drdt_SB "Density derivative with respect to time in the subcooled region";
Real dhdt_SB "Enthalpy derivative with respect to time in the subcooled region";

/*********** VARIABLES WALL (wSB) **************************/
Modelica.SIunits.Temperature TwSB
    "Mean Wall temperature in the sub-cooled region";
Modelica.SIunits.Temperature TwA
    "Wall Temperature at the interface between sub-cooled and two-phase";
Modelica.SIunits.Temperature TwTP
    "Mean Wall Temperature in the two-phase region";

/************** VARIABLES SATURATED REGION *******************/
Medium.SaturationProperties sat;
Modelica.SIunits.Density rho_LS "Bubble density";
Modelica.SIunits.Density rho_VS "Dew density";
Modelica.SIunits.SpecificEnthalpy h_LS "Bubble enthalpy";
Modelica.SIunits.SpecificEnthalpy h_VS "Dew enthalpy";
Modelica.SIunits.DerDensityByPressure drdp_LS
    "Bubble point density derivative with respect to pressure";
Modelica.SIunits.DerDensityByPressure drdp_VS
    "Dew point density derivative with respect to pressure";
Modelica.SIunits.DerEnthalpyByPressure dhdp_LS
    "Bubble point specific enthalpy derivative with respect to pressure";
Modelica.SIunits.DerEnthalpyByPressure dhdp_VS
    "Dew point specific enthalpy derivative with respect to pressure";

/************ TWO-PHASE REGION (TP) ****************/
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_TP
    "Heat transfer coefficient two-phase side";
parameter Real Void "Void fraction assumed constant for now";
parameter Real dVoid_dp "Void fraction derivative with respect to pressure";
parameter Real dVoid_dh "Void fraction derivative with respect to enthalpy";
Modelica.SIunits.Length L_TP "Length of the two-phase region";
Modelica.SIunits.SpecificEnthalpy h_TP "Mean Enthalpy of the two-phase region";
//Modelica.SIunits.Pressure p_TP "pressure of the two-phase region";
Modelica.SIunits.Temperature T_TP "Mean Temperatue of the two-phase region";
Modelica.SIunits.Density rho_TP "Mean density of the two-phase region";
Real drdt_TP "Density derivative with respect to time in the two-phase region";
Real drhdt_TP
    "Density and Enthalpy derivative with respect to time in the two-phase region";

equation
  /****************** BOUNDARY EQUATION *************************/
  TwSB = MB_port.TwSB;
  TwTP = MB_port.TwTP;
  QwSB = MB_port.QwSB;
  QwTP = MB_port.QwTP;
  L_SB = MB_port.L_SB;
  L_TP = MB_port.L_TP;

  der(L_SB)=-der(L_TP);
  L = L_SB + L_TP;

// Write boundary equation for inlet and outlet
/********** Enthalpies ************/
h_SU = inStream(InFlow.h_outflow);
h_EX = OutFlow.h_outflow;
0 = InFlow.h_outflow;

/*************** Pressure **************/
InFlow.p = p;
OutFlow.p = p;

/***********Mass Flow ******************/
InFlow.m_flow = M_dot_su;
OutFlow.m_flow = -M_dot_ex;

/******************************************************************************************/
/**************** SUB-COOLED REGION *****************/
/******************************************************************************************/

/************ CONSTITUTIVE EQUATION ************************/
SubCooled = Medium.setState_ph(p,h_SB);
T_SB = Medium.temperature(SubCooled);
rho_SB = Medium.density(SubCooled);
drdh_SB = Medium.density_derh_p(SubCooled);
drdp_SB = Medium.density_derp_h(SubCooled);

h_SB = (h_SU + h_LS)/2 "Mean enthalpy of the subcooled region";
TwA = (TwSB*L_TP + TwTP*L_SB)/(L_TP +L_SB)
    "Wall Temperature at the border between one-phase and two-phase region";

Q_SB = pi*D*L_SB*U_SB*(TwSB -T_SB);

/************ MASS BALANCE ****************/
  A*(L_SB*drdt_SB + (rho_SB - rho_LS)*der(L_SB)) = M_dot_su - M_dot_A;

  drdt_SB = (drdp_SB +(1/2)*drdh_SB*dhdp_LS)*der(p) +(1/2)*drdh_SB*der(h_SU);

/********** ENERGY BALANCE ******************/
A*L_SB*(rho_SB*dhdt_SB + h_SB*drdt_SB - der(p)) +
A*(rho_SB*h_SB -rho_LS*h_LS)*der(L_SB) = M_dot_su*h_SU - M_dot_A*h_LS + Q_SB;

dhdt_SB = (1/2)*(dhdp_LS*der(p) + der(h_SU));

/*******  WALL ENERGY BALANCE **********/
(c_wall*M_tot/L)*(L_SB*der(TwSB) + (TwSB -TwA)*der(L_SB)) = Q_SB - QwSB;

/************** SATURATION VARIABLE EQUATIONS *******************************/
sat = Medium.setSat_p(p);
T_TP = Medium.saturationTemperature_sat(sat);
rho_LS = Medium.bubbleDensity(sat);
rho_VS = Medium.dewDensity(sat);
drdp_LS = Medium.dBubbleDensity_dPressure(sat);
drdp_VS = Medium.dDewDensity_dPressure(sat);
h_LS = Medium.bubbleEnthalpy(sat);
h_VS = Medium.dewEnthalpy(sat);
dhdp_LS = Medium.dBubbleEnthalpy_dPressure(sat);
dhdp_VS = Medium.dDewEnthalpy_dPressure(sat);

/******************************************************************************************/
/**************** TWO-PHASE REGION *****************/
/******************************************************************************************/

/**************** CONSTITUTIVE EQUATION ***********************/

// dVoid_dp = 0;
// dVoid_dh = 0;

rho_TP = rho_VS*Void + rho_LS*(1-Void);
h_TP = h_VS*Void + h_LS*(1-Void);

h_TP = (h_LS + h_EX)/2 "Mean enthalpy of the two-phase region";
Q_TP = pi*D*L_TP*U_TP*(TwTP - T_TP);

/************ MASS BALANCE ******************/
A*(L_TP*drdt_TP + (rho_LS -rho_TP)*der(L_SB)) = M_dot_A - M_dot_ex;
drdt_TP = (Void*drdp_VS + (1-Void)*drdp_LS)*der(p) + (rho_VS - rho_LS)*(dVoid_dp*der(p) + dVoid_dh*der(h_EX));

/************ ENERGY BALANCE ******************/
A*(L_TP*drhdt_TP + (rho_LS*h_LS -rho_TP*h_TP)*der(L_SB) - L_TP*der(p)) = M_dot_A*h_LS -M_dot_ex*h_EX + Q_TP;

drhdt_TP = (Void*(drdp_VS*h_VS + rho_VS*drdp_VS) + (1-Void)*(h_LS*drdp_LS + rho_LS*dhdp_LS))*der(p) +
(rho_VS*h_VS -rho_LS*h_LS)*(dVoid_dp*der(p) + dVoid_dh*der(h_EX));

/***************** WALL ENERGY BALANCE **************/
(c_wall*M_tot/L)*(L_TP*der(TwTP) + (TwA -TwTP)*der(L_SB))  = Q_TP - QwTP;

end MB_SBTP;

within Components.Units.HeatExchangers.MovingBoundary;
model MBeva
  "Moving Boundary model: Fluid enters subcooled and exits in super-heated conditons. The model consider the fluid in one side and the metal wall"

/**************** MEDIUM ***************************/
replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

/***************** PORTS ******************/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-108,-12},{-88,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
 Components.Units.HeatExchangers.MovingBoundary.MBHTB_AD
         MB_port
    annotation (Placement(transformation(extent={{-60,60},{70,100}})));

/***********THERMODYNAMIC STATES *********************/
Medium.ThermodynamicState SubCooled "Subcooled thermodynamic state";
Medium.SaturationProperties sat;
Medium.ThermodynamicState SuperHeated "Superheated thermodynamic state";
Medium.ThermodynamicState outlet "Outlet thermodynamic state";

/************* Tube pressure *****************/
Modelica.SIunits.Pressure p(start=0)
    "Pressure in the heat-exchanger: No pressure drop considered";

/*********** GENERAL VARIABLES AND PARAMETER ***********/
parameter Modelica.SIunits.Area A "Cross-sectional area";
parameter Modelica.SIunits.Length L "Total length of the exchanger";
final parameter Modelica.SIunits.Length D = 2*sqrt(A/pi) "Diameter";
constant Real pi = Modelica.Constants.pi;

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
    Modelica.SIunits.MassFlowRate M_dot_B
    "Mass flow at the interface between sub-cooled and two-phase";
Modelica.SIunits.MassFlowRate M_dot_ex
    "Mass flow at the outlet of the heat exchanger";

/*****************HEAT FLOW *************************/
Modelica.SIunits.Power Q_SB "Thermal energy transfer with the wall";
Modelica.SIunits.Power Q_TP
    "Thermal energy transfer with the wall in the two-phase region";
Modelica.SIunits.Power Q_SH
    "Thermal energy transfer with the wall in the superheated region";

Modelica.SIunits.Power QwSB
    "Thermal energy transfer to the wall SUB-COOLED REGION";
Modelica.SIunits.Power QwTP
    "Thermal energy transfer to the wall TWO-PHASE REGION";
Modelica.SIunits.Power QwSH
    "Thermal energy transfer to the wall in the superheated region";
Modelica.SIunits.Power Q_tot
    "Total thermal energy transfer from the wall to the primary fluid";

/***************** TEMPERATURES *************************/
Modelica.SIunits.Temperature T_SB "Mean Temperatue of the subcooled region";
Modelica.SIunits.Temperature T_TP "Mean Temperatue of the two-phase region";
Modelica.SIunits.Temperature T_SH "Mean Temperatue of the superheated region";

Modelica.SIunits.Temperature TwSB(start=0)
    "Mean Wall temperature in the sub-cooled region";
Modelica.SIunits.Temperature TwTP(start=0)
    "Mean Wall Temperature in the two-phase region";
Modelica.SIunits.Temperature TwSH(start=0)
    "Mean Wall Temperature in the super-heated region";

Modelica.SIunits.Temperature TwA
    "Wall Temperature at the interface between sub-cooled and two-phase";
Modelica.SIunits.Temperature TwB
    "Wall Temperature at the interface between two-phase and super-heated";
Modelica.SIunits.Temperature T_out
    "Temperature at the outlet of the moving boundary model";

/*************** HEAT TRANSFER PARAMETER ****************/
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_SB
    "Heat transfer coefficient sub-cooled side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_TP
    "Heat transfer coefficient two-phase side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_SH
    "Heat transfer coefficient Superheated side";

/*************Tube region length ********************/
Modelica.SIunits.Length L_SB(start=0) "Length of the subcooled region";
Modelica.SIunits.Length L_TP(start=0) "Length of the two-phase region";
Modelica.SIunits.Length L_SH "Length of the Superheated region";

/********** Densities ***************/
Modelica.SIunits.Density rho_SB "Mean density of the subcooled region";
Modelica.SIunits.Density rho_LS "Bubble density";
Modelica.SIunits.Density rho_VS "Dew density";
Modelica.SIunits.Density rho_TP "Mean density of the two-phase region";
Modelica.SIunits.Density rho_SH "Mean density of the superheated region";

/************** Enthalpies ************************/
Modelica.SIunits.SpecificEnthalpy h_SB "Mean Enthalpy of the subcooled region";
Modelica.SIunits.SpecificEnthalpy h_LS "Bubble enthalpy";
Modelica.SIunits.SpecificEnthalpy h_VS "Dew enthalpy";
//Modelica.SIunits.SpecificEnthalpy h_TP "Mean Enthalpy of the two-phase region";
Modelica.SIunits.SpecificEnthalpy h_SH
    "Mean Enthalpy of the Superheated region";
Modelica.SIunits.SpecificEnthalpy h_SU
    "Enthalpy at the inlet of the heat exchanger";
Modelica.SIunits.SpecificEnthalpy h_EX(start= 0)
    "Enthalpy at the outlet of the heat exchanger of the primary fluid";

/***** Enthalpy&Density****/

Real rhoh_TP "Density times enthalpy in the two-phase region";

/******************* Density derivatives ********************/
Modelica.SIunits.DerDensityByEnthalpy drdh_SB
    "Density derivative with respect to enthalpy at constant pressure in the subcooled region";
Modelica.SIunits.DerDensityByPressure drdp_SB
    "Density derivative with respect to pressure at constant enthalpy in the subcooled region";
Modelica.SIunits.DerDensityByPressure drdp_LS
    "Bubble point density derivative with respect to pressure";
Modelica.SIunits.DerDensityByPressure drdp_VS
    "Dew point density derivative with respect to pressure";
Modelica.SIunits.DerDensityByEnthalpy drdh_SH
    "Density derivative with respect to enthalpy at constant pressure in the superheated region";
Modelica.SIunits.DerDensityByPressure drdp_SH
    "Density derivative with respect to pressure at constant enthalpy in the superheated region";

/*************** Enthalpy derivatives *******************/
Modelica.SIunits.DerEnthalpyByPressure dhdp_LS
    "Bubble point specific enthalpy derivative with respect to pressure";
Modelica.SIunits.DerEnthalpyByPressure dhdp_VS
    "Dew point specific enthalpy derivative with respect to pressure";

/************ Derivative with respect to time **************/
Real drdt_SB "Density derivative with respect to time in the subcooled region";
Real dhdt_SB "Enthalpy derivative with respect to time in the subcooled region";
Real drdt_TP "Density derivative with respect to time in the two-phase region";
Real drhdt_TP
    "Density and Enthalpy derivative with respect to time in the two-phase region";
Real drdt_SH
    "Density derivative with respect to time in the superheated region";
Real dhdt_SH
    "Enthalpy derivative with respect to time in the superheated region";

/********************** VOID fraction *****************************/
parameter Real Void "Void fraction assumed constant for now";
parameter Real dVoid_dp=0 "Void fraction derivative with respect to pressure";
parameter Real dVoid_dh=0 "Void fraction derivative with respect to enthalpy";

equation
/****************** BOUNDARY EQUATION *************************/
  TwSB = MB_port.Tliq;
  TwTP = MB_port.Tmix;
  TwSH = MB_port.Tvap;

  QwSB = MB_port.Qliq;
  QwTP = MB_port.Qmix;
  QwSH = MB_port.Qvap;

  L_SB = MB_port.La;
  L_TP = MB_port.Lb -L_SB;

  L = L_SB + L_TP + L_SH;

/********** Enthalpies ************/
h_SU = inStream(InFlow.h_outflow);
h_EX = OutFlow.h_outflow;
h_SU = InFlow.h_outflow;

/*************** Pressure **************/
InFlow.p = p;
OutFlow.p = p;

/***********Mass Flow ******************/
InFlow.m_flow = M_dot_su;
OutFlow.m_flow = -M_dot_ex;

/*************** CONSTITUTIVE EQUATIONS ******************/
h_SB = (h_SU + h_LS)/2 "Mean enthalpy of the subcooled region";
rho_TP = rho_VS*Void + rho_LS*(1-Void);
rhoh_TP = rho_VS*h_VS*Void + rho_LS*h_LS*(1-Void);
h_SH = (h_EX + h_VS)/2 "Mean enthalpy of the superheated region";

TwA = (TwSB*L_TP + TwTP*L_SB)/(L_TP +L_SB)
    "Wall Temperature at the border between one-phase and two-phase region";
TwB = (TwSH*L_TP + TwTP*L_SH)/(L_TP +L_SH)
    "Wall Temperature at the border between two-phase and superheated region";

//CHANGE THIS WITH LMTD METHOD
Q_SB = pi*D*L_SB*U_SB*(TwSB -T_SB) "Heat from the wall sub-cooled region";
Q_TP = pi*D*L_TP*U_TP*(TwTP - T_TP) "Heat from the wall two-phase region";
Q_SH = pi*D*L_SH*U_SH*(TwSH -T_SH) "Heat from the wall super-heated region";

Q_tot = Q_SB + Q_TP + Q_SH;

/************ FLUID PROPERTIES ************************/
SubCooled = Medium.setState_ph(p,h_SB);
sat = Medium.setSat_p(p);
SuperHeated = Medium.setState_ph(p,h_SH);
outlet = Medium.setState_ph(p,h_EX);

/**Temperatures **/
T_SB = Medium.temperature(SubCooled);
T_TP = Medium.saturationTemperature_sat(sat);
T_SH = Medium.temperature(SuperHeated);
T_out = Medium.temperature(outlet);

/** Densities **/
rho_SB = Medium.density(SubCooled);
rho_LS = Medium.bubbleDensity(sat);
rho_VS = Medium.dewDensity(sat);
rho_SH = Medium.density(SuperHeated);

/** Enthalpies **/
h_LS = Medium.bubbleEnthalpy(sat);
h_VS = Medium.dewEnthalpy(sat);

/**Derivatives**/
drdh_SB = Medium.density_derh_p(SubCooled);
drdp_SB = Medium.density_derp_h(SubCooled);
drdp_LS = Medium.dBubbleDensity_dPressure(sat);
drdp_VS = Medium.dDewDensity_dPressure(sat);
dhdp_LS = Medium.dBubbleEnthalpy_dPressure(sat);
dhdp_VS = Medium.dDewEnthalpy_dPressure(sat);
drdh_SH = Medium.density_derh_p(SuperHeated);
drdp_SH = Medium.density_derp_h(SuperHeated);

/************ MassBalance SUB-COOLED ****************/
A*(  L_SB*drdt_SB + (rho_SB - rho_LS)*der(L_SB))   = M_dot_su - M_dot_A;

drdt_SB = (drdp_SB + (1/2)*drdh_SB*dhdp_LS)*der(p) +(1/2)*drdh_SB*der(h_SU);

/********** EnergyBalance SUB-COOLED ******************/
A*L_SB*(  rho_SB*dhdt_SB + h_SB*drdt_SB - der(p))   +
A*(  rho_SB*h_SB - rho_LS*h_LS)  *der(L_SB) = M_dot_su*h_SU - M_dot_A*h_LS + Q_SB;

dhdt_SB = (1/2)*(dhdp_LS*der(p) + der(h_SU));

/*******  WallEnergyBalance SUB-COOLED **********/
(c_wall*M_tot/L)*(L_SB*der(TwSB) + (TwSB - TwA)*der(L_SB)) = QwSB - Q_SB;

/**************************************************************************************************************/

/************ MassBalance TWO-PHASE REGION ******************/
A*(L_TP*drdt_TP + (rho_TP - rho_VS)*der(L_TP) + (rho_LS - rho_VS)*der(L_SB)) = M_dot_A - M_dot_B;

drdt_TP = (  Void*drdp_VS + (1-Void)*drdp_LS)  *der(p); //(rho_VS - rho_LS)*(dVoid_dp*der(p) + dVoid_dh*der(h_EX));

/************ EnergyBalance TWO-PHASE REGION ******************/
A*(  L_TP*drhdt_TP + (rhoh_TP - rho_VS*h_VS)*der(L_TP) + (rho_LS*h_LS - rho_VS*h_VS)*der(L_SB) - L_TP*der(p))   = M_dot_A*h_LS - M_dot_B*h_VS + Q_TP;

drhdt_TP = (   Void*(  drdp_VS*h_VS + rho_VS*drdp_VS)   + (1-Void)*(  h_LS*drdp_LS + rho_LS*dhdp_LS))    *der(p);
 //(rho_VS*h_VS -rho_LS*h_LS)*(dVoid_dp*der(p) + dVoid_dh*der(h_EX));

/***************** WallEnergyBalance TWO-PHASE REGION **************/
(c_wall*M_tot/L)*(  L_TP*der(TwTP) + (TwA - TwB)*der(L_SB) + ( TwTP - TwB) *der(L_TP))   = QwTP - Q_TP;

/**************************************************************************************************************/

/************ MassBalance SUPER-HEATED ****************/
  A*(  L_SH*drdt_SH + (rho_VS - rho_SH)*(der(L_SB)+der(L_TP)))   = M_dot_B - M_dot_ex;

  drdt_SH = (drdp_SH +(1/2)*drdh_SH*dhdp_VS)*der(p) +(1/2)*drdh_SH*der(h_EX);

/********** EnergyBalance SUPER-HEATED ******************/
A*L_SH*(  rho_SH*dhdt_SH + h_SH*drdt_SH - der(p))   +
A*( rho_VS*h_VS - rho_SH*h_SH) *( der(L_SB) + der(L_TP))  = M_dot_B*h_VS - M_dot_ex*h_EX + Q_SH;

dhdt_SH = (1/2)*( dhdp_VS*der(p) + der(h_EX));

/*******  WallEnergyBalance SUPER-HEATED **********/
(c_wall*M_tot/L)*( L_SH*der(TwSH) + (TwB -TwSH)*(der(L_SB)+ der(L_TP)))  = QwSH - Q_SH;

  annotation (Diagram(graphics));
end MBeva;

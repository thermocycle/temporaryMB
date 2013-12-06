within Components.Units.HeatExchangers.MovingBoundary;
model MBeva_sf

  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlow_sf
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  ThermoCycle.Interfaces.Fluid.Flange_ex_Cdot OutFlow_sf
    annotation (Placement(transformation(extent={{-108,10},{-88,30}})));
  MBHTA_AD MB_port annotation (Placement(transformation(extent={{-44,78},{38,98}}),
        iconTransformation(extent={{-44,78},{38,98}})));

/*********** GENERAL VARIABLES AND PARAMETER ***********/
parameter Modelica.SIunits.Area A
    "Cross-sectional area for both side of the heat exchanger";
parameter Modelica.SIunits.Length L "Total length of the exchanger";
final parameter Modelica.SIunits.Length D = 2*sqrt(A/pi) "Diameter";
constant Real pi = Modelica.Constants.pi;

Modelica.SIunits.MassFlowRate Mdot_sf
    "Mass flow at the outlet of the heat exchanger";
Modelica.SIunits.Density rho_sf "Density of the secondary fluid at the inlet";
Modelica.SIunits.SpecificHeatCapacity cp_sf
    "Specific heat capacity of the secondary fluid at the inlet";

/*************Tube region length ********************/
Modelica.SIunits.Length L_SB(start=0) "Length of the subcooled region";
Modelica.SIunits.Length L_TP(start=0) "Length of the two-phase region";
Modelica.SIunits.Length L_SH "Length of the Superheated region";

Modelica.SIunits.Temperature Tsf_SU
    "Tempearture at the inlet of the secondary fluid";
Modelica.SIunits.Temperature Tsf_SH
    "Mean Temperatue of the superheated region secondary fluid";
Modelica.SIunits.Temperature Tsf_TP
    "Mean Temperatue of the two-phase region secondary fluid";
Modelica.SIunits.Temperature Tsf_SB
    "Mean Temperatue of the subcooled region secondary fluid";
Modelica.SIunits.Temperature Tsf_B
    "Secondary fluid temperature at the interface between two-phase and super-heated";
Modelica.SIunits.Temperature Tsf_A
    "Secondary fluid temperature at the interface between two-phase and super-heated";
Modelica.SIunits.Temperature Tsf_EX
    "Secondary fluid temperature at the exit of the heat exchanger";

Modelica.SIunits.Temperature TwSB(start=0)
    "Mean Wall temperature in the sub-cooled region";
Modelica.SIunits.Temperature TwTP(start=0)
    "Mean Wall Temperature in the two-phase region";
Modelica.SIunits.Temperature TwSH(start=0)
    "Mean Wall Temperature in the super-heated region";

Modelica.SIunits.Power Qsf_SH;
Modelica.SIunits.Power Qsf_TP;
Modelica.SIunits.Power Qsf_SB;

parameter Modelica.SIunits.CoefficientOfHeatTransfer Usf
    "Secondary fluid Heat transfer coefficient sub-cooled side";

equation
  /****************** BOUNDARY EQUATION *************************/

  Tsf_SB = MB_port.Tliq;
  Tsf_TP = MB_port.Tmix;
  Tsf_SH = MB_port.Tvap;

  Qsf_SB = MB_port.Qliq;
  Qsf_TP = MB_port.Qmix;
  Qsf_SH = MB_port.Qvap;

  L_SB = MB_port.La;
  L_TP = MB_port.Lb -L_SB;

  L = L_SB + L_TP + L_SH;

/********* Temperatures **********/
OutFlow_sf.T = Tsf_EX;
InFlow_sf.T = Tsf_SU;

/**********Specific Heat Capacity *************/
OutFlow_sf.cp = cp_sf;
InFlow_sf.cp = cp_sf;

/*********** Density ***********/
OutFlow_sf.rho = rho_sf;
InFlow_sf.rho = rho_sf;

/*********** Mass flow **********/
OutFlow_sf.Mdot = Mdot_sf;
InFlow_sf.Mdot = Mdot_sf;

/*********** Temperatures ***************/

Tsf_SH = (Tsf_SU+Tsf_B)/2
    "Mean temperature of the secondary fluid in the superheated region";
Tsf_B = (L_TP*Tsf_SH + L_SH*Tsf_TP)/(L_SH+L_TP)
    "Secondary fluid temperature at the border between two-phase and superheated region";
Tsf_TP = (Tsf_A+Tsf_B)/2
    "Mean temperature of the secondary fluid in the two phase region";
Tsf_A = (L_TP*Tsf_SB + L_SB*Tsf_TP)/(L_SB+L_TP)
    "Secondary fluid temperature at the border between two-phase and subcooled";
Tsf_SB = (Tsf_A+Tsf_EX)/2
    "Mean temperature of the secondary fluid in the two phase region";

Qsf_SB = pi*D*L_SB*Usf*(Tsf_SB - TwSB);
Qsf_TP = pi*D*L_TP*Usf*(Tsf_TP - TwTP);
Qsf_SH = pi*D*L_SH*Usf*(Tsf_SH - TwSH);

/**** SecondaryFluid EnergyBalance SUB-COOLED********************/

cp_sf*rho_sf*A*( der(Tsf_SB)*L_SB) = Mdot_sf*cp_sf*( Tsf_A - Tsf_EX) - Qsf_SB;

/**** SecondaryFluid EnergyBalance TWO-PHASE REGION ********************/
cp_sf*rho_sf*A*(  L_TP*der(Tsf_TP))  = Mdot_sf*cp_sf*(Tsf_B - Tsf_A) - Qsf_TP;

/**** SecondaryFluid EnergyBalance SUPER-HEATED ********************/

cp_sf*rho_sf*A*(L_SH*der(Tsf_SH)) = Mdot_sf*cp_sf*(Tsf_SU - Tsf_B) - Qsf_SH;

  annotation (Icon(graphics));
end MBeva_sf;
